# Prompt Maestro de IA - Especificación Original de Proyecto

## Documento Original: prompt_inicial.md

Este documento contiene el prompt original (en español) que fue utilizado como especificación maestra para la generación de esta aplicación de gestión de librería.

---

## ANÁLISIS Y DESARROLLO DE APLICACIÓN CON MACROARQUITECTURA MONOLÍTICA, MVC, MODULAR

### OBJETIVO GENERAL

Crear una aplicación web monolítica para la gestión de una librería universitaria que implemente:

1. **Macroarquitectura Monolítica**: Toda la aplicación en una sola unidad de despliegue.
2. **Patrón MVC**: Separación clara entre Modelo (datos), Vista (presentación) y Controlador (lógica).
3. **Arquitectura Modular**: Componentes independientes y reutilizables sin APIs.
4. **Base de Datos 4FN**: Normalización a Cuarta Forma Normal.

---

## REQUISITOS ARQUITECTÓNICOS

### A. Servidor Web

- **Framework**: Node.js con Express.js
- **Templating**: EJS (server-side rendering, sin APIs)
- **Sesiones**: PostgreSQL con express-session
- **Seguridad**: Helmet, CORS controlado, bcrypt para passwords

### B. Base de Datos

- **RDBMS**: PostgreSQL 14+
- **Normalización**: 4FN (Cuarta Forma Normal)
- **ISBN como PK**: Identificador único de libros (no ID surrogate)
- **Admin único**: Índice parcial UNIQUE para garantizar un administrador
- **Driver**: pg (no ORMs permitidos)

### C. Arquitectura

- **Monolítica**: Sin REST APIs, sin microservicios
- **Server-side Rendering**: HTML renderizado en servidor con EJS
- **Modular**: Separación por funcionalidad (routes, services, middleware)
- **Stateless**: Sesiones en BD, no en memoria

### D. Seguridad

- **SQL Injection**: Prevención con consultas parametrizadas ($1, $2...)
- **XSS**: Auto-escaping de EJS
- **CSRF**: SameSite cookies
- **Session Fixation**: HTTP-only, secure cookies
- **Passwords**: Bcrypt con 10 rounds
- **Admin Uniqueness**: Índice único + validación en aplicación

---

## MODELO DE DATOS - ENTIDADES PRINCIPALES

### 1. USUARIOS

```sql
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) DEFAULT 'USER' CHECK (role IN ('ADMIN', 'USER')),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Admin único
CREATE UNIQUE INDEX idx_unico_admin ON users (role) WHERE role = 'ADMIN';
```

### 2. LIBROS (ISBN como PK)

```sql
CREATE TABLE books (
    isbn VARCHAR(20) PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL CHECK (price >= 0),
    stock INTEGER NOT NULL CHECK (stock >= 0),
    publication_year INTEGER,
    publisher VARCHAR(150),
    format_id INTEGER NOT NULL REFERENCES formats(format_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_books_title ON books(LOWER(title));
CREATE INDEX idx_books_price ON books(price);
```

### 3. AUTORES

```sql
CREATE TABLE authors (
    author_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    biography TEXT,
    birth_year INTEGER,
    country VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla N:M
CREATE TABLE book_authors (
    isbn VARCHAR(20) REFERENCES books(isbn) ON DELETE CASCADE,
    author_id INTEGER REFERENCES authors(author_id) ON DELETE CASCADE,
    PRIMARY KEY (isbn, author_id)
);
```

### 4. GÉNEROS

```sql
CREATE TABLE genres (
    genre_id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT
);

-- Tabla N:M
CREATE TABLE book_genres (
    isbn VARCHAR(20) REFERENCES books(isbn) ON DELETE CASCADE,
    genre_id INTEGER REFERENCES genres(genre_id) ON DELETE CASCADE,
    PRIMARY KEY (isbn, genre_id)
);
```

### 5. CONCEPTOS (Especial: definiciones por libro)

```sql
CREATE TABLE concepts (
    concept_id SERIAL PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT
);

-- Tabla N:M con definición específica por libro
CREATE TABLE book_concepts (
    isbn VARCHAR(20) REFERENCES books(isbn) ON DELETE CASCADE,
    concept_id INTEGER REFERENCES concepts(concept_id) ON DELETE CASCADE,
    definition TEXT,  -- Definición específica para este libro
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (isbn, concept_id)
);
```

### 6. IMÁGENES DE LIBROS

