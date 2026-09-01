-- ===================================================================
-- SCRIPT 02: catálogo realista y compatible con 01_schema.sql
-- ===================================================================

INSERT INTO users (username, email, password_hash, full_name, role, is_active)
VALUES
('admin', 'admin@library.local', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'Administrator', 'ADMIN', TRUE),
('reader1', 'reader1@example.com', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'Reader One', 'USER', TRUE),
('reader2', 'reader2@example.com', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'Reader Two', 'USER', TRUE)
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
('Robert C. Martin', 'Ingeniero de software y autor de Clean Code.', 1952, 'USA'),
('David Flanagan', 'Autor y experto en JavaScript.', 1968, 'USA'),
('Joshua Bloch', 'Autor de Effective Java.', 1961, 'USA'),
('Andrew Hunt', 'Especialista en ingeniería de software.', 1964, 'USA'),
('David Thomas', 'Autor y coach de desarrollo.', 1963, 'USA'),
('Mark Lutz', 'Experto en Python y lenguajes de programación.', 1960, 'USA'),
('Stephen Hawking', 'Físico teórico británico.', 1942, 'United Kingdom'),
('Carl Sagan', 'Astrónomo y divulgador científico.', 1934, 'USA'),
('Neil deGrasse Tyson', 'Astrofísico y divulgador científico.', 1958, 'USA'),
('Brian Greene', 'Físico teórico y escritor.', 1966, 'USA'),
('Geoffrey West', 'Investigador en sistemas complejos y ciencia.', 1940, 'USA')
ON CONFLICT DO NOTHING;

INSERT INTO genres (name, description)
VALUES
('Ingeniería de Software', 'Buena calidad, arquitectura y mantenibilidad del software.'),
('Programación', 'Lenguajes y técnicas de desarrollo.'),
('Ciencia', 'Divulgación científica y estudio del universo.'),
('Computación en la Nube', 'Arquitecturas, infraestructura y servicios cloud.'),
('Literatura', 'Narrativa y obras literarias clásicas.'),
('Negocios', 'Estrategia, startups y productividad.')
ON CONFLICT (name) DO NOTHING;

INSERT INTO books (
    isbn, title, description, publication_year, price, stock, format_id, format_type, digital_format, publisher
)
VALUES
('9780132350884', 'Clean Code', 'Manual práctico para escribir software limpio y mantenible.', 2008, 39.99, 24, 2, 'PHYSICAL', NULL, 'Prentice Hall'),
('9780201616224', 'The Pragmatic Programmer', 'Guía para mejorar habilidades prácticas de desarrollo.', 1999, 45.50, 12, 2, 'PHYSICAL', NULL, 'Addison-Wesley'),
('9781119266303', 'JavaScript: The Definitive Guide', 'Referencia completa del lenguaje JavaScript.', 2017, 58.00, 16, 2, 'PHYSICAL', NULL, 'O''Reilly Media'),
('9781491952023', 'Effective Python', '90 maneras concretas de escribir mejor Python.', 2019, 41.00, 14, 2, 'PHYSICAL', NULL, 'O''Reilly Media'),
('9780134685991', 'Effective Java', 'Mejores prácticas para Java moderno.', 2018, 49.00, 11, 2, 'PHYSICAL', NULL, 'Addison-Wesley'),
('9780374175398', 'A Brief History of Time', 'Exploración del tiempo y el cosmos.', 1988, 18.99, 45, 1, 'PHYSICAL', NULL, 'Bantam'),
('9780394752778', 'Cosmos', 'Recorrido por la historia del universo y la ciencia.', 1980, 20.00, 50, 1, 'PHYSICAL', NULL, 'Random House'),
('9781617293360', 'Docker in Action', 'Guía para contenedores y despliegue moderno.', 2016, 42.00, 15, 2, 'PHYSICAL', NULL, 'Manning'),
('9781492032675', 'Kubernetes Up and Running', 'Introducción práctica a Kubernetes.', 2019, 46.00, 13, 2, 'PHYSICAL', NULL, 'O''Reilly Media'),
('9781492054861', 'Terraform Up & Running', 'Infraestructura como código para producción.', 2022, 52.00, 10, 2, 'PHYSICAL', NULL, 'O''Reilly Media'),
('9780061120084', 'To Kill a Mockingbird', 'Novela de justicia y crecimiento moral.', 1960, 20.00, 33, 2, 'PHYSICAL', NULL, 'Harper Perennial'),
('9780451524935', '1984', 'Clásico distópico sobre vigilancia y poder.', 1949, 18.00, 58, 2, 'PHYSICAL', NULL, 'Signet'),
('9780135213294', 'Cloud Computing Comprehensive Guide', 'Guía integral de cloud, IaaS, PaaS, SaaS y serverless.', 2024, 59.99, 100, 3, 'DIGITAL', 'PDF', 'Cloud Press International')
ON CONFLICT (isbn) DO NOTHING;

