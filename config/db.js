// ===================================================================
// Configuración de Base de Datos PostgreSQL
// Pool de conexiones centralizado y parametrizado
// ===================================================================

const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
    host: process.env.DB_HOST || 'localhost',
    port: process.env.DB_PORT || 5432,
    database: process.env.DB_NAME || 'library_db',
    user: process.env.DB_USER || 'library_user',
    password: process.env.DB_PASSWORD || 'library_secure_password_2026',
    max: parseInt(process.env.DB_POOL_MAX) || 10,
    min: parseInt(process.env.DB_POOL_MIN) || 2,
    idleTimeoutMillis: parseInt(process.env.DB_POOL_IDLE_TIMEOUT) || 30000,
    connectionTimeoutMillis: parseInt(process.env.DB_POOL_CONNECTION_TIMEOUT) || 1000,
});

// Evento: Conexión exitosa
pool.on('connect', () => {
    console.log('✓ Database connection pool initialized');
});

// Evento: Error en conexión
pool.on('error', (err, client) => {
    console.error('Unexpected error on idle client', err);
    process.exit(-1);
});

// Función para ejecutar consultas con parámetros (previene SQL Injection)
async function query(text, params) {
    const start = Date.now();
    try {
        const result = await pool.query(text, params);
        const duration = Date.now() - start;
        console.log('Executed query', { text, duration, rows: result.rowCount });
        return result;
    } catch (error) {
        console.error('Database query error', { text, error });
        throw error;
    }
}

// Función para obtener un cliente del pool (para transacciones)
async function getClient() {
    const client = await pool.connect();
    return client;
}

// Función para cerrar el pool (útil para graceful shutdown)
async function closePool() {
    await pool.end();
    console.log('✓ Database pool closed');
}

module.exports = {
    query,
    getClient,
    closePool,
    pool,
};
