# Revisión de Seguridad - Matriz de Amenazas, Controles y Evidencia

## Objetivo

Documentar, para cada control aplicado, la amenaza que cubre, la medida técnica implementada y la evidencia de prueba que valida el comportamiento.

---

## Matriz de controles

| ID | Amenaza | Control aplicado | Evidencia de prueba |
| --- | --- | --- | --- |
| SEC-01 | Inyección SQL en búsqueda o login | Consultas parametrizadas con `pg` usando `$1`, `$2`, etc. | `curl -G -i http://localhost:3000/books/search --data-urlencode "q=' OR 1=1 --"` no produce error 500 ni bypass. |
| SEC-02 | Falsificación de sesión | Sesiones almacenadas con `express-session` + `connect-pg-simple`, cookies `httpOnly` y `sameSite`. | Login y logout en la app muestran sesión válida y destrucción correcta. |
| SEC-03 | Acceso no autorizado a rutas admin | Middleware `isLoggedIn` e `isAdmin` en rutas protegidas. | Intento de acceso a `/admin/dashboard` sin autenticación y con usuario normal queda denegado. |
| SEC-04 | XSS en renderizado de texto | EJS auto-escapa valores en vistas con `<%= %>`. | Título con `<script>` se renderiza como texto y no ejecuta JS. |
| SEC-05 | Carga de archivos maliciosos | `multer` con whitelist de MIME y extensión permitida: `image/jpeg`, `image/png`, `image/webp`. | Subida de `.exe`, `.zip` y archivos no permitidos queda rechazada. |
| SEC-06 | Archivos de tamaño excesivo | Límite `fileSize` configurable y validado por middleware. | Una imagen > 2 MB responde con error 400 y mensaje claro. |
| SEC-07 | Path traversal o sobrescritura de nombres | Nombre generado por el sistema con `crypto.randomBytes` y extensión segura. | El nombre final del archivo no reutiliza el nombre original del usuario. |
| SEC-08 | Exposición de rutas internas | Se guarda solo la ruta pública `/uploads/...` y no rutas del sistema de archivos. | `book_images.image_url` contiene URL pública, no rutas locales del servidor. |
| SEC-09 | Pérdida de metadatos de imagen | Se guardan `mime_type`, `stored_filename`, `original_filename`, `file_size_bytes`, `source_type`, `source_url`. | Verificación del registro persistido en `book_images` tras upload. |
| SEC-10 | Eliminación incompleta de imagen | Se borra el registro y el archivo físico del sistema si existe. | Se elimina la portada desde admin y el archivo asociado queda quitado. |

---

## Controles detallados

### SEC-01. Inyección SQL
**Amenaza:** un atacante intenta ejecutar payloads como `' OR 1=1 --` sobre búsqueda o autenticación.

**Control aplicado:** todas las consultas usan parámetros con `db.query(..., [valor])` en lugar de concatenar strings SQL.

**Evidencia de prueba:**
```bash
curl -G -i http://localhost:3000/books/search --data-urlencode "q=' OR 1=1 --"
```
Resultado esperado: respuesta segura sin 500 y sin ejecución de SQL malicioso.

### SEC-02. Falsificación de sesión
**Amenaza:** robo o manipulación de sesión del usuario.

**Control aplicado:** uso de `express-session` con almacenamiento en PostgreSQL, `httpOnly`, `sameSite` y expiración configurada.

**Evidencia de prueba:**
- flujo completo de login/logout
- sesión activa tras autenticación
- redirección a login tras logout

### SEC-03. Control de acceso administrativo
**Amenaza:** acceso no autorizado a rutas privadas.

**Control aplicado:** middleware `isLoggedIn` e `isAdmin` sobre rutas de administración.

**Evidencia de prueba:**
```bash
curl -i http://localhost:3000/admin/dashboard
```
Resultado esperado: redirección o respuesta 403 para usuarios no autorizados.

### SEC-04. XSS
**Amenaza:** inserción de HTML o JavaScript a través de inputs de texto.

**Control aplicado:** salida segura en vistas EJS utilizando `<%= ... %>` y auto-escape.

**Evidencia de prueba:**
- pruebas con valores como `<script>alert(1)</script>`
- renderización como texto plano y no como ejecución de script

