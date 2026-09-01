// ===================================================================
// Rutas Administrativas
// CRUD de Libros, Autores, Géneros, Imágenes (solo Administradores)
// ===================================================================

const express = require('express');
const router = express.Router();
const path = require('path');
const fs = require('fs').promises;
const bookService = require('../services/bookService');
const conceptService = require('../services/conceptService');
const authService = require('../services/authService');
const db = require('../config/db');
const { isAdmin } = require('../middleware/authMiddleware');
const { uploadSingle, handleUploadError } = require('../middleware/uploadMiddleware');
const { asyncHandler } = require('../middleware/errorMiddleware');

function normalizeCoverFlag(value) {
    if (typeof value === 'boolean') return value;
    if (typeof value === 'string') {
        const normalized = value.trim().toLowerCase();
        return ['true', '1', 'yes', 'on'].includes(normalized);
    }
    return false;
}

function normalizeImageUrl(value) {
    if (!value) return null;
    const trimmed = String(value).trim();
    if (!trimmed) return null;
    if (/^https?:\/\//i.test(trimmed) || trimmed.startsWith('/') || trimmed.startsWith('./')) {
        return trimmed;
    }
    return null;
}

// GET: Dashboard Administrativo
router.get('/dashboard', isAdmin, asyncHandler(async (req, res) => {
    const statsResult = await bookService.getInventoryStats();
    const stats = statsResult.success ? statsResult.stats : {};

    res.render('admin/dashboard', {
        title: 'Admin Dashboard',
        stats: stats
    });
}));

// GET: Listar libros para gestión administrativa
router.get('/books', isAdmin, asyncHandler(async (req, res) => {
    const searchTerm = (req.query.q || '').trim();
    const page = parseInt(req.query.page) || 1;
    const perPage = 10;

    let result;
    if (searchTerm) {
        result = await bookService.searchBooks(searchTerm, 0, 999999, page, perPage);
    } else {
        result = await bookService.getAllBooks(page, perPage);
    }

    const books = result.success ? result.books || [] : [];
    const totalCount = result.success ? result.totalCount || 0 : 0;
    const totalPages = Math.max(1, Math.ceil(totalCount / perPage));

    res.render('admin/books_list', {
        title: 'Manage Books',
        books,
        searchTerm,
        page,
        perPage,
        totalPages,
        totalCount
    });
}));

// GET: Formulario para crear libro
router.get('/books/new', isAdmin, asyncHandler(async (req, res) => {
    const formatsResult = await db.query('SELECT format_id, name FROM formats ORDER BY name');
    const formats = formatsResult.rows;

    res.render('admin/book_form', {
        title: 'Create New Book',
        book: null,
        formats: formats
    });
}));

// POST: Crear libro
router.post('/books', isAdmin, asyncHandler(async (req, res) => {
    const { isbn, title, description, publication_year, price, stock, format_id, publisher, format_type, digital_format } = req.body;

    const result = await bookService.createBook(isbn, title, description, publication_year, price, stock, format_id, publisher, format_type, digital_format);

    if (!result.success) {
        const formatsResult = await db.query('SELECT format_id, name FROM formats ORDER BY name');
        return res.render('admin/book_form', {
            title: 'Create New Book',
            book: req.body,
            formats: formatsResult.rows,
            error: result.error
        });
    }

    res.redirect(`${res.locals.baseUrl || ''}/admin/books/edit/${encodeURIComponent(isbn)}`);
}));

// GET: Formulario para editar libro
router.get('/books/edit/:isbn', isAdmin, asyncHandler(async (req, res) => {
    const { isbn } = req.params;

    const bookResult = await bookService.getBookByISBN(isbn);
    if (!bookResult.success) {
        return res.status(404).render('error', {
            message: 'Book Not Found',
            error: { status: 404 }
        });
    }

    const formatsResult = await db.query('SELECT format_id, name FROM formats ORDER BY name');
    const authorsResult = await bookService.getBookAuthors(isbn);
    const genresResult = await bookService.getBookGenres(isbn);

    res.render('admin/book_form', {
        title: 'Edit Book',
        book: bookResult.book,
        formats: formatsResult.rows,
        authors: authorsResult.authors,
        genres: genresResult.genres
    });
}));

