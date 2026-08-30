# Pruebas de seguridad y funcionalidad

Estas pruebas son reproducibles y sirven como guía para capturar evidencias del reporte.

## Preparación

```bash
cd E2/library
npm install
npm start
```

La aplicación debe estar disponible en `http://localhost:3000`. Para VM, sustituye la URL por `http://HOST/library`.

## Pruebas HTTP

### Rutas y transporte

```bash
curl -i http://localhost:3000/health
curl -i http://localhost:3000/books/catalog
curl -i http://localhost:3000/library/books/catalog
curl -i http://localhost:3000/library/css/styles.css
curl -i http://localhost:3000/library/js/script.js
```

Resultado esperado: `200` para recursos y catálogo; no debe existir redirección a HTTPS.

### Búsqueda parametrizada

```bash
curl -G -i http://localhost:3000/books/search --data-urlencode "q=Martin"
curl -G -i http://localhost:3000/books/search --data-urlencode "q=9780132350884"
curl -G -i http://localhost:3000/books/search --data-urlencode "q=' OR 1=1 --"
```

Resultado esperado: las dos primeras consultas devuelven coincidencias; el payload SQL no ejecuta SQL ni produce error 500.

### Control de acceso

```bash
curl -i http://localhost:3000/admin/dashboard
curl -i http://localhost:3000/auth/login
```

Resultado esperado: administración exige autenticación y el login responde correctamente.

### Validación de entradas

Probar desde los formularios:

- Login sin usuario o contraseña.
- Registro con contraseñas diferentes.
- Registro con contraseña menor a seis caracteres.
- ISBN duplicado desde el formulario administrativo.
- Archivo de upload que no sea JPEG, PNG o WebP.

Resultado esperado: respuesta controlada, sin stack trace ni inserción inválida.

## Evidencias PostgreSQL

Ejecutar después del esquema, seed base y script de completitud:

```bash
psql -U lib_gsm_user -d gsm_library_db -f db/07_complete_report_data.sql
psql -U lib_gsm_user -d gsm_library_db -f db/08_report_evidence.sql
```

Guardar la salida mostrando:

- Conteos de tablas.
- Cero libros sin autor o género.
- Cero claves foráneas huérfanas.
- Resultados de búsqueda con `ILIKE`.

## Checklist de capturas

- Catálogo en modo claro.
- Catálogo en modo oscuro y botón sol/luna funcionando.
- Selector de género aplicado.
- Detalle con portada real o placeholder local.
- Login y registro.
- Dashboard administrativo autenticado.
- Salida de `08_report_evidence.sql`.
- Salida de las pruebas `curl`.
