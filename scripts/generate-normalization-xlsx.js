const fs = require('fs');
const path = require('path');
const XLSX = require('xlsx');

const outputPath = path.join(__dirname, '..', 'docs', 'NORMALIZATION_4FN.xlsx');
const workbook = XLSX.utils.book_new();

function addSheet(name, rows, widths) {
    const sheet = XLSX.utils.aoa_to_sheet(rows);
    sheet['!cols'] = widths.map((width) => ({ wch: width }));
    sheet['!freeze'] = { xSplit: 0, ySplit: 1 };
    XLSX.utils.book_append_sheet(workbook, sheet, name);
}

const authors = [
    [1, 'Stephen King', 'Autor de terror y fantasía', 1947, 'United States'],
    [2, 'George Orwell', 'Escritor y periodista británico', 1903, 'United Kingdom'],
    [3, 'J.K. Rowling', 'Autora de fantasía juvenil', 1965, 'United Kingdom'],
    [4, 'Haruki Murakami', 'Novelista y escritor japonés', 1949, 'Japan'],
    [5, 'Gabriel García Márquez', 'Novelista y periodista colombiano', 1927, 'Colombia'],
    [6, 'Jane Austen', 'Novelista inglesa del Romanticismo', 1775, 'United Kingdom'],
    [7, 'Mary Shelley', 'Autora inglesa de ciencia ficción', 1797, 'United Kingdom'],
    [8, 'Isaac Asimov', 'Escritor y bioquímico estadounidense', 1920, 'United States'],
    [9, 'Franz Kafka', 'Escritor checo de ficción moderna', 1883, 'Czech Republic'],
    [10, 'Virginia Woolf', 'Escritora y crítica británica', 1882, 'United Kingdom']
];

const genres = [
    [1, 'Terror', 'Obras de tensión, misterio y miedo'],
    [2, 'Ciencia Ficción', 'Narrativas basadas en tecnología y futuro'],
    [3, 'Fantasía', 'Mundos imaginarios y magia'],
    [4, 'Novela', 'Ficción narrativa extensa'],
    [5, 'Distopía', 'Sociedades futuristas controladas'],
    [6, 'Romance', 'Relaciones y desarrollo emocional'],
    [7, 'Historia', 'Narrativas históricas o documentales'],
    [8, 'Drama', 'Obras con tensión psicológica y emocional'],
    [9, 'Filosofía', 'Temas conceptuales y reflexivos'],
    [10, 'Misterio', 'Enigmas y resolución de casos']
];

const formats = [
    [1, 'Físico', 'Edición tradicional impresa'],
    [2, 'Digital PDF', 'Formato PDF para lectura digital'],
    [3, 'Digital EPUB', 'Formato EPUB para lector electrónico'],
    [4, 'Audiolibro', 'Versión sonora del libro'],
    [5, 'Colección', 'Edición especial de colección'],
    [6, 'Bolsillo', 'Formato compacto y portable'],
    [7, 'Premium', 'Edición de lujo'],
    [8, 'Campus', 'Edición institucional'],
    [9, 'Pasta Dura', 'Edición de cubierta rígida'],
    [10, 'Pasta Blanda', 'Edición de cubierta blanda']
];

const concepts = [
    [1, 'Identidad', 'Cómo se define la personalidad de los personajes'],
    [2, 'Tiempo', 'Relación entre hechos y secuencia narrativa'],
    [3, 'Tecnología', 'Uso de avances científicos en la historia'],
    [4, 'Poder', 'Influencias políticas, sociales y morales'],
    [5, 'Memoria', 'Recuerdos y su impacto en la trama'],
    [6, 'Libertad', 'Elección individual frente a control externo'],
    [7, 'Miedo', 'Emoción que impulsa tensión y suspense'],
    [8, 'Amor', 'Relaciones humanas y emoción'],
    [9, 'Realidad', 'Distinción entre hecho objetivo y percepción'],
    [10, 'Destino', 'Curso inevitable de los acontecimientos']
];

