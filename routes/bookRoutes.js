// ===================================================================
// Rutas de Libros
// Catálogo, Búsqueda, Detalles
// ===================================================================

const express = require('express');
const router = express.Router();
const bookService = require('../services/bookService');
const conceptService = require('../services/conceptService');
const { asyncHandler } = require('../middleware/errorMiddleware');

// GET: Redirigir la raíz del enrutador de libros al catálogo
router.get('/', (req, res) => {
    res.redirect(`${res.locals.baseUrl || ''}/books/catalog`);
});

// GET: Catálogo de libros
router.get('/catalog', asyncHandler(async (req, res) => {
    const page = parseInt(req.query.page) || 1;
    const perPage = 10;
    const category = typeof req.query.category === 'string' ? req.query.category.trim() : '';

    const [result, genresResult] = await Promise.all([
        bookService.getAllBooks(page, perPage, category),
        bookService.getGenres()
    ]);

    if (!result.success) {
        return res.status(500).render('error', {
            title: 'Error',
            message: 'Error loading catalog',
            error: { status: 500, details: result.error }
        });
    }

    const totalPages = Math.ceil(result.totalCount / perPage);

    res.render('books/catalog', {
        title: 'Book Catalog',
        books: result.books || [],
        page,
        perPage,
        totalPages,
        totalCount: result.totalCount || 0,
        category,
        genres: genresResult.genres || []
    });
}));

// GET: Búsqueda de libros
router.get('/search', asyncHandler(async (req, res) => {
    const searchTerm = req.query.q || '';
    const minPrice = parseFloat(req.query.minPrice) || 0;
    const maxPrice = parseFloat(req.query.maxPrice) || 999999;
    const page = parseInt(req.query.page) || 1;
    const perPage = 10;

    let books = [];
    let totalCount = 0;
    let totalPages = 0;

    if (searchTerm.trim()) {
        const result = await bookService.searchBooks(searchTerm, minPrice, maxPrice, page, perPage);

        if (!result.success) {
            return res.status(500).render('error', {
                title: 'Error',
                message: 'Error searching books',
                error: { status: 500, details: result.error }
            });
        }

        books = result.books || [];
        totalCount = result.totalCount || 0;
        totalPages = Math.ceil(totalCount / perPage);
    }

    res.render('books/search', {
        title: 'Search Books',
        books,
        searchTerm,
        minPrice,
        maxPrice,
        page,
        perPage,
        totalPages,
        totalCount
    });
}));

// GET: Detalle de un libro
router.get('/detail/:isbn', asyncHandler(async (req, res) => {
    const { isbn } = req.params;

    const bookResult = await bookService.getBookByISBN(isbn);

    if (!bookResult.success) {
        return res.status(404).render('error', {
            title: 'Error',
            message: 'Book Not Found',
            error: { status: 404, details: 'The requested book does not exist' }
        });
    }

    const conceptsResult = await conceptService.getBookConcepts(isbn);
    const concepts = conceptsResult.success ? conceptsResult.concepts : [];

    res.render('books/detail', {
        title: bookResult.book.title,
        book: bookResult.book,
        concepts
    });
}));

// GET: Libros disponibles
router.get('/available', asyncHandler(async (req, res) => {
    const page = parseInt(req.query.page) || 1;
    const perPage = 10;

    const result = await bookService.getAvailableBooks(page, perPage);

    if (!result.success) {
        return res.status(500).render('error', {
            title: 'Error',
            message: 'Error loading available books',
            error: { status: 500, details: result.error }
        });
    }

    const totalPages = Math.ceil((result.totalCount || 0) / perPage);

    res.render('books/available', {
        title: 'Available Books',
        books: result.books || [],
        page,
        perPage,
        totalPages,
        totalCount: result.totalCount || 0
    });
}));

module.exports = router;
