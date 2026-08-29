// ===================================================================
// Middleware de Carga de Archivos (Multer)
// Validación de tipos MIME, tamaño y almacenamiento seguro
// ===================================================================

const multer = require('multer');
const path = require('path');
const crypto = require('crypto');

// Configuración de almacenamiento
const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        // Los archivos se guardan en la carpeta 'uploads'
        cb(null, path.join(__dirname, '../uploads'));
    },
    filename: (req, file, cb) => {
        // Generar nombre de archivo seguro: hash_timestamp_original
        const uniqueSuffix = Date.now() + '-' + crypto.randomBytes(6).toString('hex');
        const ext = path.extname(file.originalname);
        const name = path.basename(file.originalname, ext);
        cb(null, `${name}-${uniqueSuffix}${ext}`);
    }
});

// Filtro de tipos MIME permitidos
const fileFilter = (req, file, cb) => {
    // Tipos MIME permitidos
    const allowedMimes = process.env.ALLOWED_MIME_TYPES?.split(',') || 
                         ['image/jpeg', 'image/png', 'image/webp'];

    if (allowedMimes.includes(file.mimetype)) {
        cb(null, true);
    } else {
        cb(new Error(`Invalid file type: ${file.mimetype}. Allowed: JPEG, PNG, WebP`), false);
    }
};

// Crear instancia de multer con límites
const uploadMiddleware = multer({
    storage: storage,
    fileFilter: fileFilter,
    limits: {
        fileSize: parseInt(process.env.MAX_FILE_SIZE) || 2 * 1024 * 1024, // 2MB por defecto
        files: 1 // Un archivo por vez
    }
});

// Middleware: Manejo de errores de carga
const handleUploadError = (err, req, res, next) => {
    if (err instanceof multer.MulterError) {
        if (err.code === 'FILE_TOO_LARGE') {
            return res.status(400).json({
                success: false,
                message: 'File size exceeds maximum limit of 2MB'
            });
        }
        if (err.code === 'LIMIT_FILE_COUNT') {
            return res.status(400).json({
                success: false,
                message: 'Only one file is allowed'
            });
        }
    } else if (err) {
        return res.status(400).json({
            success: false,
            message: err.message
        });
    }
    next();
};

module.exports = {
    uploadSingle: uploadMiddleware.single('image'),
    uploadMultiple: uploadMiddleware.array('images', 5),
    handleUploadError
};
