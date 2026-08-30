-- ===================================================================
-- SCRIPT 04: Procedimientos Almacenados (Stored Procedures)
-- ===================================================================

-- Procedimiento para registrar un nuevo usuario con validación
CREATE OR REPLACE FUNCTION register_user(
    p_username VARCHAR,
    p_email VARCHAR,
    p_password_hash VARCHAR,
    p_full_name VARCHAR
) RETURNS TABLE (success BOOLEAN, message TEXT, user_id INTEGER) AS $$
BEGIN
    -- Verificar si el username ya existe
    IF EXISTS (SELECT 1 FROM users WHERE username = p_username) THEN
        RETURN QUERY SELECT FALSE::BOOLEAN, 'Username already exists'::TEXT, NULL::INTEGER;
        RETURN;
    END IF;
    
    -- Verificar si el email ya existe
    IF EXISTS (SELECT 1 FROM users WHERE email = p_email) THEN
        RETURN QUERY SELECT FALSE::BOOLEAN, 'Email already exists'::TEXT, NULL::INTEGER;
        RETURN;
    END IF;
    
    -- Insertar nuevo usuario
    INSERT INTO users (username, email, password_hash, full_name, role, is_active)
    VALUES (p_username, p_email, p_password_hash, p_full_name, 'USER', TRUE)
    RETURNING TRUE::BOOLEAN, 'User registered successfully'::TEXT, users.user_id
    INTO success, message, user_id;
    
    RETURN QUERY SELECT success, message, user_id;
END;
$$ LANGUAGE plpgsql;

-- Procedimiento para crear un libro con validación
CREATE OR REPLACE FUNCTION create_book(
    p_isbn VARCHAR,
    p_title VARCHAR,
    p_description TEXT,
    p_publication_year INTEGER,
    p_price DECIMAL,
    p_stock INTEGER,
    p_format_id INTEGER,
    p_publisher VARCHAR
) RETURNS TABLE (success BOOLEAN, message TEXT) AS $$
BEGIN
    -- Validar ISBN
    IF LENGTH(p_isbn) < 10 OR LENGTH(p_isbn) > 20 THEN
        RETURN QUERY SELECT FALSE::BOOLEAN, 'Invalid ISBN format'::TEXT;
        RETURN;
    END IF;
    
    -- Validar precio
    IF p_price < 0 THEN
        RETURN QUERY SELECT FALSE::BOOLEAN, 'Price cannot be negative'::TEXT;
        RETURN;
    END IF;
    
    -- Validar stock
    IF p_stock < 0 THEN
        RETURN QUERY SELECT FALSE::BOOLEAN, 'Stock cannot be negative'::TEXT;
        RETURN;
    END IF;
    
    -- Verificar si ISBN ya existe
    IF EXISTS (SELECT 1 FROM books WHERE isbn = p_isbn) THEN
        RETURN QUERY SELECT FALSE::BOOLEAN, 'ISBN already exists'::TEXT;
        RETURN;
    END IF;
    
    -- Insertar libro
    INSERT INTO books (isbn, title, description, publication_year, price, stock, format_id, publisher)
    VALUES (p_isbn, p_title, p_description, p_publication_year, p_price, p_stock, p_format_id, p_publisher);
    
    RETURN QUERY SELECT TRUE::BOOLEAN, 'Book created successfully'::TEXT;
END;
$$ LANGUAGE plpgsql;

-- Procedimiento para actualizar stock de un libro
CREATE OR REPLACE FUNCTION update_book_stock(
    p_isbn VARCHAR,
    p_quantity_change INTEGER
) RETURNS TABLE (success BOOLEAN, message TEXT, new_stock INTEGER) AS $$
DECLARE
    v_current_stock INTEGER;
    v_new_stock INTEGER;
BEGIN
    -- Obtener stock actual
    SELECT stock INTO v_current_stock FROM books WHERE isbn = p_isbn;
    
    IF NOT FOUND THEN
        RETURN QUERY SELECT FALSE::BOOLEAN, 'Book not found'::TEXT, NULL::INTEGER;
        RETURN;
    END IF;
    
    -- Calcular nuevo stock
    v_new_stock := v_current_stock + p_quantity_change;
    
    -- Validar que no sea negativo
    IF v_new_stock < 0 THEN
        RETURN QUERY SELECT FALSE::BOOLEAN, 'Insufficient stock'::TEXT, v_current_stock;
        RETURN;
    END IF;
    
    -- Actualizar stock
    UPDATE books SET stock = v_new_stock WHERE isbn = p_isbn;
    
    RETURN QUERY SELECT TRUE::BOOLEAN, 'Stock updated successfully'::TEXT, v_new_stock;
END;
$$ LANGUAGE plpgsql;

