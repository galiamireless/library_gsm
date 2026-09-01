# Historial de Prompts de IA - Conversaciones y Refinamientos

Documento que registra las interacciones simuladas entre el desarrollador y la IA durante la iteración y refinamiento del proyecto.

---

## Sesión 1: Inicialización de Proyecto (Enero 10, 2024)

### Prompt 1.1: Arquitectura General
```
User: "Necesito crear una aplicación de gestión de librería con arquitectura monolítica, patrón MVC y base de datos en 4FN. Usa Node.js, Express, PostgreSQL sin ORMs.  Debe tener autenticación, CRUD de libros, gestión de conceptos y validaciones de seguridad (SQL injection, XSS). ¿Por dónde empiezo?"

AI: "Te recomiendo este plan:
    1. Diseño de esquema PostgreSQL en 4FN (eliminar dependencias multivaluadas)
    2. Tablas: users, books (ISBN como PK), authors, genres, book_concepts (especial con definiciones por libro)
    3. Aplicación Node/Express sin REST APIs
    4. Capas: routes → services → config/db (queries parametrizadas)
    5. Vistas EJS server-side renderizadas
    6. Middleware de autenticación y manejo de errores
    
    Estructura:
    config/ → database pool
    middleware/ → auth, upload, error
    services/ → business logic
    routes/ → HTTP handlers
    views/ → EJS templates
    db/ → SQL scripts"

User Response: "Perfecto. Empiezo con el esquema SQL. ¿Qué validaciones mínimas necesito en la tabla users?"

AI: "En tabla users:
    - username: VARCHAR(50) UNIQUE, NOT NULL
    - email: VARCHAR(100) UNIQUE, NOT NULL
    - password_hash: VARCHAR(255), no plaintext
    - role: VARCHAR(20) CHECK IN ('ADMIN', 'USER')
    - is_active: BOOLEAN DEFAULT TRUE
    
    Índice especial para admin único:
    CREATE UNIQUE INDEX idx_unico_admin ON users(role) WHERE role='ADMIN'
    
    Esto previene múltiples admins a nivel BD."

Status: ✓ Confirmado
```

---

## Sesión 2: Diseño de Tablas N:M (Enero 11, 2024)

### Prompt 2.1: Relaciones Book-Authors-Genres
```
User: "¿Cómo modelar un libro con múltiples autores Y múltiples géneros en 4FN?
       Un libro puede tener 3 autores y 2 géneros. ¿Eso genera un Cartesian product
       innecesario si los pongo en una sola tabla?"

AI: "¡Excelente pregunta! Sí, eso es una Dependencia Multivaluada (MVD).

    INCORRECTO (Cartesian product):
    books_flat(isbn, title, author_id, genre_id)
    Libro X con 3 autores + 2 géneros = 3×2 = 6 filas
    
    CORRECTO (4FN):
    books(isbn PRIMARY KEY, title, ...)
    book_authors(isbn FK, author_id FK) - PK compuesta
    book_genres(isbn FK, genre_id FK) - PK compuesta
    authors(author_id PK, name, ...)
    genres(genre_id PK, name, ...)
    
    Ventaja: Mismo libro con 3 autores + 2 géneros = 1 + 3 + 2 = 6 filas TOTAL
    Sin redundancia de datos."

User: "¿Y para conceptos? Cada concepto puede estar en varios libros, pero la 
       definición puede ser DIFERENTE para cada libro (ej: 'Cloud' definido 
       diferente en un libro de AWS vs. Azure)."

AI: "Crear tabla puente con campo definition:

    concepts(concept_id PK, name, description)
    book_concepts(isbn FK, concept_id FK, definition TEXT, PRIMARY KEY(isbn, concept_id))
    
    Ejemplo:
    Concepto 'IaaS' en libro A: 'Infraestructura as a Service: proporciona servidores virtuales'
    Concepto 'IaaS' en libro B: 'Infrastructure as a Service: AWS EC2, Azure VMs, Google Cloud'
    
    Misma definición conceptual, contexto diferente por libro."

Status: ✓ Implementado
```

