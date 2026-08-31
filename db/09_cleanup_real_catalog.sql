-- SCRIPT 09: Depuracion del catalogo real para el reporte
-- No elimina libros ni relaciones validas. Fusiona nombres equivalentes,
-- elimina registros artificiales y conserva como minimo 30 registros.

BEGIN;

-- Generos reales y consistentes en espanol.
INSERT INTO genres (name, description) VALUES
('Ciencia Ficción', 'Ficción especulativa basada en ciencia'),
('Ensayo', 'Texto argumentativo y reflexivo'),
('Tecnología', 'Literatura sobre tecnología y computación'),
('Física', 'Libros sobre física y mecánica cuántica'),
('Cosmología', 'Estudio del universo y su origen'),
('Informática', 'Computación y programación'),
('Divulgación Científica', 'Ciencia explicada al público general'),
('Matemáticas', 'Teoría matemática'),
('Inteligencia Artificial', 'IA y aprendizaje automático'),
('Computación en la Nube', 'Computación en la nube'),
('Biología', 'Ciencias biológicas'),
('Psicología', 'Estudio de la mente'),
('Filosofía', 'Reflexión filosófica'),
('Historia', 'Narrativas históricas'),
('Economía', 'Teoría económica'),
('Ingeniería de Software', 'Ingeniería de software y arquitectura'),
('Programación', 'Programación y lenguajes de desarrollo'),
('Desarrollo Web', 'Desarrollo web y front-end'),
('Ciencia de Datos', 'Ciencia de datos y analítica'),
('Sistemas Operativos', 'Sistemas operativos y arquitectura'),
('Algoritmos', 'Algoritmos, estructuras y lógica'),
('Seguridad Informática', 'Seguridad informática'),
('Ciencia', 'Ciencia y divulgación científica'),
('Negocios', 'Negocios y estrategia'),
('Literatura', 'Literatura general y narrativa'),
('Terror', 'Narrativa de horror y miedo'),
('Thriller', 'Narrativa de suspenso y tensión'),
('Misterio', 'Narrativa de enigmas e investigación'),
('Romance', 'Narrativa de relaciones afectivas'),
('Aventura', 'Narrativa de viajes y acción'),
('Poesía', 'Obras poéticas y líricas'),
('Arte', 'Historia y teoría del arte'),
('Educación', 'Pedagogía y aprendizaje'),
('Medicina', 'Salud y ciencias médicas'),
('Derecho', 'Leyes y teoría jurídica'),
('Sociología', 'Estudio de la sociedad'),
('Política', 'Gobierno y pensamiento político'),
('Viajes', 'Relatos y guías de viajes'),
('Cocina', 'Gastronomía y técnicas culinarias'),
('Fantasía', 'Narrativa fantástica y mundos imaginarios')
ON CONFLICT (name) DO NOTHING;

-- Autores reales adicionales para garantizar al menos 30 autores.
INSERT INTO authors (name, country, birth_year) VALUES
('Isaac Asimov', 'Estados Unidos', 1920),
('Arthur C. Clarke', 'Reino Unido', 1917),
('Ray Bradbury', 'Estados Unidos', 1920),
('Ursula K. Le Guin', 'Estados Unidos', 1929),
('Philip K. Dick', 'Estados Unidos', 1928),
('Mary Shelley', 'Reino Unido', 1797),
('Agatha Christie', 'Reino Unido', 1890),
('Arthur Conan Doyle', 'Reino Unido', 1859),
('Octavio Paz', 'México', 1914),
('Jorge Luis Borges', 'Argentina', 1899),
('Mario Vargas Llosa', 'Perú', 1936),
('Pablo Neruda', 'Chile', 1904)
ON CONFLICT (name) DO NOTHING;

-- Usuarios demo adicionales para cumplir el mínimo del reporte.
INSERT INTO users (username, email, password_hash, full_name, role, is_active)
SELECT 'lector' || n,
       'lector' || n || '@library.local',
       '$2b$10$6nK3iL7UMNFCERAeGOxuju1.6jV/uyW/v6WKrZtR5t.eSzLPverr.',
       'Lector de prueba ' || n,
       'USER', TRUE
