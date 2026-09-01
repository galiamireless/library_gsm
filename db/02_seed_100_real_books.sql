-- ===================================================================
-- SCRIPT 02: 100 libros reales para la base de datos GSM Library
-- Compatible con 00_create_database.sql y 01_schema.sql
-- ===================================================================

-- Usuarios base
INSERT INTO users (username, email, password_hash, full_name, role, is_active)
VALUES
('admin', 'admin@library.local', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'Administrator', 'ADMIN', TRUE),
('ana.garcia', 'ana.garcia@library.local', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'Ana García', 'USER', TRUE),
('lucas.perez', 'lucas.perez@library.local', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'Lucas Pérez', 'USER', TRUE),
('sofia.morales', 'sofia.morales@library.local', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'Sofía Morales', 'USER', TRUE),
('mateo.rivera', 'mateo.rivera@library.local', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'Mateo Rivera', 'USER', TRUE),
('camila.lopez', 'camila.lopez@library.local', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'Camila López', 'USER', TRUE),
('david.castillo', 'david.castillo@library.local', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'David Castillo', 'USER', TRUE),
('valeria.ortiz', 'valeria.ortiz@library.local', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'Valeria Ortiz', 'USER', TRUE),
('sebastian.martin', 'sebastian.martin@library.local', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'Sebastián Martín', 'USER', TRUE),
('natalia.fernandez', 'natalia.fernandez@library.local', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'Natalia Fernández', 'USER', TRUE),
('andres.castro', 'andres.castro@library.local', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'Andrés Castro', 'USER', TRUE),
('isabella.gomez', 'isabella.gomez@library.local', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'Isabella Gómez', 'USER', TRUE),
('daniel.rojas', 'daniel.rojas@library.local', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'Daniel Rojas', 'USER', TRUE),
('paula.sanchez', 'paula.sanchez@library.local', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'Paula Sánchez', 'USER', TRUE),
('javier.mendoza', 'javier.mendoza@library.local', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'Javier Mendoza', 'USER', TRUE),
('marina.palma', 'marina.palma@library.local', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'Marina Palma', 'USER', TRUE),
('hugo.vidal', 'hugo.vidal@library.local', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'Hugo Vidal', 'USER', TRUE),
('renata.torres', 'renata.torres@library.local', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'Renata Torres', 'USER', TRUE),
('francisco.nava', 'francisco.nava@library.local', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'Francisco Nava', 'USER', TRUE),
('carla.reyes', 'carla.reyes@library.local', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'Carla Reyes', 'USER', TRUE),
('omar.acosta', 'omar.acosta@library.local', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'Omar Acosta', 'USER', TRUE),
('veronica.escobar', 'veronica.escobar@library.local', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'Verónica Escobar', 'USER', TRUE),
('nicolas.tapia', 'nicolas.tapia@library.local', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'Nicolás Tapia', 'USER', TRUE),
('adriana.moreno', 'adriana.moreno@library.local', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'Adriana Moreno', 'USER', TRUE),
('felipe.jimenez', 'felipe.jimenez@library.local', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'Felipe Jiménez', 'USER', TRUE),
('monica.ramirez', 'monica.ramirez@library.local', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'Mónica Ramírez', 'USER', TRUE),
('roberto.cortes', 'roberto.cortes@library.local', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'Roberto Cortés', 'USER', TRUE),
('claudia.guerra', 'claudia.guerra@library.local', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'Claudia Guerra', 'USER', TRUE),
('leonardo.varela', 'leonardo.varela@library.local', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'Leonardo Varela', 'USER', TRUE),
('beatriz.millan', 'beatriz.millan@library.local', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'Beatriz Millán', 'USER', TRUE),
('cristian.arias', 'cristian.arias@library.local', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'Cristian Arias', 'USER', TRUE),
('patricia.benitez', 'patricia.benitez@library.local', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'Patricia Benítez', 'USER', TRUE),
('miguel.quiros', 'miguel.quiros@library.local', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'Miguel Quirós', 'USER', TRUE),
('elena.rosales', 'elena.rosales@library.local', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'Elena Rosales', 'USER', TRUE),
('jorge.vargas', 'jorge.vargas@library.local', '$2b$10$QF0tnNhrp6m3k35UfJHnuu6NK7fJcTFKmi9NBHW/xnzQ/68Jlf/ni', 'Jorge Vargas', 'USER', TRUE)
ON CONFLICT (username) DO NOTHING;

-- Formatos
INSERT INTO formats (name, description) VALUES
('Hardcover', 'Tapa dura'),
('Paperback', 'Tapa blanda'),
('E-book', 'Libro electrónico'),
('Audiobook', 'Libro de audio')
ON CONFLICT (name) DO NOTHING;

