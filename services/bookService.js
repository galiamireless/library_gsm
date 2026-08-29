// ===================================================================
// Servicio de Libros
// Consultas SQL parametrizadas para catálogo, búsqueda y CRUD
// ===================================================================

const db = require('../config/db');

// Obtener todos los libros con paginación
async function getAllBooks(page = 1, perPage = 10) {
    try {
        const offset = (page - 1) * perPage;
        
        const result = await db.query(
            `SELECT 
                b.isbn, b.title, b.description, b.price, b.stock, b.publication_year,
                STRING_AGG(DISTINCT a.name, ', ') as authors,
                COUNT(*) OVER () as total_count
            FROM books b
            LEFT JOIN book_authors ba ON b.isbn = ba.isbn
            LEFT JOIN authors a ON ba.author_id = a.author_id
            GROUP BY b.isbn, b.title, b.description, b.price, b.stock, b.publication_year
            ORDER BY b.title ASC
            LIMIT $1 OFFSET $2`,
            [perPage, offset]
        );

        return {
            success: true,
            books: result.rows,
            totalCount: result.rows.length > 0 ? parseInt(result.rows[0].total_count) : 0,
            page: page,
            perPage: perPage
        };
    } catch (error) {
        return {
            success: false,
            error: error.message
        };
    }
}

// Obtener libro por ISBN con todos sus detalles
async function getBookByISBN(isbn) {
    try {
        const result = await db.query(
            `SELECT 
                b.isbn, b.title, b.description, b.price, b.stock, b.publication_year,
                b.publisher, f.name as format,
                STRING_AGG(DISTINCT a.name, ', ') as authors,
                STRING_AGG(DISTINCT g.name, ', ') as genres
            FROM books b
            LEFT JOIN formats f ON b.format_id = f.format_id
            LEFT JOIN book_authors ba ON b.isbn = ba.isbn
            LEFT JOIN authors a ON ba.author_id = a.author_id
            LEFT JOIN book_genres bg ON b.isbn = bg.isbn
            LEFT JOIN genres g ON bg.genre_id = g.genre_id
            WHERE b.isbn = $1
            GROUP BY b.isbn, b.title, b.description, b.price, b.stock, b.publication_year, b.publisher, f.name`,
            [isbn]
        );

        if (result.rows.length === 0) {
            throw new Error('Book not found');
        }

        // Obtener imágenes del libro
        const imagesResult = await db.query(
            'SELECT image_id, image_url, alt_text, is_cover FROM book_images WHERE isbn = $1 ORDER BY is_cover DESC, uploaded_at',
            [isbn]
        );

        const book = result.rows[0];
        book.images = imagesResult.rows;

        return {
            success: true,
            book: book
        };
    } catch (error) {
        return {
            success: false,
            error: error.message
        };
    }
}

// Buscar libros por título, descripción o autor
async function searchBooks(searchTerm, minPrice = 0, maxPrice = 999999, page = 1, perPage = 10) {
    try {
        const offset = (page - 1) * perPage;
        const searchPattern = `%${searchTerm}%`;

        const result = await db.query(
            `SELECT 
                DISTINCT b.isbn, b.title, b.description, b.price, b.stock, b.publication_year,
                STRING_AGG(DISTINCT a.name, ', ') as authors,
                COUNT(*) OVER () as total_count
            FROM books b
            LEFT JOIN book_authors ba ON b.isbn = ba.isbn
            LEFT JOIN authors a ON ba.author_id = a.author_id
            WHERE (LOWER(b.title) LIKE LOWER($1) 
                   OR LOWER(b.description) LIKE LOWER($1)
                   OR LOWER(a.name) LIKE LOWER($1))
                  AND b.price BETWEEN $2 AND $3
            GROUP BY b.isbn, b.title, b.description, b.price, b.stock, b.publication_year
            ORDER BY b.title ASC
            LIMIT $4 OFFSET $5`,
            [searchPattern, minPrice, maxPrice, perPage, offset]
        );

        return {
            success: true,
            books: result.rows,
            totalCount: result.rows.length > 0 ? parseInt(result.rows[0].total_count) : 0,
            page: page,
            perPage: perPage
        };
    } catch (error) {
        return {
            success: false,
            error: error.message
        };
    }
}

// Obtener libros disponibles (stock > 0)
async function getAvailableBooks(page = 1, perPage = 10) {
    try {
        const offset = (page - 1) * perPage;

        const result = await db.query(
            `SELECT 
                b.isbn, b.title, b.price, b.stock, b.publication_year,
                STRING_AGG(DISTINCT a.name, ', ') as authors,
                COUNT(*) OVER () as total_count
            FROM books b
            LEFT JOIN book_authors ba ON b.isbn = ba.isbn
            LEFT JOIN authors a ON ba.author_id = a.author_id
            WHERE b.stock > 0
            GROUP BY b.isbn, b.title, b.price, b.stock, b.publication_year
            ORDER BY b.title ASC
            LIMIT $1 OFFSET $2`,
            [perPage, offset]
        );

        return {
            success: true,
            books: result.rows,
            totalCount: result.rows.length > 0 ? parseInt(result.rows[0].total_count) : 0,
            page: page,
            perPage: perPage
        };
    } catch (error) {
        return {
            success: false,
            error: error.message
        };
    }
}