// POST: Actualizar libro
router.post('/books/:isbn', isAdmin, asyncHandler(async (req, res) => {
    const { isbn } = req.params;
    const { title, description, publication_year, price, stock, format_id, publisher, format_type, digital_format } = req.body;

    const result = await bookService.updateBook(isbn, title, description, publication_year, price, stock, format_id, publisher, format_type, digital_format);

    if (!result.success) {
        return res.status(400).render('error', {
            message: 'Update Failed',
            error: { status: 400, details: result.error }
        });
    }

    res.redirect(`${res.locals.baseUrl || ''}/admin/books/edit/${encodeURIComponent(isbn)}`);
}));

// GET: Listar todas las imágenes de un libro
router.get('/books/:isbn/images', isAdmin, asyncHandler(async (req, res) => {
    const { isbn } = req.params;

    const imagesResult = await db.query(
        'SELECT image_id, image_url, alt_text, is_cover FROM book_images WHERE isbn = $1 ORDER BY is_cover DESC',
        [isbn]
    );

    res.render('admin/images_list', {
        title: 'Book Images',
        isbn: isbn,
        images: imagesResult.rows
    });
}));

// POST: Cargar imagen para un libro
router.post('/books/:isbn/upload-image', isAdmin, uploadSingle, handleUploadError, asyncHandler(async (req, res) => {
    const { isbn } = req.params;
    const { image_url, alt_text, is_cover } = req.body;

    let finalFile = req.file || null;
    const normalizedImageUrl = normalizeImageUrl(image_url);

    if (!finalFile && !normalizedImageUrl) {
        return res.status(400).json({
            success: false,
            message: 'No file uploaded or valid image URL provided'
        });
    }

    const altText = (alt_text || '').trim() || 'Book cover';
    const coverFlag = normalizeCoverFlag(is_cover);
    const sourceType = finalFile ? 'upload' : 'url';
    const storedFilename = finalFile ? finalFile.filename : null;
    let imageUrl = normalizedImageUrl || null;
    let sourceUrl = normalizedImageUrl || null;

    if (finalFile) {
        imageUrl = `/uploads/${finalFile.filename}`;
        sourceUrl = imageUrl;
    }

    try {
        await db.query(
            `INSERT INTO book_images (
                isbn, image_url, alt_text, is_cover, source_type, source_url,
                original_filename, stored_filename, mime_type, file_size_bytes
            ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)`,
            [
                isbn,
                imageUrl,
                altText,
                coverFlag,
                sourceType,
                sourceUrl,
                finalFile ? finalFile.originalname : null,
                storedFilename,
                finalFile ? finalFile.mimetype : null,
                finalFile ? finalFile.size : 0
            ]
        );

        res.json({
            success: true,
            message: 'Image uploaded successfully',
            image: {
                url: imageUrl,
                filename: storedFilename,
                alt_text: altText,
                is_cover: coverFlag
            }
        });
    } catch (error) {
        if (finalFile) {
            await fs.unlink(path.join(__dirname, '../uploads', finalFile.filename)).catch(() => {});
        }
        throw error;
    }
}));

// DELETE: Eliminar imagen
router.delete('/images/:imageId', isAdmin, asyncHandler(async (req, res) => {
    const { imageId } = req.params;

    const imageResult = await db.query(
        'SELECT image_url, stored_filename FROM book_images WHERE image_id = $1',
        [imageId]
    );

    if (imageResult.rows.length === 0) {
        return res.status(404).json({
            success: false,
            message: 'Image not found'
        });
    }

    const imageUrl = imageResult.rows[0].image_url;
    const storedFilename = imageResult.rows[0].stored_filename;

    await db.query('DELETE FROM book_images WHERE image_id = $1', [imageId]);

    if (storedFilename) {
        const filePath = path.join(__dirname, '../uploads', storedFilename);
        await fs.unlink(filePath).catch(() => {});
    }

    res.json({
        success: true,
        message: 'Image deleted successfully',
        image_url: imageUrl
    });
}));

// GET: Formulario de gestión de autores
router.get('/books/:isbn/authors', isAdmin, asyncHandler(async (req, res) => {
    const { isbn } = req.params;

    const authorsResult = await bookService.getBookAuthors(isbn);
    const allAuthorsResult = await db.query('SELECT author_id, name FROM authors ORDER BY name');

    res.render('admin/manage_authors', {
        title: 'Manage Authors',
        isbn: isbn,
        bookAuthors: authorsResult.authors,
        allAuthors: allAuthorsResult.rows
    });
}));