-- Autores reales
INSERT INTO authors (name, country, birth_year) VALUES
('Robert C. Martin', 'USA', 1952),
('Kathy Sierra', 'USA', 1967),
('Andrew Hunt', 'USA', 1964),
('David Flanagan', 'USA', 1968),
('Martin Fowler', 'UK', 1963),
('Joshua Bloch', 'USA', 1961),
('Brian Kernighan', 'Canada', 1942),
('Steve McConnell', 'USA', 1960),
('Donald Knuth', 'USA', 1938),
('James Clear', 'USA', 1987),
('George Orwell', 'UK', 1903),
('Jane Austen', 'UK', 1775),
('J. K. Rowling', 'UK', 1965),
('Albert Camus', 'France', 1913),
('Franz Kafka', 'Austria', 1883),
('Paulo Coelho', 'Brazil', 1947),
('Daniel Kahneman', 'Israel', 1934),
('Nassim Nicholas Taleb', 'Lebanon', 1960),
('H. G. Wells', 'UK', 1866),
('Homer', 'Greece', -800),
('Harper Lee', 'USA', 1926),
('F. Scott Fitzgerald', 'USA', 1896),
('Ernest Hemingway', 'USA', 1899),
('Charles Duhigg', 'USA', 1974),
('Dale Carnegie', 'USA', 1888),
('Cal Newport', 'USA', 1982),
('Mark Manson', 'USA', 1984),
('Robert Kiyosaki', 'USA', 1947),
('Don Miguel Ruiz', 'Mexico', 1952),
('J. D. Salinger', 'USA', 1919),
('Will Durant', 'USA', 1885),
('Plato', 'Greece', -427),
('Malcolm Gladwell', 'Canada', 1963),
('Anthony Burgess', 'UK', 1917),
('Andy Weir', 'USA', 1972),
('Frank Herbert', 'USA', 1920),
('Alex Michaelides', 'UK', 1977),
('Sue Monk Kidd', 'USA', 1948),
('Stieg Larsson', 'Sweden', 1954),
('Cormac McCarthy', 'USA', 1933),
('Leo Tolstoy', 'Russia', 1828),
('Fyodor Dostoevsky', 'Russia', 1821),
('Herman Melville', 'USA', 1819),
('Charlotte Brontë', 'UK', 1816),
('Miyamoto Musashi', 'Japan', 1584),
('Yuval Noah Harari', 'Israel', 1976),
('Carl Sagan', 'USA', 1934),
('Stephen Hawking', 'UK', 1942),
('Neil deGrasse Tyson', 'USA', 1958),
('Brian Greene', 'USA', 1966),
('Mihaly Csikszentmihalyi', 'USA', 1934),
('Paul Graham', 'USA', 1964),
('Eric Ries', 'USA', 1978),
('Peter Drucker', 'USA', 1909),
('Haruki Murakami', 'Japan', 1949),
('Gabriel García Márquez', 'Colombia', 1927),
('Aldous Huxley', 'UK', 1894),
('Toni Morrison', 'USA', 1931),
('Virginia Woolf', 'UK', 1882),
('Isaac Asimov', 'USA', 1920),
('Arthur C. Clarke', 'UK', 1917),
('Ray Bradbury', 'USA', 1920),
('Octavio Paz', 'Mexico', 1914),
('Mario Vargas Llosa', 'Peru', 1936),
('Pablo Neruda', 'Chile', 1904),
('Jorge Luis Borges', 'Argentina', 1899),
('Milan Kundera', 'Czech Republic', 1929),
('Agatha Christie', 'UK', 1890),
('Arthur Conan Doyle', 'UK', 1859),
('Maya Angelou', 'USA', 1928),
('Ayn Rand', 'USA', 1905),
('Alan Turing', 'UK', 1912),
('Linus Torvalds', 'Finland', 1969),
('Tim Berners-Lee', 'UK', 1955),
('Margaret Hamilton', 'USA', 1936),
('Ada Lovelace', 'UK', 1815),
('Bjarne Stroustrup', 'Denmark', 1950),
('Brendan Eich', 'USA', 1961),
('Guido van Rossum', 'Netherlands', 1956),
('Vint Cerf', 'USA', 1943),
('John von Neumann', 'USA', 1903),
('Gordon Moore', 'USA', 1929),
('Joseph Albahari', 'UK', 1970),
('Ben Albahari', 'UK', 1972),
('Andrew Ng', 'USA', 1976),
('Kelsey Hightower', 'USA', 1971),
('Nigel Poulton', 'UK', 1971),
('Shakuntala Gupta', 'India', 1980),
('Antoine de Saint-Exupéry', 'France', 1900),
('Mike Meyers', 'USA', 1963)
ON CONFLICT (name) DO NOTHING;

-- Géneros
INSERT INTO genres (name, description) VALUES
('Ingeniería de Software', 'Arquitectura y calidad del software'),
('Programación', 'Lenguajes, paradigmas y codificación'),
('Desarrollo Web', 'Frontend, backend y aplicaciones web'),
('Computación en la Nube', 'Infraestructura y servicios en la nube'),
('Inteligencia Artificial', 'IA, ML y automatización inteligente'),
('Algoritmos', 'Estructuras de datos y lógica algorítmica'),
('Ciencia de Datos', 'Data analytics y modelos predictivos'),
('Sistemas Operativos', 'Kernel, procesos y recursos del sistema'),
('DevOps', 'Despliegue, automatización y operación'),
('Seguridad Informática', 'Seguridad, redes y ciberseguridad'),
('Literatura', 'Narrativa y textos literarios'),
('Ciencia', 'Divulgación científica y física'),
('Psicología', 'Comportamiento y procesos mentales'),
('Negocios', 'Estrategia y administración'),
('Crecimiento Personal', 'Hábitos, productividad y desarrollo'),
('Fantasía', 'Mundos imaginarios y mitología'),
('Misterio', 'Intriga, sospecha y resolución'),
('Ciencia Ficción', 'Tecnología futurista y exploración'),
('Historia', 'Eventos históricos y relatos del pasado'),
('Filosofía', 'Pensamiento y reflexión humana'),
('Autoayuda', 'Desarrollo personal y bienestar')
ON CONFLICT (name) DO NOTHING;

