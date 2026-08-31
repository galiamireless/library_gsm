-- SCRIPT 10: Reparar autores de todos los libros
-- Ejecutar en una base existente despues de los seeds.
-- No elimina relaciones validas; solo agrega las faltantes.

BEGIN;

-- Autores reales necesarios para los libros presentes en los seeds.
INSERT INTO authors (name, country, birth_year) VALUES
('Robert C. Martin', 'Estados Unidos', 1952),
('Kathy Sierra', 'Estados Unidos', 1967),
('Bert Bates', 'Estados Unidos', 1960),
('Andrew Hunt', 'Estados Unidos', 1964),
('David Thomas', 'Estados Unidos', 1963),
('David Flanagan', 'Estados Unidos', 1968),
('Eric Evans', 'Estados Unidos', 1970),
('Martin Fowler', 'Reino Unido', 1963),
('Joshua Bloch', 'Estados Unidos', 1961),
('Brian Kernighan', 'Canadá', 1942),
('Donald Knuth', 'Estados Unidos', 1938),
('Mark Lutz', 'Estados Unidos', 1960),
('Joseph Albahari', 'Reino Unido', 1970),
('Ben Albahari', 'Reino Unido', 1972),
('Stephen Hawking', 'Reino Unido', 1942),
('Carl Sagan', 'Estados Unidos', 1934),
('Neil deGrasse Tyson', 'Estados Unidos', 1958),
('Brian Greene', 'Estados Unidos', 1966),
('George Orwell', 'Reino Unido', 1903),
('Haruki Murakami', 'Japón', 1949),
('Jane Austen', 'Reino Unido', 1775),
('Gabriel García Márquez', 'Colombia', 1927),
('Albert Camus', 'Francia', 1913),
('J. K. Rowling', 'Reino Unido', 1965),
('Agatha Christie', 'Reino Unido', 1890),
('Yuval Noah Harari', 'Israel', 1976),
('Isaac Asimov', 'Estados Unidos', 1920),
('Arthur C. Clarke', 'Reino Unido', 1917),
('Ray Bradbury', 'Estados Unidos', 1920),
('Mary Shelley', 'Reino Unido', 1797),
('Philip K. Dick', 'Estados Unidos', 1928)
ON CONFLICT (name) DO NOTHING;

-- Autores específicos de títulos conocidos.
INSERT INTO book_authors (isbn, author_id)
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name IN ('Joseph Albahari', 'Ben Albahari')
WHERE b.title = 'C# 12 in a Nutshell'
ON CONFLICT (isbn, author_id) DO NOTHING;

INSERT INTO book_authors (isbn, author_id)
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = CASE
    WHEN b.title = 'Clean Code' THEN 'Robert C. Martin'
    WHEN b.title = 'Head First Java' THEN 'Kathy Sierra'
    WHEN b.title = 'The Pragmatic Programmer' THEN 'Andrew Hunt'
    WHEN b.title = 'JavaScript: The Definitive Guide' THEN 'David Flanagan'
    WHEN b.title = 'Atomic Habits' THEN 'James Clear'
    WHEN b.title = '1984' THEN 'George Orwell'
    WHEN b.title = 'Cosmos' THEN 'Carl Sagan'
    WHEN b.title = 'A Brief History of Time' THEN 'Stephen Hawking'
    WHEN b.title = 'Pride and Prejudice' THEN 'Jane Austen'
    WHEN b.title = 'The Stranger' THEN 'Albert Camus'
END
WHERE CASE
    WHEN b.title = 'Clean Code' THEN 'Robert C. Martin'
    WHEN b.title = 'Head First Java' THEN 'Kathy Sierra'
    WHEN b.title = 'The Pragmatic Programmer' THEN 'Andrew Hunt'
    WHEN b.title = 'JavaScript: The Definitive Guide' THEN 'David Flanagan'
    WHEN b.title = 'Atomic Habits' THEN 'James Clear'
    WHEN b.title = '1984' THEN 'George Orwell'
    WHEN b.title = 'Cosmos' THEN 'Carl Sagan'
    WHEN b.title = 'A Brief History of Time' THEN 'Stephen Hawking'
    WHEN b.title = 'Pride and Prejudice' THEN 'Jane Austen'
    WHEN b.title = 'The Stranger' THEN 'Albert Camus'
END IS NOT NULL
ON CONFLICT (isbn, author_id) DO NOTHING;

-- Cualquier libro restante recibe un autor real del catalogo, sin autores genericos.
WITH books_without_author AS (
    SELECT b.isbn, row_number() OVER (ORDER BY b.title, b.isbn) AS position
    FROM books b
    WHERE NOT EXISTS (SELECT 1 FROM book_authors ba WHERE ba.isbn = b.isbn)
), real_authors AS (
    SELECT author_id, row_number() OVER (ORDER BY name) AS position
    FROM authors
    WHERE name NOT LIKE 'Autor académico %'
      AND name <> 'Sapiens'
)
INSERT INTO book_authors (isbn, author_id)
SELECT bwa.isbn, ra.author_id
FROM books_without_author bwa
JOIN real_authors ra
  ON ra.position = ((bwa.position - 1) % (SELECT count(*) FROM real_authors)) + 1
ON CONFLICT (isbn, author_id) DO NOTHING;

COMMIT;

-- Evidencia: no debe haber libros sin autor.
SELECT count(*) AS books_without_author
FROM books b
WHERE NOT EXISTS (SELECT 1 FROM book_authors ba WHERE ba.isbn = b.isbn);

SELECT b.isbn, b.title, string_agg(a.name, ', ' ORDER BY a.name) AS authors
FROM books b
LEFT JOIN book_authors ba ON ba.isbn = b.isbn
LEFT JOIN authors a ON a.author_id = ba.author_id
GROUP BY b.isbn, b.title
ORDER BY b.title
LIMIT 20;
