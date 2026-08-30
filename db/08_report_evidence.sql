-- Evidencias SQL para el reporte de Library UDEM
-- Ejecutar como lib_gsm_user sobre gsm_library_db.

\echo '1) Conteo de registros por tabla'
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

\echo '2) Libros sin autor o género'
SELECT
    (SELECT count(*) FROM books b WHERE NOT EXISTS (SELECT 1 FROM book_authors ba WHERE ba.isbn = b.isbn)) AS books_without_author,
    (SELECT count(*) FROM books b WHERE NOT EXISTS (SELECT 1 FROM book_genres bg WHERE bg.isbn = b.isbn)) AS books_without_genre;

\echo '3) Autores visibles por libro'
SELECT b.isbn, b.title, COALESCE(string_agg(DISTINCT a.name, ', '), 'SIN AUTOR') AS authors
FROM books b
LEFT JOIN book_authors ba ON ba.isbn = b.isbn
LEFT JOIN authors a ON a.author_id = ba.author_id
GROUP BY b.isbn, b.title
ORDER BY b.title
LIMIT 20;

\echo '4) Prueba de búsqueda case-insensitive parametrizable'
PREPARE search_books(text) AS
SELECT b.isbn, b.title
FROM books b
LEFT JOIN book_authors ba ON ba.isbn = b.isbn
LEFT JOIN authors a ON a.author_id = ba.author_id
WHERE b.title ILIKE '%' || $1 || '%'
   OR b.isbn ILIKE '%' || $1 || '%'
   OR b.description ILIKE '%' || $1 || '%'
   OR a.name ILIKE '%' || $1 || '%'
ORDER BY b.title;
EXECUTE search_books('martin');
DEALLOCATE search_books;

\echo '5) Verificación de claves foráneas huérfanas'
SELECT 'book_authors' AS relation, count(*) AS orphan_rows
FROM book_authors ba LEFT JOIN books b ON b.isbn = ba.isbn WHERE b.isbn IS NULL
UNION ALL
SELECT 'book_genres', count(*) FROM book_genres bg LEFT JOIN books b ON b.isbn = bg.isbn WHERE b.isbn IS NULL
UNION ALL
SELECT 'book_concepts', count(*) FROM book_concepts bc LEFT JOIN books b ON b.isbn = bc.isbn WHERE b.isbn IS NULL;