const books = [
    ['9780306406157', 'IT', 'Historia de un grupo de amigos que enfrentan a un enemigo ancestral', 1986, 59.99, 29, 10, 'PHYSICAL', null, 'Scribner'],
    ['9780451524935', '1984', 'Una distopía sobre vigilancia y manipulación del pensamiento', 1949, 24.5, 18, 1, 'DIGITAL', 'EPUB', 'Secker & Warburg'],
    ['9780743273565', 'The Great Gatsby', 'La decadencia de la riqueza y el sueño americano', 1925, 18.9, 12, 1, 'DIGITAL', 'PDF', 'Scribner'],
    ['9780439708180', 'Harry Potter y la piedra filosofal', 'Un niño descubre su magia y es aceptado en Hogwarts', 1997, 34.9, 26, 10, 'PHYSICAL', null, 'Bloomsbury'],
    ['9780679775430', 'El amor en los tiempos del cólera', 'Elegía sobre el amor, la espera y el destino', 1985, 20.5, 15, 1, 'DIGITAL', 'PDF', 'Random House'],
    ['9780141439518', 'Pride and Prejudice', 'Relaciones sociales y evolución emocional en la Inglaterra del siglo XIX', 1813, 17.25, 11, 1, 'DIGITAL', 'EPUB', 'Penguin'],
    ['9780199535569', 'Frankenstein', 'Una creación científica y la responsabilidad moral del hombre', 1818, 22.75, 14, 9, 'PHYSICAL', null, 'Oxford'],
    ['9780553382575', 'Foundation', 'Una civilización intenta proteger su futuro frente a la decadencia', 1951, 28.5, 17, 1, 'DIGITAL', 'EPUB', 'Gnome Press'],
    ['9780805211063', 'La metamorfosis', 'Un viajero despierta transformado y aislado de su familia', 1915, 19.8, 9, 10, 'PHYSICAL', null, 'Schocken'],
    ['9780156028356', 'Mrs Dalloway', 'Una jornada íntima en la vida de una mujer londinense', 1925, 21.4, 10, 1, 'DIGITAL', 'PDF', 'Harcourt']
];

const bookAuthors = [
    ['9780306406157', 1], ['9780451524935', 2], ['9780743273565', 3], ['9780439708180', 3], ['9780679775430', 5], ['9780141439518', 6], ['9780199535569', 7], ['9780553382575', 8], ['9780805211063', 9], ['9780156028356', 10],
    ['9780306406157', 5], ['9780439708180', 10], ['9780743273565', 2], ['9780451524935', 1], ['9780199535569', 3]
];

const bookGenres = [
    ['9780306406157', 1], ['9780306406157', 8], ['9780451524935', 5], ['9780451524935', 8], ['9780743273565', 4], ['9780743273565', 6], ['9780439708180', 3], ['9780439708180', 4], ['9780679775430', 4], ['9780679775430', 8],
    ['9780141439518', 6], ['9780199535569', 2], ['9780553382575', 2], ['9780805211063', 8], ['9780156028356', 8]
];

const bookConcepts = [
    ['9780306406157', 7, 'El miedo se convierte en un mecanismo de control emocional y social'],
    ['9780306406157', 5, 'La memoria del pasado tiene poder sobre la identidad de una comunidad'],
    ['9780451524935', 4, 'El poder totalitario se sostiene en la vigilancia y la manipulación'],
    ['9780451524935', 6, 'La libertad individual se enfrenta con la disciplina social'],
    ['9780743273565', 8, 'El amor y la clase social condicionan la percepción de la felicidad'],
    ['9780439708180', 3, 'La tecnología y la magia conforman la identidad del mundo fantástico'],
    ['9780439708180', 1, 'La identidad del protagonista se define por su pertenencia a Hogwarts'],
    ['9780679775430', 9, 'La realidad se percibe de manera distinta según la memoria y la esperanza'],
    ['9780141439518', 8, 'El amor y el orgullo alteran las decisiones humanas'],
    ['9780199535569', 1, 'La creación despierta una crisis ética y emocional en el creador'],
    ['9780553382575', 10, 'El destino de la civilización parece inevitable ante el ciclo histórico'],
    ['9780805211063', 1, 'La identidad personal se transforma al perder la relación familiar'],
    ['9780156028356', 2, 'El paso del tiempo orienta la percepción del mundo interno de la protagonista']
];