// GET: Formulario de gestión de géneros
router.get('/books/:isbn/genres', isAdmin, asyncHandler(async (req, res) => {
    const { isbn } = req.params;

    const genresResult = await bookService.getBookGenres(isbn);
    const allGenresResult = await db.query('SELECT genre_id, name FROM genres ORDER BY name');

    res.render('admin/manage_genres', {
        title: 'Manage Genres',
        isbn: isbn,
        bookGenres: genresResult.genres,
        allGenres: allGenresResult.rows
    });
}));

// POST: Agregar autor a libro
router.post('/books/:isbn/authors', isAdmin, asyncHandler(async (req, res) => {
    const { isbn } = req.params;
    const { author_id } = req.body;

    const result = await bookService.addAuthorToBook(isbn, author_id);

    if (!result.success) {
        return res.status(400).json({
            success: false,
            message: result.error
        });
    }

    res.json({ success: true, message: 'Author added' });
}));

// POST: Agregar género a libro
router.post('/books/:isbn/genres', isAdmin, asyncHandler(async (req, res) => {
    const { isbn } = req.params;
    const { genre_id } = req.body;

    const result = await bookService.addGenreToBook(isbn, genre_id);

    if (!result.success) {
        return res.status(400).json({
            success: false,
            message: result.error
        });
    }

    res.json({ success: true, message: 'Genre added' });
}));

// DELETE: Eliminar libro
router.delete('/books/:isbn', isAdmin, asyncHandler(async (req, res) => {
    const { isbn } = req.params;

    const result = await bookService.deleteBook(isbn);

    if (!result.success) {
        return res.status(400).json({
            success: false,
            message: result.error
        });
    }

    res.json({ success: true, message: 'Book deleted successfully' });
}));

// GET: Listar usuarios
router.get('/users', isAdmin, asyncHandler(async (req, res) => {
    const result = await authService.getAllUsers();

    res.render('admin/users_list', {
        title: 'Manage Users',
        users: result.success ? result.users : []
    });
}));

// GET: Formulario para crear usuario
router.get('/users/new', isAdmin, asyncHandler(async (req, res) => {
    res.render('admin/user_form', {
        title: 'Create User',
        user: null,
        error: null
    });
}));

// POST: Crear usuario
router.post('/users', isAdmin, asyncHandler(async (req, res) => {
    const { username, email, password, full_name, role, is_active } = req.body;

    const result = await authService.createUser(
        username,
        email,
        password,
        full_name,
        role || 'USER',
        is_active !== undefined ? is_active !== 'false' && is_active !== false : true
    );

    if (!result.success) {
        return res.render('admin/user_form', {
            title: 'Create User',
            user: req.body,
            error: result.error
        });
    }

    res.redirect(`${res.locals.baseUrl || ''}/admin/users`);
}));

// GET: Formulario para editar usuario
router.get('/users/:userId/edit', isAdmin, asyncHandler(async (req, res) => {
    const { userId } = req.params;
    const result = await authService.getUserById(userId);

    if (!result.success) {
        return res.status(404).render('error', {
            message: 'User Not Found',
            error: { status: 404 }
        });
    }

    res.render('admin/user_form', {
        title: 'Edit User',
        user: result.user,
        error: null
    });
}));

// POST: Actualizar usuario
router.post('/users/:userId', isAdmin, asyncHandler(async (req, res) => {
    const { userId } = req.params;
    const { username, email, password, full_name, role, is_active } = req.body;

    const result = await authService.updateUser(
        userId,
        username,
        email,
        full_name,
        role || 'USER',
        is_active !== undefined ? is_active !== 'false' && is_active !== false : true,
        password && String(password).trim() ? password : null
    );

    if (!result.success) {
        return res.render('admin/user_form', {
            title: 'Edit User',
            user: { ...req.body, user_id: userId },
            error: result.error
        });
    }

    res.redirect(`${res.locals.baseUrl || ''}/admin/users`);
}));

// DELETE: Eliminar usuario
router.delete('/users/:userId', isAdmin, asyncHandler(async (req, res) => {
    const { userId } = req.params;

    const result = await authService.deleteUser(userId);

    if (!result.success) {
        return res.status(400).json({
            success: false,
            message: result.error
        });
    }

    res.json({ success: true, message: 'User deleted successfully' });
}));

module.exports = router;
