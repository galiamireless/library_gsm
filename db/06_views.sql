-- ===================================================================
-- SCRIPT 06: Vistas para reportes y catálogo
-- ===================================================================

CREATE OR REPLACE VIEW v_books_catalog AS
SELECT
    b.isbn,
    b.title,
    b.description,
    b.price,
    b.stock,
    b.publication_year,
    b.publisher,
    f.name AS format_name,
    COUNT(DISTINCT ba.author_id) AS author_count,
    COUNT(DISTINCT bg.genre_id) AS genre_count,
    STRING_AGG(DISTINCT a.name, ', ' ORDER BY a.name) AS authors,
    STRING_AGG(DISTINCT g.name, ', ' ORDER BY g.name) AS genres,
    MAX(CASE WHEN bi.is_cover = TRUE THEN bi.image_url END) AS cover_image
FROM books b
LEFT JOIN formats f ON b.format_id = f.format_id
LEFT JOIN book_authors ba ON b.isbn = ba.isbn
LEFT JOIN authors a ON ba.author_id = a.author_id
LEFT JOIN book_genres bg ON b.isbn = bg.isbn
LEFT JOIN genres g ON bg.genre_id = g.genre_id
LEFT JOIN book_images bi ON b.isbn = bi.isbn
GROUP BY b.isbn, b.title, b.description, b.price, b.stock, b.publication_year, b.publisher, f.name;

CREATE OR REPLACE VIEW v_available_books AS
SELECT
    b.isbn,
    b.title,
    b.price,
    b.stock,
    b.publication_year,
    STRING_AGG(DISTINCT a.name, ', ' ORDER BY a.name) AS authors
FROM books b
LEFT JOIN book_authors ba ON b.isbn = ba.isbn
LEFT JOIN authors a ON ba.author_id = a.author_id
WHERE b.stock > 0
GROUP BY b.isbn, b.title, b.price, b.stock, b.publication_year
ORDER BY b.title;

CREATE OR REPLACE VIEW v_out_of_stock_books AS
SELECT
    b.isbn,
    b.title,
    b.price,
    b.publication_year,
    STRING_AGG(DISTINCT a.name, ', ' ORDER BY a.name) AS authors
FROM books b
LEFT JOIN book_authors ba ON b.isbn = ba.isbn
LEFT JOIN authors a ON ba.author_id = a.author_id
WHERE b.stock = 0
GROUP BY b.isbn, b.title, b.price, b.publication_year;

CREATE OR REPLACE VIEW v_books_by_author AS
SELECT
    a.author_id,
    a.name AS author_name,
    COUNT(ba.isbn) AS book_count,
    STRING_AGG(DISTINCT b.title, ', ' ORDER BY b.title) AS books
FROM authors a
LEFT JOIN book_authors ba ON a.author_id = ba.author_id
LEFT JOIN books b ON ba.isbn = b.isbn
GROUP BY a.author_id, a.name;

CREATE OR REPLACE VIEW v_books_by_genre AS
SELECT
    g.genre_id,
    g.name AS genre_name,
    COUNT(bg.isbn) AS book_count,
    STRING_AGG(DISTINCT b.title, ', ' ORDER BY b.title) AS books,
    AVG(b.price)::DECIMAL(10,2) AS avg_price,
    MIN(b.price)::DECIMAL(10,2) AS min_price,
    MAX(b.price)::DECIMAL(10,2) AS max_price
FROM genres g
LEFT JOIN book_genres bg ON g.genre_id = bg.genre_id
LEFT JOIN books b ON bg.isbn = b.isbn
GROUP BY g.genre_id, g.name;

CREATE OR REPLACE VIEW v_inventory_stats AS
SELECT
    COUNT(*) AS total_books,
    SUM(b.stock) AS total_stock,
    COUNT(CASE WHEN b.stock = 0 THEN 1 END) AS out_of_stock_count,
    COUNT(CASE WHEN b.stock > 0 THEN 1 END) AS available_count,
    AVG(b.price)::DECIMAL(10,2) AS avg_price,
    MIN(b.price)::DECIMAL(10,2) AS min_price,
    MAX(b.price)::DECIMAL(10,2) AS max_price,
    (SUM(b.stock) * AVG(b.price))::DECIMAL(12,2) AS total_inventory_value
FROM books b;

CREATE OR REPLACE VIEW v_expensive_books AS
SELECT
    b.isbn,
    b.title,
    b.price,
    b.stock,
    STRING_AGG(DISTINCT a.name, ', ' ORDER BY a.name) AS authors
FROM books b
LEFT JOIN book_authors ba ON b.isbn = ba.isbn
LEFT JOIN authors a ON ba.author_id = a.author_id
GROUP BY b.isbn, b.title, b.price, b.stock
ORDER BY b.price DESC
LIMIT 20;

CREATE OR REPLACE VIEW v_cheapest_books AS
SELECT
    b.isbn,
    b.title,
    b.price,
    b.stock,
    STRING_AGG(DISTINCT a.name, ', ' ORDER BY a.name) AS authors
FROM books b
LEFT JOIN book_authors ba ON b.isbn = ba.isbn
LEFT JOIN authors a ON ba.author_id = a.author_id
GROUP BY b.isbn, b.title, b.price, b.stock
ORDER BY b.price ASC
LIMIT 20;

CREATE OR REPLACE VIEW v_book_concepts_definitions AS
SELECT
    b.isbn,
    b.title,
    c.concept_id,
    c.name AS concept_name,
    bc.definition,
    bc.created_at
FROM books b
INNER JOIN book_concepts bc ON b.isbn = bc.isbn
INNER JOIN concepts c ON bc.concept_id = c.concept_id
ORDER BY b.title, c.name;

CREATE OR REPLACE VIEW v_recent_changes AS
SELECT
    al.log_id,
    al.table_name,
    al.operation,
    u.username AS changed_by,
    al.changed_at,
    al.old_values,
    al.new_values
FROM audit_log al
LEFT JOIN users u ON al.user_id = u.user_id
ORDER BY al.changed_at DESC
LIMIT 100;

CREATE OR REPLACE VIEW v_books_by_year AS
SELECT
    b.publication_year,
    COUNT(*) AS book_count,
    STRING_AGG(DISTINCT b.title, ', ' ORDER BY b.title) AS books
FROM books b
WHERE b.publication_year IS NOT NULL
GROUP BY b.publication_year
ORDER BY b.publication_year DESC;

CREATE OR REPLACE VIEW v_active_users AS
SELECT
    user_id,
    username,
    email,
    full_name,
    role,
    created_at
FROM users
WHERE is_active = TRUE
ORDER BY created_at DESC;

GRANT SELECT ON ALL TABLES IN SCHEMA public TO lib_gsm_user;