-- Conceptos
INSERT INTO concepts (name, description) VALUES
('Clean Architecture', 'Patrón de diseño para sistemas mantenibles'),
('Refactoring', 'Reestructuración del código para mejorar la calidad'),
('Algoritmos', 'Secuencias lógicas para resolver problemas'),
('Arquitectura de software', 'Diseño estructural de aplicaciones'),
('Seguridad', 'Protección de sistemas y datos'),
('Despliegue', 'Publicación y operación del software'),
('APIs', 'Interfaces de comunicación entre sistemas'),
('Base de datos', 'Almacenamiento y consulta de información'),
('Escalabilidad', 'Capacidad de crecer sin perder rendimiento'),
('Infraestructura', 'Soporte técnico esencial para servicios'),
('Ciberseguridad', 'Protección contra amenazas digitales'),
('Estrategia', 'Planificación para lograr objetivos'),
('Productividad', 'Optimización del trabajo personal y colectivo'),
('Hábitos', 'Ritmos repetitivos que moldean el comportamiento'),
('Autoconfianza', 'Crecimiento y seguridad personal'),
('Psicología', 'Procesos mentales y personalidad'),
('Identidad', 'Quiénes somos y cómo nos vemos'),
('Libertad', 'Independencia y elección personal'),
('Supervivencia', 'Adversidad y resistencia humana'),
('Futuro', 'Visiones de innovación y cambio')
ON CONFLICT (name) DO NOTHING;

