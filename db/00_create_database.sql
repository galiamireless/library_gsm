-- ===================================================================
-- SCRIPT 00: Creación de Base de Datos y Usuario
-- PostgreSQL - Sistema de Gestión de Librería
-- ===================================================================

-- Eliminar BD existente en desarrollo local
DROP DATABASE IF EXISTS gsm_library_db;
DROP USER IF EXISTS lib_gsm_user;

-- Crear usuario de aplicación
CREATE USER lib_gsm_user WITH PASSWORD 'lib_gsm_user666';

-- Crear base de datos
CREATE DATABASE gsm_library_db
    OWNER lib_gsm_user
    ENCODING 'UTF8'
    LC_COLLATE 'C'
    LC_CTYPE 'C'
    TEMPLATE template0;

-- Conectar a la base de datos
\c gsm_library_db

-- Permisos básicos del esquema público
GRANT CONNECT ON DATABASE gsm_library_db TO lib_gsm_user;
GRANT USAGE ON SCHEMA public TO lib_gsm_user;

-- Extensión para hashing y utilidades
CREATE EXTENSION IF NOT EXISTS pgcrypto;
