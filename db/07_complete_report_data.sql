-- SCRIPT 07: Completar datos mínimos para reporte y evidencias
-- Ejecutar después de 01_schema.sql y un seed base.
-- Es idempotente y no elimina información existente.

BEGIN;

-- Elevar catálogos básicos a 30 registros.
INSERT INTO authors (name, country, birth_year)
SELECT 'Autor académico ' || n, 'Mexico', 1970 + (n % 30)
FROM generate_series(1, 35) AS numbers(n)
WHERE NOT EXISTS (SELECT 1 FROM authors a WHERE a.name = 'Autor académico ' || n);

INSERT INTO genres (name, description)
SELECT 'Categoría ' || n, 'Categoría adicional para pruebas y clasificación.'
FROM generate_series(1, 35) AS numbers(n)
WHERE NOT EXISTS (SELECT 1 FROM genres g WHERE g.name = 'Categoría ' || n);

INSERT INTO concepts (name, description)
SELECT 'Concepto ' || n, 'Concepto adicional para pruebas del modelo normalizado.'
FROM generate_series(1, 35) AS numbers(n)
WHERE NOT EXISTS (SELECT 1 FROM concepts c WHERE c.name = 'Concepto ' || n);

-- Usuarios regulares de prueba hasta alcanzar 30 usuarios totales.
INSERT INTO users (username, email, password_hash, full_name, role, is_active)
SELECT 'tester' || n,
       'tester' || n || '@library.local',
       '$2b$10$6nK3iL7UMNFCERAeGOxuju1.6jV/uyW/v6WKrZtR5t.eSzLPverr.',
       'Usuario de prueba ' || n,
       'USER', TRUE
FROM generate_series(1, 30) AS numbers(n)
WHERE NOT EXISTS (SELECT 1 FROM users u WHERE u.username = 'tester' || n);

-- Garantizar al menos un autor por libro y superar 30 relaciones.
WITH ranked_books AS (
    SELECT b.isbn, row_number() OVER (ORDER BY b.isbn) AS position
    FROM books b
), ranked_authors AS (
    SELECT author_id, row_number() OVER (ORDER BY author_id) AS position
    FROM authors
)
INSERT INTO book_authors (isbn, author_id)
SELECT rb.isbn, ra.author_id
FROM ranked_books rb
JOIN ranked_authors ra ON ra.position = ((rb.position - 1) % (SELECT count(*) FROM ranked_authors)) + 1
ON CONFLICT (isbn, author_id) DO NOTHING;

-- Garantizar al menos 30 relaciones libro-concepto.
WITH ranked_books AS (
    SELECT b.isbn, row_number() OVER (ORDER BY b.isbn) AS position
    FROM books b
), ranked_concepts AS (
    SELECT concept_id, row_number() OVER (ORDER BY concept_id) AS position
    FROM concepts
)
INSERT INTO book_concepts (isbn, concept_id, definition)
SELECT rb.isbn, rc.concept_id, 'Definición de prueba para ' || c.name || ' en el libro ' || rb.isbn
FROM ranked_books rb
JOIN ranked_concepts rc ON rc.position = ((rb.position - 1) % (SELECT count(*) FROM ranked_concepts)) + 1
JOIN concepts c ON c.concept_id = rc.concept_id
ON CONFLICT (isbn, concept_id) DO NOTHING;

-- Asegurar que cada libro tenga al menos un género.
WITH ranked_books AS (
    SELECT b.isbn, row_number() OVER (ORDER BY b.isbn) AS position
    FROM books b
), ranked_genres AS (
    SELECT genre_id, row_number() OVER (ORDER BY genre_id) AS position
    FROM genres
)
INSERT INTO book_genres (isbn, genre_id)
SELECT rb.isbn, rg.genre_id
FROM ranked_books rb
JOIN ranked_genres rg ON rg.position = ((rb.position - 1) % (SELECT count(*) FROM ranked_genres)) + 1
ON CONFLICT (isbn, genre_id) DO NOTHING;

COMMIT;

-- Evidencia de conteos mínimos.
SELECT table_name, row_count AS total
FROM (
    SELECT 'books' AS table_name, count(*) AS row_count FROM books
    UNION ALL SELECT 'users', count(*) FROM users
    UNION ALL SELECT 'authors', count(*) FROM authors
    UNION ALL SELECT 'genres', count(*) FROM genres
    UNION ALL SELECT 'concepts', count(*) FROM concepts
    UNION ALL SELECT 'book_concepts', count(*) FROM book_concepts
    UNION ALL SELECT 'book_authors', count(*) FROM book_authors
    UNION ALL SELECT 'book_genres', count(*) FROM book_genres
) counts
ORDER BY table_name;
