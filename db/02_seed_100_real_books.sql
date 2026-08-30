-- ===================================================================
-- SCRIPT 02: 100 libros reales para la base de datos GSM Library
-- Ejecutar después de 00_create_database.sql y 01_schema.sql
-- ===================================================================

-- Usuarios base
INSERT INTO users (username, email, password_hash, full_name, role, is_active)
VALUES
('admin', 'admin@library.local', '$2b$10$x9.V5gSBCJDcRHjAYlhsm.xQfXp0lPGGPPvLp9pRXqJvB5P8bVBOO', 'Administrator', 'ADMIN', TRUE)
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
('Bert Bates', 'USA', 1960),
('Andrew Hunt', 'USA', 1964),
('David Thomas', 'USA', 1963),
('David Flanagan', 'USA', 1968),
('Eric Evans', 'USA', 1970),
('Martin Fowler', 'UK', 1963),
('Kent Beck', 'USA', 1961),
('Joshua Bloch', 'USA', 1961),
('Brian Kernighan', 'Canada', 1942),
('Dennis Ritchie', 'USA', 1941),
('Jon Skeet', 'UK', 1973),
('Mark Lutz', 'USA', 1960),
('Tom DeMarco', 'USA', 1940),
('Steve McConnell', 'USA', 1960),
('David Thomas', 'USA', 1963),
('Charles Petzold', 'USA', 1953),
('John C. Mitchell', 'USA', 1955),
('M. T. Anderson', 'USA', 1970),
('Yuval Noah Harari', 'Israel', 1976),
('Sapiens', 'Israel', 1976),
('George Orwell', 'UK', 1903),
('Haruki Murakami', 'Japan', 1949),
('J. R. R. Tolkien', 'UK', 1892),
('George R. R. Martin', 'USA', 1948),
('Jane Austen', 'UK', 1775),
('Mary Shelley', 'UK', 1797),
('Franz Kafka', 'Austria', 1883),
('Gabriel García Márquez', 'Colombia', 1927),
('Hermann Hesse', 'Germany', 1877),
('Aldous Huxley', 'UK', 1894),
('Ayn Rand', 'USA', 1905),
('Albert Camus', 'France', 1913),
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
('Donald Knuth', 'USA', 1938),
('Gordon Moore', 'USA', 1929),
('Seth Godin', 'USA', 1960),
('Clayton Christensen', 'USA', 1952),
('Peter Drucker', 'USA', 1909),
('Nassim Nicholas Taleb', 'Lebanon', 1960),
('James Clear', 'USA', 1987),
('Daniel Kahneman', 'Israel', 1934),
('Stephen Hawking', 'UK', 1942),
('Carl Sagan', 'USA', 1934),
('Neil deGrasse Tyson', 'USA', 1958),
('Brian Greene', 'USA', 1966),
('Michio Kaku', 'USA', 1947),
('Paul Graham', 'USA', 1964),
('Eric Ries', 'USA', 1978),
('Ash Maurya', 'USA', 1982),
('Gina Trapani', 'USA', 1978),
('Abraham Maslow', 'USA', 1908),
('Daniel Goleman', 'USA', 1946),
('Mihaly Csikszentmihalyi', 'USA', 1934),
('Dale Carnegie', 'USA', 1888),
('Napoleon Hill', 'USA', 1883),
('Paulo Coelho', 'Brazil', 1947),
('Dan Brown', 'USA', 1964),
('Agatha Christie', 'UK', 1890),
('Arthur Conan Doyle', 'UK', 1859),
('J. K. Rowling', 'UK', 1965),
('C. S. Lewis', 'UK', 1898),
('Maya Angelou', 'USA', 1928),
('Toni Morrison', 'USA', 1931),
('Virginia Woolf', 'UK', 1882),
('Virginia Woolf', 'UK', 1882),
('F. Scott Fitzgerald', 'USA', 1896),
('Ernest Hemingway', 'USA', 1899),
('Jules Verne', 'France', 1828),
('H. G. Wells', 'UK', 1866),
('Isaac Asimov', 'USA', 1920),
('Arthur C. Clarke', 'UK', 1917),
('Ray Bradbury', 'USA', 1920),
('Octavio Paz', 'Mexico', 1914),
('Mario Vargas Llosa', 'Peru', 1936),
('Pablo Neruda', 'Chile', 1904),
('Jorge Luis Borges', 'Argentina', 1899),
('Hermann Hesse', 'Germany', 1877)
ON CONFLICT (name) DO NOTHING;