---

## Sesión 3: Seguridad - SQL Injection Prevention (Enero 12, 2024)

### Prompt 3.1: Parametrizadas vs. Concatenación
```
User: "Tengo un query de búsqueda. ¿Cómo asegurar que sea seguro contra SQL injection?
       
       Actual (MAL):
       const q = \"SELECT * FROM books WHERE title LIKE '%\" + searchTerm + \"%'\"

       ¿Debo usar parámetros?"

AI: "SÍ, SIEMPRE. El código CORRECTO:

    const result = await db.query(
        'SELECT * FROM books WHERE title LIKE $1 OR description LIKE $1',
        ['%' + searchTerm + '%']  // Parámetro separado
    );
    
    Por qué funciona:
    1. Driver pg maneja escaping automáticamente
    2. '%' + searchTerm + '%' se prepara en el cliente
    3. Se envía como parámetro bind, NO como string SQL
    4. BD trata todo como literal (no interpreta SQL)
    
    Ataque bloqueado:
    Input: ' OR '1'='1
    Parámetro: '%' OR '1'='1%'  → Se busca literalmente
    Resultado: Sin coincidencias (búsqueda por literal, no bypass)"

User: "¿Aplica esto a INSERT/UPDATE también?"

AI: "Exactamente. TODO query debe ser parametrizado:

    INSERT: db.query('INSERT INTO users (username, email) VALUES ($1, $2)', [username, email])
    UPDATE: db.query('UPDATE books SET price=$1 WHERE isbn=$2', [newPrice, isbn])
    DELETE: db.query('DELETE FROM books WHERE isbn=$1', [isbn])
    
    Regla oro: Si el valor viene del usuario o URL, DEBE estar en array de parámetros, 
    NUNCA concatenado en string SQL."

Status: ✓ Aplicado en todos los services
```

---

## Sesión 4: Authentication & Sessions (Enero 13, 2024)

### Prompt 4.1: bcrypt vs. Simple Hashing
```
User: "Para hashear contraseñas, ¿uso bcrypt o SHA256?"

AI: "Usa bcrypt. Razón:
    
    SHA256: Rápido (problema) → vulnerable a fuerza bruta
    bcrypt: Lento POR DISEÑO → resiste fuerza bruta
    
    Código:
    const passwordHash = await bcrypt.hash(password, 10);
    // 10 = número de rounds (iterations)
    // Más rounds = más seguro pero más lento
    // 10 es balance recomendado
    
    Verificación:
    const valid = await bcrypt.compare(inputPassword, storedHash);
    
    Beneficio: Incluso si BD se compromete, hashes son inservibles."

User: "¿Sessions en memoria o BD?"

AI: "SIEMPRE en BD para monolito. Código:

    const session = require('express-session');
    const pgSession = require('connect-pg-simple')(session);
    
    app.use(session({
        store: new pgSession({
            pool: db.pool,
            tableName: 'session',
            createTableIfMissing: true
        }),
        secret: process.env.SESSION_SECRET,
        cookie: {
            httpOnly: true,      // No accesible desde JS (XSS protection)
            secure: process.env.NODE_ENV === 'production',  // HTTPS only
            sameSite: 'Lax',     // CSRF protection
            maxAge: 24 * 60 * 60 * 1000  // 24 horas
        }
    }));
    
    Ventajas:
    - Sesión persiste en BD (no se pierde en crash)
    - Revocación fácil (DELETE FROM session)
    - Escalable a múltiples instancias"

Status: ✓ Implementado en app.js
```

---

## Sesión 5: File Upload Security (Enero 14, 2024)

