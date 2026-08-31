# Library UDEM - Aplicación Monolítica MVC

Aplicación web para la gestión de una librería universitaria construida con **Node.js**, **Express.js**, **PostgreSQL** y **EJS**. Implementa arquitectura monolítica, patrón MVC, y base de datos normalizada a **4FN**.

---

## 🎯 Características Principales

### Autenticación y Autorización
- ✅ Registro de usuarios con validaciones
- ✅ Login seguro con bcrypt (10 rounds)
- ✅ Sesiones persistentes en PostgreSQL
- ✅ Admin único enforced a nivel BD + aplicación
- ✅ Middleware de autorización por rol

### Catálogo de Libros
- ✅ Listado paginado (10 libros por página)
- ✅ Búsqueda avanzada por título, autor, descripción
- ✅ Filtrado por rango de precio
- ✅ Visualización de disponibilidad (stock)
- ✅ Detalles completos: autores, géneros, conceptos

### Administración (Admin)
- ✅ CRUD completo de libros
- ✅ Gestión de autores (N:M)
- ✅ Gestión de géneros (N:M)
- ✅ Upload seguro de portadas (JPEG, PNG, WebP)
- ✅ Gestión de conceptos con definiciones específicas por libro
- ✅ Dashboard con estadísticas de inventario

### Seguridad
- ✅ SQL Injection prevention (queries parametrizadas)
- ✅ XSS prevention (auto-escape EJS)
- ✅ CSRF protection (SameSite cookies)
- ✅ Session fixation prevention (regenerate)
- ✅ File upload validation (MIME + size + secure naming)
- ✅ Helmet security headers
- ✅ CORS controlado
- ✅ Errores sin stack traces en producción

### Base de Datos
- ✅ PostgreSQL 14+
- ✅ Normalización 4FN (Cuarta Forma Normal)
- ✅ ISBN como Primary Key
- ✅ Tablas puente para relaciones N:M
- ✅ Triggers para auditoría automática
- ✅ Stored procedures para lógica compleja
- ✅ Índices estratégicos para performance

---

## 📋 Requisitos Previos

