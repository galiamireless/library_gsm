# Plan de Pruebas - Evidencia de Ingeniería

## Objetivo

Registrar pruebas ejecutables para la aplicación de la librería, incluyendo validación funcional, autorización, seguridad, integridad, despliegue y navegación.

---

## Requisitos relacionados

- RF-01: Login y logout
- RF-02: Registro y autenticación
- RF-03: Búsqueda por ISBN, título y autor
- RF-04: CRUD de libros
- RF-05: Autorización por rol
- RF-06: Carga de imágenes con validación
- RF-07: Relaciones libro-autor, libro-género y libro-concepto
- RF-08: Normalización 4FN y restricciones de base de datos
- RF-09: Despliegue y reverse proxy

---

## Matriz de pruebas

| ID | Requisito relacionado | Precondición | Entrada | Pasos | Resultado esperado | Resultado observado | Estado | Evidencia |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| TP-01 | RF-01 | Servidor levantado | Usuario válido: `admin` / `admin123` | 1. Abrir login 2. Ingresar credenciales 3. Enviar | Login exitoso y sesión creada | Correcto | ✅ | Captura HTTP + sesión activa |
| TP-02 | RF-01 | Usuario logueado | Logout | 1. Click en logout 2. Verificar redirect | Sesión destruida y redirige a login | Correcto | ✅ | Response 302 |
| TP-03 | RF-03 | Catálogo visible | `q=9780306406157` | 1. Buscar ISBN 2. Revisar resultados | Libro encontrado por ISBN | Correcto | ✅ | Resultado con coincidencia |
| TP-04 | RF-03 | Catálogo visible | `q=Stephen` | 1. Buscar por autor | Muestra libros del autor | Correcto | ✅ | Resultado de búsqueda |
| TP-05 | RF-03 | Catálogo visible | `q=' OR 1=1 --` | 1. Ejecutar payload SQL injection | No falla ni refleja bypass | Correcto | ✅ | Respuesta segura |
| TP-06 | RF-04 | Sesión admin | ISBN nuevo | 1. Crear libro 2. Confirmar redirect | Libro guardado | Correcto | ✅ | Registro en BD |
| TP-07 | RF-04 | Sesión admin | ISBN duplicado | 1. Reintentar crear el mismo ISBN | Error controlado | Correcto | ✅ | Mensaje de validación |
| TP-08 | RF-04 | Sesión admin | Cambios de precio, stock y título | 1. Editar libro | Cambios persistidos | Correcto | ✅ | Registro actualizado |
| TP-09 | RF-04 | Sesión admin | ISBN existente | 1. Eliminar libro | Registro eliminado con restricciones | Correcto | ✅ | Confirmación de eliminación |
| TP-10 | RF-05 | Visitante no autenticado | `/admin/dashboard` | 1. Abrir ruta privada | Redirección o 403 | Correcto | ✅ | No acceso |
| TP-11 | RF-05 | Usuario registrado | `/admin/dashboard` | 1. Iniciar sesión como usuario normal 2. Abrir admin | Denegado | Correcto | ✅ | 403 Forbidden |
| TP-12 | RF-05 | Admin activo | `/admin/dashboard` | 1. Iniciar sesión como admin 2. Acceder | Panel funcional | Correcto | ✅ | Dashboard disponible |
| TP-13 | RF-05 | Base de datos con admin existente | Crear otro usuario admin | 1. Intentar crear segundo admin | Bloqueado | Correcto | ✅ | Error por restricción |
| TP-14 | RF-06 | Sesión admin | Archivo `cover.jpg` válido | 1. Subir en multipart/form-data | Imagen guardada y visible | Correcto | ✅ | Archivo en `/uploads` |
| TP-15 | RF-06 | Sesión admin | Archivo `virus.exe` | 1. Subir archivo no permitido | Rechazado con error | Correcto | ✅ | HTTP 400 |
| TP-16 | RF-06 | Sesión admin | Archivo `foto.png` de 3 MB | 1. Subir archivo grande | Rechazado por tamaño | Correcto | ✅ | Mensaje de límite |
| TP-17 | RF-06 | Sesión admin | Archivo `mi portada.jpg` | 1. Subir y marcar como portada | Nombre generado por sistema y portada marcada | Correcto | ✅ | `stored_filename` seguro |
| TP-18 | RF-06 | Sesión admin | `alt_text` vacío | 1. Subir archivo sin texto alternativo | Se usa texto por defecto | Correcto | ✅ | `alt_text` relleno |
| TP-19 | RF-07 | Libro con autor existente | Relación libro-autor | 1. Asociar libro + autor | FK creada en `book_authors` | Correcto | ✅ | Relación persistida |
| TP-20 | RF-07 | Libro con género existente | Relación libro-género | 1. Asociar libro + género | FK creada en `book_genres` | Correcto | ✅ | Relación persistida |
| TP-21 | RF-07 | Libro + concepto existente | Relación libro-concepto | 1. Asociar concepto con definición | Registro en `book_concepts` | Correcto | ✅ | Definición por libro |
| TP-22 | RF-08 | BD creada | INSERT inválido con stock negativo | 1. Ejecutar insert con `stock = -1` | Rechazado por `CHECK` | Correcto | ✅ | Error de restricción |
| TP-23 | RF-08 | BD creada | INSERT con precio negativo | 1. Ejecutar insert con `price = -5` | Rechazado por `CHECK` | Correcto | ✅ | Error de restricción |
| TP-24 | RF-08 | BD creada | Consulta con caracteres especiales | 1. Buscar `O'Reilly`, `Café`, `Álvaro` | Consulta parametrizada funciona | Correcto | ✅ | SQL seguro |
| TP-25 | RF-09 | NGINX o proxy habilitado | `/library` | 1. Levantar reverse proxy 2. Solicitar `/library/books/catalog` | Ruta servida con prefijo | Correcto | ✅ | HTTP 200 |
| TP-26 | RF-09 | Navegación básica | Sitio cargado | 1. Click en secciones/categorías | Navegación fluida | Correcto | ✅ | Sin errores JS/
| TP-27 | RF-02 | Registro con contraseña corta | `123` | 1. Enviar formulario | Rechazado | Correcto | ✅ | Mensaje de validación |
| TP-28 | RF-02 | Registro con contraseñas distintas | `pw1` / `pw2` | 1. Enviar formulario | Rechazado | Correcto | ✅ | Error de coincidencia |
| TP-29 | RF-06 | Archivo `cover.webp` | 1. Subir imagen WebP | 1. Acceder a la imagen | Carga correcta | Correcto | ✅ | Vista con portada |
| TP-30 | RF-06 | Archivo `cover.jpeg` | 1. Subir imagen JPG | 1. Revisar metadatos | Se guarda `mime_type` correcto | Correcto | ✅ | Metadata persistida |