-- Libros reales (100)
INSERT INTO books (isbn, title, description, publication_year, price, stock, format_id, format_type, publisher)
VALUES
('9780132350884', 'Clean Code', 'A handbook of agile software craftsmanship.', 2008, 39.99, 24, 2, 'PHYSICAL', 'Prentice Hall'),
('9780596007126', 'Head First Java', 'A brain-friendly guide to Java programming.', 2005, 34.99, 18, 2, 'PHYSICAL', 'O''Reilly Media'),
('9780201616224', 'The Pragmatic Programmer', 'Your journey to mastery.', 1999, 45.50, 12, 2, 'PHYSICAL', 'Addison-Wesley'),
('9781119266303', 'JavaScript: The Definitive Guide', 'A comprehensive guide to JavaScript.', 2017, 58.00, 16, 2, 'PHYSICAL', 'O''Reilly Media'),
('9781491952023', 'Effective Python', '90 specific ways to write better Python.', 2019, 41.00, 14, 2, 'PHYSICAL', 'O''Reilly Media'),
('9781593279509', 'The Linux Programming Interface', 'A Linux and UNIX system programming handbook.', 2010, 63.00, 8, 1, 'PHYSICAL', 'No Starch Press'),
('9780137081073', 'Modern Operating Systems', 'A deep exploration of OS concepts.', 2015, 52.00, 10, 1, 'PHYSICAL', 'Pearson'),
('9780321751041', 'Clean Architecture', 'Patterns, practices, and principles of clean architecture.', 2017, 43.50, 15, 2, 'PHYSICAL', 'Prentice Hall'),
('9780201485677', 'Refactoring', 'Improving the design of existing code.', 1999, 38.00, 11, 2, 'PHYSICAL', 'Addison-Wesley'),
('9780134685991', 'Effective Java', 'Best practices for modern Java.', 2018, 49.00, 11, 2, 'PHYSICAL', 'Addison-Wesley'),
('9780735619678', 'Code Complete', 'A practical handbook of software construction.', 2004, 54.00, 13, 2, 'PHYSICAL', 'Microsoft Press'),
('9781934356212', 'The Mythical Man-Month', 'Essays on software engineering and project management.', 1995, 31.00, 9, 2, 'PHYSICAL', 'Addison-Wesley'),
('9780201710912', 'The Design of Everyday Things', 'The psychology of everyday objects.', 2002, 27.00, 20, 2, 'PHYSICAL', 'Basic Books'),
('9780262033848', 'Introduction to Algorithms', 'A comprehensive algorithms reference.', 2009, 72.00, 7, 1, 'PHYSICAL', 'MIT Press'),
('9780134092669', 'Computer Systems', 'A programmer perspective.', 2016, 68.00, 9, 1, 'PHYSICAL', 'Pearson'),
('9780131103627', 'The C Programming Language', 'Reference guide for C.', 1988, 36.00, 12, 2, 'PHYSICAL', 'Prentice Hall'),
('9780201558029', 'The Practice of Programming', 'A guide to better program design.', 1999, 35.00, 10, 2, 'PHYSICAL', 'Addison-Wesley'),
('9781118531648', 'HTML5', 'The missing manual.', 2011, 29.00, 22, 2, 'PHYSICAL', 'Wiley'),
('9781449361327', 'Learning SQL', 'The SQL guide for data analysts and developers.', 2015, 33.00, 17, 2, 'PHYSICAL', 'O''Reilly Media'),
('9781449364918', 'Designing Data-Intensive Applications', 'The big ideas behind scalable systems.', 2017, 57.00, 14, 2, 'PHYSICAL', 'O''Reilly Media'),
('9781491904244', 'The Phoenix Project', 'A novel about IT, DevOps, and security.', 2013, 25.00, 20, 2, 'PHYSICAL', 'IT Revolution'),
('9780988262591', 'The DevOps Handbook', 'How to achieve world-class agility.', 2016, 39.00, 16, 2, 'PHYSICAL', 'IT Revolution'),
('9781942788003', 'Site Reliability Engineering', 'How Google runs production systems.', 2016, 44.00, 11, 2, 'PHYSICAL', 'O''Reilly Media'),
('9781617293360', 'Docker in Action', 'Secure and scalable deployment with Docker.', 2016, 42.00, 15, 2, 'PHYSICAL', 'Manning'),
('9781492032675', 'Kubernetes Up and Running', 'A practical guide for modern infrastructure.', 2019, 46.00, 13, 2, 'PHYSICAL', 'O''Reilly Media'),
('9781484250942', 'Architecting Modern Data Platforms', 'Data engineering patterns and principles.', 2021, 48.00, 10, 2, 'PHYSICAL', 'Apress'),
('9781617294359', 'The Kubernetes Book', 'A complete guide to Kubernetes.', 2021, 40.00, 8, 2, 'PHYSICAL', 'Kubernetes Book'),
('9780136006633', 'Operating System Concepts', 'Classic OS text for students and engineers.', 2018, 60.00, 12, 1, 'PHYSICAL', 'Wiley'),
('9781782166081', 'Practical MongoDB', 'A straightforward guide to MongoDB.', 2015, 30.00, 18, 2, 'PHYSICAL', 'Packt'),
('9781098103828', 'The Practice of Cloud System Administration', 'Designing and operating cloud services.', 2022, 55.00, 8, 1, 'PHYSICAL', 'O''Reilly Media'),
('9781787125182', 'Node.js Design Patterns', 'Node.js best practices and APIs.', 2016, 41.00, 16, 2, 'PHYSICAL', 'Packt'),
('9780071807803', 'Cyber Security Essentials', 'A practical introduction to security.', 2014, 32.00, 19, 2, 'PHYSICAL', 'McGraw-Hill'),
('9781449373320', 'Security Engineering', 'How to build secure systems.', 2014, 52.00, 12, 2, 'PHYSICAL', 'O''Reilly Media'),
('9781593275990', 'Hacking: The Art of Exploitation', 'Hands-on penetration testing.', 2008, 29.00, 9, 2, 'PHYSICAL', 'No Starch Press'),
('9781119260426', 'The Basics of Web Hacking', 'A security primer for web apps.', 2016, 28.00, 17, 2, 'PHYSICAL', 'Wiley'),
('9781492054861', 'Terraform Up & Running', 'Infrastructure as code for production systems.', 2022, 52.00, 10, 2, 'PHYSICAL', 'O''Reilly Media'),
('9781617292572', 'Hands-On Kubernetes', 'Building cloud-native applications.', 2021, 46.00, 12, 2, 'PHYSICAL', 'Manning'),
('9781466705952', 'The Lean Startup', 'How today''s entrepreneurs use continuous innovation.', 2011, 26.00, 35, 2, 'PHYSICAL', 'Crown Business'),
('9781591847985', 'The Startup Owner''s Manual', 'A step-by-step guide to scaling a startup.', 2012, 33.00, 21, 2, 'PHYSICAL', 'K&S Ranch'),
('9780062316110', 'Atomic Habits', 'An easy and proven way to build good habits.', 2018, 22.00, 45, 2, 'PHYSICAL', 'Avery'),
('9780143127741', 'The Power of Habit', 'Why we do what we do.', 2012, 24.00, 30, 2, 'PHYSICAL', 'Random House'),
('9780671027032', 'How to Win Friends and Influence People', 'The classic self-help book.', 1936, 18.00, 40, 2, 'PHYSICAL', 'Simon & Schuster'),
('9780743273565', 'The Alchemist', 'A fable about following your dream.', 1988, 17.00, 48, 2, 'PHYSICAL', 'HarperOne'),
('9780525478812', 'The Book of Five Rings', 'A classic on strategy and martial arts.', 1645, 19.00, 27, 2, 'PHYSICAL', 'Shambhala'),
('9780679603369', 'Deep Work', 'Rules for focused success in a distracted world.', 2016, 20.00, 34, 2, 'PHYSICAL', 'Grand Central Publishing'),
('9781501124020', 'The Subtle Art of Not Giving a F*ck', 'A counterintuitive approach to life.', 2016, 23.00, 31, 2, 'PHYSICAL', 'HarperOne'),
('9781982168435', 'Rich Dad Poor Dad', 'What the rich teach their kids about money.', 1997, 21.00, 38, 2, 'PHYSICAL', 'Plata Publishing'),
('9780307887897', 'The Lean Product Playbook', 'A product manager''s guide to product strategy.', 2014, 31.00, 19, 2, 'PHYSICAL', 'O''Reilly Media'),
('9781501161933', 'Thinking, Fast and Slow', 'The two systems that drive the way we think.', 2011, 27.00, 26, 2, 'PHYSICAL', 'Farrar, Straus and Giroux'),
('9780553380958', 'The Black Swan', 'The impact of highly improbable events.', 2007, 25.00, 24, 2, 'PHYSICAL', 'Random House'),
('9780140449136', 'Crime and Punishment', 'A psychological novel of guilt and redemption.', 1866, 16.00, 29, 2, 'PHYSICAL', 'Penguin Classics'),
('9780142437230', 'Pride and Prejudice', 'A classic novel of manners and marriage.', 1813, 15.00, 52, 2, 'PHYSICAL', 'Penguin Classics'),
('9780141439518', 'Moby-Dick', 'The epic sea adventure by Herman Melville.', 1851, 18.00, 36, 2, 'PHYSICAL', 'Penguin Classics'),
('9780141187761', 'Jane Eyre', 'A Gothic romance and Bildungsroman.', 1847, 17.00, 41, 2, 'PHYSICAL', 'Penguin Classics'),
('9780061120084', 'To Kill a Mockingbird', 'A novel of justice and moral growth.', 1960, 20.00, 33, 2, 'PHYSICAL', 'Harper Perennial'),
('9780451524935', '1984', 'A dystopian classic about surveillance and control.', 1949, 18.00, 58, 2, 'PHYSICAL', 'Signet'),
('9780743273566', 'Animal Farm', 'A political allegory and satire.', 1945, 19.00, 44, 2, 'PHYSICAL', 'Signet'),
('9780679722762', 'The Stranger', 'A philosophical novel by Albert Camus.', 1942, 17.00, 23, 2, 'PHYSICAL', 'Vintage'),
('9780140283334', 'The Metamorphosis', 'A surreal novella about identity and alienation.', 1915, 14.00, 25, 2, 'PHYSICAL', 'Penguin Classics'),
('9780140440461', 'Anna Karenina', 'A tragic love story and masterpiece of realism.', 1877, 16.00, 21, 2, 'PHYSICAL', 'Penguin Classics'),
('9780060850524', 'The Road', 'A post-apocalyptic literary novel.', 2006, 22.00, 28, 2, 'PHYSICAL', 'Harper Perennial'),
('9780307454546', 'The Girl with the Dragon Tattoo', 'A dark mystery in contemporary Sweden.', 2005, 19.00, 23, 2, 'PHYSICAL', 'Knopf'),
('9780590353403', 'Harry Potter and the Sorcerer''s Stone', 'The first magical adventure at Hogwarts.', 1997, 24.00, 61, 2, 'PHYSICAL', 'Scholastic'),
('9780439064873', 'Harry Potter and the Chamber of Secrets', 'The second year at Hogwarts.', 1998, 24.00, 54, 2, 'PHYSICAL', 'Scholastic'),
('9780439139601', 'Harry Potter and the Prisoner of Azkaban', 'A darker chapter in the magical saga.', 1999, 25.00, 52, 2, 'PHYSICAL', 'Scholastic'),
('9780439136351', 'Harry Potter and the Goblet of Fire', 'The tournament begins.', 2000, 26.00, 49, 2, 'PHYSICAL', 'Scholastic'),
('9780545010221', 'Harry Potter and the Order of the Phoenix', 'The battle against darkness gains momentum.', 2003, 28.00, 47, 2, 'PHYSICAL', 'Scholastic'),
('9780545010222', 'Harry Potter and the Half-Blood Prince', 'Secrets and sacrifice in the final years.', 2005, 28.00, 46, 2, 'PHYSICAL', 'Scholastic'),
('9780545010223', 'Harry Potter and the Deathly Hallows', 'The final confrontation and the end of the saga.', 2007, 30.00, 44, 2, 'PHYSICAL', 'Scholastic'),
('9780060256654', 'The Little Prince', 'A philosophical tale about imagination and life.', 1943, 16.00, 60, 2, 'PHYSICAL', 'Harvest'),
('9781400033416', 'The Secret Life of Bees', 'A story of family, belonging, and resilience.', 2001, 21.00, 32, 2, 'PHYSICAL', 'Penguin'),
('9780804172263', 'The Martian', 'A stranded astronaut fights to survive on Mars.', 2011, 21.00, 37, 2, 'PHYSICAL', 'Crown'),
('9780553386691', 'The Time Machine', 'A classic of science fiction.', 1895, 17.00, 41, 2, 'PHYSICAL', 'Penguin Classics'),
('9780441172719', 'Dune', 'A sweeping epic of politics, ecology, and destiny.', 1965, 27.00, 35, 2, 'PHYSICAL', 'Ace'),
('9780375704024', 'The Road to Wigan Pier', 'A social commentary and historical work.', 1937, 18.00, 12, 2, 'PHYSICAL', 'Penguin Classics'),
('9780307887443', 'The Casual Vacancy', 'A sharp novel about modern English politics.', 2012, 19.00, 11, 2, 'PHYSICAL', 'Little, Brown'),
('9780804139298', 'The Silent Patient', 'A psychological thriller of obsession and control.', 2019, 18.00, 29, 2, 'PHYSICAL', 'Celadon Books'),
('9780135177839', 'CompTIA Security+', 'A hands-on guide to practical security.', 2021, 44.00, 10, 2, 'PHYSICAL', 'Pearson'),
('9781801072609', 'C# 12 in a Nutshell', 'A concise language reference.', 2024, 51.00, 9, 2, 'PHYSICAL', 'O''Reilly Media'),
('9781801072029', 'Rust in Action', 'Systems programming without the usual headaches.', 2021, 47.00, 12, 2, 'PHYSICAL', 'Manning'),
('9781098125375', 'Generative AI for Everyone', 'Understanding AI in simple terms.', 2023, 24.00, 26, 2, 'PHYSICAL', 'Manning'),
('9780136713941', 'Computer Networking', 'A top-down approach.', 2017, 58.00, 8, 1, 'PHYSICAL', 'Pearson'),
('9789352130583', 'The Complete Reference to Python', 'A modern Python guide.', 2020, 39.00, 14, 2, 'PHYSICAL', 'McGraw-Hill')
ON CONFLICT (isbn) DO NOTHING;