const bookImages = [
    [1, '9780306406157', '/uploads/it.jpg', 'Portada IT', true],
    [2, '9780451524935', '/uploads/1984.jpg', 'Portada 1984', true],
    [3, '9780743273565', '/uploads/gatsby.jpg', 'Portada Great Gatsby', true],
    [4, '9780439708180', '/uploads/harrypotter.jpg', 'Portada Harry Potter', true],
    [5, '9780679775430', '/uploads/amor-colera.jpg', 'Portada El amor en los tiempos del cólera', true],
    [6, '9780141439518', '/uploads/pride.jpg', 'Portada Pride and Prejudice', true],
    [7, '9780199535569', '/uploads/frankenstein.jpg', 'Portada Frankenstein', true],
    [8, '9780553382575', '/uploads/foundation.jpg', 'Portada Foundation', true],
    [9, '9780805211063', '/uploads/metamorfosis.jpg', 'Portada La metamorfosis', true],
    [10, '9780156028356', '/uploads/mrs-dalloway.jpg', 'Portada Mrs Dalloway', true]
];

const summaryRows = [
    ['NORMALIZACION A 4FN - LIBRARY UDEM'],
    ['Proyecto', 'Aplicación monolítica Node.js + Express + EJS + PostgreSQL'],
    ['Clave primaria principal', 'books.isbn'],
    ['Objetivo', 'Eliminar datos repetidos, dependencias parciales y multivaluadas'],
    ['Resultado', 'Modelo normalizado con tablas puente para autores, géneros, conceptos e imágenes'],
    ['Fuente técnica', 'db/01_schema.sql'],
    ['Fecha de generación', new Date().toISOString().slice(0, 10)]
];

addSheet('Resumen', summaryRows, [30, 90]);

addSheet('0FN', [
    ['Nivel', 'Tabla', 'ISBN', 'TITULO', 'AUTORES', 'GENERO', 'AÑO', 'PRECIO', 'STOCK', 'FORMATO', 'IMAGEN', 'CONCEPTOS'],
    ['0FN', 'libros_desnormalizados', '9780306406157', 'IT', 'Stephen King', 'Terror, Thriller', 1986, 59.99, 29, 'Pasta dura', 'it.jpg', 'Miedo, memoria'],
    ['0FN', 'libros_desnormalizados', '9780451524935', '1984', 'George Orwell', 'Distopía, Drama', 1949, 24.5, 18, 'Digital EPUB', '1984.jpg', 'Poder, libertad'],
    ['0FN', 'libros_desnormalizados', '9780743273565', 'The Great Gatsby', 'J.K. Rowling', 'Novela, Romance', 1925, 18.9, 12, 'Digital PDF', 'gatsby.jpg', 'Amor, sociedad'],
    ['0FN', 'libros_desnormalizados', '9780439708180', 'Harry Potter y la piedra filosofal', 'J.K. Rowling', 'Fantasía, Juvenil', 1997, 34.9, 26, 'Pasta dura', 'harrypotter.jpg', 'Identidad, magia'],
    ['0FN', 'libros_desnormalizados', '9780679775430', 'El amor en los tiempos del cólera', 'Gabriel García Márquez', 'Novela, Drama', 1985, 20.5, 15, 'Digital PDF', 'amor-colera.jpg', 'Realidad, memoria'],
    ['0FN', 'libros_desnormalizados', '9780141439518', 'Pride and Prejudice', 'Jane Austen', 'Romance, Novela', 1813, 17.25, 11, 'Digital EPUB', 'pride.jpg', 'Amor, orgullo'],
    ['0FN', 'libros_desnormalizados', '9780199535569', 'Frankenstein', 'Mary Shelley', 'Ciencia Ficción, Drama', 1818, 22.75, 14, 'Pasta dura', 'frankenstein.jpg', 'Identidad, moral'],
    ['0FN', 'libros_desnormalizados', '9780553382575', 'Foundation', 'Isaac Asimov', 'Ciencia Ficción', 1951, 28.5, 17, 'Digital EPUB', 'foundation.jpg', 'Destino, historia'],
    ['0FN', 'libros_desnormalizados', '9780805211063', 'La metamorfosis', 'Franz Kafka', 'Drama, Novela', 1915, 19.8, 9, 'Pasta dura', 'metamorfosis.jpg', 'Identidad, aislamiento'],
    ['0FN', 'libros_desnormalizados', '9780156028356', 'Mrs Dalloway', 'Virginia Woolf', 'Novela, Drama', 1925, 21.4, 10, 'Digital PDF', 'mrs-dalloway.jpg', 'Tiempo, realidad']
], [12, 18, 16, 22, 22, 18, 12, 13, 14, 18, 18, 24]);