### Prompt 5.1: Validación de Imágenes
```
User: "¿Cómo evitar que alguien suba un archivo .exe disfrazado de imagen?"

AI: "Tres niveles de defensa:

    1. VALIDACIÓN MIME TYPE (lado servidor):
    const fileFilter = (req, file, cb) => {
        const allowedMimes = ['image/jpeg', 'image/png', 'image/webp'];
        if (allowedMimes.includes(file.mimetype)) {
            cb(null, true);
        } else {
            cb(new Error('Invalid file type'));
        }
    };
    
    2. LÍMITE DE TAMAÑO:
    limits: { fileSize: 2 * 1024 * 1024 }  // 2MB máximo
    
    3. RENOMBRAMIENTO SEGURO:
    const uniqueSuffix = Date.now() + '-' + crypto.randomBytes(6).toString('hex');
    filename: (req, file, cb) => {
        const name = file.originalname.split('.')[0];
        cb(null, name + '-' + uniqueSuffix + '.jpg');
    }
    
    Result: portada-1704067200000-a1b2c3d4e5f6.jpg
    
    Previene:
    - Ejecución de scripts (MIME whitelist)
    - Path traversal (nombre seguro)
    - Collision (timestamp + random)"

User: "¿Dónde guardar archivos?"

AI: "/uploads fuera de public/
    
    Serve vía middleware (verificación en cada acceso):
    app.get('/uploads/:filename', (req, res) => {
        // Validar que existe en BD
        // Validar que usuario tiene acceso
        res.sendFile(`./uploads/\${filename}`);
    });
    
    En nginx:
    location /uploads {
        add_header Content-Disposition 'attachment';  // Descarga, no ejecuta
    }"

Status: ✓ Implementado en uploadMiddleware.js
```

---

## Sesión 6: Admin Uniqueness Enforcement (Enero 15, 2024)

### Prompt 6.1: Garantizar un Solo Admin
```
User: "Necesito garantizar que SOLO haya UN admin en el sistema.
       ¿Nivel BD, nivel aplicación, o ambos?"

AI: "AMBOS niveles - Defensa en profundidad:

    NIVEL BD (Garantía absoluta):
    CREATE UNIQUE INDEX idx_unico_admin ON users(role) WHERE role='ADMIN';
    
    Si intentas INSERT/UPDATE con role='ADMIN' y uno ya existe:
    ERROR: duplicate key value violates unique constraint 'idx_unico_admin'
    
    NIVEL APLICACIÓN (Validación temprana):
    // services/authService.js
    async function createAdmin(username, email, password) {
        const existing = await db.query(
            'SELECT COUNT(*) as count FROM users WHERE role = \$1',
            ['ADMIN']
        );
        
        if (existing.rows[0].count > 0) {
            throw new Error('Admin already exists');
        }
        
        // Proceder con creación...
    }
    
    NIVEL TRIGGER (Doble verificación):
    CREATE TRIGGER tg_validate_single_admin
    BEFORE INSERT OR UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION validate_single_admin();
    
    Beneficio: Si alguien (o otro código) intenta bypasear la aplicación,
              la BD sigue protegida."

Status: ✓ Implementado en 3 capas
```

---

## Sesión 7: View Rendering con EJS (Enero 16, 2024)

### Prompt 7.1: XSS Prevention en Templates
```
User: "En las vistas EJS, ¿cómo prevenir XSS cuando muestro datos del usuario?"

AI: "Usa <%= %> para auto-escape (DEFAULT SEGURO):

    SEGURO:
    <h2><%= book.title %></h2>
    <!-- Input: <img onerror='alert()'> -->
    <!-- Output: &lt;img onerror=&#x27;alert()&#x27;&gt; -->
    
    PELIGROSO (EVITAR):
    <h2><%- book.title %></h2>  <!-- <%- sin escape -->
    <!-- Output: <img onerror='alert()'> → EJECUTA JS -->
    
    Regla: <%= para datos, <%- SOLO para HTML controlado
    
    Validación adicional:
    - Sanitizar inputs largos (DOMPurify en cliente)
    - CSP headers (Helmet automático)"

User: "¿Y para atributos HTML?"

AI: "
    <img src=\"<%= imagePath %>\" alt=\"<%= book.title %>\">
    
    <!-- Escapa comillas y caracteres especiales automáticamente -->
    <!-- Previene injection de atributos: \" onload=\"alert() -->
"

Status: ✓ Implementado en todas las vistas
```

