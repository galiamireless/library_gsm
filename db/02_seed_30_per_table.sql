-- ===================================================================
-- SCRIPT 02: Datos Sintéticos (30+ registros por tabla)
-- Incluye libro especial "Cloud Computing" con definiciones de conceptos
-- ===================================================================

-- Insertar Administrador Único
INSERT INTO users (username, email, password_hash, full_name, role, is_active) VALUES
('admin', 'admin@library.local', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'Administrator', 'ADMIN', TRUE);

INSERT INTO users (username, email, password_hash, full_name, role, is_active) VALUES
('jdoe', 'john.doe@example.com', '$2b$10$x9.V5gSBCJDcRHjAYlhsm.xQfXp0lPGGPPvLp9pRXqJvB5P8bVBOO', 'John Doe', 'USER', TRUE),
('jsmith', 'jane.smith@example.com', '$2b$10$x9.V5gSBCJDcRHjAYlhsm.xQfXp0lPGGPPvLp9pRXqJvB5P8bVBOO', 'Jane Smith', 'USER', TRUE),
('mgarcia', 'maria.garcia@example.com', '$2b$10$x9.V5gSBCJDcRHjAYlhsm.xQfXp0lPGGPPvLp9pRXqJvB5P8bVBOO', 'María García', 'USER', TRUE),
('alopez', 'alex.lopez@example.com', '$2b$10$x9.V5gSBCJDcRHjAYlhsm.xQfXp0lPGGPPvLp9pRXqJvB5P8bVBOO', 'Alejandro López', 'USER', TRUE),
('cchen', 'carlos.chen@example.com', '$2b$10$x9.V5gSBCJDcRHjAYlhsm.xQfXp0lPGGPPvLp9pRXqJvB5P8bVBOO', 'Carlos Chen', 'USER', TRUE),
('erodrigue', 'emma.rodriguez@example.com', '$2b$10$x9.V5gSBCJDcRHjAYlhsm.xQfXp0lPGGPPvLp9pRXqJvB5P8bVBOO', 'Emma Rodríguez', 'USER', TRUE),
('kmuller', 'klaus.muller@example.com', '$2b$10$x9.V5gSBCJDcRHjAYlhsm.xQfXp0lPGGPPvLp9pRXqJvB5P8bVBOO', 'Klaus Müller', 'USER', TRUE),
('fmartin', 'florence.martin@example.com', '$2b$10$x9.V5gSBCJDcRHjAYlhsm.xQfXp0lPGGPPvLp9pRXqJvB5P8bVBOO', 'Florence Martin', 'USER', TRUE),
('rkim', 'rosa.kim@example.com', '$2b$10$x9.V5gSBCJDcRHjAYlhsm.xQfXp0lPGGPPvLp9pRXqJvB5P8bVBOO', 'Rosa Kim', 'USER', TRUE);
('jdoe', 'john.doe@example.com', '$2b$10$6nK3iL7UMNFCERAeGOxuju1.6jV/uyW/v6WKrZtR5t.eSzLPverr.', 'John Doe', 'USER', TRUE),
('jsmith', 'jane.smith@example.com', '$2b$10$6nK3iL7UMNFCERAeGOxuju1.6jV/uyW/v6WKrZtR5t.eSzLPverr.', 'Jane Smith', 'USER', TRUE),
('mgarcia', 'maria.garcia@example.com', '$2b$10$6nK3iL7UMNFCERAeGOxuju1.6jV/uyW/v6WKrZtR5t.eSzLPverr.', 'María García', 'USER', TRUE),
('alopez', 'alex.lopez@example.com', '$2b$10$6nK3iL7UMNFCERAeGOxuju1.6jV/uyW/v6WKrZtR5t.eSzLPverr.', 'Alejandro López', 'USER', TRUE),
('cchen', 'carlos.chen@example.com', '$2b$10$6nK3iL7UMNFCERAeGOxuju1.6jV/uyW/v6WKrZtR5t.eSzLPverr.', 'Carlos Chen', 'USER', TRUE),
('erodrigue', 'emma.rodriguez@example.com', '$2b$10$6nK3iL7UMNFCERAeGOxuju1.6jV/uyW/v6WKrZtR5t.eSzLPverr.', 'Emma Rodríguez', 'USER', TRUE),
('kmuller', 'klaus.muller@example.com', '$2b$10$6nK3iL7UMNFCERAeGOxuju1.6jV/uyW/v6WKrZtR5t.eSzLPverr.', 'Klaus Müller', 'USER', TRUE),
('fmartin', 'florence.martin@example.com', '$2b$10$6nK3iL7UMNFCERAeGOxuju1.6jV/uyW/v6WKrZtR5t.eSzLPverr.', 'Florence Martin', 'USER', TRUE),
('rkim', 'rosa.kim@example.com', '$2b$10$6nK3iL7UMNFCERAeGOxuju1.6jV/uyW/v6WKrZtR5t.eSzLPverr.', 'Rosa Kim', 'USER', TRUE);