-- Géneros
INSERT INTO genres (name, description) VALUES
('Software Engineering', 'Ingeniería de software y arquitectura'),
('Programming', 'Programación y lenguajes de desarrollo'),
('Web Development', 'Desarrollo web y front-end'),
('Cloud Computing', 'Computación en la nube y plataformas digitales'),
('AI', 'IA y aprendizaje automático'),
('Algorithms', 'Algoritmos, estructuras y lógica'),
('Data Science', 'Ciencia de datos y analítica'),
('Operating Systems', 'Sistemas operativos y arquitectura'),
('DevOps', 'DevOps y despliegue continuo'),
('Security', 'Seguridad informática'),
('Literature', 'Literatura general y narrativa'),
('Science', 'Ciencia y divulgación científica'),
('Psychology', 'Psicología y comportamiento humano'),
('Business', 'Negocios y estrategia'),
('Personal Growth', 'Crecimiento personal y productividad')
ON CONFLICT (name) DO NOTHING;

-- Libros reales (100)
INSERT INTO books (isbn, title, description, publication_year, price, stock, format_id, publisher)
VALUES
('9780132350884', 'Clean Code', 'A handbook of agile software craftsmanship.', 2008, 39.99, 24, 2, 'Prentice Hall'),
('9780596007126', 'Head First Java', 'A brain-friendly guide to Java programming.', 2005, 34.99, 18, 2, 'O''Reilly Media'),
('9780201616224', 'The Pragmatic Programmer', 'Your journey to mastery.', 1999, 45.50, 12, 2, 'Addison-Wesley'),
('9781119266303', 'JavaScript: The Definitive Guide', 'A comprehensive guide to JavaScript.', 2017, 58.00, 16, 2, 'O''Reilly Media'),
('9781491952023', 'Effective Python', '90 specific ways to write better Python.', 2019, 41.00, 14, 2, 'O''Reilly Media'),
('9781593279509', 'The Linux Programming Interface', 'A Linux and UNIX system programming handbook.', 2010, 63.00, 8, 1, 'No Starch Press'),
('9780137081073', 'Modern Operating Systems', 'A deep exploration of OS concepts.', 2015, 52.00, 10, 1, 'Pearson'),
('9780321751041', 'Clean Architecture', 'Patterns, practices, and principles of clean architecture.', 2017, 43.50, 15, 2, 'Prentice Hall'),
('9780201485677', 'Refactoring', 'Improving the design of existing code.', 1999, 38.00, 11, 2, 'Addison-Wesley'),
('9780134685991', 'Effective Java', 'Best practices for modern Java.', 2018, 49.00, 11, 2, 'Addison-Wesley'),
('9780735619678', 'Code Complete', 'A practical handbook of software construction.', 2004, 54.00, 13, 2, 'Microsoft Press'),
('9781934356212', 'The Mythical Man-Month', 'Essays on software engineering and project management.', 1995, 31.00, 9, 2, 'Addison-Wesley'),
('9780201710912', 'The Design of Everyday Things', 'The psychology of everyday objects.', 2002, 27.00, 20, 2, 'Basic Books'),
('9780262033848', 'Introduction to Algorithms', 'A comprehensive algorithms reference.', 2009, 72.00, 7, 1, 'MIT Press'),
('9780134092669', 'Computer Systems', 'A programmer perspective.', 2016, 68.00, 9, 1, 'Pearson'),
('9780131103627', 'The C Programming Language', 'Reference guide for C.', 1988, 36.00, 12, 2, 'Prentice Hall'),
('9780201558029', 'The Practice of Programming', 'A guide to better program design.', 1999, 35.00, 10, 2, 'Addison-Wesley'),
('9781118531648', 'HTML5', 'The missing manual.', 2011, 29.00, 22, 2, 'Wiley'),
('9781449361327', 'Learning SQL', 'The SQL guide for data analysts and developers.', 2015, 33.00, 17, 2, 'O''Reilly Media'),
('9781449364918', 'Designing Data-Intensive Applications', 'The big ideas behind scalable systems.', 2017, 57.00, 14, 2, 'O''Reilly Media'),
('9781491904244', 'The Phoenix Project', 'A novel about IT, DevOps, and security.', 2013, 25.00, 20, 2, 'IT Revolution'),
('9780988262591', 'The DevOps Handbook', 'How to achieve world-class agility.', 2016, 39.00, 16, 2, 'IT Revolution'),
('9781942788003', 'Site Reliability Engineering', 'How Google runs production systems.', 2016, 44.00, 11, 2, 'O''Reilly Media'),
('9781617293360', 'Docker in Action', 'Secure and scalable deployment with Docker.', 2016, 42.00, 15, 2, 'Manning'),
('9781492032675', 'Kubernetes Up and Running', 'A practical guide for modern infrastructure.', 2019, 46.00, 13, 2, 'O''Reilly Media'),
('9781484250942', 'Architecting Modern Data Platforms', 'Data engineering patterns and principles.', 2021, 48.00, 10, 2, 'Apress'),
('9781617294359', 'The Kubernetes Book', 'A complete guide to Kubernetes.', 2021, 40.00, 8, 2, 'Kubernetes Book'),
('9780136006633', 'Operating System Concepts', 'Classic OS text for students and engineers.', 2018, 60.00, 12, 1, 'Wiley'),
('9781782166081', 'Practical MongoDB', 'A straightforward guide to MongoDB.', 2015, 30.00, 18, 2, 'Packt'),
('9781098103828', 'The Practice of Cloud System Administration', 'Designing and operating cloud services.', 2022, 55.00, 8, 1, 'O''Reilly Media'),
('9781787125182', 'Node.js Design Patterns', 'Node.js best practices and APIs.', 2016, 41.00, 16, 2, 'Packt'),
('9780071807803', 'Cyber Security Essentials', 'A practical introduction to security.', 2014, 32.00, 19, 2, 'McGraw-Hill'),
('9781449373320', 'Security Engineering', 'How to build secure systems.', 2014, 52.00, 12, 2, 'O''Reilly Media'),
('9781593275990', 'Hacking: The Art of Exploitation', 'Hands-on penetration testing.', 2008, 29.00, 9, 2, 'No Starch Press'),
('9781119260426', 'The Basics of Web Hacking', 'A security primer for web apps.', 2016, 28.00, 17, 2, 'Wiley'),
('9781492054861', 'Terraform Up & Running', 'Infrastructure as code for production systems.', 2022, 52.00, 10, 2, 'O''Reilly Media'),
('9781617292572', 'Hands-On Kubernetes', 'Building cloud-native applications.', 2021, 46.00, 12, 2, 'Manning'),
('9781466705952', 'The Lean Startup', 'How today''s entrepreneurs use continuous innovation.', 2011, 26.00, 35, 2, 'Crown Business'),
('9781591847985', 'The Startup Owner''s Manual', 'A step-by-step guide to scaling a startup.', 2012, 33.00, 21, 2, 'K&S Ranch'),
('9780062316110', 'Atomic Habits', 'An easy and proven way to build good habits.', 2018, 22.00, 45, 2, 'Avery'),
('9780143127741', 'The Power of Habit', 'Why we do what we do.', 2012, 24.00, 30, 2, 'Random House'),
('9780671027032', 'How to Win Friends and Influence People', 'The classic self-help book.', 1936, 18.00, 40, 2, 'Simon & Schuster'),
('9780743273565', 'The Alchemist', 'A fable about following your dream.', 1988, 17.00, 48, 2, 'HarperOne'),
('9780525478812', 'The Book of Five Rings', 'A classic on strategy and martial arts.', 1645, 19.00, 27, 2, 'Shambhala'),
('9780679603369', 'Deep Work', 'Rules for focused success in a distracted world.', 2016, 20.00, 34, 2, 'Grand Central Publishing'),
('9781501124020', 'The Subtle Art of Not Giving a F*ck', 'A counterintuitive approach to life.', 2016, 23.00, 31, 2, 'HarperOne'),
('9781982168435', 'Rich Dad Poor Dad', 'What the rich teach their kids about money.', 1997, 21.00, 38, 2, 'Plata Publishing'),
('9780307887897', 'The Lean Product Playbook', 'A product manager''s guide to product strategy.', 2014, 31.00, 19, 2, 'O''Reilly Media'),
('9781501161933', 'Thinking, Fast and Slow', 'The two systems that drive the way we think.', 2011, 27.00, 26, 2, 'Farrar, Straus and Giroux'),
('9780553380958', 'The Black Swan', 'The impact of highly improbable events.', 2007, 25.00, 24, 2, 'Random House'),
('9780140449136', 'Crime and Punishment', 'A psychological novel of guilt and redemption.', 1866, 16.00, 29, 2, 'Penguin Classics'),
('9780142437230', 'Pride and Prejudice', 'A classic novel of manners and marriage.', 1813, 15.00, 52, 2, 'Penguin Classics'),
('9780141439518', 'Moby-Dick', 'The epic sea adventure by Herman Melville.', 1851, 18.00, 36, 2, 'Penguin Classics'),
('9780141187761', 'Jane Eyre', 'A Gothic romance and Bildungsroman.', 1847, 17.00, 41, 2, 'Penguin Classics'),
('9780061120084', 'To Kill a Mockingbird', 'A novel of justice and moral growth.', 1960, 20.00, 33, 2, 'Harper Perennial'),
('9780451524935', '1984', 'A dystopian classic about surveillance and control.', 1949, 18.00, 58, 2, 'Signet'),
('9780743273566', 'Animal Farm', 'A political allegory and satire.', 1945, 19.00, 44, 2, 'Signet'),
('9780679722762', 'The Stranger', 'A philosophical novel by Albert Camus.', 1942, 17.00, 23, 2, 'Vintage'),
('9780140283334', 'The Metamorphosis', 'A surreal novella about identity and alienation.', 1915, 14.00, 25, 2, 'Penguin Classics'),
('9780140440461', 'Anna Karenina', 'A tragic love story and masterpiece of realism.', 1877, 16.00, 21, 2, 'Penguin Classics'),
('9780060850524', 'The Road', 'A post-apocalyptic literary novel.', 2006, 22.00, 28, 2, 'Harper Perennial'),
('9780307454546', 'The Girl with the Dragon Tattoo', 'A dark mystery in contemporary Sweden.', 2005, 19.00, 23, 2, 'Knopf'),
('9780590353403', 'Harry Potter and the Sorcerer''s Stone', 'The first magical adventure at Hogwarts.', 1997, 24.00, 61, 2, 'Scholastic'),
('9780439064873', 'Harry Potter and the Chamber of Secrets', 'The second year at Hogwarts.', 1998, 24.00, 54, 2, 'Scholastic'),
('9780439139601', 'Harry Potter and the Prisoner of Azkaban', 'A darker chapter in the magical saga.', 1999, 25.00, 52, 2, 'Scholastic'),
('9780439136351', 'Harry Potter and the Goblet of Fire', 'The tournament begins.', 2000, 26.00, 49, 2, 'Scholastic'),
('9780545010221', 'Harry Potter and the Order of the Phoenix', 'The battle against darkness gains momentum.', 2003, 28.00, 47, 2, 'Scholastic'),
('9780545010222', 'Harry Potter and the Half-Blood Prince', 'Secrets and sacrifice in the final years.', 2005, 28.00, 46, 2, 'Scholastic'),
('9780545010223', 'Harry Potter and the Deathly Hallows', 'The final confrontation and the end of the saga.', 2007, 30.00, 44, 2, 'Scholastic'),
('9780060256654', 'The Little Prince', 'A philosophical tale about imagination and life.', 1943, 16.00, 60, 2, 'Harvest'),
('9781400033416', 'The Secret Life of Bees', 'A story of family, belonging, and resilience.', 2001, 21.00, 32, 2, 'Penguin'),
('9780804172263', 'The Martian', 'A stranded astronaut fights to survive on Mars.', 2011, 21.00, 37, 2, 'Crown'),
('9780553386691', 'The Time Machine', 'A classic of science fiction.', 1895, 17.00, 41, 2, 'Penguin Classics'),
('9780441172719', 'Dune', 'A sweeping epic of politics, ecology, and destiny.', 1965, 27.00, 35, 2, 'Ace'),
('9780375704024', 'The Road to Wigan Pier', 'A social commentary and historical work.', 1937, 18.00, 12, 2, 'Penguin Classics'),
('9780307887443', 'The Casual Vacancy', 'A sharp novel about modern English politics.', 2012, 19.00, 11, 2, 'Little, Brown'),
('9780804139298', 'The Silent Patient', 'A psychological thriller of obsession and control.', 2019, 18.00, 29, 2, 'Celadon Books'),
('9780735219090', 'Atomic Habits', 'Tiny changes, remarkable results.', 2018, 22.00, 45, 2, 'Avery'),
('9781524763141', 'The Four Agreements', 'A practical guide to personal freedom.', 1997, 20.00, 31, 2, 'Amber-Allen'),
('9780316769488', 'The Catcher in the Rye', 'A classic novel of adolescence and alienation.', 1951, 18.00, 30, 2, 'Little, Brown'),
('9780143038412', 'The Story of Philosophy', 'A history of philosophy for the broad public.', 1926, 19.00, 16, 2, 'Touchstone'),
('9780140444307', 'The Republic', 'A foundational text of political philosophy.', 380, 14.00, 18, 2, 'Penguin Classics'),
('9781594480003', 'The Tipping Point', 'How little things can make a big difference.', 2000, 21.00, 27, 2, 'Little, Brown'),
('9780307743657', 'The Great Gatsby', 'A portrait of wealth, illusion, and desire.', 1925, 17.00, 48, 2, 'Scribner'),
('9780679783268', 'The Sun Also Rises', 'A classic novel on the Lost Generation.', 1926, 18.00, 15, 2, 'Scribner'),
('9780451527749', 'The Grapes of Wrath', 'An epic novel of hardship and survival.', 1939, 21.00, 20, 2, 'Penguin'),
('9780060935467', 'A Clockwork Orange', 'A dystopian novel on free will and violence.', 1962, 19.00, 18, 2, 'HarperPerennial'),
('9780142437209', 'The Odyssey', 'An epic poem of heroic return and adventure.', -800, 16.00, 24, 2, 'Penguin Classics'),
('9780140449136', 'The Iliad', 'The epic poem of war and honor.', -800, 16.00, 22, 2, 'Penguin Classics'),
('9781612680194', 'Rich Dad Poor Dad', 'Build financial intelligence and wealth.', 1997, 21.00, 20, 2, 'Plata Publishing'),
('9780135177839', 'CompTIA Security+', 'A hands-on guide to practical security.', 2021, 44.00, 10, 2, 'Pearson'),
('9781801072609', 'C# 12 in a Nutshell', 'A concise language reference.', 2024, 51.00, 9, 2, 'O''Reilly Media'),
('9781801072029', 'Rust in Action', 'Systems programming without the usual headaches.', 2021, 47.00, 12, 2, 'Manning'),
('9781098125375', 'Generative AI for Everyone', 'Understanding AI in simple terms.', 2023, 24.00, 26, 2, 'Manning'),
('9780136713941', 'Computer Networking', 'A top-down approach.', 2017, 58.00, 8, 1, 'Pearson'),
('9789352130583', 'The Complete Reference to Python', 'A modern Python guide.', 2020, 39.00, 14, 2, 'McGraw-Hill')
ON CONFLICT (isbn) DO NOTHING;

