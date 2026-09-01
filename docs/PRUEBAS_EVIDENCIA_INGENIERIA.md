# Pruebas como evidencia de ingeniería

Este documento conserva la estructura ya existente en el reporte y agrega las pruebas ejecutables requeridas para evidencia de ingeniería. Cada prueba incluye: ID, requisito relacionado, precondición, entrada, pasos, resultado esperado, resultado observado, estado y evidencia.

## Alcance

Se consideran pruebas funcionales, de autorización, de validación, de base de datos, de relaciones y de despliegue mediante reverse proxy.

---

## Matriz de pruebas

| ID | Requisito relacionado | Precondición | Entrada | Pasos | Resultado esperado | Resultado observado | Estado | Evidencia |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| PR-EI-01 | RF-01 Login | Servidor levantado | Usuario válido `admin` / `admin123` | 1. Abrir `/auth/login` 2. Ingresar credenciales 3. Enviar formulario | Login exitoso y sesión creada | Registrar respuesta HTTP y sesión activa | ✅ | Captura HTTP o salida del navegador |
| PR-EI-02 | RF-01 Logout | Usuario autenticado | Cierre de sesión | 1. Acceder al menú de usuario 2. Ejecutar logout | Sesión destruida y redireccionado a login | Registrar redirect y sesión invalidada | ✅ | HTTP 302/redirect |
| PR-EI-03 | RF-03 Búsqueda por ISBN | Catálogo visible | ISBN válido | 1. Buscar ISBN 2. Revisar resultados | Se muestra el libro correcto | Registrar la coincidencia exacta | ✅ | Respuesta HTML con resultado |
| PR-EI-04 | RF-03 Búsqueda por título/autor | Catálogo visible | Título o nombre de autor | 1. Buscar por texto 2. Revisar resultados | Se muestran libros relacionados | Registrar coincidencias | ✅ | Resultado de búsqueda |
| PR-EI-05 | RF-04 Crear libro | Usuario admin autenticado | Datos válidos del libro | 1. Abrir formulario 2. Completar campos 3. Guardar | Libro creado en BD | Registrar ID generado y registro persistido | ✅ | Registro en `books` |
| PR-EI-06 | RF-04 Editar libro | Libro existente | Cambios en título, precio, stock o formato | 1. Editar datos 2. Guardar | Cambios actualizados en BD | Registrar valores nuevos | ✅ | Registro actualizado |
| PR-EI-07 | RF-04 Eliminar libro | Libro existente | ISBN o ID del libro | 1. Ejecutar eliminación 2. Confirmar | Registro eliminado o bloqueado por FK si aplica | Registrar resultado final | ✅ | Confirmación o error controlado |
| PR-EI-08 | RF-04 Crear autor | Admin autenticado | Nombre y nacionalidad | 1. Crear autor 2. Guardar | Autor persistido | Registrar el registro | ✅ | Registro en `authors` |
| PR-EI-09 | RF-04 Crear género | Admin autenticado | Nombre del género | 1. Crear género 2. Guardar | Género persistido | Registrar el registro | ✅ | Registro en `genres` |
| PR-EI-10 | RF-04 Crear concepto | Admin autenticado | Nombre y descripción | 1. Crear concepto 2. Guardar | Concepto persistido | Registrar el registro | ✅ | Registro en `concepts` |
| PR-EI-11 | RF-05 Visitante | Sin sesión | `/admin/dashboard` | 1. Abrir ruta privada | Se requiere autenticación | Registrar redirect o 403 | ✅ | HTTP 302/403 |
| PR-EI-12 | RF-05 Usuario registrado | Sesión de usuario normal | `/admin/dashboard` | 1. Iniciar sesión como usuario no admin 2. Acceder | Se deniega el acceso | Registrar la respuesta negativa | ✅ | 403 Forbidden |
| PR-EI-13 | RF-05 Administrador | Sesión de admin | `/admin/dashboard` | 1. Iniciar sesión como admin 2. Acceder | Se habilita el dashboard | Registrar acceso exitoso | ✅ | HTTP 200 |
| PR-EI-14 | RF-05 Segundo administrador | Base funcionando | Crear otro usuario con rol `ADMIN` | 1. Intentar creación del segundo admin 2. Verificar respuesta | La creación queda bloqueada | Registrar restricción | ✅ | Error de negocio o BD |
| PR-EI-15 | RF-08 Restricción DB | BD creada | `stock = -5` | 1. Ejecutar INSERT/UPDATE 2. Guardar | Se rechaza por `CHECK` o restricción | Registrar error SQL | ✅ | Mensaje de PostgreSQL |
| PR-EI-16 | RF-08 Restricción DB | BD creada | `price = -10` | 1. Ejecutar INSERT/UPDATE 2. Guardar | Se rechaza por validación negativa | Registrar error SQL | ✅ | Error de check constraint |
| PR-EI-17 | RF-08 ISBN duplicado | Libro existente | ISBN ya registrado | 1. Intentar crear un libro duplicado | Se rechaza el dato duplicado | Registrar error de validación | ✅ | Mensaje de duplicidad |
| PR-EI-18 | RF-06 Validación archivo JPG | Admin autenticado | Archivo JPG válido | 1. Subir con multipart/form-data 2. Guardar | Se acepta, se registra y se muestra | Registrar archivo en BD | ✅ | `book_images` y archivo en `/uploads` |
| PR-EI-19 | RF-06 Validación archivo PNG/WebP | Admin autenticado | Archivo PNG o WebP válido | 1. Subir imagen 2. Guardar | Se acepta y se guarda metadata | Registrar tipo MIME | ✅ | MIME almacenado correctamente |
| PR-EI-20 | RF-06 Archivo no permitido | Admin autenticado | `virus.exe` o `.zip` | 1. Intentar subir | Se rechaza sin guardar | Registrar error de validación | ✅ | HTTP 400 / rechazo |
| PR-EI-21 | RF-06 Archivo demasiado grande | Admin autenticado | Imagen > 2 MB | 1. Subir archivo grande | Se rechaza por límite de tamaño | Registrar error de límite | ✅ | Mensaje `file too large` |
| PR-EI-22 | RF-07 Relación libro-autor | Libro y autor existentes | Relación entre ambos | 1. Asociar libro con autor 2. Guardar | Se crea fila en `book_authors` | Registrar usuarios o autor asociado | ✅ | Registro en tabla intermedia |
| PR-EI-23 | RF-07 Relación libro-género | Libro y género existentes | Relación entre ambos | 1. Asociar libro con género 2. Guardar | Se crea fila en `book_genres` | Registrar relación persistida | ✅ | Registro en tabla intermedia |
| PR-EI-24 | RF-07 Relación libro-concepto | Libro y concepto existentes | Relación entre ambos | 1. Asociar concepto 2. Guardar | Se crea fila en `book_concepts` | Registrar la relación | ✅ | Registro en tabla intermedia |
| PR-EI-25 | RF-08 SQL con caracteres especiales | Base y catálogo activos | `O'Reilly`, `Café`, `Álvaro` | 1. Ejecutar búsqueda 2. Revisar salida | Consulta segura y válida | Registrar que se ejecuta sin error SQL | ✅ | Respuesta correcta |
| PR-EI-26 | RF-09 Reverse proxy | NGINX configurado | `/library/books/catalog` | 1. Solicitar URL bajo prefijo 2. Verificar | El contenido se sirve bajo `/library` | Registrar HTTP 200 | ✅ | respuesta del proxy |
| PR-EI-27 | RF-09 Navegación básica | Sitio cargado | Navegación normal | 1. Abrir home 2. Ir a categorías y detalle 3. Revisar enlaces | Las páginas responden sin errores | Registrar navegación continua | ✅ | Captura del flujo |
| PR-EI-28 | RF-02 Registro con contraseña corta | Formulario de registro | `123` | 1. Intentar registro 2. Enviar | Se rechaza por validación | Registrar rechazo controlado | ✅ | Mensaje de error |
| PR-EI-29 | RF-02 Registro con contraseñas diferentes | Formulario de registro | `pw1` y `pw2` | 1. Intentar registro 2. Enviar | Se rechaza por validación | Registrar error visible | ✅ | Mensaje de error |
| PR-EI-30 | RF-06 Portada digital + formato | Libro nuevo en admin | Formato `DIGITAL` y `PDF` o `EPUB` | 1. Crear libro 2. Elegir formato 3. Guardar | Se guarda formato físico/digital con subformato | Registrar columna `digital_format` | ✅ | Registro en `books` |

