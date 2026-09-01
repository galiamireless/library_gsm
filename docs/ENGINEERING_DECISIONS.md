# Decisiones de Ingeniería de Software (ADR - Architectural Decision Records)

## ADR-001: Arquitectura Monolítica Server-Side

### Contexto
Se requería construir una aplicación web para la gestión de una librería con funcionalidades CRUD, autenticación, gestión de imágenes y conceptos asociados a libros.

### Problema
¿Debe la aplicación implementarse como un monolito server-side, microservicios, o una SPA con backend API?

### Alternativas Evaluadas
1. **Monolito Server-Side (EJS)**: Una sola aplicación Node.js que renderiza HTML en el servidor.
2. **Microservicios**: Múltiples servicios independientes con API REST.
3. **Single Page Application (React/Vue)**: Frontend SPA consumiendo API GraphQL o REST.

### Decisión
**Monolito Server-Side usando Node.js, Express y EJS**

### Justificación
- **Simplificidad**: Menor complejidad operacional para una aplicación de gestión de librería.
- **Cumplimiento de requisitos**: El ejercicio explícitamente requiere arquitectura monolítica.
- **Rendimiento**: Renderizado server-side reduce carga en cliente y mejora SEO.
- **Mantenibilidad**: Un solo codebase es más fácil de entender y mantener.
- **Costo**: Menor overhead operacional en infraestructura.
- **Deployment**: Facilita despliegue único en GCP Compute Engine.

### Riesgos Mitigados
- **Escalabilidad limitada**: Uso de connection pooling en PostgreSQL.
- **Acoplamiento**: Separación clara de concerns (MVC).
- **Fault isolation**: No aplica para monolito.

### Validación
- Arquitectura implementada sin APIs REST o GraphQL.
- Patrón MVC con routes, services, middleware.
- Renderizado EJS en servidor.

---

## ADR-002: Acceso Directo a PostgreSQL sin ORMs

### Contexto
Se requiere acceder a PostgreSQL de forma segura y eficiente sin usar herramientas como Sequelize, TypeORM o Prisma.

### Problema
¿Usar un ORM que abstrae SQL o escribir consultas SQL parametrizadas directamente?

### Alternativas Evaluadas
1. **Driver PostgreSQL puro (pg)**: Consultas SQL parametrizadas manuales.
2. **Sequelize**: ORM con migraciones automáticas.
3. **TypeORM**: ORM orientado a objetos.
4. **Prisma**: ORM moderno con schema SDL.

### Decisión
**Driver PostgreSQL puro (pg) con consultas parametrizadas**

### Justificación
- **Requisito explícito**: El ejercicio prohibe ORMs.
- **Control total**: Máximo control sobre consultas y performance.
- **Seguridad**: Parámetros SQL previenen inyección ($1, $2...).
- **Transparencia**: Los desarrolladores entienden exactamente qué SQL se ejecuta.
- **Eficiencia**: Sin overhead de mapeo objeto-relacional.
- **Learning**: Experiencia directa con SQL y bases de datos relacionales.

### Riesgos Mitigados
- **SQL Injection**: Todos los queries usan parámetros.
- **Errores SQL**: Manejo explícito de excepciones.
- **Performance**: Optimización manual de índices y queries.

### Validación
- Todas las consultas en services/ usan parámetros ($1, $2...).
- Pool de conexiones centralizado en config/db.js.
- Sin ORM en package.json.

---

## ADR-003: Renderizado Server-Side con EJS

### Contexto
Se requiere una interfaz de usuario web para catálogo, búsqueda, autenticación y administración.

### Problema
¿Renderizar en servidor (EJS/Pug) o cliente (React/Vue)?

### Alternativas Evaluadas
1. **EJS Server-Side**: Plantillas en servidor con renderizado dinámico.
2. **React SPA**: Frontend reactivo con llamadas API.
3. **Pug/Haml**: Template engines alternativos.
4. **Handlebars**: Template engine sin lógica.

### Decisión
**EJS Server-Side**

### Justificación
- **Simplicidad**: Sintaxis JS directa en plantillas.
- **SEO**: Contenido pre-renderizado es mejor indexable.
- **Performance inicial**: No requiere JavaScript cliente para funcionalidad básica.
- **Seguridad**: Validación en servidor, no depende de JS cliente.
- **Compatibilidad**: Funciona en navegadores antiguos sin soporte JS.
- **Mantenibilidad**: Toda lógica en un lugar (servidor).

### Riesgos Mitigados
- **Interactividad limitada**: Scripts JS adicionales para validación cliente.
- **Experiencia de usuario**: Recarga completa de página en cada acción.
- **Debugging**: Stack traces claros en servidor.

### Validación
- Todas las vistas en /views/ usando EJS.
- Partials para componentes reutilizables (navbar, header, footer).
- Renderizado dinámico de catálogo, búsqueda, detalles.

---

## ADR-004: ISBN como Primary Key

### Contexto
Se requiere identificar libros de forma única en la base de datos.

### Problema
¿Usar un campo ISBN como PK o una clave sustituta (ID autonumérico)?

### Alternativas Evaluadas
1. **ISBN como PK**: VARCHAR(20) PRIMARY KEY.
2. **ID numérico como PK**: SERIAL PRIMARY KEY (surrogate key).
3. **Composite Key**: ISBN + versión.

### Decisión
**ISBN como Primary Key**

### Justificación
- **Requisito explícito**: El ejercicio especifica ISBN como PK principal.
- **Naturalidad**: ISBN es naturalmente único a nivel mundial.
- **Integridad**: Previene duplicados de libros en BD.
- **Semantic**: El modelo de datos es más claro.
- **Búsqueda**: ISBN es campo de búsqueda común.