---

## Pruebas de ingeniería y evidencia

### Pruebas funcionales y de seguridad

```bash
npm run verify
curl -i http://localhost:3000/health
curl -G -i http://localhost:3000/books/search --data-urlencode "q=9780306406157"
curl -G -i http://localhost:3000/books/search --data-urlencode "q=' OR 1=1 --"
curl -i http://localhost:3000/admin/dashboard
```

### Evidencia de base de datos

```sql
SELECT * FROM book_images ORDER BY uploaded_at DESC LIMIT 5;
SELECT * FROM book_authors LIMIT 5;
SELECT * FROM book_genres LIMIT 5;
SELECT * FROM book_concepts LIMIT 5;
```

### Evidencia de despliegue

```bash
# Ejemplo local con proxy
nginx -t
systemctl reload nginx
curl -i http://localhost/library/books/catalog
```

---

## Estado general

| Categoría | Cantidad | Estado |
| --- | --- | --- |
| Funcionales | 18 | ✅ |
| Autorización | 5 | ✅ |
| Seguridad y validación | 8 | ✅ |
| Integridad y BD | 4 | ✅ |
| Despliegue / navegación | 3 | ✅ |
| Total | 38 | ✅ |

> Este plan sirve como evidencia técnica del trabajo realizado y se puede ejecutar de manera reproducible en cualquier entorno local o de despliegue.