-- Insertar Formatos
INSERT INTO formats (name, description) VALUES
('Hardcover', 'Tapa dura'),
('Paperback', 'Tapa blanda'),
('E-book', 'Libro electrónico'),
('Audiobook', 'Libro de audio');

-- Insertar Autores (25+)
INSERT INTO authors (name, biography, birth_year, country) VALUES
('Stephen Hawking', 'Físico teórico britanico', 1942, 'United Kingdom'),
('Carl Sagan', 'Astrónomo y divulgador científico americano', 1934, 'USA'),
('Richard Feynman', 'Físico teórico y divulgador', 1918, 'USA'),
('David Deutsch', 'Físico cuántico británico', 1953, 'United Kingdom'),
('Neil deGrasse Tyson', 'Astrofísico americano', 1958, 'USA'),
('Lisa Randall', 'Física teórica de partículas', 1962, 'USA'),
('Michio Kaku', 'Físico teórico japonés-americano', 1947, 'USA'),
('Brian Greene', 'Físico de cuerdas americano', 1966, 'USA'),
('Lawrence Krauss', 'Físico astrofísico americano', 1954, 'USA'),
('Max Tegmark', 'Cosmólogo sueco-americano', 1967, 'USA'),
('Paul Davies', 'Físico y escritor británico', 1946, 'United Kingdom'),
('John Barrow', 'Cosmólogo británico', 1952, 'United Kingdom'),
('Alan Lightman', 'Físico y escritor americano', 1948, 'USA'),
('Sean Carroll', 'Físico cosmólogo americano', 1966, 'USA'),
('Leonard Susskind', 'Físico teórico americano', 1940, 'USA'),
('Geoffrey West', 'Físico e investigador del Instituto Santa Fe', 1940, 'USA'),
('Carlo Rovelli', 'Físico teórico italiano', 1956, 'Italy'),
('Frank Tipler', 'Cosmólogo teórico americano', 1947, 'USA'),
('Andrei Linde', 'Cosmólogo ruso-americano', 1948, 'Russia'),
('Alan Guth', 'Cosmólogo americano', 1947, 'USA'),
('Roger Penrose', 'Matemático y físico británico', 1931, 'United Kingdom'),
('Juan Maldacena', 'Físico argentino-americano', 1968, 'Argentina'),
('Kip Thorne', 'Físico americano premio Nobel', 1940, 'USA'),
('Rainer Weiss', 'Físico americano premio Nobel', 1932, 'USA'),
('Barry Barish', 'Físico americano premio Nobel', 1956, 'USA');

-- Insertar Géneros (15+)
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
('Cloud Computing', 'Computación en la nube'),
('Biología', 'Ciencias biológicas'),
('Psicología', 'Estudio de la mente'),
('Filosofía', 'Reflexión filosófica'),
('Historia', 'Narrativas históricas'),
('Economía', 'Teoría económica');

-- Insertar Conceptos Clave para el Libro de Cloud Computing
INSERT INTO concepts (name, description) VALUES
('IaaS', 'Infrastructure as a Service'),
('PaaS', 'Platform as a Service'),
('SaaS', 'Software as a Service'),
('FaaS', 'Function as a Service'),
('Bucket', 'Contenedor de almacenamiento en la nube'),
('Public Cloud', 'Infraestructura en la nube pública'),
('Private Cloud', 'Infraestructura en la nube privada'),
('Hybrid Cloud', 'Combinación de nube pública y privada'),
('Multicloud', 'Uso de múltiples proveedores de nube'),
('Serverless', 'Arquitectura sin servidores');

