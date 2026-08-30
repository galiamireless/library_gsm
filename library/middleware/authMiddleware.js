// ===================================================================
// Middleware de Autenticación
// Verifica sesión y autorización de usuarios
// ===================================================================

// Middleware: Verificar si el usuario está logueado
const isLoggedIn = (req, res, next) => {
    if (req.session && req.session.user) {
        return next();
    }
    res.redirect('/auth/login');
};

// Middleware: Verificar si el usuario es Administrador
const isAdmin = (req, res, next) => {
    if (!req.session || !req.session.user) {
        return res.status(401).render('error', {
            message: 'Unauthorized: Please login first',
            error: { status: 401 }
        });
    }

    if (req.session.user.role !== 'ADMIN') {
        return res.status(403).render('error', {
            message: 'Forbidden: Admin access required',
            error: { status: 403 }
        });
    }

    next();
};

// Middleware: Permitir acceso solo a usuarios no autenticados (para login/registro)
const isNotLoggedIn = (req, res, next) => {
    if (req.session && req.session.user) {
        return res.redirect('/books/catalog');
    }
    next();
};

// Middleware: Adjuntar información del usuario a res.locals
const attachUserToLocals = (req, res, next) => {
    if (req.session && req.session.user) {
        res.locals.user = req.session.user;
        res.locals.isLoggedIn = true;
        res.locals.isAdmin = req.session.user.role === 'ADMIN';
    } else {
        res.locals.user = null;
        res.locals.isLoggedIn = false;
        res.locals.isAdmin = false;
    }
    next();
};

// Middleware: Validar token/sesión (para APIs internas si es necesario)
const validateSession = (req, res, next) => {
    if (!req.session || !req.session.user) {
        return res.status(401).json({
            success: false,
            message: 'Session expired or invalid'
        });
    }
    next();
};

module.exports = {
    isLoggedIn,
    isAdmin,
    isNotLoggedIn,
    attachUserToLocals,
    validateSession
};