INSERT INTO book_authors (isbn, author_id)
VALUES
('9780132350884', 1),
('9780201616224', 4),
('9780201616224', 5),
('9781119266303', 2),
('9781491952023', 6),
('9780134685991', 3),
('9780374175398', 7),
('9780394752778', 8),
('9781617293360', 10),
('9781492032675', 10),
('9781492054861', 10),
('9780135213294', 11)
ON CONFLICT (isbn, author_id) DO NOTHING;

INSERT INTO book_genres (isbn, genre_id)
VALUES
('9780132350884', 1),
('9780201616224', 1),
('9781119266303', 2),
('9781491952023', 2),
('9780134685991', 2),
('9780374175398', 3),
('9780394752778', 3),
('9781617293360', 4),
('9781492032675', 4),
('9781492054861', 4),
('9780061120084', 5),
('9780451524935', 5),
('9780135213294', 4)
ON CONFLICT (isbn, genre_id) DO NOTHING;

INSERT INTO concepts (name, description)
VALUES
('IaaS', 'Infrastructure as a Service'),
('PaaS', 'Platform as a Service'),
('SaaS', 'Software as a Service'),
('FaaS', 'Function as a Service'),
('Bucket', 'Contenedor de almacenamiento cloud'),
('Serverless', 'Arquitectura sin administración de servidores')
ON CONFLICT (name) DO NOTHING;

INSERT INTO book_concepts (isbn, concept_id, definition)
VALUES
('9780135213294', (SELECT concept_id FROM concepts WHERE name = 'IaaS'), 'Infraestructura virtualizada que ofrece recursos de cómputo y red bajo demanda.'),
('9780135213294', (SELECT concept_id FROM concepts WHERE name = 'PaaS'), 'Entorno listo para desarrollar y desplegar aplicaciones sin gestionar el hardware.'),
('9780135213294', (SELECT concept_id FROM concepts WHERE name = 'SaaS'), 'Aplicaciones entregadas como servicio directamente al usuario.'),
('9780135213294', (SELECT concept_id FROM concepts WHERE name = 'FaaS'), 'Ejecución de funciones sin aprovisionar servidores dedicados.'),
('9780135213294', (SELECT concept_id FROM concepts WHERE name = 'Bucket'), 'Contenedor de almacenamiento orientado a objetos en la nube.'),
('9780135213294', (SELECT concept_id FROM concepts WHERE name = 'Serverless'), 'Modelo de despliegue donde la operación de infraestructura se abstrae completamente.')
ON CONFLICT (isbn, concept_id) DO NOTHING;

INSERT INTO book_images (isbn, image_url, alt_text, is_cover, source_type)
VALUES
('9780132350884', '/uploads/9780132350884.jpg', 'Portada Clean Code', TRUE, 'upload'),
('9780201616224', '/uploads/9780201616224.jpg', 'Portada The Pragmatic Programmer', TRUE, 'upload'),
('9781119266303', '/uploads/9781119266303.jpg', 'Portada JavaScript: The Definitive Guide', TRUE, 'upload'),
('9781491952023', '/uploads/9781491952023.jpg', 'Portada Effective Python', TRUE, 'upload'),
('9780134685991', '/uploads/9780134685991.jpg', 'Portada Effective Java', TRUE, 'upload'),
('9780374175398', '/uploads/9780374175398.jpg', 'Portada A Brief History of Time', TRUE, 'upload'),
('9780394752778', '/uploads/9780394752778.jpg', 'Portada Cosmos', TRUE, 'upload'),
('9781617293360', '/uploads/9781617293360.jpg', 'Portada Docker in Action', TRUE, 'upload'),
('9781492032675', '/uploads/9781492032675.jpg', 'Portada Kubernetes Up and Running', TRUE, 'upload'),
('9781492054861', '/uploads/9781492054861.jpg', 'Portada Terraform Up & Running', TRUE, 'upload'),
('9780135213294', '/uploads/9780135213294.jpg', 'Portada Cloud Computing Comprehensive Guide', TRUE, 'upload')
ON CONFLICT DO NOTHING;