---

## Sesión 8: Error Handling sin Exponer Stack (Enero 17, 2024)

### Prompt 8.1: Errores Seguros en Producción
```
User: "¿Cómo mostrar errores al usuario sin exponer stack traces internos?"

AI: "Middleware centralizado:

    // middleware/errorMiddleware.js
    const errorHandler = (err, req, res, next) => {
        const isDev = process.env.NODE_ENV === 'development';
        
        const details = isDev 
            ? err.message + '\\n' + err.stack
            : 'An unexpected error occurred';
        
        const status = err.status || 500;
        
        res.status(status).render('error', {
            error: {
                status,
                message: err.message,
                details
            }
        });
    };
    
    En PRODUCCIÓN:
    - Logs detallados en servidor (no en respuesta HTTP)
    - Usuario ve: 'An unexpected error occurred'
    
    En DESARROLLO:
    - Stack trace visible para debugging
    
    Logging:
    logger.error({
        message: err.message,
        stack: err.stack,
        user_id: req.session?.user?.user_id,
        timestamp: new Date()
    });"

Status: ✓ Implementado
```

---

## Sesión 9: Paginación Eficiente (Enero 18, 2024)

### Prompt 9.1: Query con LIMIT/OFFSET
```
User: "¿Cómo paginar catálogo sin traer todos los registros?"

AI: "LIMIT + OFFSET:

    async function getAllBooks(page = 1, perPage = 10) {
        const offset = (page - 1) * perPage;
        
        const result = await db.query(
            `SELECT * FROM books 
             ORDER BY title ASC
             LIMIT \$1 OFFSET \$2`,
            [perPage, offset]  // $1=LIMIT, $2=OFFSET
        );
        
        // Obtener total para calcular páginas
        const countResult = await db.query(
            'SELECT COUNT(*) as total FROM books'
        );
        
        return {
            books: result.rows,
            totalCount: parseInt(countResult.rows[0].total),
            totalPages: Math.ceil(countResult.rows[0].total / perPage),
            currentPage: page
        };
    }
    
    En vista:
    // pages: 1 | 2 | 3 ... 10 | Next |
    
    Performance:
    - LIMIT 10: Trae solo 10 filas
    - OFFSET 1000000: Sigue rápido con índice
    - Indexado en: ORDER BY column"

Status: ✓ Implementado en bookService
```

---

## Sesión 10: 4FN Explicado (Enero 19, 2024)

### Prompt 10.1: De 0FN a 4FN
```
User: "Estoy confundido. ¿Qué es exactamente 4FN y por qué importa
       para mi librería?"

AI: "Normalización progresiva:

    0FN (NO NORMALIZADO):
    Una sola tabla giant:
    (isbn, title, author1, author2, author3, genre1, genre2, image1, image2)
    
    1FN (Valores atómicos):
    Eliminar repeticiones → authors(id, name), genres(id, name)
    
    2FN (Sin dependencias parciales):
    Si tienes (isbn, author_id) PK, no puede haber (author_id → name)
    
    3FN (Sin dependencias transitivas):
    Si (isbn → title → genre), romper en tablas separadas
    
    4FN (Sin dependencias multivaluadas):
    AQUÍ ESTAMOS TÚ Y YO.
    
    Problem: Libro X con 3 autores Y 2 géneros
    - Si en tabla: (isbn, author, genre) → 3×2 = 6 filas (redundancia)
    - 4FN: (isbn, author) en book_authors (3 filas)
           (isbn, genre) en book_genres (2 filas)
           TOTAL: 1 + 3 + 2 = 6 PERO sin redundancia
    
    Beneficio: Cambiar genre no duplica autores, y viceversa."

Status: ✓ Explicado y documentado
```

---

## Sesión 11: Índices y Performance (Enero 20, 2024)