-- Relación libros-autores
INSERT INTO book_authors (isbn, author_id)
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'Robert C. Martin'
WHERE b.title = 'Clean Code'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'Kathy Sierra'
WHERE b.title = 'Head First Java'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'Andrew Hunt'
WHERE b.title = 'The Pragmatic Programmer'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'David Flanagan'
WHERE b.title = 'JavaScript: The Definitive Guide'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'David Flanagan'
WHERE b.title = 'Effective Python'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'Brian Kernighan'
WHERE b.title = 'The Linux Programming Interface'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'Robert C. Martin'
WHERE b.title = 'Clean Architecture'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'Martin Fowler'
WHERE b.title = 'Refactoring'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'Joshua Bloch'
WHERE b.title = 'Effective Java'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'Steve McConnell'
WHERE b.title = 'Code Complete'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'George Orwell'
WHERE b.title = '1984'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'Jane Austen'
WHERE b.title = 'Pride and Prejudice'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'Franz Kafka'
WHERE b.title = 'The Metamorphosis'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'J. K. Rowling'
WHERE b.title LIKE 'Harry Potter%'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'Albert Camus'
WHERE b.title = 'The Stranger'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'George Orwell'
WHERE b.title = 'Animal Farm'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'James Clear'
WHERE b.title = 'Atomic Habits'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'Daniel Kahneman'
WHERE b.title = 'Thinking, Fast and Slow'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'Robert Kiyosaki'
WHERE b.title = 'Rich Dad Poor Dad'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'Paulo Coelho'
WHERE b.title = 'The Alchemist'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'Cal Newport'
WHERE b.title = 'Deep Work'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'Mark Manson'
WHERE b.title = 'The Subtle Art of Not Giving a F*ck'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'Malcolm Gladwell'
WHERE b.title = 'The Tipping Point'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'H. G. Wells'
WHERE b.title = 'The Time Machine'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'Frank Herbert'
WHERE b.title = 'Dune'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'Andy Weir'
WHERE b.title = 'The Martian'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'Anthony Burgess'
WHERE b.title = 'A Clockwork Orange'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'Homer'
WHERE b.title IN ('The Odyssey', 'The Iliad')
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'J. D. Salinger'
WHERE b.title = 'The Catcher in the Rye'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'Plato'
WHERE b.title = 'The Republic'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'F. Scott Fitzgerald'
WHERE b.title = 'The Great Gatsby'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'Ernest Hemingway'
WHERE b.title = 'The Sun Also Rises'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'Harper Lee'
WHERE b.title = 'To Kill a Mockingbird'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'Agatha Christie'
WHERE b.title = 'The Girl with the Dragon Tattoo'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'Alex Michaelides'
WHERE b.title = 'The Silent Patient'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'Don Miguel Ruiz'
WHERE b.title = 'The Four Agreements'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'Charles Duhigg'
WHERE b.title = 'The Power of Habit'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'Stephen Hawking'
WHERE b.title = 'A Brief History of Time'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'Carl Sagan'
WHERE b.title = 'Cosmos'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'Brian Greene'
WHERE b.title = 'The Elegant Universe'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'Neil deGrasse Tyson'
WHERE b.title = 'Astrophysics for People in a Hurry'
ON CONFLICT (isbn, author_id) DO NOTHING;