addSheet('1FN', [
    ['1FN - Atributos atómicos y separación de entidades'],
    ['TABLA: authors'],
    ['author_id', 'name', 'biography', 'birth_year', 'country'],
    ...authors,
    [],
    ['TABLA: genres'],
    ['genre_id', 'name', 'description'],
    ...genres.map(([id, name, description]) => [id, name, description]),
    [],
    ['TABLA: formats'],
    ['format_id', 'name', 'description'],
    ...formats.map(([id, name, description]) => [id, name, description]),
    [],
    ['TABLA: concepts'],
    ['concept_id', 'name', 'description'],
    ...concepts.map(([id, name, description]) => [id, name, description]),
    [],
    ['TABLA: books'],
    ['isbn', 'title', 'description', 'publication_year', 'price', 'stock', 'format_id', 'format_type', 'digital_format', 'publisher'],
    ...books
], [16, 26, 38, 12, 20]);

addSheet('2FN', [
    ['2FN - Todas las claves no primarias dependen de la clave compuesta'],
    ['TABLA: book_authors'],
    ['isbn', 'author_id'],
    ...bookAuthors,
    [],
    ['TABLA: book_genres'],
    ['isbn', 'genre_id'],
    ...bookGenres,
    [],
    ['TABLA: book_concepts'],
    ['isbn', 'concept_id', 'definition'],
    ...bookConcepts
], [18, 12, 60]);

addSheet('3FN', [
    ['3FN - Sin dependencias transitivas'],
    ['TABLA: books'],
    ['isbn', 'title', 'description', 'publication_year', 'price', 'stock', 'format_id', 'format_type', 'digital_format', 'publisher'],
    ...books,
    [],
    ['TABLA: formats'],
    ['format_id', 'name', 'description'],
    ...formats.map(([id, name, description]) => [id, name, description]),
    [],
    ['TABLA: concepts'],
    ['concept_id', 'name', 'description'],
    ...concepts.map(([id, name, description]) => [id, name, description])
], [18, 26, 42, 12, 12, 12, 12, 18, 18, 22]);