```sql
CREATE TABLE book_images (
    image_id SERIAL PRIMARY KEY,
    isbn VARCHAR(20) NOT NULL REFERENCES books(isbn) ON DELETE CASCADE,
    image_url VARCHAR(500) NOT NULL,
    alt_text VARCHAR(255),
    is_cover BOOLEAN DEFAULT FALSE,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

### 7. AUDITORÍA

```sql
CREATE TABLE audit_log (
    log_id SERIAL PRIMARY KEY,
    table_name VARCHAR(50),
    operation VARCHAR(10) CHECK (operation IN ('INSERT', 'UPDATE', 'DELETE')),
    user_id INTEGER REFERENCES users(user_id),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    old_values JSONB,
    new_values JSONB
);
```

### 8. SESIONES

```sql
CREATE TABLE session (
    sid VARCHAR PRIMARY KEY,
    sess JSONB,
    expire TIMESTAMP
);
```

---

## FUNCIONALIDADES REQUERIDAS

### A. Autenticación

- [ ] **Registro de Usuario**: username, email, contraseña (confirmada), nombre completo
- [ ] **Login**: Validación de credenciales, creación de sesión
- [ ] **Logout**: Destrucción de sesión
- [ ] **Admin Único**: Máximo un administrador en el sistema

### B. Catálogo de Libros

- [ ] **Listado Completo**: Paginado (10 por página)
- [ ] **Búsqueda**: Por título, autor, descripción
- [ ] **Filtros**: Rango de precio
- [ ] **Disponibilidad**: Filtro por stock > 0
- [ ] **Detalles**: ISBN, título, año, precio, stock, autores, géneros, conceptos

### C. Administración de Libros (Admin)

- [ ] **Crear Libro**: ISBN único, validaciones
- [ ] **Editar Libro**: Actualizar campos (excepto ISBN)
- [ ] **Eliminar Libro**: Con cascada de dependencias
- [ ] **Gestionar Autores**: Agregar/remover (N:M)
- [ ] **Gestionar Géneros**: Agregar/remover (N:M)
- [ ] **Gestionar Conceptos**: Crear/editar/eliminar con definiciones por libro
- [ ] **Subir Imágenes**: Formato JPEG/PNG/WebP, máximo 2MB

### D. Estadísticas y Reportes

- [ ] **Dashboard Admin**: Total libros, stock total, disponibles, agotados
- [ ] **Análisis de Precios**: Promedio, mínimo, máximo
- [ ] **Vistas de Agregación**: Libros por autor, por género

---

## ESTRUCTURA DE DIRECTORIOS

```
E2/library/
├── config/
│   └── db.js                    # Configuración de pool PostgreSQL
├── middleware/
│   ├── authMiddleware.js        # Autenticación y autorización
│   ├── uploadMiddleware.js      # Manejo de cargas de archivo
│   └── errorMiddleware.js       # Manejo de errores
├── services/
│   ├── authService.js           # Lógica de autenticación
│   ├── bookService.js           # Lógica de libros
│   └── conceptService.js        # Lógica de conceptos
├── routes/
│   ├── authRoutes.js            # Rutas de autenticación
│   ├── bookRoutes.js            # Rutas de catálogo
│   ├── adminRoutes.js           # Rutas administrativas
│   └── conceptRoutes.js         # Rutas de conceptos
├── views/
│   ├── layout.ejs               # Template maestro
│   ├── partials/
│   │   └── navbar.ejs           # Barra de navegación
│   ├── auth/
│   │   ├── login.ejs
│   │   └── register.ejs
│   ├── books/
│   │   ├── catalog.ejs
│   │   ├── search.ejs
│   │   └── detail.ejs
│   ├── admin/
│   │   ├── dashboard.ejs
│   │   ├── book_form.ejs
│   │   ├── images_list.ejs
│   │   ├── manage_authors.ejs
│   │   ├── manage_genres.ejs
│   │   └── manage_concepts.ejs
│   └── error.ejs
├── public/
│   ├── css/
│   │   └── styles.css           # Estilos personalizados
│   └── js/
│       └── script.js            # Validación cliente
├── uploads/                     # Imágenes subidas
├── db/
│   ├── 00_create_database.sql   # Crear BD
│   ├── 01_schema.sql            # Tablas y esquema
│   ├── 02_seed_30_per_table.sql # Datos de prueba (30+ registros)
│   ├── 03_all_queries.sql       # Ejemplos de queries parametrizadas
│   ├── 04_stored_procedures.sql # Procedimientos almacenados
│   ├── 05_triggers.sql          # Triggers para auditoría
│   └── 06_views.sql             # Vistas para reportes
├── docs/
│   ├── REQUIREMENTS.md          # Requisitos funcionales/no-funcionales
│   ├── ARCHITECTURE_MONOLITHIC.md # Diagrama de arquitectura
│   ├── ENGINEERING_DECISIONS.md # ADRs (Architectural Decision Records)
│   ├── NORMALIZATION_4FN.md     # Justificación de 4FN
│   ├── GCP_COMMANDS.md          # Comandos para despliegue en GCP
│   ├── SECURITY_REVIEW.md       # Matriz de seguridad OWASP
│   ├── TEST_PLAN.md             # Casos de prueba (75+)
│   ├── PROMPT_MAESTRO_IA.md     # Este documento
│   ├── AI_PROMPT_HISTORY.md     # Historial de prompts IA
│   └── AI_CHANGELOG.md          # Changelog de cambios IA
├── app.js                       # Aplicación principal Express
├── package.json                 # Dependencias Node.js
├── .env.example                 # Template de variables de entorno
└── README.md                    # Documentación general
```

---

## RESTRICCIONES TÉCNICAS

1. ✓ **NO APIs REST**: Todo server-side rendering con EJS
2. ✓ **NO ORMs**: SQL parametrizado puro con driver pg
3. ✓ **NO Microservicios**: Una sola aplicación monolítica
4. ✓ **4FN Obligatorio**: Todas las dependencias multivaluadas separadas
5. ✓ **ISBN como PK**: No ID numérico en tabla books
6. ✓ **Admin Único**: Enforced en BD (índice) + aplicación
7. ✓ **Queries Parametrizadas**: $1, $2, $3... en TODO código SQL
8. ✓ **PostgreSQL**: No MySQL, no SQLite
9. ✓ **bcrypt**: No MD5, SHA1, o hashing simple
10. ✓ **EJS Server-side**: No React, Vue, o SPA

---

## DATOS DE SEMILLA MÍNIMOS

- **Usuarios**: 1 admin + 9 usuarios regulares
- **Libros**: 21+ libros (incluyendo "Cloud Computing Comprehensive Guide")
- **Autores**: 25+ autores
- **Géneros**: 15+ géneros
- **Formatos**: 4 formatos (Hardcover, Paperback, E-book, Audiobook)
- **Conceptos**: 10+ conceptos (IaaS, PaaS, SaaS, FaaS, etc.)
- **Asociaciones**: Book_authors (50+), book_genres (40+), book_concepts (10+)

---

## VALIDACIONES REQUERIDAS

### Frontend (Punto de entrada)
- Username: 3-50 caracteres, alfanuméricos
- Email: Formato válido
- Password: Mínimo 6 caracteres
- Precio: Decimal positivo
- Stock: Entero no negativo
- ISBN: Formato validado

### Backend (Garantía)
- Todos los validaciones repetidas en servidor
- Queries parametrizadas sin excepciones
- Constraints de BD para integridad

---

## CONSIDERACIONES DE PERFORMANCE

1. **Connection Pooling**: min=2, max=10
2. **Índices**: En isbn, title, email, price
3. **Paginación**: Máximo 10-20 registros por página
4. **Lazy Loading**: No traer relacionados innecesariamente
5. **Vistas Materializadas**: Para reportes complejos

---

## SEGURIDAD REQUERIDA

1. **SQL Injection**: Parametrizadas ($1, $2...)
2. **XSS**: Auto-escape EJS
3. **CSRF**: SameSite=Lax
4. **Authentication**: Sessions en BD
5. **Authorization**: Middleware isAdmin
6. **Password Hashing**: bcrypt (10 rounds)
7. **File Upload**: MIME whitelist, size limit, secure naming
8. **Error Handling**: No stack traces en producción
9. **HTTPS**: En producción
10. **Environment Variables**: .env no en control de versiones

---

## ENTREGABLES

1. ✅ Código fuente completo funcional
2. ✅ Esquema SQL completo (4FN)
3. ✅ Datos de semilla (30+ por tabla)
4. ✅ Documentación de arquitectura
5. ✅ Matriz de decisiones de ingeniería
6. ✅ Matriz de seguridad OWASP
7. ✅ Plan de pruebas (75+ casos)
8. ✅ Comandos de despliegue en GCP
9. ✅ Historial de cambios IA
10. ✅ README de proyecto

---

## NOTAS FINALES

- Énfasis en **arquitectura limpia** y **separación de concerns**
- **Documentación técnica** de nivel profesional
- **Cumplimiento estricto** de restricciones (sin APIs, sin ORMs)
- **Seguridad by design** (no como afterthought)
- **Código educativo** que demuestre mejores prácticas
- **Listo para producción** (con ajustes de .env)

---

## Historial de Referencia

Este prompt fue utilizado como especificación maestra para:
- Generación de arquitectura monolítica
- Diseño de base de datos 4FN
- Implementación de capas (routes, services, middleware)
- Creación de templates EJS
- Documentación técnica completa
- Plan de pruebas integral
- Directrices de seguridad OWASP
- Procedimientos de despliegue en GCP

**Versión**: 1.0  
**Fecha**: Enero 2024  
**Estatus**: Completado según especificación