-- Insertar Libros (20+)
INSERT INTO books (isbn, title, description, publication_year, price, stock, format_id, publisher) VALUES
('978-0374175398', 'A Brief History of Time', 'Exploration of time, space, and the cosmos.', 1988, 18.99, 45, 1, 'Bantam'),
('978-0394752778', 'Cosmos', 'A journey through space and time exploring the universe.', 1980, 20.00, 50, 1, 'Random House'),
('978-0465025275', 'QED: The Strange Theory of Light and Matter', 'Quantum electrodynamics explained.', 1985, 15.99, 35, 2, 'Princeton'),
('978-0199297948', 'The Beginning of Infinity', 'Explanation and knowledge in the universe.', 2011, 22.50, 40, 1, 'Penguin'),
('978-0393635066', 'Astrophysics for People in a Hurry', 'Quick guide to understanding the cosmos.', 2017, 16.99, 55, 2, 'Norton'),
('978-1480583597', 'Dark Matter and Dark Energy', 'Exploring the mysteries of the universe.', 2016, 19.99, 30, 2, 'Kindle'),
('978-0393243529', 'The Elegant Universe', 'Superstrings, hidden dimensions and the quest for the ultimate theory.', 2003, 21.00, 38, 1, 'Norton'),
('978-0385407571', 'A Universe from Nothing', 'Why there is something rather than nothing.', 2012, 17.50, 42, 2, 'Free Press'),
('978-0670021253', 'The Mathematical Universe', 'Our reality as a mathematical structure.', 2014, 23.00, 28, 1, 'Knopf'),
('978-0062226761', 'Something Deeply Hidden', 'Quantum mechanics and quantum entanglement.', 2019, 18.95, 33, 1, 'Dutton'),
('978-0874517880', 'The Structure and Interpretation of Computer Programs', 'Fundamental computer science.', 1996, 65.00, 15, 1, 'MIT Press'),
('978-0262033848', 'Introduction to Algorithms', 'Classic algorithms textbook.', 2009, 89.99, 12, 1, 'MIT Press'),
('978-0136019008', 'Clean Code', 'Writing code that is readable and maintainable.', 2008, 32.00, 25, 2, 'Prentice Hall'),
('978-0201616224', 'Design Patterns', 'Elements of Reusable Object-Oriented Software.', 1994, 54.99, 18, 1, 'Addison-Wesley'),
('978-0596007974', 'Learning Python', 'Comprehensive Python programming guide.', 2013, 39.99, 22, 2, 'O''Reilly'),
('978-1491954324', 'JavaScript: The Definitive Guide', 'Complete reference for JavaScript.', 2020, 59.99, 16, 1, 'O''Reilly'),
('978-1492092544', 'Kubernetes in Action', 'Container orchestration and deployment.', 2021, 44.99, 20, 1, 'Manning'),
('978-1491908779', 'Docker in Action', 'Container technology for applications.', 2016, 38.00, 17, 2, 'Manning'),
('978-0134685991', 'Effective Java', 'Programming language best practices.', 2018, 54.00, 19, 1, 'Addison-Wesley'),
('978-0596517748', 'Head First Design Patterns', 'Object-oriented design patterns made simple.', 2004, 35.00, 21, 2, 'O''Reilly'),
-- LIBRO ESPECIAL: Cloud Computing
('978-0-13-521329-4', 'Cloud Computing Comprehensive Guide', 'Complete guide to cloud architecture, deployment, and best practices. From IaaS to Serverless, covers all cloud paradigms and platforms.', 2024, 59.99, 100, 1, 'Cloud Press International');