addSheet('4FN', [
    ['4FN - Eliminación de dependencias multivaluadas y diccionario de datos'],
    ['TABLA: books'],
    ['isbn', 'title', 'description', 'publication_year', 'price', 'stock', 'format_id', 'format_type', 'digital_format', 'publisher'],
    ...books,
    [],
    ['TABLA: book_authors'],
    ['isbn', 'author_id'],
    ...bookAuthors,
    [],
    ['TABLA: book_genres'],
    ['isbn', 'genre_id'],
    ...bookGenres,
    [],
    ['TABLA: book_concepts'],
    ['isbn', 'concept_id', 'definition'],
    ...bookConcepts,
    [],
    ['TABLA: book_images'],
    ['image_id', 'isbn', 'image_url', 'alt_text', 'is_cover'],
    ...bookImages,
    [],
    ['DICCIONARIO DE DATOS'],
    ['Tabla', 'Campo', 'Tipo', 'Clave', 'Descripcion', 'Regla/Validacion'],
    ['books', 'isbn', 'VARCHAR(20)', 'PK', 'Identificador único del libro', 'No nulo y único'],
    ['books', 'title', 'VARCHAR(255)', '', 'Título del libro', 'Obligatorio'],
    ['books', 'description', 'TEXT', '', 'Resumen del contenido', 'Puede ser nulo'],
    ['books', 'publication_year', 'INTEGER', '', 'Año de publicación', 'Puede ser nulo'],
    ['books', 'price', 'DECIMAL(10,2)', '', 'Precio del libro', 'Debe ser >= 0'],
    ['books', 'stock', 'INTEGER', '', 'Existencias disponibles', 'Debe ser >= 0'],
    ['books', 'format_id', 'INTEGER', 'FK', 'Identificador del formato', 'Referencias formats(format_id)'],
    ['books', 'format_type', 'VARCHAR(20)', '', 'Tipo de edición', 'PHYSICAL o DIGITAL'],
    ['books', 'digital_format', 'VARCHAR(10)', '', 'Formato digital', 'PDF o EPUB'],
    ['books', 'publisher', 'VARCHAR(150)', '', 'Editorial', 'Puede ser nulo'],
    ['authors', 'author_id', 'SERIAL', 'PK', 'Identificador de autor', 'Autonumérico'],
    ['authors', 'name', 'VARCHAR(150)', '', 'Nombre del autor', 'Obligatorio'],
    ['authors', 'biography', 'TEXT', '', 'Biografía del autor', 'Puede ser nulo'],
    ['authors', 'birth_year', 'INTEGER', '', 'Año de nacimiento', 'Puede ser nulo'],
    ['authors', 'country', 'VARCHAR(100)', '', 'País de origen', 'Puede ser nulo'],
    ['book_authors', 'isbn', 'VARCHAR(20)', 'PK/FK', 'Libro relacionado', 'FK a books(isbn)'],
    ['book_authors', 'author_id', 'INTEGER', 'PK/FK', 'Autor relacionado', 'FK a authors(author_id)'],
    ['book_genres', 'isbn', 'VARCHAR(20)', 'PK/FK', 'Libro relacionado', 'FK a books(isbn)'],
    ['book_genres', 'genre_id', 'INTEGER', 'PK/FK', 'Género asociado', 'FK a genres(genre_id)'],
    ['book_concepts', 'isbn', 'VARCHAR(20)', 'PK/FK', 'Libro relacionado', 'FK a books(isbn)'],
    ['book_concepts', 'concept_id', 'INTEGER', 'PK/FK', 'Concepto asociado', 'FK a concepts(concept_id)'],
    ['book_concepts', 'definition', 'TEXT', '', 'Definición del concepto', 'No nulo'],
    ['book_images', 'image_id', 'SERIAL', 'PK', 'Identificador de imagen', 'Autonumérico'],
    ['book_images', 'isbn', 'VARCHAR(20)', 'FK', 'Libro asociado', 'FK a books(isbn)'],
    ['book_images', 'image_url', 'VARCHAR(500)', '', 'Ruta de la imagen', 'No nula'],
    ['book_images', 'alt_text', 'VARCHAR(255)', '', 'Texto alternativo', 'Puede ser nulo'],
    ['book_images', 'is_cover', 'BOOLEAN', '', 'Es portada', 'Default false']
], [18, 20, 20, 16, 22, 18, 80]);

