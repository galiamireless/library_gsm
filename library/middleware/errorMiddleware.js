// ===================================================================
// Middleware de Manejo Global de Errores
// Centraliza y normaliza respuestas de error sin exponer stack traces
// ===================================================================

// Middleware: Manejador de errores global
const errorHandler = (err, req, res, next) => {
    console.error('Error:', {
        message: err.message,
        stack: process.env.NODE_ENV === 'development' ? err.stack : undefined,
        url: req.url,
        method: req.method
    });

    // Errores de validación
    if (err.name === 'ValidationError') {
        return res.status(400).render('error', {
            message: 'Validation Error',
            error: {
                status: 400,
                details: err.message
            }
        });
    }

    // Errores de autenticación
    if (err.name === 'AuthenticationError' || err.status === 401) {
        return res.status(401).render('error', {
            message: 'Authentication Failed',
            error: {
                status: 401,
                details: 'Invalid credentials or session expired'
            }
        });
    }

    // Errores de autorización
    if (err.status === 403) {
        return res.status(403).render('error', {
            message: 'Access Denied',
            error: {
                status: 403,
                details: 'You do not have permission to access this resource'
            }
        });
    }

    // Errores de base de datos
    if (err.name === 'DatabaseError' || err.name === 'error') {
        return res.status(500).render('error', {
            message: 'Database Error',
            error: {
                status: 500,
                details: 'An error occurred while processing your request. Please try again later.'
            }
        });
    }

    // Error 404 - Recurso no encontrado
    if (err.status === 404) {
        return res.status(404).render('error', {
            message: 'Not Found',
            error: {
                status: 404,
                details: 'The requested resource was not found'
            }
        });
    }

    // Error genérico
    const status = err.status || 500;
    const message = status === 500 ? 'Internal Server Error' : err.message;
    const details = process.env.NODE_ENV === 'development' ? err.message : 'An unexpected error occurred';

    res.status(status).render('error', {
        message: message,
        error: {
            status: status,
            details: details
        }
    });
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