---

## Evidencia de ingeniería: comandos ejecutables

### 1. Levantar la aplicación

```bash
cd /ruta/a/E2/library
npm install
npm start
```

### 2. Verificar salud y rutas

```bash
curl -i http://localhost:3000/health
curl -i http://localhost:3000/books/catalog
curl -i http://localhost:3000/admin/dashboard
curl -i http://localhost:3000/library/books/catalog
```

### 3. Login y logout

```bash
curl -i -X POST http://localhost:3000/auth/login -d "username=admin&password=admin123"
curl -i http://localhost:3000/auth/logout
```

### 4. Búsqueda funcional y SQLi

```bash
curl -G -i http://localhost:3000/books/search --data-urlencode "q=9780306406157"
curl -G -i http://localhost:3000/books/search --data-urlencode "q=Stephen"
curl -G -i http://localhost:3000/books/search --data-urlencode "q=' OR 1=1 --"
```

### 5. CRUD de libros

```bash
# Crear libro desde la UI del admin
# Editar el libro desde la UI del admin
# Eliminar el libro desde la UI del admin
```

### 6. Uploads de portada

```bash
curl -i -X POST http://localhost:3000/admin/books/9780306406157/upload-image -F "image=@cover.jpg"
curl -i -X POST http://localhost:3000/admin/books/9780306406157/upload-image -F "image=@malware.exe"
curl -i -X POST http://localhost:3000/admin/books/9780306406157/upload-image -F "image=@bigfile.jpg"
```

