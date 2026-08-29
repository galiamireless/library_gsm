// ===================================================================
// Aplicación Principal: Monolithic Web Application para Librería
// Stack: Node.js, Express, EJS, PostgreSQL
// ===================================================================

const express = require('express');
const path = require('path');
const session = require('express-session');
const pgSession = require('connect-pg-simple')(session);
const morgan = require('morgan');
const helmet = require('helmet');
const cors = require('cors');
require('dotenv').config();

// Importar configuración y middleware
const db = require('./config/db');
const {
    errorHandler,
    notFoundHandler,
    asyncHandler
} = require('./middleware/errorMiddleware');
const { attachUserToLocals } = require('./middleware/authMiddleware');

// Importar rutas
const authRoutes = require('./routes/authRoutes');
const bookRoutes = require('./routes/bookRoutes');
const adminRoutes = require('./routes/adminRoutes');
const conceptRoutes = require('./routes/conceptRoutes');

// Crear aplicación Express
const app = express();
const PORT = process.env.PORT || 3000;
const NODE_ENV = process.env.NODE_ENV || 'development';

// ===================================================================
// CONFIGURACIÓN DE SEGURIDAD
// ===================================================================

// Helmet: Protecciones HTTP headers
app.use(helmet());

// CORS: Control de origen cruzado
app.use(cors({
    origin: process.env.CORS_ORIGIN || 'http://localhost:3000',
    credentials: true
}));

// ===================================================================
// CONFIGURACIÓN DE VISTAS Y ARCHIVOS ESTÁTICOS
// ===================================================================

// Motor de plantillas: EJS
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

// Archivos estáticos: CSS, JS, Imágenes
app.use(express.static(path.join(__dirname, 'public')));
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// ===================================================================
// MIDDLEWARE DE PARSEO Y LOGGING
// ===================================================================

// Body parser: Formularios URL-encoded
app.use(express.urlencoded({ extended: true, limit: '10mb' }));
app.use(express.json({ limit: '10mb' }));

// Logging: Morgan
if (NODE_ENV === 'development') {
    app.use(morgan('dev'));
} else {
    app.use(morgan('combined'));
}

// ===================================================================
// CONFIGURACIÓN DE SESIONES
// ===================================================================

app.use(session({
    store: new pgSession({
        pool: db.pool,
        tableName: 'session',
        createTableIfMissing: true
    }),
    secret: process.env.SESSION_SECRET || 'your_session_secret_change_me',
    resave: false,
    saveUninitialized: false,
    cookie: {
        secure: process.env.SESSION_COOKIE_SECURE === 'true', // HTTPS en producción
        httpOnly: process.env.SESSION_COOKIE_HTTPONLY !== 'false',
        sameSite: process.env.SESSION_COOKIE_SAMESITE || 'Lax',
        maxAge: parseInt(process.env.SESSION_MAX_AGE) || 86400000 // 24 horas
    }
}));

// ===================================================================
// MIDDLEWARE GLOBAL
// ===================================================================

// Adjuntar información del usuario a res.locals
app.use(attachUserToLocals);

// ===================================================================
// RUTAS DE LA APLICACIÓN
// ===================================================================

// Ruta principal: Redireccionar a catálogo
app.get('/', (req, res) => {
    res.redirect('/books/catalog');
});

// Rutas de autenticación
app.use('/auth', authRoutes);

// Rutas de libros (catálogo público)
app.use('/books', bookRoutes);

// Rutas administrativas
app.use('/admin', adminRoutes);

// Rutas de conceptos
app.use('/concepts', conceptRoutes);

// Health check (para monitoring)
app.get('/health', (req, res) => {
    res.json({ status: 'OK', timestamp: new Date().toISOString() });
});

// ===================================================================
// MANEJO DE ERRORES
// ===================================================================

// Middleware 404: Recursos no encontrados
app.use(notFoundHandler);

// Middleware: Manejador global de errores
app.use(errorHandler);

// ===================================================================
// INICIALIZACIÓN DEL SERVIDOR
// ===================================================================

const server = app.listen(PORT, () => {
    console.log(`
    ╔═══════════════════════════════════════╗
    ║   Library Management System Started   ║
    ╠═══════════════════════════════════════╣
    ║ URL:     http://localhost:${PORT}      ║
    ║ ENV:     ${NODE_ENV}                    ║
    ║ Port:    ${PORT}                        ║
    ╚═══════════════════════════════════════╝
    `);
});

// ===================================================================
// GRACEFUL SHUTDOWN
// ===================================================================

// Manejo de señales de terminación
process.on('SIGTERM', async () => {
    console.log('SIGTERM received. Shutting down gracefully...');
    server.close(async () => {
        console.log('Server closed');
        await db.closePool();
        console.log('Database pool closed');
        process.exit(0);
    });
});

process.on('SIGINT', async () => {
    console.log('SIGINT received. Shutting down gracefully...');
    server.close(async () => {
        console.log('Server closed');
        await db.closePool();
        console.log('Database pool closed');
        process.exit(0);
    });
});

// Manejo de excepciones no capturadas
process.on('uncaughtException', (error) => {
    console.error('Uncaught Exception:', error);
    process.exit(1);
});

process.on('unhandledRejection', (reason, promise) => {
    console.error('Unhandled Rejection at:', promise, 'reason:', reason);
    process.exit(1);
});

module.exports = app;
