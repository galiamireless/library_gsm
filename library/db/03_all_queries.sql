-- ===================================================================
-- SCRIPT 03: Consultas SQL Parametrizadas
-- Todas las consultas utilizan $1, $2... para prevenir SQL Injection
-- ===================================================================

-- AUTENTICACIÓN Y USUARIOS

-- Login: Obtener usuario por username
-- SELECT * FROM users WHERE username = $1;

-- Registrar nuevo usuario
-- INSERT INTO users (username, email, password_hash, full_name, role) 
-- VALUES ($1, $2, $3, $4, 'USER');

-- Verificar si existe admin
-- SELECT COUNT(*) as admin_count FROM users WHERE role = 'ADMIN';

-- LIBROS Y CATÁLOGO

-- Obtener todos los libros con paginación
-- SELECT isbn, title, price, stock, publication_year FROM books 
-- ORDER BY title LIMIT $1 OFFSET $2;

-- Buscar libros por título
-- SELECT isbn, title, price, stock FROM books 
-- WHERE LOWER(title) LIKE LOWER($1) 
-- LIMIT $2 OFFSET $3;

-- Obtener detalle completo de un libro con autores y géneros
-- SELECT b.isbn, b.title, b.description, b.price, b.stock, 
--        b.publication_year, f.name as format,
--        STRING_AGG(DISTINCT a.name, ', ') as authors,
--        STRING_AGG(DISTINCT g.name, ', ') as genres
-- FROM books b
-- LEFT JOIN formats f ON b.format_id = f.format_id
-- LEFT JOIN book_authors ba ON b.isbn = ba.isbn
-- LEFT JOIN authors a ON ba.author_id = a.author_id
-- LEFT JOIN book_genres bg ON b.isbn = bg.isbn
-- LEFT JOIN genres g ON bg.genre_id = g.genre_id
-- WHERE b.isbn = $1
-- GROUP BY b.isbn, b.title, b.description, b.price, b.stock, b.publication_year, f.name;

-- ADMINISTRACIÓN DE LIBROS

-- Crear nuevo libro
-- INSERT INTO books (isbn, title, description, publication_year, price, stock, format_id, publisher)
-- VALUES ($1, $2, $3, $4, $5, $6, $7, $8);

-- Actualizar libro
-- UPDATE books SET title = $1, description = $2, price = $3, stock = $4, format_id = $5
-- WHERE isbn = $6;

-- Eliminar libro y sus relaciones (ON DELETE CASCADE lo hace automático)
-- DELETE FROM books WHERE isbn = $1;

-- GESTIÓN DE AUTORES

-- Obtener autores de un libro
-- SELECT a.author_id, a.name FROM authors a
-- INNER JOIN book_authors ba ON a.author_id = ba.author_id
-- WHERE ba.isbn = $1;

-- Agregar autor a un libro
-- INSERT INTO book_authors (isbn, author_id) VALUES ($1, $2);

-- Crear nuevo autor
-- INSERT INTO authors (name, biography, birth_year, country) 
-- VALUES ($1, $2, $3, $4) RETURNING author_id;

-- GESTIÓN DE GÉNEROS

-- Obtener géneros de un libro
-- SELECT g.genre_id, g.name FROM genres g
-- INNER JOIN book_genres bg ON g.genre_id = bg.genre_id
-- WHERE bg.isbn = $1;

-- Agregar género a un libro
-- INSERT INTO book_genres (isbn, genre_id) VALUES ($1, $2);

-- CONCEPTOS Y DEFINICIONES

-- Obtener conceptos de un libro con sus definiciones
-- SELECT c.concept_id, c.name, bc.definition
-- FROM concepts c
-- INNER JOIN book_concepts bc ON c.concept_id = bc.concept_id
-- WHERE bc.isbn = $1
-- ORDER BY c.name;

-- Agregar concepto a un libro con definición
-- INSERT INTO book_concepts (isbn, concept_id, definition) 
-- VALUES ($1, $2, $3);

-- Actualizar definición de concepto en un libro
-- UPDATE book_concepts SET definition = $1 
-- WHERE isbn = $2 AND concept_id = $3;

-- Eliminar concepto de un libro
-- DELETE FROM book_concepts WHERE isbn = $1 AND concept_id = $2;

-- IMÁGENES

-- Obtener imágenes de un libro
-- SELECT image_id, image_url, alt_text, is_cover FROM book_images 
-- WHERE isbn = $1 ORDER BY is_cover DESC, uploaded_at;

-- Agregar imagen a un libro
-- INSERT INTO book_images (isbn, image_url, alt_text, is_cover) 
-- VALUES ($1, $2, $3, $4);

-- Eliminar imagen
-- DELETE FROM book_images WHERE image_id = $1;

-- BÚSQUEDAS COMPLEJAS

-- Búsqueda avanzada: libros por autor y género
-- SELECT DISTINCT b.isbn, b.title, b.price FROM books b
-- INNER JOIN book_authors ba ON b.isbn = ba.isbn
-- INNER JOIN authors a ON ba.author_id = a.author_id
-- INNER JOIN book_genres bg ON b.isbn = bg.isbn
-- INNER JOIN genres g ON bg.genre_id = g.genre_id
-- WHERE LOWER(a.name) LIKE LOWER($1) AND g.genre_id = $2;

-- Búsqueda de libros por rango de precio
-- SELECT isbn, title, price FROM books 
-- WHERE price BETWEEN $1 AND $2 
-- ORDER BY price ASC;

-- Buscar libros con stock disponible
-- SELECT isbn, title, price, stock FROM books 
-- WHERE stock > 0 
-- ORDER BY title;

-- Obtener resumen del catálogo
-- SELECT COUNT(*) as total_books, 
--        AVG(price) as avg_price, 
--        MIN(price) as min_price, 
--        MAX(price) as max_price,
--        SUM(stock) as total_stock
-- FROM books;

-- AUDITORÍA

-- Registrar cambio en auditoría (se usa desde triggers)
-- INSERT INTO audit_log (table_name, operation, user_id, old_values, new_values)
-- VALUES ($1, $2, $3, $4, $5);