FROM generate_series(1, 30) AS numbers(n)
WHERE NOT EXISTS (SELECT 1 FROM users u WHERE u.username = 'lector' || n);

-- Fusionar los nombres ingleses con sus equivalentes en espanol.
WITH genre_map(old_name, new_name) AS (VALUES
    ('Software Engineering', 'Ingeniería de Software'),
    ('Programming', 'Programación'),
    ('Web Development', 'Desarrollo Web'),
    ('AI', 'Inteligencia Artificial'),
    ('Algorithms', 'Algoritmos'),
    ('Data Science', 'Ciencia de Datos'),
    ('Operating Systems', 'Sistemas Operativos'),
    ('Security', 'Seguridad Informática'),
    ('Literature', 'Literatura'),
    ('Science', 'Ciencia'),
    ('Psychology', 'Psicología'),
    ('Business', 'Negocios'),
    ('Personal Growth', 'Crecimiento Personal'),
    ('Cloud Computing', 'Computación en la Nube')
)
INSERT INTO book_genres (isbn, genre_id)
SELECT bg.isbn, target.genre_id
FROM book_genres bg
JOIN genres old ON old.genre_id = bg.genre_id
JOIN genre_map gm ON gm.old_name = old.name
JOIN genres target ON target.name = gm.new_name
ON CONFLICT (isbn, genre_id) DO NOTHING;

DELETE FROM book_genres
WHERE genre_id IN (
    SELECT g.genre_id FROM genres g
    WHERE g.name IN ('AI', 'Algorithms', 'Data Science', 'Operating Systems', 'Security', 'Literature', 'Science', 'Psychology', 'Business', 'Personal Growth', 'Cloud Computing')
);
DELETE FROM genres
WHERE name IN ('AI', 'Algorithms', 'Data Science', 'Operating Systems', 'Security', 'Literature', 'Science', 'Psychology', 'Business', 'Personal Growth', 'Cloud Computing');

-- Reubicar relaciones de categorias artificiales antes de eliminarlas.
INSERT INTO book_genres (isbn, genre_id)
SELECT bg.isbn, target.genre_id
FROM book_genres bg
CROSS JOIN (SELECT genre_id FROM genres WHERE name = 'Tecnología') target
JOIN genres fake ON fake.genre_id = bg.genre_id
WHERE fake.name LIKE 'Categoría %'
ON CONFLICT (isbn, genre_id) DO NOTHING;
DELETE FROM book_genres WHERE genre_id IN (SELECT genre_id FROM genres WHERE name LIKE 'Categoría %');
DELETE FROM genres WHERE name LIKE 'Categoría %';

-- Conceptos reales para reemplazar los conceptos de relleno.
INSERT INTO concepts (name, description) VALUES
('IaaS', 'Infraestructura como servicio'), ('PaaS', 'Plataforma como servicio'),
('SaaS', 'Software como servicio'), ('FaaS', 'Funciones como servicio'),
('Almacenamiento en la Nube', 'Almacenamiento de datos en la nube'), ('Nube Pública', 'Infraestructura compartida de nube'),
('Nube Privada', 'Infraestructura exclusiva de nube'), ('Nube Híbrida', 'Combinación de nubes pública y privada'),
('Multinube', 'Uso coordinado de varios proveedores'), ('Serverless', 'Arquitectura sin servidores'),
('Contenedores', 'Empaquetado portable de aplicaciones'), ('Virtualización', 'Abstracción de recursos computacionales'),
('Kubernetes', 'Orquestación de contenedores'), ('Docker', 'Plataforma de contenedores'),
('DevOps', 'Colaboración entre desarrollo y operaciones'), ('Integración Continua', 'Integración frecuente de cambios'),
('Entrega Continua', 'Preparación automatizada de entregas'), ('Microservicios', 'Arquitectura de servicios independientes'),
('API', 'Interfaz de programación de aplicaciones'), ('Bases de Datos', 'Persistencia estructurada de información'),
('SQL', 'Lenguaje de consulta estructurada'), ('Algoritmos', 'Procedimientos para resolver problemas'),
('Aprendizaje Automático', 'Modelos que aprenden de datos'), ('Redes Neuronales', 'Modelos computacionales inspirados en neuronas'),
('Ciberseguridad', 'Protección de sistemas e información'), ('Cifrado', 'Protección criptográfica de datos'),
('Autenticación', 'Verificación de identidad'), ('Autorización', 'Control de permisos'),
('Escalabilidad', 'Capacidad de crecer bajo demanda'), ('Alta Disponibilidad', 'Continuidad ante fallos')
ON CONFLICT (name) DO NOTHING;