- **Node.js** 18+ ([nodejs.org](https://nodejs.org))
- **PostgreSQL** 14+ ([postgresql.org](https://postgresql.org))
- **Git** (opcional, para clonar repo)
- **npm** (incluido con Node.js)

### Verificar instalación:
```bash
node --version      # v18.0.0 o superior
npm --version       # 9.0.0 o superior
psql --version      # PostgreSQL 14 o superior
```

---

## 🚀 Inicio Rápido

### 1. Clonar o descargar el proyecto
```bash
cd E2/library
```

### 2. Instalar dependencias
```bash
npm install
```

### 3. Configurar base de datos
```bash
# Crear BD y usuario PostgreSQL
psql -U postgres -f db/00_create_database.sql

# Crear esquema, datos, procedimientos, triggers y vistas
psql -U lib_gsm_user -d gsm_library_db -f db/01_schema.sql
psql -U lib_gsm_user -d gsm_library_db -f db/02_seed_100_real_books.sql
psql -U lib_gsm_user -d gsm_library_db -f db/04_stored_procedures.sql
psql -U lib_gsm_user -d gsm_library_db -f db/05_triggers.sql
psql -U lib_gsm_user -d gsm_library_db -f db/06_views.sql
```

### 4. Configurar ambiente
```bash
# Copiar template de configuración
cp .env.example .env

# Editar .env con tus valores
nano .env
# Cambiar: DB_HOST, DB_PASSWORD, SESSION_SECRET
```

### 5. Iniciar servidor
```bash
# Desarrollo (con nodemon auto-reload)
npm run dev

# O producción
npm start
```

### 6. Acceder a la aplicación
```
http://localhost:3000
```

---

## Credenciales Iniciales (Demo)

```
Administrador:
  Username: admin
  Email: admin@library.local
  Password: admin123 (solo demo; cambiar en producción)

Usuarios regulares:
  Username: jdoe, jsmith, mgarcia, alopez, cchen, erodrigue, kmuller, fmartin, rkim
  Password: usuario123 (solo demo; cambiar en producción)
  Emails: john.doe@example.com, jane.smith@example.com, maria.garcia@example.com, etc.
```

**⚠️ IMPORTANTE**: Cambiar contraseñas inmediatamente en producción.

## Despliegue local

```bash
cd E2/library
npm install
psql -U postgres -f db/00_create_database.sql
psql -U lib_gsm_user -d gsm_library_db -f db/01_schema.sql
psql -U lib_gsm_user -d gsm_library_db -f db/02_seed_100_real_books.sql
psql -U lib_gsm_user -d gsm_library_db -f db/04_stored_procedures.sql
psql -U lib_gsm_user -d gsm_library_db -f db/05_triggers.sql
psql -U lib_gsm_user -d gsm_library_db -f db/06_views.sql
# Depurar categorias/autores y completar minimos del reporte
psql -U lib_gsm_user -d gsm_library_db -f db/09_cleanup_real_catalog.sql
psql -U lib_gsm_user -d gsm_library_db -f db/10_repair_book_authors.sql
# Completar mínimos de datos y generar salida para evidencias
psql -U lib_gsm_user -d gsm_library_db -f db/07_complete_report_data.sql
psql -U lib_gsm_user -d gsm_library_db -f db/08_report_evidence.sql
npm start
```

La aplicación queda disponible en `http://localhost:3000`. Para el despliegue detrás de NGINX, publícala bajo `/library` y conserva `PORT`, `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, `DB_PASSWORD` y `SESSION_SECRET` en `.env`.

## Despliegue en GCP con PM2

```bash
sudo apt update && sudo apt install -y nodejs npm postgresql nginx
cd /opt/library/E2/library
npm ci --omit=dev
npm start
sudo npm install -g pm2
pm2 start app.js --name library-udem
pm2 save
pm2 startup
```

Configura NGINX para reenviar `/library/` al puerto de Node y conserva el prefijo al enviar los headers. Los detalles de firewall y proxy están en `docs/GCP_COMMANDS.md`.

## Verificación automática

Con el servidor activo, ejecuta `npm run verify` para comprobar rutas, assets, búsqueda y filtro de género. Las pruebas de seguridad y la lista de capturas están en `docs/SECURITY_TESTS.md`.

---

## 📁 Estructura del Proyecto

```
E2/library/
├── config/
│   └── db.js                    # Pool PostgreSQL
├── middleware/
│   ├── authMiddleware.js        # Autenticación/autorización
│   ├── uploadMiddleware.js      # Validación de uploads
│   └── errorMiddleware.js       # Manejo de errores
├── services/
│   ├── authService.js           # Lógica de autenticación
│   ├── bookService.js           # Lógica de libros
│   └── conceptService.js        # Lógica de conceptos
├── routes/
│   ├── authRoutes.js            # Login/register
│   ├── bookRoutes.js            # Catálogo público
│   ├── adminRoutes.js           # Admin CRUD
│   └── conceptRoutes.js         # Conceptos
├── views/
│   ├── layout.ejs               # Template maestro
│   ├── auth/                    # Login/register
│   ├── books/                   # Catálogo
│   ├── admin/                   # Admin panel
│   └── partials/                # Componentes reutilizables
├── public/
│   ├── css/styles.css           # Estilos personalizados
│   └── js/script.js             # JS cliente
├── uploads/                     # Imágenes de libros
├── db/
│   ├── 00_create_database.sql   # Inicialización
│   ├── 01_schema.sql            # Tablas y esquema
│   ├── 02_seed_30_per_table.sql # Datos de prueba
│   ├── 04_stored_procedures.sql # Procedimientos
│   ├── 05_triggers.sql          # Triggers
│   └── 06_views.sql             # Vistas SQL
├── docs/
│   ├── REQUIREMENTS.md          # Requisitos (RF/RNF)
│   ├── ARCHITECTURE_MONOLITHIC.md
│   ├── ENGINEERING_DECISIONS.md # ADRs
│   ├── NORMALIZATION_4FN.md     # 4FN explicado
│   ├── SECURITY_REVIEW.md       # Seguridad OWASP
│   ├── TEST_PLAN.md             # 75+ casos de prueba
│   ├── GCP_COMMANDS.md          # Despliegue en GCP
│   ├── PROMPT_MAESTRO_IA.md     # Especificación original
│   ├── AI_PROMPT_HISTORY.md     # Conversaciones IA
│   └── AI_CHANGELOG.md          # Registro de cambios
├── app.js                       # Punto de entrada Express
├── package.json                 # Dependencias
├── .env.example                 # Template de configuración
└── README.md                    # Este archivo
```

---

## 🔐 Seguridad

### Implementado:
- SQL Injection: Queries parametrizadas ($1, $2...)
- XSS: Auto-escape EJS
- CSRF: SameSite=Lax cookies
- Session Fixation: HTTP-only secure cookies
- Password Hashing: bcrypt 10 rounds
- Admin Unique: Índice parcial BD + validación
- File Upload: MIME whitelist + size limit + secure naming
- Error Handling: No stack traces en producción
- Helmet: Security headers (HSTS, CSP, XFrame, etc.)

### Auditoría:
- Tabla `audit_log` registra INSERT/UPDATE/DELETE
- Triggers automáticos por tabla
- Valores before/after en JSON

---

## 📊 Base de Datos

### Tablas (12):
- `users` - Administradores y usuarios regulares
- `books` - Libros con ISBN como PK
- `formats` - Tipos de formato (Hardcover, Paperback, etc)
- `authors` - Autores de libros
- `genres` - Géneros literarios
- `book_authors` - N:M (libro-autor)
- `book_genres` - N:M (libro-género)
- `concepts` - Conceptos (IaaS, PaaS, etc)
- `book_concepts` - N:M especial (con definición por libro)
- `book_images` - Portadas e imágenes
- `audit_log` - Registro de cambios
- `session` - Sesiones de usuarios

### Normalización:
- ✅ 1FN: Valores atómicos
- ✅ 2FN: No dependencias parciales
- ✅ 3FN: No dependencias transitivas
- ✅ 4FN: No dependencias multivaluadas

---

## 🧪 Pruebas

### 75 casos de prueba cubiertos:
- Autenticación (12 casos)
- Catálogo (12 casos)
- CRUD Libros (9 casos)
- Imágenes (8 casos)
- Conceptos (7 casos)
- Seguridad (6 casos)
- Integridad de datos (6 casos)
- Performance (5 casos)
- Usabilidad (5 casos)
- Operaciones (5 casos)

Ver: `docs/TEST_PLAN.md`

### Ejecutar pruebas manuales:
```bash
# En desarrollo, verificar funcionalidades en http://localhost:3000
# Ver TEST_PLAN.md para casos específicos
```

---

## 📈 Despliegue en Google Cloud Platform

### Provisionar infraestructura:
```bash
# Todos los comandos en docs/GCP_COMMANDS.md

# Ejemplo: Crear Compute Engine + Cloud SQL
gcloud compute instances create library-app-vm --zone=us-central1-a
gcloud sql instances create library-postgres-db --database-version=POSTGRES_14
```

### Inicializar en VM:
```bash
# Dentro de la VM CentOS Stream 10:
sudo yum update -y
sudo yum install nodejs postgresql -y
cd /opt/library-app
npm install
npm start
```

Ver: `docs/GCP_COMMANDS.md` para instrucciones detalladas.

---

## 📖 Documentación

| Documento | Propósito |
|-----------|-----------|
| `REQUIREMENTS.md` | 50+ requisitos funcionales y no-funcionales |
| `ARCHITECTURE_MONOLITHIC.md` | Diagrama de capas y flujos |
| `ENGINEERING_DECISIONS.md` | 7 Architectural Decision Records (ADRs) |
| `NORMALIZATION_4FN.md` | Justificación 0FN → 4FN |
| `SECURITY_REVIEW.md` | Matriz OWASP con 10+ amenazas mitigadas |
| `TEST_PLAN.md` | 75 casos de prueba |
| `GCP_COMMANDS.md` | Despliegue en Google Cloud |
| `PROMPT_MAESTRO_IA.md` | Especificación original |
| `AI_PROMPT_HISTORY.md` | 12 sesiones de conversación IA |
| `AI_CHANGELOG.md` | Registro de cambios generados |

---

## 🛠️ Desarrollo

### Estructura de código:

```
Request HTTP → Middleware (auth, error) → Routes → Services → DB
                         ↓                                      ↓
                    Context injected              Parameterized SQL query
                                                          ↓
                                               PostgreSQL returns data
                                                          ↓
                         EJS renders template ← Services format response
                                                          ↓
                                            HTTP response (HTML)
```

### Agregar una nueva funcionalidad:

1. **Crear tabla en BD** (`db/01_schema.sql`)
2. **Crear servicio** (`services/newService.js`)
3. **Crear rutas** (`routes/newRoutes.js`)
4. **Crear vistas** (`views/new/`)
5. **Montar en app.js**

### Convenciones de código:

- ✅ Async/await para I/O
- ✅ Queries parametrizadas SIEMPRE
- ✅ Middleware global en app.js
- ✅ Services sin lógica HTTP
- ✅ Views con datos via res.locals
- ✅ Errores via next(error)

---

## 🐛 Troubleshooting

### Error: "Cannot connect to database"
```bash
# Verificar PostgreSQL
sudo service postgresql start

# Verificar usuario y BD
psql -U postgres -l | grep library_db

# Verificar credenciales en .env
cat .env | grep DB_
```

### Error: "Port 3000 already in use"
```bash
# Matar proceso en puerto 3000
lsof -i :3000
kill -9 <PID>

# O cambiar puerto en .env
PORT=3001
```

### Error: "File upload failed"
```bash
# Verificar permisos de directorio
ls -la uploads/
chmod 755 uploads/

# Verificar MIME type whitelist
echo $ALLOWED_MIME_TYPES
```

### Error: "Session table not found"
```bash
# Las sesiones se crean automáticamente
# Si no, ejecutar manualmente:
psql -U library_user -d library_db -c \
  "CREATE TABLE session (sid VARCHAR PRIMARY KEY, sess JSONB, expire TIMESTAMP);"
```

---

## 📋 Checklist Antes de Producción

- [ ] Cambiar todas las contraseñas (.env)
- [ ] Generar nuevo SESSION_SECRET (openssl rand -hex 32)
- [ ] Set NODE_ENV=production
- [ ] Set SESSION_COOKIE_SECURE=true
- [ ] Instalar certificado SSL/HTTPS
- [ ] Configurar backups automáticos BD
- [ ] Verificar CORS_ORIGIN es dominio correcto
- [ ] Desactivar auto-seed (AUTO_SEED_DB=false)
- [ ] Revisar logs y auditoría
- [ ] Pruebas de carga
- [ ] Pruebas de seguridad (OWASP)
- [ ] Preparar plan de recuperación de desastres

---

## 🚀 Performance

### Optimizaciones implementadas:
- Connection pooling (min=2, max=10)
- Índices en PK, FK, title, price
- Paginación (LIMIT 10)
- Vistas SQL para reportes
- STRING_AGG para agregaciones
- Lazy loading de relaciones

### Monitoreo recomendado:
- CPU < 70%
- Memory < 80%
- DB connections activas < 9
- Query time < 100ms

---

## 📞 Soporte y Contribuciones

### Reportar bugs:
1. Describir error en detalle
2. Incluir logs (docs/logs/)
3. Pasos para reproducir

### Solicitar features:
1. Verificar docs/REQUIREMENTS.md
2. Crear issue con descripción
3. Incluir caso de uso

### Contribuir:
1. Fork del proyecto
2. Branch feature (git checkout -b feature/nueva-funcion)
3. Commit cambios (git commit -m 'Agregar ...')
4. Push (git push origin feature/nueva-funcion)
5. Pull request

---

## 📄 Licencia

Proyecto educativo - Universidad.  
Año: 2024  
Semestre: 7mo  
Materia: Integración de Tecnologías Web

---

## 📞 Contacto

**Desarrollador**: GitHub Copilot  
**Usuario**: Estudiante de Ingeniería  
**Institución**: Universidad [Nombre]  
**Profesor**: [Nombre del profesor]

---

## 🎓 Recursos de Aprendizaje

### Tecnologías usadas:
- [Node.js Docs](https://nodejs.org/docs/)
- [Express.js Guide](https://expressjs.com/guide)
- [PostgreSQL Manual](https://www.postgresql.org/docs/)
- [EJS Documentation](https://ejs.co/)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)

### Lecturas recomendadas:
- "Designing Data-Intensive Applications" (Kleppmann)
- "Web Security Academy" (PortSwigger)
- "PostgreSQL Documentation" (Official)

---

## ✅ Conclusión

Aplicación **monolítica, segura y documentada** lista para:
- ✅ Uso educativo
- ✅ Demostraciones
- ✅ Desarrollo adicional
- ✅ Despliegue con ajustes

**Estado**: Versión 1.0 - Completado según especificación  
**Última actualización**: Febrero 2024

---

**Gracias por usar esta aplicación. ¡Happy coding! 🚀**