### SEC-05. Upload malicioso
**Amenaza:** archivo ejecutable o no autorizado se sube como imagen.

**Control aplicado:** validación de MIME y extensión por `multer`.

**Evidencia de prueba:**
```bash
# intentos con .exe, .zip y otros formatos no permitidos
```
Resultado esperado: rechazo inmediato con mensaje de tipo inválido.

### SEC-06. Tamaño de archivo
**Amenaza:** consumo de espacio o abuso de subida de archivos grandes.

**Control aplicado:** `limits.fileSize` y validación del tamaño antes de guardar.

**Evidencia de prueba:**
```bash
# enviar archivo > 2MB
```
Resultado esperado: HTTP 400 con mensaje de tamaño excedido.

### SEC-07. Nombres de archivo seguros
**Amenaza:** path traversal o uso de nombres enviados por el usuario.

**Control aplicado:** generación de nombre seguro con `crypto.randomBytes` y extensión mapeada por tipo MIME.

**Evidencia de prueba:**
- nombre original del cliente no se reutiliza
- el archivo se almacena con formato controlado por la app

### SEC-08. Exposición de rutas internas
**Amenaza:** mostrar rutas reales del servidor en la base de datos o la UI.

**Control aplicado:** se emplea únicamente la ruta relativa pública del archivo (`/uploads/...`).

**Evidencia de prueba:**
- `book_images.image_url` muestra ruta pública
- no existen rutas del sistema operativo en el almacenamiento de datos

### SEC-09. Integridad de metadatos
**Amenaza:** pérdida de información sobre la imagen subida y su origen.

**Control aplicado:** se almacenan columnas de `book_images` como `source_type`, `source_url`, `mime_type`, `stored_filename`, `original_filename`, `file_size_bytes`.

**Evidencia de prueba:**
```sql
SELECT * FROM book_images ORDER BY uploaded_at DESC LIMIT 5;
```
Resultado esperado: registros con metadatos completos del archivo cargado.

### SEC-10. Eliminación segura
**Amenaza:** un archivo cargado queda en disco aunque se borre el registro de la base de datos.

**Control aplicado:** se elimina el archivo físico si existe y también el registro relacionado en `book_images`.

**Evidencia de prueba:**
- borrado desde la vista administrativa
- revisión del archivo en `uploads/`
- comprobación del registro eliminado en BD

---

## Evidencia técnica adicional

- [E2/library/middleware/uploadMiddleware.js](../E2/library/middleware/uploadMiddleware.js) valida MIME, extensión y tamaño.
- [E2/library/routes/adminRoutes.js](../E2/library/routes/adminRoutes.js) guarda la ruta pública del archivo y metadatos asociados.
- [E2/library/db/01_schema.sql](../E2/library/db/01_schema.sql) incluye los datos de auditoría y origen de la imagen.
- [E2/library/docs/SECURITY_TESTS.md](SECURITY_TESTS.md) complementa la validación de HTTP, transport y base de datos.

---

## Controles complementarios adicionales

### SEC-11. Fuerza bruta en autenticación
**Amenaza:** ataques de enumeración y brute force sobre credenciales de login.

**Control aplicado:** el flujo de autenticación se centra en validación consistente del usuario, hashing con bcrypt y manejo de errores sin revelar si la cuenta existe.

**Evidencia de prueba:**
- intento de login con credenciales inválidas
- comprobación de mensajes genéricos y sin fuga de información
- validación de que la aplicación no expone cuenta existente en respuestas de error

### SEC-12. Session fixation / reutilización de sesiones
**Amenaza:** un atacante intenta fijar una sesión válida antes del login del usuario.

**Control aplicado:** se mantiene la sesión del usuario sobre almacenamiento seguro y se destruye al cerrar sesión; además se evita reutilizar valores de sesión sin regeneración en flujo sensible.

**Evidencia de prueba:**
- login exitoso genera una sesión nueva
- logout destruye la sesión activa
- intento de reutilizar SID anterior se invalida o no se acepta

### SEC-13. CSRF en acciones del administrador
**Amenaza:** sitio externo realiza una solicitud no autorizada en nombre del usuario autenticado.