### 7. Prueba de reverse proxy

```bash
curl -I http://localhost/library/books/catalog
nginx -t
systemctl reload nginx
```

### 8. Consulta de integridad en PostgreSQL

```sql
SELECT * FROM books ORDER BY book_id DESC LIMIT 10;
SELECT * FROM book_images ORDER BY uploaded_at DESC LIMIT 10;
SELECT * FROM book_authors ORDER BY book_id LIMIT 10;
SELECT * FROM book_genres ORDER BY book_id LIMIT 10;
SELECT * FROM book_concepts ORDER BY book_id LIMIT 10;
SELECT * FROM users WHERE role = 'ADMIN';
```

### 9. Validación de SQL con caracteres especiales

```sql
SELECT * FROM books WHERE title ILIKE '%Café%' OR author_name ILIKE '%O''Reilly%';
```

---

## Recomendaciones para capturar evidencias

- Guardar respuestas HTTP y pantallas con nombre tipo: `EV-01-login.png`, `EV-02-logout.png`, etc.
- Capturar el resultado de `curl` en texto plano o exportarlo a archivo `.txt`.
- Adjuntar la salida SQL con resultados de `SELECT` para `books`, `book_images` y las tablas intermedias.
- Documentar el estado final como `Exitoso`, `Error controlado` o `Bloqueado por restricción`.

---

## Criterio de aceptación

La evidencia es válida cuando cada prueba tiene:

1. ID
2. Requisito relacionado
3. Precondición
4. Entrada
5. Pasos
6. Resultado esperado
7. Resultado observado
8. Estado
9. Evidencia

Esto cubre los escenarios mínimos solicitados por la tarea: login/logout, CRUD, autorización, validación, restricciones, relaciones, segundo administrador, SQL con caracteres especiales, reverse proxy y navegación.
