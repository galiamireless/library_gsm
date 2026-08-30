// ===================================================================
// Middleware de Manejo Global de Errores
// Centraliza y normaliza respuestas de error sin exponer stack traces
// ===================================================================

const buildErrorView = (status = 500, message = 'Internal Server Error', details = 'An unexpected error occurred') => ({
    title: 'Error',
    message,
    error: {
        status,
        details
    }
});

// Middleware: Manejador de errores global
const errorHandler = (err, req, res, next) => {
    const status = err && err.status ? err.status : 500;
    const message = err && err.message ? err.message : 'Internal Server Error';
    const details = process.env.NODE_ENV === 'development' && err && err.stack
        ? err.stack
        : 'An unexpected error occurred';

    console.error('Error:', {
        message,
        stack: process.env.NODE_ENV === 'development' ? err && err.stack : undefined,
        url: req.url,
        method: req.method
    });

    if (err && err.name === 'ValidationError') {
        return res.status(400).render('error', buildErrorView(400, 'Validation Error', err.message));
    }

    if (err && (err.name === 'AuthenticationError' || err.status === 401)) {
        return res.status(401).render('error', buildErrorView(401, 'Authentication Failed', 'Invalid credentials or session expired'));
    }

    if (err && err.status === 403) {
        return res.status(403).render('error', buildErrorView(403, 'Access Denied', 'You do not have permission to access this resource'));
    }

    if (err && (err.name === 'DatabaseError' || err.name === 'error')) {
        return res.status(500).render('error', buildErrorView(500, 'Database Error', 'An error occurred while processing your request. Please try again later.'));
    }

    if (status === 404) {
        return res.status(404).render('error', buildErrorView(404, 'Not Found', 'The requested resource was not found'));
    }

    res.status(status).render('error', buildErrorView(status, status === 500 ? 'Internal Server Error' : message, details));
};

// Middleware: Manejador de rutas no encontradas (404)
const notFoundHandler = (req, res, next) => {
    const err = new Error('Not Found');
    err.status = 404;
    next(err);
};

// Middleware: Wrapper para rutas asincrónicas (evita try-catch repetitivo)
const asyncHandler = (fn) => (req, res, next) => {
    Promise.resolve(fn(req, res, next)).catch(next);
};

// Clase personalizada para errores de aplicación
class AppError extends Error {
    constructor(message, status = 500) {
        super(message);
        this.status = status;
        this.name = 'AppError';
    }
}

module.exports = {
    errorHandler,
    notFoundHandler,
    asyncHandler,
    AppError
};
