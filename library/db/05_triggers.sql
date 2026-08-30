-- ===================================================================
-- SCRIPT 05: Triggers de Auditoría y Automatización
-- ===================================================================

-- Función para auditar cambios en usuarios
CREATE OR REPLACE FUNCTION audit_users_changes() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO audit_log (table_name, operation, user_id, old_values, new_values)
    VALUES (
        'users',
        TG_OP,
        COALESCE(NEW.user_id, OLD.user_id),
        CASE WHEN TG_OP = 'DELETE' THEN row_to_json(OLD) ELSE NULL END,
        CASE WHEN TG_OP != 'DELETE' THEN row_to_json(NEW) ELSE NULL END
    );
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

-- Trigger para auditar cambios en usuarios
CREATE TRIGGER tg_audit_users
AFTER INSERT OR UPDATE OR DELETE ON users
FOR EACH ROW EXECUTE FUNCTION audit_users_changes();

-- Función para auditar cambios en libros
CREATE OR REPLACE FUNCTION audit_books_changes() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO audit_log (table_name, operation, user_id, old_values, new_values)
    VALUES (
        'books',
        TG_OP,
        1, -- Usuario del sistema (admin)
        CASE WHEN TG_OP = 'DELETE' THEN row_to_json(OLD) ELSE NULL END,
        CASE WHEN TG_OP != 'DELETE' THEN row_to_json(NEW) ELSE NULL END
    );
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

-- Trigger para auditar cambios en libros
CREATE TRIGGER tg_audit_books
AFTER INSERT OR UPDATE OR DELETE ON books
FOR EACH ROW EXECUTE FUNCTION audit_books_changes();

-- Función para actualizar timestamp de modificación en usuarios
CREATE OR REPLACE FUNCTION update_user_timestamp() RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para actualizar timestamp de usuarios
CREATE TRIGGER tg_update_user_timestamp
BEFORE UPDATE ON users
FOR EACH ROW EXECUTE FUNCTION update_user_timestamp();

-- Función para actualizar timestamp de modificación en libros
CREATE OR REPLACE FUNCTION update_book_timestamp() RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para actualizar timestamp de libros
CREATE TRIGGER tg_update_book_timestamp
BEFORE UPDATE ON books
FOR EACH ROW EXECUTE FUNCTION update_book_timestamp();

-- Función para validar que solo exista un admin
CREATE OR REPLACE FUNCTION validate_single_admin() RETURNS TRIGGER AS $$
BEGIN
    -- Si intenta crear o cambiar a ADMIN
    IF NEW.role = 'ADMIN' THEN
        -- Verificar si ya existe otro ADMIN
        IF EXISTS (SELECT 1 FROM users WHERE role = 'ADMIN' AND user_id != NEW.user_id) THEN
            RAISE EXCEPTION 'Only one ADMIN user is allowed in the system';
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para validar admin único
CREATE TRIGGER tg_validate_single_admin
BEFORE INSERT OR UPDATE ON users
FOR EACH ROW EXECUTE FUNCTION validate_single_admin();

-- Función para validar restricciones de libros
CREATE OR REPLACE FUNCTION validate_book_constraints() RETURNS TRIGGER AS $$
BEGIN
    -- Validar precio no negativo
    IF NEW.price < 0 THEN
        RAISE EXCEPTION 'Price cannot be negative';
    END IF;
    
    -- Validar stock no negativo
    IF NEW.stock < 0 THEN
        RAISE EXCEPTION 'Stock cannot be negative';
    END IF;
    
    -- Validar ISBN no vacío
    IF NEW.isbn IS NULL OR LENGTH(TRIM(NEW.isbn)) = 0 THEN
        RAISE EXCEPTION 'ISBN cannot be empty';
    END IF;
    
    -- Validar título no vacío
    IF NEW.title IS NULL OR LENGTH(TRIM(NEW.title)) = 0 THEN
        RAISE EXCEPTION 'Title cannot be empty';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para validar restricciones de libros
CREATE TRIGGER tg_validate_book_constraints
BEFORE INSERT OR UPDATE ON books
FOR EACH ROW EXECUTE FUNCTION validate_book_constraints();

-- Función para limpiar sesiones expiradas periódicamente
CREATE OR REPLACE FUNCTION cleanup_expired_sessions() RETURNS VOID AS $$
BEGIN
    DELETE FROM session WHERE expire < CURRENT_TIMESTAMP;
END;
$$ LANGUAGE plpgsql;

-- Función para registrar evento de descarga de libro
CREATE OR REPLACE FUNCTION log_book_access(p_isbn VARCHAR, p_user_id INTEGER) RETURNS VOID AS $$
BEGIN
    INSERT INTO audit_log (table_name, operation, user_id, new_values)
    VALUES ('book_access', 'SELECT', p_user_id, json_build_object('isbn', p_isbn));
END;
$$ LANGUAGE plpgsql;
