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
const { errorHandler, notFoundHandler } = require('./middleware/errorMiddleware');
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
app.enable('trust proxy');

// ===================================================================
// CONFIGURACIÓN DE SEGURIDAD
// ===================================================================
app.use(helmet({
    hsts: false,
    contentSecurityPolicy: false
}));
app.use(cors({
    origin: process.env.CORS_ORIGIN || 'http://localhost:3000',
    credentials: true
}));

// ===================================================================
// CONFIGURACIÓN DE VISTAS Y ARCHIVOS ESTÁTICOS
// ===================================================================
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));
app.use('/css', express.static(path.join(__dirname, 'public/css')));
app.use('/js', express.static(path.join(__dirname, 'public/js')));
app.use('/images', express.static(path.join(__dirname, 'public/images')));
app.use('/library/css', express.static(path.join(__dirname, 'public/css')));
app.use('/library/js', express.static(path.join(__dirname, 'public/js')));
app.use('/library/images', express.static(path.join(__dirname, 'public/images')));
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));
app.use('/library/uploads', express.static(path.join(__dirname, 'uploads')));
app.use(express.static(path.join(__dirname, 'public')));

// ===================================================================
// MIDDLEWARE DE PARSEO Y LOGGING
// ===================================================================
app.use(express.urlencoded({ extended: true, limit: '10mb' }));
app.use(express.json({ limit: '10mb' }));

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
        secure: false,
        httpOnly: process.env.SESSION_COOKIE_HTTPONLY !== 'false',
        sameSite: process.env.SESSION_COOKIE_SAMESITE || 'Lax',
        maxAge: parseInt(process.env.SESSION_MAX_AGE) || 86400000
    }
}));

// ===================================================================
// MIDDLEWARE GLOBAL DE CONTEXTO
// ===================================================================
app.use((req, res, next) => {
    req.headers['x-forwarded-proto'] = 'http';
    res.locals.baseUrl = req.originalUrl.startsWith('/library') ? '/library' : '';
    res.locals.user = req.session ? req.session.user : null;
    res.locals.isLoggedIn = !!(req.session && req.session.user);
    res.locals.isAdmin = !!(req.session && req.session.user && req.session.user.role === 'ADMIN');
    next();
});

app.use(attachUserToLocals);

// ===================================================================
// RUTAS DE LA APLICACIÓN
// ===================================================================
app.get('/', (req, res) => {
    res.redirect(`${res.locals.baseUrl || ''}/books/catalog`);
});

app.get('/library', (req, res) => {
    res.redirect('/library/books/catalog');
});

app.get('/books', (req, res) => {
    res.redirect(`${res.locals.baseUrl || ''}/books/catalog`);
});

app.get('/admin', (req, res) => {
    res.redirect(`${res.locals.baseUrl || ''}/admin/dashboard`);
});

app.get('/auth', (req, res) => {
    res.redirect(`${res.locals.baseUrl || ''}/auth/login`);
});

app.use('/auth', authRoutes);
app.use('/books', bookRoutes);
app.use('/library/auth', authRoutes);
app.use('/library/books', bookRoutes);
app.use('/admin', adminRoutes);
app.use('/concepts', conceptRoutes);
app.use('/library/admin', adminRoutes);
app.use('/library/concepts', conceptRoutes);

app.get('/health', (req, res) => {
    res.json({ status: 'OK', timestamp: new Date().toISOString() });
});

app.use(notFoundHandler);
app.use(errorHandler);

const server = app.listen(PORT, async () => {
    console.log(`
    ╔═══════════════════════════════════════╗
    ║   Library Management System Started   ║
    ╠═══════════════════════════════════════╣
    ║ URL:     http://localhost:${PORT}      ║
    ║ ENV:     ${NODE_ENV}                    ║
    ║ Port:    ${PORT}                        ║
    ╚═══════════════════════════════════════╝
    `);

    const connected = await db.testConnection();
    if (!connected) {
        console.warn('⚠ PostgreSQL not available; app is running in degraded mode until DB is started.');
    }
});

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

process.on('uncaughtException', (error) => {
    console.error('Uncaught Exception:', error);
    process.exit(1);
});

process.on('unhandledRejection', (reason, promise) => {
    console.error('Unhandled Rejection at:', promise, 'reason:', reason);
    process.exit(1);
});

module.exports = app;
