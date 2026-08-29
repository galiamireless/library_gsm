# Arquitectura Monolítica de la Aplicación de Gestión de Librería

## Diagrama de Arquitectura de Alto Nivel

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         USUARIO / NAVEGADOR                             │
│                    (HTTP/HTTPS Request-Response)                        │
└────────────────────────────────┬────────────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                    CAPA DE PRESENTACIÓN (CLIENT)                        │
├─────────────────────────────────────────────────────────────────────────┤
│  HTML/CSS/JS                                                             │
│  ├── HTML: Generado por EJS en servidor                                │
│  ├── CSS: Bootstrap 5 CDN + /css/styles.css (custom)                  │
│  └── JS: Validación cliente + jQuery (opcional)                        │
└────────────────────────────────┬────────────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────────────┐
│              EXPRESS.JS SERVER (MONOLÍTICO - app.js)                    │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  ┌──────────────────────────────────────────────────────────────────┐  │
│  │                   CAPA DE MIDDLEWARE                             │  │
│  ├──────────────────────────────────────────────────────────────────┤  │
│  │  ✓ helmet()                - HTTP security headers              │  │
│  │  ✓ cors()                  - Cross-origin validation            │  │
│  │  ✓ morgan()                - Request logging                    │  │
│  │  ✓ express.urlencoded()    - Form body parsing                 │  │
│  │  ✓ express.json()          - JSON body parsing                 │  │
│  │  ✓ express-session         - Session management + PostgreSQL   │  │
│  │  ✓ attachUserToLocals()    - User context injection            │  │
│  │  ✓ errorMiddleware         - Centralized error handling        │  │
│  └──────────────────────────────────────────────────────────────────┘  │
│                                 │                                        │
│                                 ▼                                        │
│  ┌──────────────────────────────────────────────────────────────────┐  │
│  │                   CAPA DE ROUTING                                │  │
│  ├──────────────────────────────────────────────────────────────────┤  │
│  │  /auth/login              → authRoutes (POST)                   │  │
│  │  /auth/register           → authRoutes (POST)                   │  │
│  │  /auth/logout             → authRoutes (GET)                    │  │
│  │  /books/catalog           → bookRoutes (paginación)             │  │
│  │  /books/search            → bookRoutes (búsqueda)               │  │
│  │  /books/detail/:isbn      → bookRoutes (detalle)                │  │
│  │  /books/available         → bookRoutes (disponibles)            │  │
│  │  /admin/dashboard         → adminRoutes (isAdmin)               │  │
│  │  /admin/books/*           → adminRoutes (CRUD libros)           │  │
│  │  /admin/images/*          → adminRoutes (gestión imágenes)      │  │
│  │  /concepts/*              → conceptRoutes (conceptos)           │  │
│  │  /health                  → Health check JSON                   │  │
│  └──────────────────────────────────────────────────────────────────┘  │
│                                 │                                        │
│                                 ▼                                        │
│  ┌──────────────────────────────────────────────────────────────────┐  │
│  │                   CAPA DE CONTROLADOR / RUTAS                    │  │
│  ├──────────────────────────────────────────────────────────────────┤  │
│  │  routes/authRoutes.js         → Controllers de autenticación     │  │
│  │  routes/bookRoutes.js         → Controllers de catálogo         │  │
│  │  routes/adminRoutes.js        → Controllers administrativos     │  │
│  │  routes/conceptRoutes.js      → Controllers de conceptos        │  │
│  │                                                                  │  │
│  │  Responsabilidades:                                             │  │
│  │  • Recibir request HTTP                                         │  │
│  │  • Validar parámetros                                           │  │
│  │  • Llamar servicios                                             │  │
│  │  • Renderizar respuesta (HTML o JSON)                           │  │
│  └──────────────────────────────────────────────────────────────────┘  │
│                                 │                                        │
│                                 ▼                                        │
│  ┌──────────────────────────────────────────────────────────────────┐  │
│  │                   CAPA DE NEGOCIO (SERVICES)                     │  │
│  ├──────────────────────────────────────────────────────────────────┤  │
│  │  services/authService.js      → Lógica de autenticación        │  │
│  │  ├── registerUser()            - Validar, hash, crear usuario   │  │
│  │  ├── loginUser()               - Verificar credenciales         │  │
│  │  ├── hashPassword()            - Bcrypt hashing                 │  │
│  │  ├── verifyPassword()          - Bcrypt compare                 │  │
│  │  └── createAdmin()             - Enforce admin único            │  │
│  │                                                                  │  │
│  │  services/bookService.js      → Lógica de catálogo             │  │
│  │  ├── getAllBooks()             - Listar con paginación         │  │
│  │  ├── searchBooks()             - Búsqueda avanzada             │  │
│  │  ├── getBookByISBN()           - Detalle con relaciones        │  │
│  │  ├── createBook()              - Validar e insertar            │  │
│  │  ├── updateBook()              - Editar libro                  │  │
│  │  ├── deleteBook()              - Eliminar con cascada          │  │
│  │  └── getInventoryStats()       - Estadísticas                  │  │
│  │                                                                  │  │
│  │  services/conceptService.js   → Lógica de conceptos            │  │
│  │  ├── getAllConcepts()          - Listar conceptos              │  │
│  │  ├── getBookConcepts()         - Conceptos por libro           │  │
│  │  ├── addConceptToBook()        - Agregar con definición        │  │
│  │  └── updateBookConceptDefinition() - Editar definición         │  │
│  │                                                                  │  │
│  │  Características:                                               │  │
│  │  • Lógica de negocio centralizada                               │  │
│  │  • Acceso a datos vía queries SQL parametrizadas                │  │
│  │  • Validaciones de datos                                        │  │
│  │  • Manejo de excepciones                                        │  │
│  └──────────────────────────────────────────────────────────────────┘  │
│                                 │                                        │
│                                 ▼                                        │
│  ┌──────────────────────────────────────────────────────────────────┐  │
│  │                   CAPA DE DATOS (DATA ACCESS)                    │  │
│  ├──────────────────────────────────────────────────────────────────┤  │
│  │  config/db.js             → Pool de conexiones PostgreSQL       │  │
│  │  ├── pg.Pool()            - Conexiones reutilizables            │  │
│  │  │   ├── min: 2           - Mínimas conexiones                  │  │
│  │  │   └── max: 10          - Máximas conexiones                  │  │
│  │  ├── query()              - Ejecutar SQL parametrizado          │  │
│  │  └── closePool()          - Cierre graceful                     │  │
│  │                                                                  │  │
│  │  Características:                                               │  │
│  │  • Parámetros SQL ($1, $2...) previenen inyección              │  │
│  │  • Connection pooling para eficiencia                           │  │
│  │  • Manejo de errores y retry logic                              │  │
│  └──────────────────────────────────────────────────────────────────┘  │
│                                                                          │
└──────────────────────────────────┬───────────────────────────────────────┘
                                   │
                                   ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                        PostgreSQL DATABASE                              │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  TABLAS (11):                                                          │
│  ├── users              (user_id, username, email, password_hash)      │
│  ├── books              (isbn PRIMARY KEY, title, price, stock)        │
│  ├── formats            (format_id, name)                              │
│  ├── authors            (author_id, name, biography)                   │
│  ├── genres             (genre_id, name)                               │
│  ├── book_authors       (N:M bridge table)                             │
│  ├── book_genres        (N:M bridge table)                             │
│  ├── book_images        (image_id, isbn FK, image_url)                │
│  ├── concepts           (concept_id, name)                             │
│  ├── book_concepts      (N:M bridge, definición especial)             │
│  ├── audit_log          (Registro de cambios)                          │
│  └── session            (Sessions de express-session)                  │
│                                                                         │
│  CARACTERÍSTICAS:                                                       │
│  ✓ 4FN Normalization   - Eliminación de MVD                            │
│  ✓ Foreign Keys        - Integridad referencial                        │
│  ✓ Unique Constraints  - ISBN, username, email                         │
│  ✓ Check Constraints   - price>=0, stock>=0                            │
│  ✓ Triggers            - Auditoría, timestamps                         │
│  ✓ Stored Procedures   - Lógica de negocio en BD                      │
│  ✓ Views               - Reportes y agregaciones                       │
│  ✓ Partial Index       - Admin único (UNIQUE WHERE role='ADMIN')      │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Flujo de Datos - Ejemplo: Búsqueda de Libros

```
1. USUARIO escribe en form de búsqueda
                │
                ▼
2. NAVEGADOR envía GET /books/search?q=Cloud&minPrice=10&maxPrice=50
                │
                ▼
3. EXPRESS.JS recibe request
                │
                ├─ morgan() → log acceso
                ├─ cors() → validar origen
                └─ errorHandler() → try/catch
                │
                ▼
4. bookRoutes.js (GET /books/search)
                │
                ├─ Leer query params
                ├─ Validar searchTerm (no null)
                └─ Llamar service
                │
                ▼
5. bookService.js → searchBooks(term, minPrice, maxPrice, page)
                │
                ├─ Validar parámetros
                ├─ Construir SQL con LIKE y BETWEEN
                └─ Llamar config/db.query()
                │
                ▼
6. config/db.js → query(sql, [term, minPrice, maxPrice, page])
                │
                ├─ Obtener conexión de pool
                ├─ Parámetros ya separados ($1, $2, $3)
                └─ Ejecutar query en PostgreSQL
                │
                ▼
7. PostgreSQL ejecuta:
   SELECT * FROM books WHERE LOWER(title) LIKE LOWER($1)
   AND price BETWEEN $2 AND $3 LIMIT 10 OFFSET ($4-1)*10
   Parámetros: ['%cloud%', 10, 50, 1]
                │
                ▼
8. PostgreSQL retorna resultado (array de rows)
                │
                ▼
9. bookService.js recibe result.rows
                │
                ├─ Procesar datos
                ├─ Calcular paginación
                └─ Retornar {success: true, books, totalCount}
                │
                ▼
10. bookRoutes.js recibe respuesta
                │
                ├─ Renderizar vista EJS: views/books/search.ejs
                ├─ Pasar contexto: {books, totalCount, searchTerm}
                ├─ EJS genera HTML dinámico
                └─ Enviar respuesta HTTP
                │
                ▼
11. NAVEGADOR recibe HTML renderizado
                │
                ├─ CSS Bootstrap (CDN)
                ├─ JS validación
                └─ Muestra resultados al usuario
                │
                ▼
12. USUARIO ve resultados de búsqueda
```

---

## Componentes Clave

### 1. CAPA DE PRESENTACIÓN (Views)

**Arquitectura EJS Jerárquica**:
```
views/
├── layout.ejs                   ← Template maestro (DOCTYPE, head, body)
├── partials/
│   └── navbar.ejs               ← Navigation bar reutilizable
├── auth/
│   ├── login.ejs                ← Formulario login
│   └── register.ejs             ← Formulario registro
├── books/
│   ├── catalog.ejs              ← Listado paginado
│   ├── search.ejs               ← Búsqueda avanzada
│   └── detail.ejs               ← Detalle con conceptos
├── admin/
│   ├── dashboard.ejs            ← Estadísticas
│   ├── book_form.ejs            ← Crear/editar libro
│   ├── images_list.ejs          ← Gestión de imágenes
│   ├── manage_authors.ejs       ← Autores N:M
│   ├── manage_genres.ejs        ← Géneros N:M
│   ├── manage_concepts.ejs      ← Conceptos con definiciones
│   └── concepts_list.ejs        ← Lista de conceptos
└── error.ejs                    ← Página de error genérica

```

**Contexto de Variables (res.locals)**:
- `user`: Objeto usuario actual {user_id, username, email, role}
- `isLoggedIn`: Boolean
- `isAdmin`: Boolean
- Datos específicos de ruta (books, stats, etc)

### 2. CAPA DE SEGURIDAD (Middleware)

```
authMiddleware.js:
  ├─ isLoggedIn()           → Requerido para rutas protegidas
  ├─ isAdmin()              → Requerido para funciones admin
  ├─ isNotLoggedIn()        → Requerido para login/register (no logueado)
  └─ attachUserToLocals()   → Inyecta user en res.locals

uploadMiddleware.js:
  ├─ MIME validation        → Solo JPEG, PNG, WebP
  ├─ Size limit             → Máximo 2MB
  ├─ Secure filename        → TIMESTAMP + HASH
  └─ Error handling         → MulterError

errorMiddleware.js:
  ├─ errorHandler()         → Centraliza errores
  ├─ notFoundHandler()      → HTTP 404
  └─ asyncHandler()         → Wrapper para async/await
```

### 3. CAPA DE PERSISTENCIA (Services)

Cada service es un módulo Node.js que exporta funciones async:

```javascript
module.exports = {
    registerUser: async (username, email, password, fullName) => {...},
    loginUser: async (username, password) => {...},
    getAllBooks: async (page, perPage) => {...},
    searchBooks: async (term, minPrice, maxPrice, page, perPage) => {...},
    // ... más funciones
};
```

**Patrón de Respuesta**:
```javascript
{
    success: boolean,
    user: {...},          // o books, stats, concept, etc
    error: "string",      // Si success=false
    totalCount: number,   // Si hay paginación
    page: number
}
```

### 4. CAPA DE BASE DE DATOS (SQL)

**Estrategia de Queries**:
- Todas usan parámetros ($1, $2...) 
- Encapsuladas en funciones de services
- Reutilización vía vistas SQL (views)
- Agregaciones con STRING_AGG para N:M

**Ejemplo: Obtener Libro con Autores y Géneros**:
```sql
SELECT 
    b.isbn, b.title, b.description, b.price, b.stock,
    STRING_AGG(DISTINCT a.name, ', ') as authors,
    STRING_AGG(DISTINCT g.name, ', ') as genres
FROM books b
LEFT JOIN book_authors ba ON b.isbn = ba.isbn
LEFT JOIN authors a ON ba.author_id = a.author_id
LEFT JOIN book_genres bg ON b.isbn = bg.isbn
LEFT JOIN genres g ON bg.genre_id = g.genre_id
WHERE b.isbn = $1
GROUP BY b.isbn;
```

---

## Patrones Implementados

| Patrón | Ubicación | Descripción |
|--------|-----------|-------------|
| **MVC** | Rutas → Services → Vistas | Separación de concerns |
| **Repository** | services/ | Acceso a datos centralizado |
| **Middleware** | middleware/ | Pipeline de procesamiento |
| **Template Inheritance** | layout.ejs | DRY en vistas |
| **Connection Pool** | config/db.js | Reutilización de conexiones |
| **Error Handling** | errorMiddleware.js | Centralización de errores |
| **Authentication** | authMiddleware.js + session | Guard de rutas |
| **N:M Relationships** | book_authors, book_genres, book_concepts | Tablas puente normalizadas |
| **Audit Trail** | triggers + audit_log table | Trazabilidad |

---

## Despliegue en GCP

```
┌──────────────────────────────────────────────────────────┐
│          Google Cloud Platform (GCP)                     │
├──────────────────────────────────────────────────────────┤
│                                                          │
│  Compute Engine (VM):                                    │
│  ├─ CentOS Stream 10                                     │
│  ├─ 2-4 vCPU, 4-8GB RAM                                 │
│  └─ Public IP (IP Estática)                            │
│                                                          │
│  Cloud SQL / PostgreSQL:                                │
│  ├─ PostgreSQL 14+                                       │
│  ├─ High Availability (backup automático)               │
│  └─ Firewall rule: acepta solo desde VM                │
│                                                          │
│  Cloud Storage (opcional):                              │
│  └─ Almacenar imágenes uploadadas                       │
│                                                          │
│  Load Balancer (opcional):                              │
│  ├─ HTTPS termination                                   │
│  └─ Distribute traffic a múltiples instancias          │
│                                                          │
└──────────────────────────────────────────────────────────┘
```

---

## Conclusión

La arquitectura monolítica implementa claramente:
- ✓ **Separación de concerns** (MVC pattern)
- ✓ **Seguridad en capas** (middleware, SQL parameterizado)
- ✓ **Escalabilidad** (pool de conexiones, paginación, índices)
- ✓ **Mantenibilidad** (services reutilizables, vistas DRY)
- ✓ **Confiabilidad** (triggers, constraints, auditoría)