-- Asociar Autores con Libros
INSERT INTO book_authors (isbn, author_id) VALUES
('978-0374175398', 1),  -- A Brief History of Time - Stephen Hawking
('978-0394752778', 2),  -- Cosmos - Carl Sagan
('978-0465025275', 3),  -- QED - Richard Feynman
('978-0199297948', 4),  -- The Beginning of Infinity - David Deutsch
('978-0393635066', 5),  -- Astrophysics for People in a Hurry - Neil deGrasse Tyson
('978-1480583597', 6),  -- Dark Matter and Dark Energy - Lisa Randall
('978-0393243529', 7),  -- The Elegant Universe - Michio Kaku
('978-0385407571', 8),  -- A Universe from Nothing - Lawrence Krauss
('978-0670021253', 9),  -- The Mathematical Universe - Max Tegmark
('978-0062226761', 10), -- Something Deeply Hidden - Sean Carroll
('978-0874517880', 11), -- SICP - Harold Abelson
('978-0262033848', 12), -- Introduction to Algorithms - Thomas Cormen
('978-0136019008', 13), -- Clean Code - Robert Martin
('978-0201616224', 14), -- Design Patterns - Gang of Four
('978-0596007974', 15), -- Learning Python - Mark Lutz
('978-1491954324', 16), -- JavaScript Definitive Guide - David Flanagan
('978-1492092544', 17), -- Kubernetes in Action - Marko Luksa
('978-1491908779', 18), -- Docker in Action - Jeff Nickoloff
('978-0134685991', 19), -- Effective Java - Joshua Bloch
('978-0596517748', 20), -- Head First Design Patterns - Freeman & Freeman
('978-0-13-521329-4', 21); -- Cloud Computing Comprehensive Guide - Geoffrey West

-- Asociar Géneros con Libros
INSERT INTO book_genres (isbn, genre_id) VALUES
('978-0374175398', 4), ('978-0374175398', 7),
('978-0394752778', 5), ('978-0394752778', 7),
('978-0465025275', 4), ('978-0465025275', 7),
('978-0199297948', 4), ('978-0199297948', 13),
('978-0393635066', 5), ('978-0393635066', 7),
('978-1480583597', 4), ('978-1480583597', 5),
('978-0393243529', 4), ('978-0393243529', 7),
('978-0385407571', 4), ('978-0385407571', 5),
('978-0670021253', 5), ('978-0670021253', 8),
('978-0062226761', 4), ('978-0062226761', 13),
('978-0874517880', 6), ('978-0874517880', 8),
('978-0262033848', 6), ('978-0262033848', 8),
('978-0136019008', 6), ('978-0136019008', 2),
('978-0201616224', 6), ('978-0201616224', 2),
('978-0596007974', 6), ('978-0596007974', 3),
('978-1491954324', 6), ('978-1491954324', 3),
('978-1492092544', 10), ('978-1492092544', 3),
('978-1491908779', 10), ('978-1491908779', 3),
('978-0134685991', 6), ('978-0134685991', 3),
('978-0596517748', 6), ('978-0596517748', 2),
('978-0-13-521329-4', 10), ('978-0-13-521329-4', 3), ('978-0-13-521329-4', 7);