// Crear nuevo libro
async function createBook(isbn, title, description, publicationYear, price, stock, formatId, publisher) {
    try {
        // Validar entrada
        if (!isbn || !title) {
            throw new Error('ISBN and title are required');
        }

        // Validar ISBN único
        const existingBook = await db.query('SELECT isbn FROM books WHERE isbn = $1', [isbn]);
        if (existingBook.rows.length > 0) {
            throw new Error('ISBN already exists');
        }

        // Validar price y stock
        if (price < 0) throw new Error('Price cannot be negative');
        if (stock < 0) throw new Error('Stock cannot be negative');

        const result = await db.query(
            `INSERT INTO books (isbn, title, description, publication_year, price, stock, format_id, publisher)
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
            RETURNING isbn, title, price, stock`,
            [isbn, title, description, publicationYear, price, stock, formatId, publisher]
        );

        return {
            success: true,
            book: result.rows[0]
        };
    } catch (error) {
        return {
            success: false,
            error: error.message
        };
    }
}

// Actualizar libro
async function updateBook(isbn, title, description, publicationYear, price, stock, formatId, publisher) {
    try {
        if (!isbn || !title) {
            throw new Error('ISBN and title are required');
        }

        if (price < 0) throw new Error('Price cannot be negative');
        if (stock < 0) throw new Error('Stock cannot be negative');

        const result = await db.query(
            `UPDATE books 
            SET title = $1, description = $2, publication_year = $3, price = $4, stock = $5, format_id = $6, publisher = $7
            WHERE isbn = $8
            RETURNING isbn, title, price, stock`,
            [title, description, publicationYear, price, stock, formatId, publisher, isbn]
        );

        if (result.rows.length === 0) {
            throw new Error('Book not found');
        }

        return {
            success: true,
            book: result.rows[0]
        };
    } catch (error) {
        return {
            success: false,
            error: error.message
        };
    }
}

// Eliminar libro
async function deleteBook(isbn) {
    try {
        const result = await db.query('DELETE FROM books WHERE isbn = $1 RETURNING isbn', [isbn]);

        if (result.rows.length === 0) {
            throw new Error('Book not found');
        }

        return {
            success: true,
            message: 'Book deleted successfully'
        };
    } catch (error) {
        return {
            success: false,
            error: error.message
        };
    }
}

// Obtener estadísticas del inventario
async function getInventoryStats() {
    try {
        const result = await db.query(
            `SELECT 
                COUNT(*) as total_books,
                SUM(stock) as total_stock,
                COUNT(CASE WHEN stock = 0 THEN 1 END) as out_of_stock_count,
                COUNT(CASE WHEN stock > 0 THEN 1 END) as available_count,
                AVG(price)::DECIMAL(10, 2) as avg_price,
                MIN(price)::DECIMAL(10, 2) as min_price,
                MAX(price)::DECIMAL(10, 2) as max_price
            FROM books`
        );

        return {
            success: true,
            stats: result.rows[0]
        };
    } catch (error) {
        return {
            success: false,
            error: error.message
        };
    }
}

// Obtener autores de un libro
async function getBookAuthors(isbn) {
    try {
        const result = await db.query(
            `SELECT a.author_id, a.name 
            FROM authors a
            INNER JOIN book_authors ba ON a.author_id = ba.author_id
            WHERE ba.isbn = $1
            ORDER BY a.name`,
            [isbn]
        );

        return {
            success: true,
            authors: result.rows
        };
    } catch (error) {
        return {
            success: false,
            error: error.message
        };
    }
}

// Agregar autor a libro
async function addAuthorToBook(isbn, authorId) {
    try {
        const result = await db.query(
            `INSERT INTO book_authors (isbn, author_id) VALUES ($1, $2) RETURNING isbn, author_id`,
            [isbn, authorId]
        );

        return {
            success: true,
            message: 'Author added to book'
        };
    } catch (error) {
        return {
            success: false,
            error: error.message
        };
    }
}

// Obtener géneros de un libro
async function getBookGenres(isbn) {
    try {
        const result = await db.query(
            `SELECT g.genre_id, g.name 
            FROM genres g
            INNER JOIN book_genres bg ON g.genre_id = bg.genre_id
            WHERE bg.isbn = $1
            ORDER BY g.name`,
            [isbn]
        );

        return {
            success: true,
            genres: result.rows
        };
    } catch (error) {
        return {
            success: false,
            error: error.message
        };
    }
}

// Agregar género a libro
async function addGenreToBook(isbn, genreId) {
    try {
        const result = await db.query(
            `INSERT INTO book_genres (isbn, genre_id) VALUES ($1, $2) RETURNING isbn, genre_id`,
            [isbn, genreId]
        );

        return {
            success: true,
            message: 'Genre added to book'
        };
    } catch (error) {
        return {
            success: false,
            error: error.message
        };
    }
}

module.exports = {
    getAllBooks,
    getBookByISBN,
    searchBooks,
    getAvailableBooks,
    createBook,
    updateBook,
    deleteBook,
    getInventoryStats,
    getBookAuthors,
    addAuthorToBook,
    getBookGenres,
    addGenreToBook
};
