# Normalización a Cuarta Forma Normal (4FN)

## Introducción

Este documento detalla el proceso de normalización de la base de datos de la librería desde 0FN (sin normalizar) hasta 4FN (cuarta forma normal), asegurando eliminación de dependencias multivaluadas y redundancia de datos.

## Entidades Iniciales (0FN - Desnormalizado)

```
LIBRO_COMPLETO(
    ISBN,
    Título,
    Descripción,
    Año_Publicación,
    Precio,
    Stock,
    Formato,
    Editorial,
    Autor_1,
    Autor_2,
    Autor_3,
    Género_1,
    Género_2,
    Imagen_1,
    Imagen_2,
    Imagen_3,
    Concepto_1,
    Definición_1,
    Concepto_2,
    Definición_2
)
```

**Problemas**: Anomalías de inserción, actualización y eliminación. Redundancia masiva. Imposible agregar nuevo autor sin duplicar todo el registro.

---

## Primera Forma Normal (1FN)

**Definición**: Todos los atributos contienen valores atómicos (no repetiéndose).

### Transformación 0FN → 1FN

Se eliminan grupos repetitivos creando tablas separadas:

```sql
CREATE TABLE books (
    isbn VARCHAR(20) PRIMARY KEY,
    title VARCHAR(255),
    description TEXT,
    publication_year INTEGER,
    price DECIMAL(10,2),
    stock INTEGER,
    publisher VARCHAR(150)
);

CREATE TABLE formats (
    format_id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE
);

CREATE TABLE authors (
    author_id SERIAL PRIMARY KEY,
    name VARCHAR(150)
);

CREATE TABLE book_authors (
    isbn VARCHAR(20) REFERENCES books(isbn),
    author_id INTEGER REFERENCES authors(author_id),
    PRIMARY KEY (isbn, author_id)
);

CREATE TABLE genres (
    genre_id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE
);

CREATE TABLE book_genres (
    isbn VARCHAR(20) REFERENCES books(isbn),
    genre_id INTEGER REFERENCES genres(genre_id),
    PRIMARY KEY (isbn, genre_id)
);

CREATE TABLE book_images (
    image_id SERIAL PRIMARY KEY,
    isbn VARCHAR(20) REFERENCES books(isbn),
    image_url VARCHAR(500),
    alt_text VARCHAR(255)
);

CREATE TABLE concepts (
    concept_id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE
);

CREATE TABLE book_concepts (
    isbn VARCHAR(20) REFERENCES books(isbn),
    concept_id INTEGER REFERENCES concepts(concept_id),
    definition TEXT,
    PRIMARY KEY (isbn, concept_id)
);
```

**Logro 1FN**: ✓ Todos los atributos son atómicos.

**Anomalías restantes**:
- Dependencias funcionales parciales en book_authors y book_genres (PK compuesta).

---

## Segunda Forma Normal (2FN)

**Definición**: Está en 1FN + Cada atributo no-clave depende funcionalmente de TODA la clave primaria (no de parte de ella).

### Evaluación 1FN → 2FN

En `book_authors (isbn, author_id)`:
- Clave primaria: (isbn, author_id)
- Todos los atributos son parte de la clave → **Ya está en 2FN**

No hay atributos no-clave que dependan parcialmente de la PK en nuestro esquema.

**Logro 2FN**: ✓ No existen dependencias funcionales parciales.

**Anomalías restantes**:
- Dependencias transitivas en books (ej: formato está separado pero podría relacionarse indirectamente).

---

## Tercera Forma Normal (3FN)

**Definición**: Está en 2FN + Ningún atributo no-clave depende transitivamente de la clave primaria.

### Evaluación 2FN → 3FN

En tabla `books (isbn, title, ..., publisher)`:
- isbn → title, description, ..., publisher (dependencia directa de PK)
- No hay dependencia transitiva: publisher no depende de otro atributo no-clave.

En tabla `formats (format_id, name)`:
- format_id → name (dependencia directa)
- 3FN ✓

En tablas puente (book_authors, book_genres, book_concepts):
- Compuestas solo de FK y atributos de definición.
- 3FN ✓

**Logro 3FN**: ✓ No existen dependencias transitivas.

**Anomalías restantes**:
- **Dependencias Multivaluadas (MVD)**: Un libro tiene múltiples autores Y múltiples géneros INDEPENDIENTEMENTE uno del otro.
  - Generar Cartesian Product innecesario.
  - Ejemplo: Libro con 3 autores y 2 géneros = 6 combinaciones posibles en JOIN.

---

## Cuarta Forma Normal (4FN)

**Definición**: Está en 3FN + No existen dependencias multivaluadas no triviales.

### Problema de MVD en 3FN

Si pudiéramos almacenar en una sola tabla:
```
books_flat (isbn, title, author, genre, image, concept, definition)
```

Insertar libro "Cloud Computing" con 1 autor, 2 géneros, 1 imagen, 10 conceptos:
- Generaría 1 × 2 × 1 × 10 = 20 filas innecesarias
- Redundancia de datos
- Anomalías de actualización

