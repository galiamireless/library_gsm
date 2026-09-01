-- ===================================================================
-- SCRIPT 02: Datos sintéticos y semilla del catálogo
-- Requiere el esquema actual de 01_schema.sql
-- ===================================================================

INSERT INTO users (username, email, password_hash, full_name, role, is_active)
VALUES
('admin', 'admin@library.local', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'Administrator', 'ADMIN', TRUE),
('jdoe', 'john.doe@example.com', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'John Doe', 'USER', TRUE),
('jsmith', 'jane.smith@example.com', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'Jane Smith', 'USER', TRUE),
('mgarcia', 'maria.garcia@example.com', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'María García', 'USER', TRUE),
('alopez', 'alex.lopez@example.com', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'Alejandro López', 'USER', TRUE),
('cchen', 'carlos.chen@example.com', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'Carlos Chen', 'USER', TRUE)
ON CONFLICT (username) DO NOTHING;

INSERT INTO formats (name, description)
VALUES
('Hardcover', 'Tapa dura'),
('Paperback', 'Tapa blanda'),
('E-book', 'Libro electrónico'),
('Audiobook', 'Libro de audio')
ON CONFLICT (name) DO NOTHING;

INSERT INTO authors (name, biography, birth_year, country)
VALUES
('Stephen Hawking', 'Físico teórico británico.', 1942, 'United Kingdom'),
('Carl Sagan', 'Astrónomo y divulgador científico.', 1934, 'USA'),
('Richard Feynman', 'Físico teórico y divulgador.', 1918, 'USA'),
('David Deutsch', 'Físico cuántico británico.', 1953, 'United Kingdom'),
('Neil deGrasse Tyson', 'Astrofísico estadounidense.', 1958, 'USA'),
('Lisa Randall', 'Física teórica de partículas.', 1962, 'USA'),
('Michio Kaku', 'Físico teórico.', 1947, 'USA'),
('Brian Greene', 'Físico de cuerdas.', 1966, 'USA'),
('Lawrence Krauss', 'Físico astrofísico.', 1954, 'USA'),
('Max Tegmark', 'Cosmólogo y matemático.', 1967, 'USA'),
('Robert C. Martin', 'Desarrollador y autor de Clean Code.', 1952, 'USA'),
('David Flanagan', 'Experto en JavaScript.', 1968, 'USA'),
('Joshua Bloch', 'Autor de Effective Java.', 1961, 'USA'),
('Martin Fowler', 'Arquitecto de software.', 1963, 'United Kingdom'),
('Mark Lutz', 'Especialista en Python.', 1960, 'USA'),
('Geoffrey West', 'Investigador científico.', 1940, 'USA')
ON CONFLICT DO NOTHING;

INSERT INTO genres (name, description)
VALUES
('Ciencia', 'Ciencia y divulgación científica'),
('Computación', 'Tecnología y computación'),
('Programación', 'Programación y lenguajes de desarrollo'),
('Ciencia Ficción', 'Ficción especulativa'),
('Cosmología', 'Estudio del universo'),
('Ingeniería de Software', 'Buenas prácticas de software'),
('Cloud Computing', 'Tecnología de computación en la nube'),
('Divulgación Científica', 'Textos para público general')
ON CONFLICT (name) DO NOTHING;

INSERT INTO concepts (name, description)
VALUES
('IaaS', 'Infrastructure as a Service'),
('PaaS', 'Platform as a Service'),
('SaaS', 'Software as a Service'),
('FaaS', 'Function as a Service'),
('Bucket', 'Contenedor de almacenamiento cloud'),
('Public Cloud', 'Infraestructura pública compartida'),
('Private Cloud', 'Infraestructura privada dedicada'),
('Hybrid Cloud', 'Combinación de nube pública y privada'),
('Multicloud', 'Uso de múltiples proveedores cloud'),
('Serverless', 'Arquitectura sin administración de servidores')
ON CONFLICT (name) DO NOTHING;

