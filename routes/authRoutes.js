// ===================================================================
// Rutas de Autenticación
// Login, Registro, Logout
// ===================================================================

const express = require('express');
const router = express.Router();
const authService = require('../services/authService');
const { isNotLoggedIn, isLoggedIn } = require('../middleware/authMiddleware');
const { asyncHandler } = require('../middleware/errorMiddleware');

// GET: Formulario de Login
router.get('/login', isNotLoggedIn, (req, res) => {
    res.render('auth/login', {
        title: 'Login',
        error: null
    });
});

// POST: Procesar Login
router.post('/login', isNotLoggedIn, asyncHandler(async (req, res) => {
    const { username, password } = req.body;

    if (!username || !password) {
        return res.render('auth/login', {
            title: 'Login',
            error: 'Username and password are required'
        });
    }

    const result = await authService.loginUser(username, password);

    if (!result.success) {
        return res.render('auth/login', {
            title: 'Login',
            error: result.error
        });
    }

    // Crear sesión
    req.session.user = result.user;
    req.session.save((err) => {
        if (err) {
            return res.render('auth/login', {
                title: 'Login',
                error: 'Session error. Please try again.'
            });
        }
        res.redirect(`${res.locals.baseUrl || ''}/books/catalog`);
    });
}));

// GET: Formulario de Registro
router.get('/register', isNotLoggedIn, (req, res) => {
    res.render('auth/register', {
        title: 'Register',
        error: null
    });
});

// POST: Procesar Registro
router.post('/register', isNotLoggedIn, asyncHandler(async (req, res) => {
    const { username, email, password, password_confirm, full_name } = req.body;

    // Validaciones
    if (!username || !email || !password) {
        return res.render('auth/register', {
            title: 'Register',
            error: 'Username, email, and password are required'
        });
    }

    if (password !== password_confirm) {
        return res.render('auth/register', {
            title: 'Register',
            error: 'Passwords do not match'
        });
    }

    if (password.length < 6) {
        return res.render('auth/register', {
            title: 'Register',
            error: 'Password must be at least 6 characters long'
        });
    }

    // Registrar usuario
    const result = await authService.registerUser(username, email, password, full_name);

    if (!result.success) {
        return res.render('auth/register', {
            title: 'Register',
            error: result.error
        });
    }

    // Crear sesión automáticamente después del registro
    req.session.user = result.user;
    req.session.save((err) => {
        if (err) {
            return res.render('auth/register', {
                title: 'Register',
                error: 'Session error. Please try again.'
            });
        }
        res.redirect(`${res.locals.baseUrl || ''}/books/catalog`);
    });
}));

// GET: Logout
router.get('/logout', isLoggedIn, (req, res) => {
    req.session.destroy((err) => {
        if (err) {
            return res.redirect(`${res.locals.baseUrl || ''}/books/catalog`);
        }
        res.redirect(`${res.locals.baseUrl || ''}/auth/login`);
    });
});

module.exports = router;
