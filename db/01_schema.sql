-- ===================================================================
-- SCRIPT 01: Esquema de Base de Datos en 4FN
-- Entidad Libro con ISBN como Primary Key
-- Relaciones N:M para Autores, Géneros, Conceptos e Imágenes
-- ===================================================================

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(150),
    role VARCHAR(20) NOT NULL DEFAULT 'USER' CHECK (role IN ('ADMIN', 'USER')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE UNIQUE INDEX idx_unico_admin ON users (role) WHERE role = 'ADMIN';

CREATE TABLE authors (
    author_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    biography TEXT,
    birth_year INTEGER,
    country VARCHAR(100),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE genres (
    genre_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE formats (
    format_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE concepts (
    concept_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE books (
    isbn VARCHAR(20) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    publication_year INTEGER,
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    stock INTEGER NOT NULL CHECK (stock >= 0),
    format_id INTEGER REFERENCES formats(format_id),
    format_type VARCHAR(20) NOT NULL DEFAULT 'PHYSICAL' CHECK (format_type IN ('PHYSICAL', 'DIGITAL')),
    digital_format VARCHAR(10) CHECK (digital_format IN ('PDF', 'EPUB')),
    publisher VARCHAR(150),
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT ck_book_format_validity CHECK (
        (format_type = 'PHYSICAL' AND digital_format IS NULL)
        OR (format_type = 'DIGITAL' AND digital_format IN ('PDF', 'EPUB'))
    )
);

CREATE TABLE book_authors (
    isbn VARCHAR(20) REFERENCES books(isbn) ON DELETE CASCADE,
    author_id INTEGER REFERENCES authors(author_id) ON DELETE CASCADE,
    PRIMARY KEY (isbn, author_id)
);

CREATE TABLE book_genres (
    isbn VARCHAR(20) REFERENCES books(isbn) ON DELETE CASCADE,
    genre_id INTEGER REFERENCES genres(genre_id) ON DELETE CASCADE,
    PRIMARY KEY (isbn, genre_id)
);

CREATE TABLE book_concepts (
    isbn VARCHAR(20) REFERENCES books(isbn) ON DELETE CASCADE,
    concept_id INTEGER REFERENCES concepts(concept_id) ON DELETE CASCADE,
    definition TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (isbn, concept_id)
);

CREATE TABLE book_images (
    image_id SERIAL PRIMARY KEY,
    isbn VARCHAR(20) REFERENCES books(isbn) ON DELETE CASCADE,
    image_url VARCHAR(500) NOT NULL,
    alt_text VARCHAR(255),
    is_cover BOOLEAN NOT NULL DEFAULT FALSE,
    source_type VARCHAR(20) NOT NULL DEFAULT 'upload' CHECK (source_type IN ('upload', 'url')),
    source_url VARCHAR(500),
    original_filename VARCHAR(255),
    stored_filename VARCHAR(255),
    mime_type VARCHAR(50),
    file_size_bytes INTEGER NOT NULL DEFAULT 0,
    uploaded_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE audit_log (
    log_id SERIAL PRIMARY KEY,
    table_name VARCHAR(100),
    operation VARCHAR(10) CHECK (operation IN ('INSERT', 'UPDATE', 'DELETE')),
    user_id INTEGER REFERENCES users(user_id),
    changed_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    old_values JSONB,
    new_values JSONB
);

CREATE TABLE session (
    sid VARCHAR(255) PRIMARY KEY,
    sess JSONB NOT NULL,
    expire TIMESTAMPTZ NOT NULL
);

CREATE INDEX idx_books_title ON books(title);
CREATE INDEX idx_books_publication_year ON books(publication_year);
CREATE INDEX idx_books_price ON books(price);
CREATE INDEX idx_authors_name ON authors(name);
CREATE INDEX idx_genres_name ON genres(name);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_book_images_isbn ON book_images(isbn);
CREATE INDEX idx_book_authors_author_id ON book_authors(author_id);
CREATE INDEX idx_book_genres_genre_id ON book_genres(genre_id);
CREATE INDEX idx_book_concepts_concept_id ON book_concepts(concept_id);
CREATE INDEX idx_session_expire ON session(expire);

COMMENT ON TABLE books IS 'Entidad principal: Libros. ISBN como Primary Key.';
COMMENT ON TABLE book_authors IS 'Relación N:M entre libros y autores (4FN).';
COMMENT ON TABLE book_genres IS 'Relación N:M entre libros y géneros (4FN).';
COMMENT ON TABLE book_concepts IS 'Relación N:M con definiciones específicas por libro.';
COMMENT ON TABLE book_images IS 'Imágenes y portadas de libros.';
COMMENT ON COLUMN users.role IS 'Rol del usuario: ADMIN o USER. Solo un ADMIN permitido.';
COMMENT ON COLUMN book_concepts.definition IS 'Definición específica del concepto dentro del contexto del libro.';

GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO lib_gsm_user;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO lib_gsm_user;