addSheet('Entidades', [
    ['Tabla', 'Clave primaria', 'Claves foráneas', 'Atributos principales', 'Propósito'],
    ['users', 'user_id', 'ninguna', 'username, email, password_hash, role', 'Usuarios del sistema'],
    ['authors', 'author_id', 'ninguna', 'name, biography, birth_year, country', 'Catálogo de autores'],
    ['genres', 'genre_id', 'ninguna', 'name, description', 'Catálogo de géneros'],
    ['formats', 'format_id', 'ninguna', 'name, description', 'Catálogo de formatos'],
    ['concepts', 'concept_id', 'ninguna', 'name, description', 'Conceptos globales'],
    ['books', 'isbn', 'format_id -> formats(format_id)', 'title, description, price, stock, publisher', 'Libro principal'],
    ['book_authors', '(isbn, author_id)', 'isbn -> books(isbn); author_id -> authors(author_id)', 'solo claves', 'Relación N:M libro-autor'],
    ['book_genres', '(isbn, genre_id)', 'isbn -> books(isbn); genre_id -> genres(genre_id)', 'solo claves', 'Relación N:M libro-género'],
    ['book_concepts', '(isbn, concept_id)', 'isbn -> books(isbn); concept_id -> concepts(concept_id)', 'definition', 'Definición por libro'],
    ['book_images', 'image_id', 'isbn -> books(isbn)', 'image_url, alt_text, is_cover', 'Portadas e imágenes'],
    ['audit_log', 'log_id', 'user_id -> users(user_id)', 'operation, old_values, new_values', 'Auditoría de cambios'],
    ['session', 'sid', 'ninguna', 'sess, expire', 'Sesiones del sistema']
], [18, 22, 42, 40, 30]);

addSheet('Relaciones 4FN', [
    ['Origen', 'Cardinalidad', 'Destino', 'Implementación', 'Justificación'],
    ['books', '1:N', 'book_authors', 'book_authors.isbn -> books.isbn', 'Un libro puede tener varios autores'],
    ['authors', '1:N', 'book_authors', 'book_authors.author_id -> authors.author_id', 'Un autor puede publicar varios libros'],
    ['books', '1:N', 'book_genres', 'book_genres.isbn -> books.isbn', 'Un libro puede pertenecer a varios géneros'],
    ['genres', '1:N', 'book_genres', 'book_genres.genre_id -> genres.genre_id', 'Un género clasifica múltiples libros'],
    ['books', '1:N', 'book_concepts', 'book_concepts.isbn -> books.isbn', 'Cada libro puede definir varios conceptos'],
    ['concepts', '1:N', 'book_concepts', 'book_concepts.concept_id -> concepts.concept_id', 'Un concepto se reutiliza en distintos libros'],
    ['books', '1:N', 'book_images', 'book_images.isbn -> books.isbn', 'Todo libro puede tener varias imágenes'],
    ['formats', '1:N', 'books', 'books.format_id -> formats.format_id', 'El catálogo de formatos no se duplica'],
    ['users', '1:N', 'audit_log', 'audit_log.user_id -> users.user_id', 'Se guarda el historial de cambios'],
    ['users', '1:N', 'session', 'session.user_id no aplica', 'Se mantiene la sesión del usuario']
], [16, 14, 18, 38, 54]);

addSheet('Restricciones', [
    ['Objeto', 'Restricción', 'Valor', 'Finalidad'],
    ['books', 'PRIMARY KEY', 'isbn', 'Identificador único del libro'],
    ['books', 'CHECK', 'price >= 0', 'Impide precios negativos'],
    ['books', 'CHECK', 'stock >= 0', 'Impide inventario negativo'],
    ['books', 'CHECK', 'format_type IN (PHYSICAL, DIGITAL)', 'Restringe tipo de edición'],
    ['books', 'CHECK', 'digital_format IN (PDF, EPUB)', 'Restringe formatos digitales válidos'],
    ['genre', 'UNIQUE', 'name', 'Evita duplicados de géneros'],
    ['concepts', 'UNIQUE', 'name', 'Evita conceptos repetidos'],
    ['users', 'UNIQUE', 'email', 'Evita duplicación de cuentas'],
    ['users', 'UNIQUE INDEX parcial', 'role = ADMIN', 'Garantiza un solo administrador'],
    ['book_authors', 'PK compuesta', '(isbn, author_id)', 'Elimina redundancia por combinación'],
    ['book_genres', 'PK compuesta', '(isbn, genre_id)', 'Elimina redundancia por combinación'],
    ['book_concepts', 'PK compuesta', '(isbn, concept_id)', 'Mantiene definición del concepto por libro']
], [18, 22, 22, 40]);

fs.mkdirSync(path.dirname(outputPath), { recursive: true });
XLSX.writeFile(workbook, outputPath);
console.log(`Generated ${outputPath}`);

