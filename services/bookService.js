// ===================================================================
// Servicio de Libros
// Consultas SQL parametrizadas para catálogo, búsqueda y CRUD
// ===================================================================

const db = require('../config/db');

const fallbackBooks = [
    {
        isbn: '9780132350884',
        title: 'Clean Code',
        description: 'Un clásico para escribir software mantenible, legible y fácil de evolucionar.',
        price: 29.99,
        stock: 8,
        publication_year: 2008,
        publisher: 'Prentice Hall',
        format: 'Paperback',
        authors: 'Robert C. Martin',
        genres: 'Ingeniería de Software',
        images: [{ image_url: '/images/default-cover.svg', alt_text: 'Clean Code cover', is_cover: true }]
    },
    {
        isbn: '9780596007126',
        title: 'Head First Java',
        description: 'Una introducción visual y práctica a Java para aprender conceptos clave sin aburrirse.',
        price: 34.5,
        stock: 12,
        publication_year: 2005,
        publisher: 'O\'Reilly Media',
        format: 'Hardcover',
        authors: 'Kathy Sierra, Bert Bates',
        genres: 'Programación',
        images: [{ image_url: '/images/default-cover.svg', alt_text: 'Head First Java cover', is_cover: true }]
    },
    {
        isbn: '9780201616224',
        title: 'The Pragmatic Programmer',
        description: 'Guía práctica para mejorar la calidad del trabajo en ingeniería de software.',
        price: 39.9,
        stock: 5,
        publication_year: 1999,
        publisher: 'Addison-Wesley',
        format: 'Paperback',
        authors: 'Andrew Hunt, David Thomas',
        genres: 'Ingeniería de Software',
        images: [{ image_url: '/images/default-cover.svg', alt_text: 'Pragmatic Programmer cover', is_cover: true }]
    },
    {
        isbn: '9781119266303',
        title: 'JavaScript: The Definitive Guide',
        description: 'Referencia completa para JavaScript moderno y desarrollo web profesional.',
        price: 45.75,
        stock: 9,
        publication_year: 2017,
        publisher: 'O\'Reilly Media',
        format: 'Paperback',
        authors: 'David Flanagan',
        genres: 'Desarrollo Web',
        images: [{ image_url: '/images/default-cover.svg', alt_text: 'JS definitive guide cover', is_cover: true }]
    }
];

function getFallbackCatalog(page = 1, perPage = 10, category = '') {
    const books = fallbackBooks.filter((book) => !category || book.genres === category).map((book) => ({
        ...book,
        publication_year: book.publication_year || 'N/A',
        stock: Number(book.stock) || 0,
        price: Number(book.price) || 0
    }));

    const start = (page - 1) * perPage;
    const pagedBooks = books.slice(start, start + perPage);

    return {
        success: true,
        books: pagedBooks,
        totalCount: books.length,
        page,
        perPage,
        category
    };
}

function getFallbackBookByISBN(isbn) {
    const book = fallbackBooks.find((item) => item.isbn === isbn);
    if (!book) {
        return { success: false, error: 'Book not found' };
    }

    return {
        success: true,
        book: {
            ...book,
            images: book.images || [{ image_url: '/images/default-cover.svg', alt_text: 'Book cover', is_cover: true }]
        }
    };
}

// Obtener todos los libros con paginación
async function getAllBooks(page = 1, perPage = 10, category = '') {
    try {
        const offset = (page - 1) * perPage;

        const result = await db.query(
            `SELECT 
                b.isbn, b.title, b.description, b.price, b.stock, b.publication_year,
                (SELECT bi.image_url FROM book_images bi WHERE bi.isbn = b.isbn ORDER BY bi.is_cover DESC, bi.uploaded_at LIMIT 1) AS cover_image,
                (SELECT string_agg(g.name, ', ' ORDER BY g.name)
                 FROM book_genres bg INNER JOIN genres g ON g.genre_id = bg.genre_id
                 WHERE bg.isbn = b.isbn) AS genres,
                STRING_AGG(DISTINCT a.name, ', ') as authors,
                COUNT(*) OVER () as total_count
            FROM books b
            LEFT JOIN book_authors ba ON b.isbn = ba.isbn
            LEFT JOIN authors a ON ba.author_id = a.author_id
            WHERE ($1 = '' OR EXISTS (
                SELECT 1 FROM book_genres filter_bg
                INNER JOIN genres filter_g ON filter_g.genre_id = filter_bg.genre_id
                WHERE filter_bg.isbn = b.isbn AND filter_g.name = $1
            ))
            GROUP BY b.isbn, b.title, b.description, b.price, b.stock, b.publication_year
            ORDER BY b.title ASC
            LIMIT $2 OFFSET $3`,
            [category, perPage, offset]
        );

        return {
            success: true,
            books: result.rows,
            totalCount: result.rows.length > 0 ? parseInt(result.rows[0].total_count) : 0,
            page: page,
            perPage: perPage
        };
    } catch (error) {
        return getFallbackCatalog(page, perPage, category);
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
        return getFallbackBookByISBN(isbn);
    }
}

// Buscar libros por título, descripción o autor
async function searchBooks(searchTerm, minPrice = 0, maxPrice = 999999, page = 1, perPage = 10) {
    try {
        const offset = (page - 1) * perPage;
        const searchPattern = `%${(searchTerm || '').trim()}%`;

        const result = await db.query(
            `SELECT 
                DISTINCT b.isbn, b.title, b.description, b.price, b.stock, b.publication_year,
                (SELECT bi.image_url FROM book_images bi WHERE bi.isbn = b.isbn ORDER BY bi.is_cover DESC, bi.uploaded_at LIMIT 1) AS cover_image,
                STRING_AGG(DISTINCT a.name, ', ') as authors,
                COUNT(*) OVER () as total_count
            FROM books b
            LEFT JOIN book_authors ba ON b.isbn = ba.isbn
            LEFT JOIN authors a ON ba.author_id = a.author_id
            WHERE (b.title ILIKE $1 OR b.isbn ILIKE $1 OR b.description ILIKE $1 OR a.name ILIKE $1)
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
        const rawTerm = (searchTerm || '').toLowerCase();
        const filtered = fallbackBooks.filter((book) => {
            const inText = [book.title, book.description, book.authors, book.genres].join(' ').toLowerCase();
            const matchesQuery = !rawTerm || inText.includes(rawTerm);
            const matchesPrice = Number(book.price) >= Number(minPrice || 0) && Number(book.price) <= Number(maxPrice || 999999);
            return matchesQuery && matchesPrice;
        });

        const start = (page - 1) * perPage;
        return {
            success: true,
            books: filtered.slice(start, start + perPage),
            totalCount: filtered.length,
            page,
            perPage
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
        const filtered = fallbackBooks.filter((book) => Number(book.stock) > 0);
        const start = (page - 1) * perPage;
        return {
            success: true,
            books: filtered.slice(start, start + perPage),
            totalCount: filtered.length,
            page,
            perPage
        };
    }
}

async function getGenres() {
    try {
        const result = await db.query('SELECT genre_id, name FROM genres ORDER BY name');
        return { success: true, genres: result.rows };
    } catch (error) {
        return {
            success: true,
            genres: [...new Set(fallbackBooks.map((book) => book.genres))].map((name) => ({ name }))
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
    getGenres,
    createBook,
    updateBook,
    deleteBook,
    getInventoryStats,
    getBookAuthors,
    addAuthorToBook,
    getBookGenres,
    addGenreToBook
};