### Transformación 3FN → 4FN

La solución es **descomponer en proyecciones independientes**:

```sql
-- Proyección 1: Libro con sus autores
SELECT isbn, title, author_id FROM books
INNER JOIN book_authors USING (isbn)

-- Proyección 2: Libro con sus géneros (independiente de autores)
SELECT isbn, title, genre_id FROM books
INNER JOIN book_genres USING (isbn)

-- Proyección 3: Libro con sus imágenes (independiente de autores y géneros)
SELECT isbn, image_id, image_url FROM books
INNER JOIN book_images USING (isbn)

-- Proyección 4: Libro con conceptos y definiciones
SELECT isbn, concept_id, definition FROM books
INNER JOIN book_concepts USING (isbn)
```

Cada MVD está en su propia tabla puente.

**Logro 4FN**: ✓ Dependencias multivaluadas eliminadas.

### Estructura Final 4FN

```
┌─────────────────┐
│      books      │ (PK: isbn)
│─────────────────│
│ isbn (PK)       │
│ title           │
│ description     │
│ price           │
│ stock           │
│ pub_year        │
│ publisher       │
│ format_id (FK)  │
└─────────────────┘
        │
        ├──→ ┌──────────────┐
        │    │   formats    │
        │    └──────────────┘
        │
        ├──→ ┌─────────────────────┐
        │    │  book_authors (N:M) │ ← MVD 1: Autores
        │    └─────────────────────┘
        │           │
        │           └──→ ┌──────────┐
        │                │ authors  │
        │                └──────────┘
        │
        ├──→ ┌────────────────────┐
        │    │  book_genres (N:M) │ ← MVD 2: Géneros (indep. de autores)
        │    └────────────────────┘
        │           │
        │           └──→ ┌────────┐
        │                │ genres │
        │                └────────┘
        │
        ├──→ ┌──────────────────────┐
        │    │   book_images (1:N)  │ ← MVD 3: Imágenes (indep. de autores/géneros)
        │    └──────────────────────┘
        │
        └──→ ┌─────────────────────────────┐
             │ book_concepts (N:M, especial)│ ← MVD 4: Conceptos con definiciones
             └─────────────────────────────┘
                     │
                     └──→ ┌──────────┐
                          │ concepts │
                          └──────────┘
```

---

## Beneficios de 4FN

| Aspecto | Beneficio |
|--------|-----------|
| **Integridad** | Imposible tener combinaciones cartesianas incorrectas |
| **Redundancia** | Mínima duplicación de datos |
| **Consultas** | JOINs explícitos y controlados |
| **Mantenimiento** | Cambios en autores no afectan géneros |
| **Flexibilidad** | Fácil agregar nuevas MVD |
| **Performance** | Índices claros en PK/FK de tablas puente |

---

## Ejemplo de Operaciones en 4FN

### Insertar Libro "Cloud Computing" con 1 autor, 2 géneros, 3 imágenes, 10 conceptos

```sql
-- 1. Insertar libro base
INSERT INTO books VALUES ('978-0-13-521329-4', 'Cloud Computing', ...);

-- 2. Agregar autor (1 fila)
INSERT INTO book_authors VALUES ('978-0-13-521329-4', 21);

-- 3. Agregar géneros (2 filas - independiente de autores)
INSERT INTO book_genres VALUES 
  ('978-0-13-521329-4', 10),
  ('978-0-13-521329-4', 3);

-- 4. Agregar imágenes (3 filas)
INSERT INTO book_images VALUES
  ('978-0-13-521329-4', '/uploads/img1.jpg', ...),
  ('978-0-13-521329-4', '/uploads/img2.jpg', ...),
  ('978-0-13-521329-4', '/uploads/img3.jpg', ...);

-- 5. Agregar conceptos (10 filas con definiciones específicas)
INSERT INTO book_concepts VALUES
  ('978-0-13-521329-4', 1, 'IaaS: Infraestructure as a Service...'),
  ('978-0-13-521329-4', 2, 'PaaS: Platform as a Service...'),
  ...
  ('978-0-13-521329-4', 10, 'Serverless: Arquitectura sin servidores...');
```

**Total de filas insertadas**: 1 + 1 + 2 + 3 + 10 = **17 filas**
(vs. 1 × 1 × 2 × 3 × 10 = **60 filas** en Cartesian product)

---

## Verificación de 4FN

✓ Todos los atributos son atómicos (1FN)
✓ No hay dependencias parciales (2FN)
✓ No hay dependencias transitivas (3FN)
✓ Cada MVD está en su propia tabla puente (4FN)

**Conclusión**: Esquema en **4FN** completamente normalizado.

---

## Referencias

- Codd, E.F. (1970). "A Relational Model of Data for Large Shared Data Banks"
- Date, C.J. (2003). "An Introduction to Database Systems" (8th Edition)
- Garcia-Molina, Ullman, Widom. "Database Systems: The Complete Book" (2nd Edition)
