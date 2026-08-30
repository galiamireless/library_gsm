// ===================================================================
// Rutas de Conceptos y Definiciones
// Gestión de conceptos asociados a libros
// ===================================================================

const express = require('express');
const router = express.Router();
const conceptService = require('../services/conceptService');
const db = require('../config/db');
const { isAdmin } = require('../middleware/authMiddleware');
const { asyncHandler } = require('../middleware/errorMiddleware');

// GET: Formulario para gestionar conceptos de un libro
router.get('/books/:isbn/concepts', isAdmin, asyncHandler(async (req, res) => {
    const { isbn } = req.params;

    // Verificar que el libro existe
    const bookCheck = await db.query('SELECT title FROM books WHERE isbn = $1', [isbn]);
    if (bookCheck.rows.length === 0) {
        return res.status(404).render('error', {
            message: 'Book Not Found',
            error: { status: 404 }
        });
    }

    const bookTitle = bookCheck.rows[0].title;

    // Obtener conceptos del libro
    const bookConceptsResult = await conceptService.getBookConcepts(isbn);
    const bookConcepts = bookConceptsResult.success ? bookConceptsResult.concepts : [];

    // Obtener todos los conceptos disponibles
    const allConceptsResult = await conceptService.getAllConcepts();
    const allConcepts = allConceptsResult.success ? allConceptsResult.concepts : [];

    res.render('admin/manage_concepts', {
        title: 'Manage Book Concepts',
        isbn: isbn,
        bookTitle: bookTitle,
        bookConcepts: bookConcepts,
        availableConcepts: allConcepts
    });
}));

// POST: Agregar concepto a un libro
router.post('/books/:isbn/concepts', isAdmin, asyncHandler(async (req, res) => {
    const { isbn } = req.params;
    const { concept_id, definition } = req.body;

    if (!definition) {
        return res.status(400).json({
            success: false,
            message: 'Definition is required'
        });
    }

    const result = await conceptService.addConceptToBook(isbn, concept_id, definition);

    if (!result.success) {
        return res.status(400).json({
            success: false,
            message: result.error
        });
    }

    res.json({ success: true, message: 'Concept added to book' });
}));

// PUT: Actualizar definición de concepto en un libro
router.put('/books/:isbn/concepts/:conceptId', isAdmin, asyncHandler(async (req, res) => {
    const { isbn, conceptId } = req.params;
    const { definition } = req.body;

    if (!definition) {
        return res.status(400).json({
            success: false,
            message: 'Definition is required'
        });
    }

    const result = await conceptService.updateBookConceptDefinition(isbn, conceptId, definition);

    if (!result.success) {
        return res.status(400).json({
            success: false,
            message: result.error
        });
    }

    res.json({ success: true, message: 'Definition updated successfully' });
}));

// DELETE: Eliminar concepto de un libro
router.delete('/books/:isbn/concepts/:conceptId', isAdmin, asyncHandler(async (req, res) => {
    const { isbn, conceptId } = req.params;

    const result = await conceptService.removeConceptFromBook(isbn, conceptId);

    if (!result.success) {
        return res.status(400).json({
            success: false,
            message: result.error
        });
    }

    res.json({ success: true, message: 'Concept removed from book' });
}));

// GET: Crear nuevo concepto
router.get('/concepts/new', isAdmin, asyncHandler(async (req, res) => {
    res.render('admin/concept_form', {
        title: 'Create New Concept',
        concept: null
    });
}));

// POST: Crear concepto
router.post('/concepts', isAdmin, asyncHandler(async (req, res) => {
    const { name, description } = req.body;

    const result = await conceptService.createConcept(name, description);

    if (!result.success) {
        return res.render('admin/concept_form', {
            title: 'Create New Concept',
            concept: req.body,
            error: result.error
        });
    }

    res.redirect('/admin/concepts');
}));

// GET: Listar todos los conceptos
router.get('/concepts', isAdmin, asyncHandler(async (req, res) => {
    const result = await conceptService.getAllConcepts();

    const concepts = result.success ? result.concepts : [];

    res.render('admin/concepts_list', {
        title: 'Manage Concepts',
        concepts: concepts
    });
}));

// GET: Editar concepto
router.get('/concepts/:conceptId/edit', isAdmin, asyncHandler(async (req, res) => {
    const { conceptId } = req.params;

    const result = await conceptService.getConceptById(conceptId);

    if (!result.success) {
        return res.status(404).render('error', {
            message: 'Concept Not Found',
            error: { status: 404 }
        });
    }

    res.render('admin/concept_form', {
        title: 'Edit Concept',
        concept: result.concept
    });
}));

// POST: Actualizar concepto
router.post('/concepts/:conceptId', isAdmin, asyncHandler(async (req, res) => {
    const { conceptId } = req.params;
    const { name, description } = req.body;

    const result = await conceptService.updateConcept(conceptId, name, description);

    if (!result.success) {
        return res.render('admin/concept_form', {
            title: 'Edit Concept',
            concept: req.body,
            error: result.error
        });
    }

    res.redirect('/admin/concepts');
}));

// DELETE: Eliminar concepto
router.delete('/concepts/:conceptId', isAdmin, asyncHandler(async (req, res) => {
    const { conceptId } = req.params;

    const result = await conceptService.deleteConcept(conceptId);

    if (!result.success) {
        return res.status(400).json({
            success: false,
            message: result.error
        });
    }

    res.json({ success: true, message: 'Concept deleted successfully' });
}));

module.exports = router;
