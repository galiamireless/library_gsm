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
const db = require('../config/db');
const { isAdmin } = require('../middleware/authMiddleware');
const { uploadSingle, handleUploadError } = require('../middleware/uploadMiddleware');
const { asyncHandler } = require('../middleware/errorMiddleware');

// GET: Dashboard Administrativo
router.get('/dashboard', isAdmin, asyncHandler(async (req, res) => {
    const statsResult = await bookService.getInventoryStats();
    const stats = statsResult.success ? statsResult.stats : {};

    res.render('admin/dashboard', {
        title: 'Admin Dashboard',
        stats: stats
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
    const { isbn, title, description, publication_year, price, stock, format_id, publisher } = req.body;

    const result = await bookService.createBook(isbn, title, description, publication_year, price, stock, format_id, publisher);

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
    const { title, description, publication_year, price, stock, format_id, publisher } = req.body;

    const result = await bookService.updateBook(isbn, title, description, publication_year, price, stock, format_id, publisher);

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

    if (!req.file) {
        return res.status(400).json({
            success: false,
            message: 'No file uploaded'
        });
    }

    // Construir URL de la imagen
    const imageUrl = `/uploads/${req.file.filename}`;
    const altText = req.body.alt_text || 'Book cover';
    const isCover = req.body.is_cover === 'true';

    try {
        await db.query(
            'INSERT INTO book_images (isbn, image_url, alt_text, is_cover) VALUES ($1, $2, $3, $4)',
            [isbn, imageUrl, altText, isCover]
        );

        res.json({
            success: true,
            message: 'Image uploaded successfully',
            image: {
                url: imageUrl,
                filename: req.file.filename
            }
        });
    } catch (error) {
        // Eliminar archivo si la BD falla
        await fs.unlink(path.join(__dirname, '../uploads', req.file.filename)).catch(() => {});
        throw error;
    }
}));

// DELETE: Eliminar imagen
router.delete('/images/:imageId', isAdmin, asyncHandler(async (req, res) => {
    const { imageId } = req.params;

    // Obtener ruta de archivo
    const imageResult = await db.query(
        'SELECT image_url FROM book_images WHERE image_id = $1',
        [imageId]
    );

    if (imageResult.rows.length === 0) {
        return res.status(404).json({
            success: false,
            message: 'Image not found'
        });
    }

    const imageUrl = imageResult.rows[0].image_url;

    // Eliminar de BD
    await db.query('DELETE FROM book_images WHERE image_id = $1', [imageId]);

    // Eliminar archivo del sistema
    const filePath = path.join(__dirname, '../public', imageUrl);
    await fs.unlink(filePath).catch(() => {});

    res.json({
        success: true,
        message: 'Image deleted successfully'
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

module.exports = router;