### Riesgos Mitigados
- **Longitud**: VARCHAR(20) soporta ISBN-10 (13 dígitos) e ISBN-13 (17 con guiones).
- **Formato**: Validación en aplicación para ISBN válidos.
- **Actualización**: Raras veces se actualiza ISBN.

### Validación
- Tabla books con isbn VARCHAR(20) PRIMARY KEY.
- Validación en authService.createBook().
- FK de otras tablas apuntan a ISBN.

---

## ADR-005: Normalización 4FN para Relaciones N:M

### Contexto
Un libro puede tener múltiples autores, géneros, imágenes y conceptos. Estos pueden ser compartidos entre libros.

### Problema
¿Cómo modelar estas relaciones N:M de forma eficiente y normalizada?

### Alternativas Evaluadas
1. **Tablas puente normalizadas (4FN)**: Descomposición completa de MVD.
2. **Campos ARRAY PostgreSQL**: Denormalización con tipos nativos.
3. **Campos JSON**: Almacenamiento flexible pero no ACID.
4. **Denormalización**: Datos redundantes para performance.

### Decisión
**Tablas puente normalizadas en 4FN**

### Justificación
- **Integridad referencial**: Constraints mantienen consistencia.
- **Escalabilidad**: Eficiente para grandes volúmenes.
- **Flexibilidad**: Conceptos pueden tener definiciones específicas por libro.
- **Consultas**: JOIN claros y optimizables.
- **Requiso académico**: 4FN demoestra comprensión de normalización.

### Estructura
```sql
-- Ejemplo: Libro con múltiples autores
books (isbn, ...)
authors (author_id, name, ...)
book_authors (isbn, author_id) -- Tabla puente

-- Conceptos con definiciones específicas por libro
book_concepts (isbn, concept_id, definition)
concepts (concept_id, name, ...)
```

### Riesgos Mitigados
- **Queries complejas**: Vistas y procedimientos almacenados simplifican búsquedas.
- **Performance**: Índices en FK y PK de tablas puente.

### Validación
- 4FN alcanzada en /db/01_schema.sql.
- Relaciones documentadas en comentarios de tablas.
- Integridad referencial con ON DELETE CASCADE.

---

## ADR-006: Autenticación con Sesiones Server-Side

### Contexto
Se requiere autenticar usuarios y mantener su estado durante la navegación.

### Problema
¿Usar sesiones server-side o tokens JWT?

### Alternativas Evaluadas
1. **express-session con PostgreSQL**: Sesiones server-side persistidas.
2. **JWT (JSON Web Tokens)**: Stateless, tokens en cliente.
3. **OAuth 2.0**: Delegación a proveedor externo.

### Decisión
**express-session con almacenamiento en PostgreSQL**

### Justificación
- **Requisito monolito**: Sessions encajan mejor con server-side.
- **Seguridad**: Datos de sesión en servidor, no en cliente.
- **Revocación**: Fácil cerrar sesión eliminando cookie.
- **Simplicidad**: No requiere firma/verificación de tokens.
- **Persistence**: Tablas de sesión en la BD para durabilidad.

### Configuración
- **Store**: connect-pg-simple para guardar sesiones en PostgreSQL.
- **Cookie**: HTTP-only, Secure (producción), SameSite=Lax.
- **Duration**: 24 horas (configurable via .env).

### Validación
- Session config en app.js.
- Tabla session creada automáticamente.
- Middleware attachUserToLocals() en cada request.

---

## ADR-007: Hashing de Contraseñas con Bcrypt

### Contexto
Las contraseñas de usuarios deben almacenarse de forma segura.

### Problema
¿Usar bcrypt, Argon2, scrypt, o PBKDF2?

### Alternativas Evaluadas
1. **bcrypt**: Rounds configurables, lento por diseño.
2. **Argon2**: Moderno, consume memoria, más seguro.
3. **scrypt**: Balance entre seguridad y velocidad.
4. **PBKDF2**: Estándar NIST.

### Decisión
**bcrypt con 10 rounds**

### Justificación
- **Estándar de facto**: Ampliamente usado y confiable.
- **Seguridad**: Resiste ataques de fuerza bruta por su lentitud.
- **Simplicidad**: API simple en Node.js.
- **Mantenibilidad**: Bien documentado.
- **Configurabilidad**: Rounds ajustables según hardware.

### Implementación
- **10 rounds**: Balance entre seguridad (lentitud) y UX (no demasiado lento).
- **Configuración**: Via variable de entorno BCRYPT_ROUNDS.

### Validación
- authService.hashPassword() usa bcrypt.
- authService.verifyPassword() compara contra hash.
- Contraseñas nunca se almacenan en BD en texto plano.

---

## Resumen de Decisiones

| ADR | Decisión | Justificación Clave | Estado |
|-----|----------|-------------------|--------|
| ADR-001 | Monolito Server-Side | Simplicidad, requisito explícito | ✓ Implementado |
| ADR-002 | PostgreSQL puro (pg) | Control, seguridad, requisito | ✓ Implementado |
| ADR-003 | EJS Server-Side | SEO, seguridad, simplicidad | ✓ Implementado |
| ADR-004 | ISBN como PK | Identidad natural, requisito | ✓ Implementado |
| ADR-005 | 4FN con tablas puente | Integridad, flexibilidad | ✓ Implementado |
| ADR-006 | express-session | Seguridad, revocación fácil | ✓ Implementado |
| ADR-007 | bcrypt + 10 rounds | Estándar, seguridad probada | ✓ Implementado |