-- Procedimiento para obtener catálogo con paginación
CREATE OR REPLACE FUNCTION get_catalog(
    p_page INTEGER DEFAULT 1,
    p_per_page INTEGER DEFAULT 10
) RETURNS TABLE (
    isbn VARCHAR,
    title VARCHAR,
    price DECIMAL,
    stock INTEGER,
    publication_year INTEGER,
    total_count BIGINT
) AS $$
DECLARE
    v_offset INTEGER;
BEGIN
    v_offset := (p_page - 1) * p_per_page;
    
    RETURN QUERY
    SELECT 
        b.isbn, 
        b.title, 
        b.price, 
        b.stock, 
        b.publication_year,
        COUNT(*) OVER () as total_count
    FROM books b
    ORDER BY b.title
    LIMIT p_per_page OFFSET v_offset;
END;
$$ LANGUAGE plpgsql;

-- Procedimiento para búsqueda avanzada
CREATE OR REPLACE FUNCTION search_books(
    p_search_term VARCHAR DEFAULT '',
    p_min_price DECIMAL DEFAULT 0,
    p_max_price DECIMAL DEFAULT 9999999,
    p_page INTEGER DEFAULT 1,
    p_per_page INTEGER DEFAULT 10
) RETURNS TABLE (
    isbn VARCHAR,
    title VARCHAR,
    description TEXT,
    price DECIMAL,
    stock INTEGER,
    publication_year INTEGER,
    total_count BIGINT
) AS $$
DECLARE
    v_offset INTEGER;
    v_search_pattern VARCHAR;
BEGIN
    v_offset := (p_page - 1) * p_per_page;
    v_search_pattern := '%' || p_search_term || '%';
    
    RETURN QUERY
    SELECT 
        b.isbn, 
        b.title, 
        b.description, 
        b.price, 
        b.stock, 
        b.publication_year,
        COUNT(*) OVER () as total_count
    FROM books b
    WHERE (LOWER(b.title) LIKE LOWER(v_search_pattern) 
           OR LOWER(b.description) LIKE LOWER(v_search_pattern))
          AND b.price BETWEEN p_min_price AND p_max_price
    ORDER BY b.title
    LIMIT p_per_page OFFSET v_offset;
END;
$$ LANGUAGE plpgsql;

-- Procedimiento para obtener detalles completos de un libro
CREATE OR REPLACE FUNCTION get_book_details(p_isbn VARCHAR) RETURNS TABLE (
    title VARCHAR,
    description TEXT,
    price DECIMAL,
    stock INTEGER,
    publication_year INTEGER,
    publisher VARCHAR,
    format VARCHAR,
    authors TEXT,
    genres TEXT,
    concepts TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        b.title,
        b.description,
        b.price,
        b.stock,
        b.publication_year,
        b.publisher,
        f.name as format,
        STRING_AGG(DISTINCT a.name, ', ' ORDER BY a.name) as authors,
        STRING_AGG(DISTINCT g.name, ', ' ORDER BY g.name) as genres,
        STRING_AGG(DISTINCT c.name, ', ' ORDER BY c.name) as concepts
    FROM books b
    LEFT JOIN formats f ON b.format_id = f.format_id
    LEFT JOIN book_authors ba ON b.isbn = ba.isbn
    LEFT JOIN authors a ON ba.author_id = a.author_id
    LEFT JOIN book_genres bg ON b.isbn = bg.isbn
    LEFT JOIN genres g ON bg.genre_id = g.genre_id
    LEFT JOIN book_concepts bc ON b.isbn = bc.isbn
    LEFT JOIN concepts c ON bc.concept_id = c.concept_id
    WHERE b.isbn = p_isbn
    GROUP BY b.isbn, b.title, b.description, b.price, b.stock, b.publication_year, b.publisher, f.name;
END;
$$ LANGUAGE plpgsql;

-- Procedimiento para verificar permisos de admin
CREATE OR REPLACE FUNCTION is_admin(p_user_id INTEGER) RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (SELECT 1 FROM users WHERE user_id = p_user_id AND role = 'ADMIN');
END;
$$ LANGUAGE plpgsql;

-- Procedimiento para obtener conceptos con definiciones de un libro
CREATE OR REPLACE FUNCTION get_book_concepts(p_isbn VARCHAR) RETURNS TABLE (
    concept_id INTEGER,
    concept_name VARCHAR,
    definition TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c.concept_id,
        c.name as concept_name,
        bc.definition
    FROM concepts c
    INNER JOIN book_concepts bc ON c.concept_id = bc.concept_id
    WHERE bc.isbn = p_isbn
    ORDER BY c.name;
END;
$$ LANGUAGE plpgsql;