-- Asociar Conceptos con el Libro de Cloud Computing con Definiciones Específicas
INSERT INTO book_concepts (isbn, concept_id, definition) VALUES
('978-0-13-521329-4', 1, 'Infrastructure as a Service (IaaS) proporciona recursos informáticos virtualizados a través de internet. En este libro, se explora cómo IaaS permite a las empresas escalar sus infraestructuras sin inversiones en servidores físicos, cubriendo proveedores como AWS EC2, Microsoft Azure, y Google Cloud.'),
('978-0-13-521329-4', 2, 'Platform as a Service (PaaS) ofrece un entorno completo para desarrollar, probar y desplegar aplicaciones en la nube. Este texto detalla cómo PaaS simplifica el ciclo de vida del desarrollo y menciona plataformas como Heroku, Google App Engine, y Azure App Service.'),
('978-0-13-521329-4', 3, 'Software as a Service (SaaS) entrega aplicaciones de software directamente a través del navegador. En este libro se analiza cómo SaaS ha transformado la forma en que las empresas utilizan software, con ejemplos de Salesforce, Microsoft 365, y Slack.'),
('978-0-13-521329-4', 4, 'Function as a Service (FaaS) es un modelo de computación sin servidor donde se ejecutan funciones en respuesta a eventos. El libro explora arquitecturas serverless con AWS Lambda, Google Cloud Functions, y Azure Functions.'),
('978-0-13-521329-4', 5, 'Los Buckets son contenedores de almacenamiento de objetos en la nube que permiten guardar y recuperar datos de forma escalable. Este libro cubre cómo Amazon S3, Google Cloud Storage, y Azure Blob Storage utilizan buckets para la gestión eficiente de datos.'),
('978-0-13-521329-4', 6, 'Public Cloud es una infraestructura en la nube accesible al público en general. El texto examina ventajas de escalabilidad, costos reducidos, y desventajas de seguridad que caracteran la nube pública.'),
('978-0-13-521329-4', 7, 'Private Cloud es una infraestructura dedicada exclusivamente a una organización. Este libro detalla cómo las empresas construyen nubes privadas para mayor control, seguridad y cumplimiento normativo.'),
('978-0-13-521329-4', 8, 'Hybrid Cloud combina infraestructuras de nube pública y privada para máxima flexibilidad. El texto explore estrategias de migración gradual y orquestación entre nubes públicas y privadas.'),
('978-0-13-521329-4', 9, 'Multicloud es la estrategia de utilizar múltiples proveedores de nube simultáneamente. Este libro advierte sobre los riesgos de vendor lock-in y proporciona mejores prácticas para gestionar aplicaciones en múltiples nubes.'),
('978-0-13-521329-4', 10, 'Serverless es un modelo de arquitectura donde los desarrolladores no administran servidores. El libro profundiza en cómo Serverless reduce costos operacionales y permite que los equipos se enfoquen en la lógica empresarial.');

-- Insertar Imágenes de Ejemplo (portadas)
INSERT INTO book_images (isbn, image_url, alt_text, is_cover) VALUES
('978-0374175398', '/uploads/978-0374175398.jpg', 'Portada A Brief History of Time', TRUE),
('978-0394752778', '/uploads/978-0394752778.jpg', 'Portada Cosmos', TRUE),
('978-0465025275', '/uploads/978-0465025275.jpg', 'Portada QED', TRUE),
('978-0199297948', '/uploads/978-0199297948.jpg', 'Portada The Beginning of Infinity', TRUE),
('978-0393635066', '/uploads/978-0393635066.jpg', 'Portada Astrophysics for People in a Hurry', TRUE),
('978-1480583597', '/uploads/978-1480583597.jpg', 'Portada Dark Matter and Dark Energy', TRUE),
('978-0393243529', '/uploads/978-0393243529.jpg', 'Portada The Elegant Universe', TRUE),
('978-0385407571', '/uploads/978-0385407571.jpg', 'Portada A Universe from Nothing', TRUE),
('978-0670021253', '/uploads/978-0670021253.jpg', 'Portada The Mathematical Universe', TRUE),
('978-0062226761', '/uploads/978-0062226761.jpg', 'Portada Something Deeply Hidden', TRUE),
('978-0874517880', '/uploads/978-0874517880.jpg', 'Portada SICP', TRUE),
('978-0262033848', '/uploads/978-0262033848.jpg', 'Portada Introduction to Algorithms', TRUE),
('978-0136019008', '/uploads/978-0136019008.jpg', 'Portada Clean Code', TRUE),
('978-0201616224', '/uploads/978-0201616224.jpg', 'Portada Design Patterns', TRUE),
('978-0596007974', '/uploads/978-0596007974.jpg', 'Portada Learning Python', TRUE),
('978-1491954324', '/uploads/978-1491954324.jpg', 'Portada JavaScript Definitive Guide', TRUE),
('978-1492092544', '/uploads/978-1492092544.jpg', 'Portada Kubernetes in Action', TRUE),
('978-1491908779', '/uploads/978-1491908779.jpg', 'Portada Docker in Action', TRUE),
('978-0134685991', '/uploads/978-0134685991.jpg', 'Portada Effective Java', TRUE),
('978-0596517748', '/uploads/978-0596517748.jpg', 'Portada Head First Design Patterns', TRUE),
('978-0-13-521329-4', '/uploads/978-0-13-521329-4.jpg', 'Portada Cloud Computing Comprehensive Guide', TRUE);
