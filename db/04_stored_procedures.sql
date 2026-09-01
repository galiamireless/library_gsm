-- ===================================================================
-- SCRIPT 04: Procedimientos almacenados compatibles con el esquema
-- ===================================================================

CREATE OR REPLACE FUNCTION register_user(
    p_username VARCHAR,
    p_email VARCHAR,
    p_password_hash VARCHAR,
    p_full_name VARCHAR
) RETURNS TABLE (success BOOLEAN, message TEXT, user_id INTEGER) AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM users WHERE username = p_username) THEN
        RETURN QUERY SELECT FALSE::BOOLEAN, 'Username already exists'::TEXT, NULL::INTEGER;
        RETURN;
    END IF;

    IF EXISTS (SELECT 1 FROM users WHERE email = p_email) THEN
        RETURN QUERY SELECT FALSE::BOOLEAN, 'Email already exists'::TEXT, NULL::INTEGER;
        RETURN;
    END IF;

    INSERT INTO users (username, email, password_hash, full_name, role, is_active)
    VALUES (p_username, p_email, p_password_hash, p_full_name, 'USER', TRUE)
    RETURNING user_id INTO user_id;

    RETURN QUERY SELECT TRUE::BOOLEAN, 'User registered successfully'::TEXT, user_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION create_book(
    p_isbn VARCHAR,
    p_title VARCHAR,
    p_description TEXT,
    p_publication_year INTEGER,
    p_price DECIMAL,
    p_stock INTEGER,
    p_format_id INTEGER,
    p_publisher VARCHAR,
    p_format_type VARCHAR DEFAULT 'PHYSICAL',
    p_digital_format VARCHAR DEFAULT NULL
) RETURNS TABLE (success BOOLEAN, message TEXT) AS $$
BEGIN
    IF p_isbn IS NULL OR LENGTH(TRIM(p_isbn)) = 0 THEN
        RETURN QUERY SELECT FALSE::BOOLEAN, 'ISBN is required'::TEXT;
        RETURN;
    END IF;

    IF p_title IS NULL OR LENGTH(TRIM(p_title)) = 0 THEN
        RETURN QUERY SELECT FALSE::BOOLEAN, 'Title is required'::TEXT;
        RETURN;
    END IF;

    IF p_price < 0 THEN
        RETURN QUERY SELECT FALSE::BOOLEAN, 'Price cannot be negative'::TEXT;
        RETURN;
    END IF;

    IF p_stock < 0 THEN
        RETURN QUERY SELECT FALSE::BOOLEAN, 'Stock cannot be negative'::TEXT;
        RETURN;
    END IF;

    IF EXISTS (SELECT 1 FROM books WHERE isbn = p_isbn) THEN
        RETURN QUERY SELECT FALSE::BOOLEAN, 'ISBN already exists'::TEXT;
        RETURN;
    END IF;

    IF p_format_type = 'DIGITAL' AND p_digital_format NOT IN ('PDF', 'EPUB') THEN
        RETURN QUERY SELECT FALSE::BOOLEAN, 'Digital books must declare PDF or EPUB'::TEXT;
        RETURN;
    END IF;

    INSERT INTO books (
        isbn, title, description, publication_year, price, stock, format_id, publisher,
        format_type, digital_format
    )
    VALUES (
        p_isbn, p_title, p_description, p_publication_year, p_price, p_stock,
        p_format_id, p_publisher, p_format_type, p_digital_format
    );

    RETURN QUERY SELECT TRUE::BOOLEAN, 'Book created successfully'::TEXT;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_book_stock(
    p_isbn VARCHAR,
    p_quantity_change INTEGER
) RETURNS TABLE (success BOOLEAN, message TEXT, new_stock INTEGER) AS $$
DECLARE
    v_current_stock INTEGER;
    v_new_stock INTEGER;
BEGIN
    SELECT stock INTO v_current_stock FROM books WHERE isbn = p_isbn;

    IF NOT FOUND THEN
        RETURN QUERY SELECT FALSE::BOOLEAN, 'Book not found'::TEXT, NULL::INTEGER;
        RETURN;
    END IF;

    v_new_stock := v_current_stock + p_quantity_change;

    IF v_new_stock < 0 THEN
        RETURN QUERY SELECT FALSE::BOOLEAN, 'Insufficient stock'::TEXT, v_current_stock;
        RETURN;
    END IF;

    UPDATE books SET stock = v_new_stock WHERE isbn = p_isbn;

    RETURN QUERY SELECT TRUE::BOOLEAN, 'Stock updated successfully'::TEXT, v_new_stock;
END;
$$ LANGUAGE plpgsql;

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
    SELECT b.isbn, b.title, b.price, b.stock, b.publication_year, COUNT(*) OVER () AS total_count
    FROM books b
    ORDER BY b.title
    LIMIT p_per_page OFFSET v_offset;
END;
$$ LANGUAGE plpgsql;

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
    v_pattern VARCHAR;
BEGIN
    v_offset := (p_page - 1) * p_per_page;
    v_pattern := '%' || COALESCE(p_search_term, '') || '%';

    RETURN QUERY
    SELECT b.isbn, b.title, b.description, b.price, b.stock, b.publication_year, COUNT(*) OVER() AS total_count
    FROM books b
    WHERE (
        LOWER(b.title) LIKE LOWER(v_pattern)
        OR LOWER(COALESCE(b.description, '')) LIKE LOWER(v_pattern)
        OR LOWER(COALESCE(b.isbn, '')) LIKE LOWER(v_pattern)
    )
      AND b.price BETWEEN p_min_price AND p_max_price
    ORDER BY b.title
    LIMIT p_per_page OFFSET v_offset;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_book_details(p_isbn VARCHAR) RETURNS TABLE (
    title VARCHAR,
    description TEXT,
    price DECIMAL,
    stock INTEGER,
    publication_year INTEGER,
    publisher VARCHAR,
    format_name VARCHAR,
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
        f.name,
        STRING_AGG(DISTINCT a.name, ', ' ORDER BY a.name),
        STRING_AGG(DISTINCT g.name, ', ' ORDER BY g.name),
        STRING_AGG(DISTINCT c.name, ', ' ORDER BY c.name)
    FROM books b
    LEFT JOIN formats f ON b.format_id = f.format_id
    LEFT JOIN book_authors ba ON b.isbn = ba.isbn
    LEFT JOIN authors a ON ba.author_id = a.author_id
    LEFT JOIN book_genres bg ON b.isbn = bg.isbn
    LEFT JOIN genres g ON bg.genre_id = g.genre_id
    LEFT JOIN book_concepts bc ON b.isbn = bc.isbn
    LEFT JOIN concepts c ON bc.concept_id = c.concept_id
    WHERE b.isbn = p_isbn
    GROUP BY b.title, b.description, b.price, b.stock, b.publication_year, b.publisher, f.name;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_book_concepts(p_isbn VARCHAR) RETURNS TABLE (
    concept_id INTEGER,
    concept_name VARCHAR,
    definition TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT c.concept_id, c.name AS concept_name, bc.definition
    FROM concepts c
    INNER JOIN book_concepts bc ON c.concept_id = bc.concept_id
    WHERE bc.isbn = p_isbn
    ORDER BY c.name;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION is_admin(p_user_id INTEGER) RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (SELECT 1 FROM users WHERE user_id = p_user_id AND role = 'ADMIN');
END;
$$ LANGUAGE plpgsql;
