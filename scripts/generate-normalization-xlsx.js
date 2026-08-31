const fs = require('fs');
const path = require('path');
const XLSX = require('xlsx');

const outputPath = path.join(__dirname, '..', 'docs', 'NORMALIZATION_4FN.xlsx');
const workbook = XLSX.utils.book_new();

function addSheet(name, rows, widths) {
    const sheet = XLSX.utils.aoa_to_sheet(rows);
    sheet['!cols'] = widths.map((width) => ({ wch: width }));
    XLSX.utils.book_append_sheet(workbook, sheet, name);
}

addSheet('Resumen', [
    ['NORMALIZACION A 4FN - LIBRARY UDEM'],
    ['Proyecto', 'Aplicacion monolitica Node.js + Express + EJS + PostgreSQL'],
    ['Clave primaria principal', 'books.isbn'],
    ['Objetivo', 'Eliminar grupos repetitivos, dependencias parciales, transitivas y multivaluadas'],
    ['Resultado', 'Modelo relacional con tablas puente para autores, generos, imagenes y conceptos'],
    ['Fuente tecnica', 'db/01_schema.sql'],
    ['Fecha de generacion', new Date().toISOString().slice(0, 10)]
], [34, 105]);

addSheet('0FN', [
    ['Nivel', 'Situacion', 'Problema', 'Accion', 'Resultado'],
    ['0FN', 'Un libro contiene varios autores, géneros, imágenes y conceptos en la misma fila', 'Duplicación de datos, inconsistencias y anomalías de inserción', 'Separar atributos repetidos en entidades dedicadas', 'Base inicial sin normalizar'],
    ['0FN', 'Ejemplo de libro desnormalizado', 'Un mismo libro puede duplicarse si cambia autor o género', 'Establecer estructura relacional', 'Se visualiza la necesidad de 1FN'],
], [14, 50, 50, 32, 30]);

addSheet('1FN', [
    ['Regla', 'Análisis', 'Transformación', 'Resultado esperado'],
    ['1FN', 'Todos los atributos deben ser atómicos', 'Se separan grupos repetitivos en tablas', 'Cada valor tiene una fila o una entidad independiente'],
    ['1FN', 'Generación de tablas base', 'books, authors, genres, formats, concepts, book_images', 'Se elimina la repetición en columnas'],
    ['1FN', 'Relaciones N:M', 'book_authors, book_genres, book_concepts', 'Se crean tablas puente con PK compuesta'],
    ['1FN', 'Validación', 'No existen columnas multi-valoradas ni listas iguales en una fila', 'Se cumple 1FN'],
], [14, 42, 38, 38]);

addSheet('2FN', [
    ['Regla', 'Análisis', 'Observación', 'Resultado esperado'],
    ['2FN', 'Es necesario que todo atributo no clave dependa de toda la clave primaria', 'Las tablas puente usan clave primaria compuesta', 'No hay dependencia parcial'],
    ['2FN', 'book_authors', '(isbn, author_id) y los atributos no clave son nulos o no aplican', 'Todo valor depende del conjunto completo de la clave', 'Se cumple 2FN'],
    ['2FN', 'book_genres', '(isbn, genre_id) cumple la misma regla', 'No hay atributos que dependan solo de isbn o solo de genre_id', 'Se cumple 2FN'],
    ['2FN', 'book_concepts', '(isbn, concept_id) conserva definición y relación', 'La definición depende del par completo', 'Se cumple 2FN'],
], [14, 44, 40, 40]);

addSheet('3FN', [
    ['Regla', 'Análisis', 'Observación', 'Resultado esperado'],
    ['3FN', 'No debe haber dependencias transitivas', 'El formato o catálogo no depende de otra columna no clave', 'Se separa catálogo de formatos'],
    ['3FN', 'books', 'isbn determina título, precio, stock, editorial y formato', 'La dependencia es directa con la PK', 'Se cumple 3FN'],
    ['3FN', 'formats', 'format_id determina nombre del formato', 'No existe un atributo ajeno que lo controle', 'Se cumple 3FN'],
    ['3FN', 'concepts', 'concept_id determina nombre del concepto', 'No se repite la misma definición en varias filas', 'Se cumple 3FN'],
], [14, 40, 38, 38]);

addSheet('4FN', [
    ['Regla', 'Análisis', 'Problema resuelto', 'Resultado esperado'],
    ['4FN', 'Se eliminan dependencias multivaluadas no triviales', 'Un libro puede tener varios autores y varios géneros independientemente', 'Se separan las relaciones como entidades independientes'],
    ['4FN', 'MVD', 'Si un libro posee 3 autores y 2 géneros, no se genera 6 filas redundantes en una sola tabla', 'Se usa book_authors y book_genres'],
    ['4FN', 'Aplicación del diseño', 'book_images y book_concepts se mantienen como relaciones independientes', 'Se evita producto cartesiano y redundancia'],
    ['4FN', 'Resultado final', 'Base de datos normalizada a 4FN', 'Modelo estable para CRUD, búsquedas y validación'],
], [14, 44, 44, 38]);

