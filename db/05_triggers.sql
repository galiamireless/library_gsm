-- ===================================================================
-- SCRIPT 05: Triggers de auditoría y validación
-- ===================================================================

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

CREATE TRIGGER tg_audit_users
AFTER INSERT OR UPDATE OF username, email, password_hash, full_name, role, is_active OR DELETE ON users
FOR EACH ROW EXECUTE FUNCTION audit_users_changes();

CREATE OR REPLACE FUNCTION audit_books_changes() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO audit_log (table_name, operation, user_id, old_values, new_values)
    VALUES (
        'books',
        TG_OP,
        1,
        CASE WHEN TG_OP = 'DELETE' THEN row_to_json(OLD) ELSE NULL END,
        CASE WHEN TG_OP != 'DELETE' THEN row_to_json(NEW) ELSE NULL END
    );
    RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_audit_books
AFTER INSERT OR UPDATE OF title, description, publication_year, price, stock, format_id, format_type, digital_format, publisher OR DELETE ON books
FOR EACH ROW EXECUTE FUNCTION audit_books_changes();

CREATE OR REPLACE FUNCTION update_user_timestamp() RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_update_user_timestamp
BEFORE UPDATE ON users
FOR EACH ROW EXECUTE FUNCTION update_user_timestamp();

CREATE OR REPLACE FUNCTION update_book_timestamp() RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_update_book_timestamp
BEFORE UPDATE ON books
FOR EACH ROW EXECUTE FUNCTION update_book_timestamp();

CREATE OR REPLACE FUNCTION validate_single_admin() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.role = 'ADMIN' AND EXISTS (
        SELECT 1 FROM users WHERE role = 'ADMIN' AND user_id <> COALESCE(NEW.user_id, -1)
    ) THEN
        RAISE EXCEPTION 'Only one ADMIN user is allowed in the system';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_validate_single_admin
BEFORE INSERT OR UPDATE ON users
FOR EACH ROW EXECUTE FUNCTION validate_single_admin();

CREATE OR REPLACE FUNCTION validate_book_constraints() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.price < 0 THEN
        RAISE EXCEPTION 'Price cannot be negative';
    END IF;

    IF NEW.stock < 0 THEN
        RAISE EXCEPTION 'Stock cannot be negative';
    END IF;

    IF NEW.isbn IS NULL OR LENGTH(TRIM(NEW.isbn)) = 0 THEN
        RAISE EXCEPTION 'ISBN cannot be empty';
    END IF;

    IF NEW.title IS NULL OR LENGTH(TRIM(NEW.title)) = 0 THEN
        RAISE EXCEPTION 'Title cannot be empty';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_validate_book_constraints
BEFORE INSERT OR UPDATE ON books
FOR EACH ROW EXECUTE FUNCTION validate_book_constraints();

CREATE OR REPLACE FUNCTION cleanup_expired_sessions() RETURNS VOID AS $$
BEGIN
    DELETE FROM session WHERE expire < CURRENT_TIMESTAMP;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION log_book_access(p_isbn VARCHAR, p_user_id INTEGER) RETURNS VOID AS $$
BEGIN
    INSERT INTO audit_log (table_name, operation, user_id, new_values)
    VALUES ('book_access', 'INSERT', p_user_id, json_build_object('isbn', p_isbn));
END;
$$ LANGUAGE plpgsql;