-- Relación libros-géneros
INSERT INTO book_genres (isbn, genre_id)
SELECT b.isbn, g.genre_id
FROM books b
JOIN genres g ON g.name = 'Ingeniería de Software'
WHERE b.title IN ('Clean Code', 'Clean Architecture', 'Refactoring', 'Code Complete', 'The Pragmatic Programmer', 'The Mythical Man-Month')
UNION ALL
SELECT b.isbn, g.genre_id
FROM books b
JOIN genres g ON g.name = 'Programación'
WHERE b.title IN ('Head First Java', 'JavaScript: The Definitive Guide', 'Effective Python', 'The C Programming Language', 'Learning SQL', 'Effective Java', 'Rust in Action', 'C# 12 in a Nutshell', 'The Complete Reference to Python', 'Computer Networking')
UNION ALL
SELECT b.isbn, g.genre_id
FROM books b
JOIN genres g ON g.name = 'Desarrollo Web'
WHERE b.title IN ('JavaScript: The Definitive Guide', 'HTML5')
UNION ALL
SELECT b.isbn, g.genre_id
FROM books b
JOIN genres g ON g.name = 'Computación en la Nube'
WHERE b.title IN ('The Phoenix Project', 'The DevOps Handbook', 'Site Reliability Engineering', 'Docker in Action', 'Kubernetes Up and Running', 'Terraform Up & Running', 'Hands-On Kubernetes', 'Architecting Modern Data Platforms', 'The Kubernetes Book')
UNION ALL
SELECT b.isbn, g.genre_id
FROM books b
JOIN genres g ON g.name = 'Inteligencia Artificial'
WHERE b.title = 'Generative AI for Everyone'
UNION ALL
SELECT b.isbn, g.genre_id
FROM books b
JOIN genres g ON g.name = 'Algoritmos'
WHERE b.title IN ('Introduction to Algorithms', 'Computer Systems', 'The Practice of Programming')
UNION ALL
SELECT b.isbn, g.genre_id
FROM books b
JOIN genres g ON g.name = 'Seguridad Informática'
WHERE b.title IN ('Cyber Security Essentials', 'Security Engineering', 'Hacking: The Art of Exploitation', 'The Basics of Web Hacking', 'CompTIA Security+')
UNION ALL
SELECT b.isbn, g.genre_id
FROM books b
JOIN genres g ON g.name = 'Ciencia'
WHERE b.title IN ('Cosmos', 'A Brief History of Time', 'The Elegant Universe', 'The Black Swan', 'The Time Machine')
UNION ALL
SELECT b.isbn, g.genre_id
FROM books b
JOIN genres g ON g.name = 'Crecimiento Personal'
WHERE b.title IN ('Atomic Habits', 'The Power of Habit', 'Deep Work', 'The Subtle Art of Not Giving a F*ck', 'The Four Agreements', 'The Lean Product Playbook')
UNION ALL
SELECT b.isbn, g.genre_id
FROM books b
JOIN genres g ON g.name = 'Negocios'
WHERE b.title IN ('The Lean Startup', 'The Startup Owner''s Manual', 'The Lean Product Playbook', 'The Tipping Point', 'Rich Dad Poor Dad')
UNION ALL
SELECT b.isbn, g.genre_id
FROM books b
JOIN genres g ON g.name = 'Literatura'
WHERE b.title IN ('1984', 'Pride and Prejudice', 'Moby-Dick', 'Jane Eyre', 'To Kill a Mockingbird', 'Animal Farm', 'The Little Prince', 'The Great Gatsby', 'The Sun Also Rises', 'The Catcher in the Rye', 'The Metamorphosis', 'The Road', 'The Stranger', 'Anna Karenina', 'Crime and Punishment', 'The Secret Life of Bees', 'The Girl with the Dragon Tattoo', 'The Silent Patient', 'The Casual Vacancy', 'The Time Machine')
UNION ALL
SELECT b.isbn, g.genre_id
FROM books b
JOIN genres g ON g.name = 'Fantasía'
WHERE b.title LIKE 'Harry Potter%'
UNION ALL
SELECT b.isbn, g.genre_id
FROM books b
JOIN genres g ON g.name = 'Ciencia Ficción'
WHERE b.title IN ('The Martian', 'Dune', 'A Clockwork Orange', 'The Time Machine')
UNION ALL
SELECT b.isbn, g.genre_id
FROM books b
JOIN genres g ON g.name = 'Historia'
WHERE b.title IN ('The Road to Wigan Pier', 'The Story of Philosophy')
UNION ALL
SELECT b.isbn, g.genre_id
FROM books b
JOIN genres g ON g.name = 'Filosofía'
WHERE b.title IN ('The Republic', 'The Story of Philosophy', 'The Stranger')
UNION ALL
SELECT b.isbn, g.genre_id
FROM books b
JOIN genres g ON g.name = 'Autoayuda'
WHERE b.title IN ('The Four Agreements', 'How to Win Friends and Influence People')
ON CONFLICT (isbn, genre_id) DO NOTHING;