### Prompt 11.1: Qué Indexar
```
User: "¿Cuáles columnas debo indexar para que las búsquedas sean rápidas?"

AI: "Busca por:
    1. Primarias (PK): isbn
    2. Foreign Keys: author_id, genre_id (importantes para JOINs)
    3. Búsquedas frecuentes: title (con LOWER para case-insensitive)
    4. Filtros: price, stock
    5. Uniqueness: username, email
    
    SQL:
    CREATE INDEX idx_books_title ON books(LOWER(title));
    CREATE INDEX idx_books_price ON books(price);
    CREATE INDEX idx_books_stock ON books(stock);
    CREATE INDEX idx_users_email ON users(email);
    CREATE INDEX idx_users_username ON users(username);
    
    En búsqueda:
    SELECT * FROM books 
    WHERE LOWER(title) LIKE \$1
    AND price BETWEEN \$2 AND \$3
    ORDER BY title ASC
    LIMIT 10;
    
    Usa: idx_books_title para LIKE, después filtra por price.
    
    Verificar plan:
    EXPLAIN ANALYZE SELECT ...
    
    Si ves 'Seq Scan' con filtros, agregar índice."

Status: ✓ Aplicado en schema
```

---

## Sesión 12: Triggers para Auditoría (Enero 21, 2024)

### Prompt 12.1: Registrar Cambios Automáticamente
```
User: "¿Cómo registrar quién cambió qué y cuándo automáticamente?"

AI: "Triggers en BD:

    CREATE TABLE audit_log (
        log_id SERIAL PRIMARY KEY,
        table_name VARCHAR(50),
        operation VARCHAR(10),  -- INSERT, UPDATE, DELETE
        user_id INTEGER,
        changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        old_values JSONB,  -- valores antes
        new_values JSONB   -- valores después
    );
    
    CREATE TRIGGER tg_audit_books
    AFTER INSERT OR UPDATE OR DELETE ON books
    FOR EACH ROW
    EXECUTE FUNCTION audit_log_function();
    
    CREATE OR REPLACE FUNCTION audit_log_function()
    RETURNS TRIGGER AS \$\$
    BEGIN
        INSERT INTO audit_log (table_name, operation, user_id, old_values, new_values)
        VALUES (
            TG_TABLE_NAME,
            TG_OP,
            (SELECT user_id FROM users LIMIT 1),  -- Obtener current user
            row_to_json(OLD),
            row_to_json(NEW)
        );
        RETURN NEW;
    END;
    \$\$ LANGUAGE plpgsql;
    
    Beneficio: Compliance, auditoría, revert cambios accidentales."

Status: ✓ Implementado
```

---

## Resumen de Conversaciones

| Sesión | Tema | Decisión | Implementado |
|--------|------|----------|--------------|
| 1 | Arquitectura General | Monolítica + MVC | ✓ |
| 2 | Tablas N:M | 4FN con puentes | ✓ |
| 3 | SQL Injection | Parametrizadas $N | ✓ |
| 4 | Autenticación | bcrypt + Sessions BD | ✓ |
| 5 | File Upload | MIME + rename + límite | ✓ |
| 6 | Admin Único | 3 niveles (BD+App+Trigger) | ✓ |
| 7 | XSS Prevention | <%= auto-escape | ✓ |
| 8 | Error Handling | Centralizado, no stack | ✓ |
| 9 | Paginación | LIMIT/OFFSET | ✓ |
| 10 | 4FN | 0→1→2→3→4FN | ✓ |
| 11 | Índices | PK, FK, title, price | ✓ |
| 12 | Auditoría | Triggers + audit_log | ✓ |

---

## Conclusión

Estas conversaciones simuladas representan el proceso iterativo de:
1. **Especificación** - Entender requisitos
2. **Diseño** - Arquitectura y schema
3. **Implementación** - Código
4. **Refinamiento** - Seguridad y performance
5. **Validación** - Testing y auditoría

Cada prompt/respuesta fue resuelto en el código y documentación generados.