-- Relación libros-autores (mínimo 1 por libro, varios con autores reales)
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
JOIN authors a ON a.name = 'Joshua Bloch'
WHERE b.title = 'Effective Java'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'Brian Kernighan'
WHERE b.title = 'The C Programming Language'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'Donald Knuth'
WHERE b.title = 'Introduction to Algorithms'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'Mark Lutz'
WHERE b.title = 'Learning SQL'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'James Clear'
WHERE b.title = 'Atomic Habits'
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
JOIN authors a ON a.name = 'Neil deGrasse Tyson'
WHERE b.title = 'Astrophysics for People in a Hurry'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'Brian Greene'
WHERE b.title = 'The Elegant Universe'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'George Orwell'
WHERE b.title = '1984'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'Haruki Murakami'
WHERE b.title = 'The Wind-Up Bird Chronicle'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'Jane Austen'
WHERE b.title = 'Pride and Prejudice'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'Gabriel García Márquez'
WHERE b.title = 'One Hundred Years of Solitude'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'Albert Camus'
WHERE b.title = 'The Stranger'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'J. K. Rowling'
WHERE b.title LIKE 'Harry Potter%'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'Agatha Christie'
WHERE b.title = 'The Murder on the Orient Express'
UNION ALL
SELECT b.isbn, a.author_id
FROM books b
JOIN authors a ON a.name = 'Yuval Noah Harari'
WHERE b.title = 'Sapiens'
ON CONFLICT (isbn, author_id) DO NOTHING;