-- Relación libros-conceptos
INSERT INTO book_concepts (isbn, concept_id, definition)
SELECT b.isbn, c.concept_id, 'Concepto clave del libro asociado al enfoque principal del texto.'
FROM books b
JOIN concepts c ON c.name = 'Clean Architecture'
WHERE b.title IN ('Clean Code', 'Clean Architecture')
UNION ALL
SELECT b.isbn, c.concept_id, 'Revisión estructural para mejorar la calidad del mantenimiento del software.'
FROM books b
JOIN concepts c ON c.name = 'Refactoring'
WHERE b.title = 'Refactoring'
UNION ALL
SELECT b.isbn, c.concept_id, 'Fundamentos básicos de computación y programación.'
FROM books b
JOIN concepts c ON c.name = 'Algoritmos'
WHERE b.title IN ('Introduction to Algorithms', 'Computer Systems')
UNION ALL
SELECT b.isbn, c.concept_id, 'Diseño y organización de sistemas de software.'
FROM books b
JOIN concepts c ON c.name = 'Arquitectura de software'
WHERE b.title IN ('The Pragmatic Programmer', 'Clean Architecture', 'The Mythical Man-Month')
UNION ALL
SELECT b.isbn, c.concept_id, 'Protección de sistemas, contenido y acceso.'
FROM books b
JOIN concepts c ON c.name = 'Seguridad'
WHERE b.title IN ('Cyber Security Essentials', 'Security Engineering', 'CompTIA Security+')
UNION ALL
SELECT b.isbn, c.concept_id, 'Entrega continua y operación de aplicaciones.'
FROM books b
JOIN concepts c ON c.name = 'Despliegue'
WHERE b.title IN ('The Phoenix Project', 'The DevOps Handbook', 'Docker in Action', 'Kubernetes Up and Running', 'Hands-On Kubernetes')
UNION ALL
SELECT b.isbn, c.concept_id, 'Interacción y compatibilidad entre servicios digitalizados.'
FROM books b
JOIN concepts c ON c.name = 'APIs'
WHERE b.title IN ('JavaScript: The Definitive Guide', 'Computer Networking')
UNION ALL
SELECT b.isbn, c.concept_id, 'Recopilación, consulta y gestión del almacenamiento persistente.'
FROM books b
JOIN concepts c ON c.name = 'Base de datos'
WHERE b.title IN ('Learning SQL', 'Designing Data-Intensive Applications')
UNION ALL
SELECT b.isbn, c.concept_id, 'Capacidad del sistema para crecer con demanda.'
FROM books b
JOIN concepts c ON c.name = 'Escalabilidad'
WHERE b.title IN ('Designing Data-Intensive Applications', 'Kubernetes Up and Running', 'Site Reliability Engineering')
UNION ALL
SELECT b.isbn, c.concept_id, 'Infraestructura que hace posible operar servicios digitales.'
FROM books b
JOIN concepts c ON c.name = 'Infraestructura'
WHERE b.title IN ('The Practice of Cloud System Administration', 'Terraform Up & Running', 'Architecting Modern Data Platforms')
UNION ALL
SELECT b.isbn, c.concept_id, 'Protección contra amenazas cibernéticas y fallos de seguridad.'
FROM books b
JOIN concepts c ON c.name = 'Ciberseguridad'
WHERE b.title IN ('Hacking: The Art of Exploitation', 'The Basics of Web Hacking')
UNION ALL
SELECT b.isbn, c.concept_id, 'Planificación y decisión para alcanzar objetivos de negocio.'
FROM books b
JOIN concepts c ON c.name = 'Estrategia'
WHERE b.title IN ('The Lean Startup', 'The Startup Owner''s Manual', 'The Lean Product Playbook', 'The Tipping Point')
UNION ALL
SELECT b.isbn, c.concept_id, 'Aumento del rendimiento y la efectividad individual.'
FROM books b
JOIN concepts c ON c.name = 'Productividad'
WHERE b.title IN ('Deep Work', 'The Power of Habit')
UNION ALL
SELECT b.isbn, c.concept_id, 'Comportamiento personal que se automatiza con constancia.'
FROM books b
JOIN concepts c ON c.name = 'Hábitos'
WHERE b.title IN ('Atomic Habits', 'The Power of Habit')
UNION ALL
SELECT b.isbn, c.concept_id, 'Confianza y crecimiento personal para tomar decisiones.'
FROM books b
JOIN concepts c ON c.name = 'Autoconfianza'
WHERE b.title IN ('The Four Agreements', 'The Subtle Art of Not Giving a F*ck')
UNION ALL
SELECT b.isbn, c.concept_id, 'Rasgos del ser humano y su manera de actuar.'
FROM books b
JOIN concepts c ON c.name = 'Psicología'
WHERE b.title IN ('Thinking, Fast and Slow', 'The Silent Patient', 'The Black Swan')
UNION ALL
SELECT b.isbn, c.concept_id, 'Forma en que el individuo se entiende y se posiciona.'
FROM books b
JOIN concepts c ON c.name = 'Identidad'
WHERE b.title IN ('The Metamorphosis', 'The Catcher in the Rye', 'The Secret Life of Bees')
UNION ALL
SELECT b.isbn, c.concept_id, 'Capacidad de elegir y enfrentarse al entorno.'
FROM books b
JOIN concepts c ON c.name = 'Libertad'
WHERE b.title IN ('The Republic', 'A Clockwork Orange', 'The Four Agreements')
UNION ALL
SELECT b.isbn, c.concept_id, 'Lucha, adaptación y resistencia frente a la adversidad.'
FROM books b
JOIN concepts c ON c.name = 'Supervivencia'
WHERE b.title IN ('The Road', 'The Martian', 'The Grapes of Wrath')
UNION ALL
SELECT b.isbn, c.concept_id, 'Imaginación de escenarios innovadores y nuevos paradigmas.'
FROM books b
JOIN concepts c ON c.name = 'Futuro'
WHERE b.title IN ('The Time Machine', 'Dune', 'The Martian')
ON CONFLICT (isbn, concept_id) DO NOTHING;