addSheet('Entidades', [
    ['Tabla', 'Clave primaria', 'Claves foraneas', 'Atributos principales', 'Proposito'],
    ['users', 'user_id', 'ninguna', 'username, email, password_hash, role', 'Usuarios y administracion'],
    ['authors', 'author_id', 'ninguna', 'name, biography, birth_year, country', 'Catalogo de autores'],
    ['genres', 'genre_id', 'ninguna', 'name, description', 'Catalogo de generos'],
    ['formats', 'format_id', 'ninguna', 'name, description', 'Catalogo de formatos'],
    ['concepts', 'concept_id', 'ninguna', 'name, description', 'Conceptos globales'],
    ['books', 'isbn', 'format_id -> formats', 'title, description, price, stock, publisher', 'Entidad principal'],
    ['book_authors', '(isbn, author_id)', 'isbn -> books; author_id -> authors', 'solo claves', 'Relacion N:M libro-autor'],
    ['book_genres', '(isbn, genre_id)', 'isbn -> books; genre_id -> genres', 'solo claves', 'Relacion N:M libro-genero'],
    ['book_concepts', '(isbn, concept_id)', 'isbn -> books; concept_id -> concepts', 'definition, created_at', 'Definicion especifica por libro'],
    ['book_images', 'image_id', 'isbn -> books', 'image_url, alt_text, is_cover', 'Portadas e imagenes'],
    ['audit_log', 'log_id', 'user_id -> users', 'operation, old_values, new_values', 'Auditoria'],
    ['session', 'sid', 'ninguna', 'sess, expire', 'Persistencia de sesiones']
], [22, 25, 48, 58, 34]);

addSheet('Relaciones 4FN', [
    ['Origen', 'Cardinalidad', 'Destino', 'Implementacion', 'Justificacion'],
    ['books', '1:N', 'book_authors', 'book_authors.isbn FK', 'Un libro puede tener varios autores'],
    ['authors', '1:N', 'book_authors', 'book_authors.author_id FK', 'Un autor puede escribir varios libros'],
    ['books', '1:N', 'book_genres', 'book_genres.isbn FK', 'Un libro puede tener varios generos'],
    ['genres', '1:N', 'book_genres', 'book_genres.genre_id FK', 'Un genero puede clasificar varios libros'],
    ['books', '1:N', 'book_images', 'book_images.isbn FK', 'Las imagenes son independientes de autores y generos'],
    ['books', '1:N', 'book_concepts', 'book_concepts.isbn FK', 'Cada libro puede contextualizar conceptos'],
    ['concepts', '1:N', 'book_concepts', 'book_concepts.concept_id FK', 'Un concepto se reutiliza con definiciones por libro'],
    ['formats', '1:N', 'books', 'books.format_id FK', 'Catalogo sin duplicar nombre de formato'],
    ['users', '1:N', 'session', 'session.sess JSONB', 'Persistencia server-side de sesiones'],
    ['users', '1:N', 'audit_log', 'audit_log.user_id FK', 'Registro de operaciones']
], [20, 15, 22, 35, 64]);

addSheet('Restricciones', [
    ['Objeto', 'Restriccion', 'Valor', 'Finalidad'],
    ['books', 'PRIMARY KEY', 'isbn', 'Identificador unico del libro'],
    ['users', 'UNIQUE', 'username y email', 'Evitar cuentas duplicadas'],
    ['genres', 'UNIQUE', 'name', 'Evitar generos duplicados'],
    ['concepts', 'UNIQUE', 'name', 'Evitar conceptos duplicados'],
    ['books', 'CHECK', 'price >= 0', 'Evitar precios negativos'],
    ['books', 'CHECK', 'stock >= 0', 'Evitar inventario negativo'],
    ['users', 'UNIQUE INDEX parcial', 'role = ADMIN', 'Garantizar un solo administrador'],
    ['Relaciones', 'FOREIGN KEY', 'ON DELETE CASCADE', 'Conservar integridad al eliminar libros'],
    ['Rendimiento', 'INDEX', 'title, price, author_id, genre_id', 'Optimizar busquedas y relaciones']
], [24, 25, 38, 62]);

addSheet('Evidencia', [
    ['Evidencia', 'Comando o archivo', 'Que demuestra'],
    ['Esquema', 'db/01_schema.sql', 'Tablas, PK, FK, UNIQUE, CHECK e indices'],
    ['Modelo ER', 'T2.html -> Descargar PNG', 'Entidades y relaciones completas'],
    ['Conteos', 'db/08_report_evidence.sql', 'Cantidad de registros por tabla'],
    ['Depuracion', 'db/09_cleanup_real_catalog.sql', 'Categorias reales y autores sin datos artificiales'],
    ['Autores', 'db/10_repair_book_authors.sql', 'Libros relacionados con autores reales'],
    ['Validacion', 'npm run verify', 'Rutas, assets, busqueda y filtro'],
    ['Documentacion', 'docs/REQUIREMENTS.md y SECURITY_REVIEW.md', 'Requisitos, riesgos y mitigaciones']
], [22, 48, 78]);

for (const sheet of workbook.SheetNames) {
    const worksheet = workbook.Sheets[sheet];
    worksheet['!freeze'] = { xSplit: 0, ySplit: 1 };
}

fs.mkdirSync(path.dirname(outputPath), { recursive: true });
XLSX.writeFile(workbook, outputPath);
console.log(`Generated ${outputPath}`);
