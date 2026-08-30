// ===================================================================
// Servicio de Autenticación
// Maneja login, registro y validación de usuarios con bcrypt
// ===================================================================

const bcrypt = require('bcrypt');
const db = require('../config/db');

// Hash de contraseña
async function hashPassword(password) {
    const rounds = parseInt(process.env.BCRYPT_ROUNDS) || 10;
    return await bcrypt.hash(password, rounds);
}

// Verificar contraseña
async function verifyPassword(password, hash) {
    return await bcrypt.compare(password, hash);
}

// Registrar nuevo usuario
async function registerUser(username, email, password, fullName) {
    try {
        // Validar entrada
        if (!username || !email || !password) {
            throw new Error('Username, email, and password are required');
        }

        // Verificar si username ya existe
        const userCheck = await db.query('SELECT user_id FROM users WHERE username = $1', [username]);
        if (userCheck.rows.length > 0) {
            throw new Error('Username already exists');
        }

        // Verificar si email ya existe
        const emailCheck = await db.query('SELECT user_id FROM users WHERE email = $1', [email]);
        if (emailCheck.rows.length > 0) {
            throw new Error('Email already exists');
        }

        // Hash de la contraseña
        const passwordHash = await hashPassword(password);

        // Insertar usuario en la base de datos
        const result = await db.query(
            'INSERT INTO users (username, email, password_hash, full_name, role, is_active) VALUES ($1, $2, $3, $4, $5, $6) RETURNING user_id, username, email, full_name, role',
            [username, email, passwordHash, fullName || username, 'USER', true]
        );

        return {
            success: true,
            user: result.rows[0]
        };
    } catch (error) {
        return {
            success: false,
            error: error.message
        };
    }
}

// Login de usuario
async function loginUser(username, password) {
    try {
        if (!username || !password) {
            throw new Error('Username and password are required');
        }

        // Buscar usuario por username
        const result = await db.query(
            'SELECT user_id, username, email, full_name, role, password_hash, is_active FROM users WHERE username = $1',
            [username]
        );

        if (result.rows.length === 0) {
            throw new Error('Invalid credentials');
        }

        const user = result.rows[0];

        // Verificar si el usuario está activo
        if (!user.is_active) {
            throw new Error('User account is deactivated');
        }

        // Verificar contraseña
        const passwordValid = await verifyPassword(password, user.password_hash);
        if (!passwordValid) {
            throw new Error('Invalid credentials');
        }

        // Retornar usuario sin la contraseña
        return {
            success: true,
            user: {
                user_id: user.user_id,
                username: user.username,
                email: user.email,
                full_name: user.full_name,
                role: user.role
            }
        };
    } catch (error) {
        return {
            success: false,
            error: error.message
        };
    }
}

// Obtener usuario por ID
async function getUserById(userId) {
    try {
        const result = await db.query(
            'SELECT user_id, username, email, full_name, role, is_active, created_at FROM users WHERE user_id = $1',
            [userId]
        );

        if (result.rows.length === 0) {
            throw new Error('User not found');
        }

        return {
            success: true,
            user: result.rows[0]
        };
    } catch (error) {
        return {
            success: false,
            error: error.message
        };
    }
}

// Verificar si existe administrador
async function adminExists() {
    try {
        const result = await db.query('SELECT COUNT(*) as count FROM users WHERE role = $1', ['ADMIN']);
        return result.rows[0].count > 0;
    } catch (error) {
        console.error('Error checking admin existence:', error);
        return false;
    }
}

// Crear administrador (solo si no existe)
async function createAdmin(username, email, password, fullName) {
    try {
        // Verificar si ya existe un admin
        if (await adminExists()) {
            throw new Error('Admin already exists. Only one admin allowed.');
        }

        // Validar entrada
        if (!username || !email || !password) {
            throw new Error('Username, email, and password are required');
        }

        // Hash de la contraseña
        const passwordHash = await hashPassword(password);

        // Insertar administrador
        const result = await db.query(
            'INSERT INTO users (username, email, password_hash, full_name, role, is_active) VALUES ($1, $2, $3, $4, $5, $6) RETURNING user_id, username, email, role',
            [username, email, passwordHash, fullName || 'Administrator', 'ADMIN', true]
        );

        return {
            success: true,
            user: result.rows[0]
        };
    } catch (error) {
        return {
            success: false,
            error: error.message
        };
    }
}

// Cambiar contraseña de usuario
async function changePassword(userId, oldPassword, newPassword) {
    try {
        // Obtener usuario actual
        const userResult = await db.query(
            'SELECT password_hash FROM users WHERE user_id = $1',
            [userId]
        );

        if (userResult.rows.length === 0) {
            throw new Error('User not found');
        }

        // Verificar contraseña anterior
        const passwordValid = await verifyPassword(oldPassword, userResult.rows[0].password_hash);
        if (!passwordValid) {
            throw new Error('Current password is incorrect');
        }

        // Hash de la nueva contraseña
        const newPasswordHash = await hashPassword(newPassword);

        // Actualizar contraseña
        await db.query(
            'UPDATE users SET password_hash = $1 WHERE user_id = $2',
            [newPasswordHash, userId]
        );

        return {
            success: true,
            message: 'Password changed successfully'
        };
    } catch (error) {
        return {
            success: false,
            error: error.message
        };
    }
}

module.exports = {
    hashPassword,
    verifyPassword,
    registerUser,
    loginUser,
    getUserById,
    adminExists,
    createAdmin,
    changePassword
};