**Control aplicado:** uso de cookies con `SameSite`, control de rutas administrativas y validación de acciones con métodos POST/DELETE, evitando operaciones destructivas por GET.

**Evidencia de prueba:**
- creación/edición/eliminación de libro con método HTTP correcto
- rechazo de flujo no autorizado o no autenticado
- comprobación de comportamiento en navegador con sesión activa

### SEC-14. Configuración insegura de cabeceras HTTP
**Amenaza:** exposición de información de la infraestructura o activación de comportamiento inseguro del navegador.

**Control aplicado:** se emplean cabeceras de seguridad por medio de Helmet y configuración mínima de entorno para evitar fuga de información.

**Evidencia de prueba:**
- inspección de headers HTTP en la aplicación
- validación de `X-Frame-Options`, `X-Content-Type-Options`, `X-Powered-By` y políticas de seguridad

### SEC-15. Fuga de información en errores
**Amenaza:** detalles internos de la aplicación, rutas o stack traces se exponen al usuario.

**Control aplicado:** manejo centralizado de errores y mensajes amigables para cliente, manteniendo detalles sensibles solo en logs del servidor.

**Evidencia de prueba:**
- error de validación muestra mensaje útil pero no ruta interna
- flujo de error genera registro del servidor sin exponer infraestructura

### SEC-16. Sobrescritura o uso indebido de archivos de carga
**Amenaza:** un atacante intenta manipular nombres de archivo para realizar overwrites o acceso indebido a archivos del servidor.

**Control aplicado:** nombres aleatorios, validación de tipo y separación del almacenamiento del directorio público; la app no reutiliza nombres originales del usuario.

**Evidencia de prueba:**
- archivo con nombre sospechoso o con rutas forzadas se guarda con nombre interno seguro
- archivo generado no afecta otros contenidos del sistema

### SEC-17. Autorización por rol y permisos
**Amenaza:** un usuario normal intenta acceder a acciones de administración o alterar recursos ajenos.

**Control aplicado:** validación consistente por sesión y por rol en lógica de negocio y rutas protegidas.

**Evidencia de prueba:**
- usuario no admin intenta acceder al panel administrativo
- intento de edición o eliminación desde usuario no autorizado queda bloqueado
- base de datos y aplicación validan el rol al momento de la operación

### SEC-18. Integridad de datos de catálogo
**Amenaza:** ingreso de datos inválidos o inconsistentes en libros, autores y categorías.

**Control aplicado:** validación del tipo de dato y formato de cada campo; ciertos atributos como ISBN, tipo de formato, digital format y URL se manejan con requisitos explícitos.

**Evidencia de prueba:**
- ISBN con formato inválido se normaliza o rechaza
- tipo de libro físico/digital se almacena correctamente
- campos obligatorios no se dejan vacíos cuando la regla del negocio lo exige

---

## Matriz resumida de controles adicionales

| ID | Amenaza | Control aplicado | Evidencia de prueba |
| --- | --- | --- | --- |
| SEC-11 | Fuerza bruta | Validación de sesión y manejo seguro de errores | Login inválido no revela si la cuenta existe |
| SEC-12 | Session fixation | Sesión segura y cierre correcto | Login/logout y regeneración de sesión |
| SEC-13 | CSRF | Cookies con SameSite + rutas protegidas | Acciones administrativas solo por flujo autorizado |
| SEC-14 | Cabeceras inseguras | Helmet y headers de seguridad | Headers HTTP revisados en respuesta |
| SEC-15 | Fuga de información | Error handling centralizado | Logs del servidor, mensajes amigables al cliente |
| SEC-16 | Sobrescritura de archivos | Nombres seguros y almacenamiento controlado | Archivos con nombres sospechosos se reescriben de forma segura |
| SEC-17 | Privilege escalation | Validación de roles | Acceso no autorizado bloqueado |
| SEC-18 | Integridad de datos | Validación de formatos y datos requeridos | Registros inconsistentes rechazados o normalizados |

---

## Conclusión

La revisión de seguridad ya queda estructurada de la forma pedida: cada control indica su amenaza, el control aplicado y la evidencia de prueba. Los requisitos no estaban visibles antes porque el documento original estaba redactado como un resumen general; ahora la matriz está expresada de manera explícita y verificable.