INSERT INTO books (
    isbn, title, description, publication_year, price, stock, format_id, format_type, digital_format, publisher
)
VALUES
('9780374175398', 'A Brief History of Time', 'Exploración del tiempo, el espacio y el cosmos.', 1988, 18.99, 45, 1, 'PHYSICAL', NULL, 'Bantam'),
('9780394752778', 'Cosmos', 'Recorrido por el universo y la ciencia moderna.', 1980, 20.00, 50, 1, 'PHYSICAL', NULL, 'Random House'),
('9780465025275', 'QED: The Strange Theory of Light and Matter', 'Explicación clara de la electrodinámica cuántica.', 1985, 15.99, 35, 2, 'PHYSICAL', NULL, 'Princeton'),
('9780199297948', 'The Beginning of Infinity', 'Teoría del conocimiento y la explicación.', 2011, 22.50, 40, 1, 'PHYSICAL', NULL, 'Penguin'),
('9780393635066', 'Astrophysics for People in a Hurry', 'Guía breve para entender la astrofísica.', 2017, 16.99, 55, 2, 'PHYSICAL', NULL, 'Norton'),
('9781480583597', 'Dark Matter and Dark Energy', 'Misterios del universo observable.', 2016, 19.99, 30, 2, 'PHYSICAL', NULL, 'Kindle'),
('9780393243529', 'The Elegant Universe', 'Supercuerdas, dimensiones ocultas y teoría final.', 2003, 21.00, 38, 1, 'PHYSICAL', NULL, 'Norton'),
('9780132350884', 'Clean Code', 'Guía práctica para escribir software mantenible.', 2008, 39.99, 24, 2, 'PHYSICAL', NULL, 'Prentice Hall'),
('9781119266303', 'JavaScript: The Definitive Guide', 'Referencia completa de JavaScript.', 2017, 58.00, 16, 2, 'PHYSICAL', NULL, 'O''Reilly Media'),
('9781491952023', 'Effective Python', '90 formas de escribir mejor Python.', 2019, 41.00, 14, 2, 'PHYSICAL', NULL, 'O''Reilly Media'),
('9780135213294', 'Cloud Computing Comprehensive Guide', 'Guía integral de cloud, IaaS, PaaS, SaaS y serverless.', 2024, 59.99, 100, 3, 'DIGITAL', 'PDF', 'Cloud Press International')
ON CONFLICT (isbn) DO NOTHING;

INSERT INTO book_authors (isbn, author_id)
VALUES
('9780374175398', 1),
('9780394752778', 2),
('9780465025275', 3),
('9780199297948', 4),
('9780393635066', 5),
('9781480583597', 6),
('9780393243529', 7),
('9780132350884', 11),
('9781119266303', 12),
('9781491952023', 15),
('9780135213294', 16)
ON CONFLICT (isbn, author_id) DO NOTHING;

INSERT INTO book_genres (isbn, genre_id)
VALUES
('9780374175398', 1), ('9780374175398', 8),
('9780394752778', 1), ('9780394752778', 8),
('9780465025275', 1), ('9780465025275', 8),
('9780199297948', 1), ('9780199297948', 8),
('9780393635066', 1), ('9780393635066', 8),
('9781480583597', 1), ('9781480583597', 8),
('9780393243529', 1), ('9780393243529', 8),
('9780132350884', 6), ('9780132350884', 3),
('9781119266303', 3), ('9781119266303', 2),
('9781491952023', 3),
('9780135213294', 7), ('9780135213294', 2)
ON CONFLICT (isbn, genre_id) DO NOTHING;

INSERT INTO book_concepts (isbn, concept_id, definition)
VALUES
('9780135213294', 1, 'Infrastructure as a Service (IaaS) virtualiza la infraestructura de cómputo y almacenamiento.'),
('9780135213294', 2, 'Platform as a Service (PaaS) entrega un entorno listo para despliegue de aplicaciones.'),
('9780135213294', 3, 'Software as a Service (SaaS) brinda software listo para usar desde la web.'),
('9780135213294', 4, 'Function as a Service (FaaS) ejecuta código por eventos sin administrar servidores.'),
('9780135213294', 5, 'Un bucket es un contenedor para almacenamiento de objetos en la nube.'),
('9780135213294', 6, 'Public Cloud ofrece infraestructura compartida para múltiples usuarios.'),
('9780135213294', 7, 'Private Cloud entrega infraestructura dedicada a una organización.'),
('9780135213294', 8, 'Hybrid Cloud combina recursos públicos y privados.'),
('9780135213294', 9, 'Multicloud usa varios proveedores para mayor flexibilidad.'),
('9780135213294', 10, 'Serverless elimina la necesidad de administrar servidores.')
ON CONFLICT (isbn, concept_id) DO NOTHING;

INSERT INTO book_images (isbn, image_url, alt_text, is_cover, source_type)
VALUES
('9780374175398', '/uploads/9780374175398.jpg', 'Portada A Brief History of Time', TRUE, 'upload'),
('9780394752778', '/uploads/9780394752778.jpg', 'Portada Cosmos', TRUE, 'upload'),
('9780465025275', '/uploads/9780465025275.jpg', 'Portada QED', TRUE, 'upload'),
('9780199297948', '/uploads/9780199297948.jpg', 'Portada The Beginning of Infinity', TRUE, 'upload'),
('9780393635066', '/uploads/9780393635066.jpg', 'Portada Astrophysics for People in a Hurry', TRUE, 'upload'),
('9781480583597', '/uploads/9781480583597.jpg', 'Portada Dark Matter and Dark Energy', TRUE, 'upload'),
('9780393243529', '/uploads/9780393243529.jpg', 'Portada The Elegant Universe', TRUE, 'upload'),
('9780132350884', '/uploads/9780132350884.jpg', 'Portada Clean Code', TRUE, 'upload'),
('9781119266303', '/uploads/9781119266303.jpg', 'Portada JavaScript: The Definitive Guide', TRUE, 'upload'),
('9781491952023', '/uploads/9781491952023.jpg', 'Portada Effective Python', TRUE, 'upload'),
('9780135213294', '/uploads/9780135213294.jpg', 'Portada Cloud Computing Comprehensive Guide', TRUE, 'upload')
ON CONFLICT DO NOTHING;