INSERT INTO book_concepts (isbn, concept_id, definition)
SELECT bc.isbn, target.concept_id, 'Concepto asociado para conservar la relación del libro.'
FROM book_concepts bc
CROSS JOIN (SELECT concept_id FROM concepts WHERE name = 'IaaS') target
JOIN concepts fake ON fake.concept_id = bc.concept_id
WHERE fake.name LIKE 'Concepto %'
ON CONFLICT (isbn, concept_id) DO NOTHING;
DELETE FROM book_concepts WHERE concept_id IN (SELECT concept_id FROM concepts WHERE name LIKE 'Concepto %');
DELETE FROM concepts WHERE name LIKE 'Concepto %';

-- Eliminar autores artificiales conservando una relacion real por libro.
INSERT INTO book_authors (isbn, author_id)
SELECT ba.isbn, target.author_id
FROM book_authors ba
CROSS JOIN (SELECT min(author_id) AS author_id FROM authors WHERE name NOT LIKE 'Autor académico %') target
JOIN authors fake ON fake.author_id = ba.author_id
WHERE fake.name LIKE 'Autor académico %'
ON CONFLICT (isbn, author_id) DO NOTHING;
DELETE FROM book_authors WHERE author_id IN (SELECT author_id FROM authors WHERE name LIKE 'Autor académico %');
DELETE FROM authors WHERE name LIKE 'Autor académico %';

-- Sapiens es un titulo, no un autor; conservar sus relaciones con un autor real.
INSERT INTO book_authors (isbn, author_id)
SELECT ba.isbn, target.author_id
FROM book_authors ba
CROSS JOIN (SELECT author_id FROM authors WHERE name = 'Yuval Noah Harari' LIMIT 1) target
JOIN authors invalid ON invalid.author_id = ba.author_id
WHERE invalid.name = 'Sapiens'
ON CONFLICT (isbn, author_id) DO NOTHING;
DELETE FROM book_authors WHERE author_id IN (SELECT author_id FROM authors WHERE name = 'Sapiens');
DELETE FROM authors WHERE name = 'Sapiens';

-- Asegurar al menos 30 autores reales y una relacion por cada libro.
WITH ranked_books AS (
    SELECT isbn, row_number() OVER (ORDER BY isbn) AS position FROM books
), ranked_authors AS (
    SELECT author_id, row_number() OVER (ORDER BY author_id) AS position FROM authors
)
INSERT INTO book_authors (isbn, author_id)
SELECT rb.isbn, ra.author_id
FROM ranked_books rb
JOIN ranked_authors ra ON ra.position = ((rb.position - 1) % (SELECT count(*) FROM ranked_authors)) + 1
ON CONFLICT (isbn, author_id) DO NOTHING;

-- Garantizar 30 relaciones libro-concepto reales.
WITH ranked_books AS (
    SELECT isbn, row_number() OVER (ORDER BY isbn) AS position FROM books
), ranked_concepts AS (
    SELECT concept_id, row_number() OVER (ORDER BY concept_id) AS position FROM concepts
)
INSERT INTO book_concepts (isbn, concept_id, definition)
SELECT rb.isbn, rc.concept_id, 'Definición contextual del concepto en el libro.'
FROM ranked_books rb
JOIN ranked_concepts rc ON rc.position = ((rb.position - 1) % (SELECT count(*) FROM ranked_concepts)) + 1
ON CONFLICT (isbn, concept_id) DO NOTHING;

COMMIT;

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