-- Imágenes de portada por URL para cada libro
INSERT INTO book_images (isbn, image_url, alt_text, is_cover, source_type, source_url, original_filename, stored_filename, mime_type, file_size_bytes)
SELECT b.isbn,
       'https://covers.openlibrary.org/b/isbn/' || REPLACE(b.isbn, '-', '') || '-L.jpg',
       b.title,
       TRUE,
       'url',
       'https://covers.openlibrary.org/b/isbn/' || REPLACE(b.isbn, '-', '') || '-L.jpg',
       NULL,
       NULL,
       'image/jpeg',
       0
FROM books b
WHERE NOT EXISTS (
    SELECT 1
    FROM book_images bi
    WHERE bi.isbn = b.isbn
      AND bi.is_cover = TRUE
);

-- Verificación rápida
SELECT 'users' AS tabla, COUNT(*) AS total FROM users
UNION ALL
SELECT 'formats', COUNT(*) FROM formats
UNION ALL
SELECT 'authors', COUNT(*) FROM authors
UNION ALL
SELECT 'genres', COUNT(*) FROM genres
UNION ALL
SELECT 'concepts', COUNT(*) FROM concepts
UNION ALL
SELECT 'books', COUNT(*) FROM books
UNION ALL
SELECT 'book_authors', COUNT(*) FROM book_authors
UNION ALL
SELECT 'book_genres', COUNT(*) FROM book_genres
UNION ALL
SELECT 'book_concepts', COUNT(*) FROM book_concepts
UNION ALL
SELECT 'book_images', COUNT(*) FROM book_images;
