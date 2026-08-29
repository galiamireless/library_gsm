# Requisitos Funcionales y No Funcionales

## Requisitos Funcionales (RF)

### Gestión de Usuarios y Autenticación
- **RF-01**: El sistema debe permitir el registro de nuevos usuarios con username, email, contraseña y nombre completo.
- **RF-02**: El sistema debe permitir login de usuarios registrados con validación de credenciales.
- **RF-03**: El sistema debe permitir logout de usuarios autenticados.
- **RF-04**: El sistema debe mantener sesiones de usuario seguras mediante express-session.
- **RF-05**: Debe existir un único Administrador en el sistema con acceso a funciones administrativas.

### Catálogo de Libros
- **RF-06**: El sistema debe mostrar un catálogo completo de libros con paginación (10 libros por página).
- **RF-07**: El sistema debe permitir búsqueda de libros por título, autor y descripción.
- **RF-08**: El sistema debe permitir filtrado de libros por rango de precio.
- **RF-09**: El sistema debe mostrar detalles completos de cada libro incluyendo: ISBN, título, descripción, precio, stock, año, formato, autores, géneros.
- **RF-10**: El sistema debe mostrar solo libros con stock disponible en la vista "Available Books".

### CRUD de Libros (Admin)
- **RF-11**: El administrador debe poder crear nuevos libros con ISBN único como identificador principal.
- **RF-12**: El administrador debe poder editar información de libros existentes.
- **RF-13**: El administrador debe poder eliminar libros del catálogo.
- **RF-14**: El administrador debe poder agregar autores a libros.
- **RF-15**: El administrador debe poder agregar géneros a libros.

### Gestión de Imágenes
- **RF-16**: El administrador debe poder subir portadas de libros en formatos JPEG, PNG o WebP.
- **RF-17**: El tamaño de imágenes no debe exceder 2MB.
- **RF-18**: Los archivos subidos deben renombrarse de forma segura con hash y timestamp.
- **RF-19**: El sistema debe permitir eliminar imágenes de libros.

### Gestión de Conceptos y Definiciones
- **RF-20**: El sistema debe permitir crear conceptos globales (IaaS, PaaS, SaaS, FaaS, Bucket, etc.).
- **RF-21**: El administrador debe poder asociar conceptos a libros con definiciones específicas.
- **RF-22**: El administrador debe poder editar definiciones de conceptos en contextos de libros específicos.
- **RF-23**: El administrador debe poder eliminar asociaciones concepto-libro.
- **RF-24**: Los usuarios deben poder visualizar conceptos y sus definiciones en la página de detalle de libros.

### Reportes y Estadísticas
- **RF-25**: El dashboard administrativo debe mostrar estadísticas de inventario: total de libros, stock total, disponibles, agotados.
- **RF-26**: El dashboard debe mostrar análisis de precios: promedio, mínimo, máximo.

## Requisitos No Funcionales (RNF)

### Arquitectura y Diseño
- **RNF-01**: La aplicación debe ser monolítica server-side sin APIs REST ni GraphQL.
- **RNF-02**: La aplicación debe seguir el patrón MVC con separación de concerns.
- **RNF-03**: La interfaz de usuario debe renderizarse en el servidor usando EJS.
- **RNF-04**: No se deben usar ORMs; las consultas deben ser SQL parametrizadas puras con el driver pg.

### Base de Datos
- **RNF-05**: Utilizar PostgreSQL como RDBMS.
- **RNF-06**: El esquema debe estar normalizado en 4FN (cuarta forma normal).
- **RNF-07**: ISBN debe ser Primary Key de la tabla books.
- **RNF-08**: Implementar relaciones N:M para autores, géneros e imágenes.
- **RNF-09**: Implementar tabla puente book_concepts con definiciones específicas por libro.
- **RNF-10**: Usar un índice parcial único para garantizar un único Administrador.

### Seguridad
- **RNF-11**: Todas las contraseñas deben estar hasheadas con bcrypt (10 rounds).
- **RNF-12**: Todas las consultas SQL deben usar parámetros ($1, $2...) para prevenir SQL Injection.
- **RNF-13**: Implementar middleware de autenticación para proteger rutas administrativas.
- **RNF-14**: Las sesiones deben ser HTTP-only y Secure (en producción).
- **RNF-15**: Validar y filtrar todos los inputs de usuario.
- **RNF-16**: Implementar CORS con origen controlado.
- **RNF-17**: No exponer stack traces en mensajes de error en producción.

### Performance y Escalabilidad
- **RNF-18**: Implementar pool de conexiones PostgreSQL con min=2, max=10.
- **RNF-19**: Timeout de conexión: 1000ms, idle timeout: 30000ms.
- **RNF-20**: Crear índices en columnas de búsqueda frecuente (title, ISBN, email).
- **RNF-21**: Implementar paginación en catálogos (máximo 10-20 registros por página).

### Usabilidad e Interfaz
- **RNF-22**: Interfaz responsive usando Bootstrap 5.
- **RNF-23**: Navegación clara entre catálogo, búsqueda, detalle y área administrativa.
- **RNF-24**: Mensajes de error claros y amigables.
- **RNF-25**: Confirmaciones de acciones destructivas (eliminar libros/imágenes).

### Despliegue y Operaciones
- **RNF-26**: Soportar despliegue en Google Cloud Platform (Compute Engine).
- **RNF-27**: Compatible con CentOS Stream 10.
- **RNF-28**: Utilizar variables de entorno para configuración sensible (.env).
- **RNF-29**: Implementar graceful shutdown con manejo de señales (SIGTERM, SIGINT).
- **RNF-30**: Registrar logs de acceso y errores.
- **RNF-31**: Endpoint /health para health checks.

### Documentación y Mantenimiento
- **RNF-32**: Documentación técnica de arquitectura.
- **RNF-33**: Matriz de seguridad con amenazas y mitigaciones.
- **RNF-34**: Plan de pruebas con casos positivos y negativos.
- **RNF-35**: Registro de decisiones de ingeniería (ADR).
- **RNF-36**: Historial de cambios y versiones.

## Matriz de Trazabilidad

| Requisito | Módulo | Estado | Evidencia |
|-----------|--------|--------|-----------|
| RF-01 | auth | ✓ | /routes/authRoutes.js - POST /auth/register |
| RF-02 | auth | ✓ | /routes/authRoutes.js - POST /auth/login |
| RF-06 | books | ✓ | /routes/bookRoutes.js - GET /books/catalog |
| RF-07 | books | ✓ | /routes/bookRoutes.js - GET /books/search |
| RF-11 | admin | ✓ | /routes/adminRoutes.js - POST /admin/books |
| RF-16 | admin | ✓ | /middleware/uploadMiddleware.js + /routes/adminRoutes.js |
| RF-20 | concepts | ✓ | /routes/conceptRoutes.js - POST /concepts |
| RNF-01 | architecture | ✓ | Monolithic design without APIs |
| RNF-06 | database | ✓ | /db/01_schema.sql - 4FN normalization |
| RNF-11 | security | ✓ | /services/authService.js - bcrypt hashing |
| RNF-12 | security | ✓ | Parametrized queries ($1, $2...) in all services |