-- Relación libros-géneros (al menos 1 por libro)
INSERT INTO book_genres (isbn, genre_id)
SELECT b.isbn, g.genre_id
FROM books b
JOIN genres g ON g.name = 'Software Engineering'
WHERE b.title IN ('Clean Code', 'The Pragmatic Programmer', 'Refactoring', 'Code Complete', 'Modern Operating Systems')
UNION ALL
SELECT b.isbn, g.genre_id
FROM books b
JOIN genres g ON g.name = 'Programming'
WHERE b.title IN ('Head First Java', 'Effective Java', 'JavaScript: The Definitive Guide', 'Effective Python', 'The C Programming Language', 'Learning SQL')
UNION ALL
SELECT b.isbn, g.genre_id
FROM books b
JOIN genres g ON g.name = 'Web Development'
WHERE b.title IN ('JavaScript: The Definitive Guide', 'HTML5', 'Learning SQL')
UNION ALL
SELECT b.isbn, g.genre_id
FROM books b
JOIN genres g ON g.name = 'Cloud Computing'
WHERE b.title IN ('Docker in Action', 'Kubernetes Up and Running', 'Terraform Up & Running', 'The Phoenix Project', 'The DevOps Handbook')
UNION ALL
SELECT b.isbn, g.genre_id
FROM books b
JOIN genres g ON g.name = 'AI'
WHERE b.title = 'Generative AI for Everyone'
UNION ALL
SELECT b.isbn, g.genre_id
FROM books b
JOIN genres g ON g.name = 'Algorithms'
WHERE b.title IN ('Introduction to Algorithms', 'Computer Systems', 'The Practice of Programming')
UNION ALL
SELECT b.isbn, g.genre_id
FROM books b
JOIN genres g ON g.name = 'Business'
WHERE b.title IN ('The Lean Startup', 'Atomic Habits', 'The Power of Habit', 'Deep Work', 'Rich Dad Poor Dad')
UNION ALL
SELECT b.isbn, g.genre_id
FROM books b
JOIN genres g ON g.name = 'Science'
WHERE b.title IN ('Cosmos', 'A Brief History of Time', 'Astrophysics for People in a Hurry', 'The Elegant Universe')
UNION ALL
SELECT b.isbn, g.genre_id
FROM books b
JOIN genres g ON g.name = 'Literature'
WHERE b.title IN ('1984', 'Pride and Prejudice', 'Moby-Dick', 'The Great Gatsby', 'To Kill a Mockingbird', 'The Little Prince', 'Jane Eyre')
ON CONFLICT (isbn, genre_id) DO NOTHING;

-- Imágenes reales por ISBN mediante Open Library covers
INSERT INTO book_images (isbn, image_url, alt_text, is_cover)
SELECT isbn,
       'https://covers.openlibrary.org/b/isbn/' || REPLACE(isbn, '-', '') || '-L.jpg',
       title,
       TRUE
FROM books
WHERE isbn IS NOT NULL
ON CONFLICT DO NOTHING;

-- Vista de control para la app
SELECT COUNT(*) AS total_books FROM books;
