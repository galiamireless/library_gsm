// ===================================================================
// Middleware de Carga de Archivos (Multer)
// Validación de tipos MIME, tamaño y almacenamiento seguro
// ===================================================================

const multer = require('multer');
const path = require('path');
const crypto = require('crypto');

const allowedMimeTypes = new Map([
    ['image/jpeg', '.jpg'],
    ['image/png', '.png'],
    ['image/webp', '.webp']
]);

const allowedExtensions = new Set(['.jpg', '.jpeg', '.png', '.webp']);
const maxFileSize = parseInt(process.env.MAX_FILE_SIZE) || 2 * 1024 * 1024;

const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, path.join(__dirname, '../uploads'));
    },
    filename: (req, file, cb) => {
        const mimeType = file.mimetype.toLowerCase();
        const extension = allowedMimeTypes.get(mimeType) || '.jpg';
        const safeToken = crypto.randomBytes(12).toString('hex');
        cb(null, `${Date.now()}-${safeToken}${extension}`);
    }
});

const fileFilter = (req, file, cb) => {
    const mimeType = file.mimetype ? file.mimetype.toLowerCase() : '';
    const extension = path.extname(file.originalname || '').toLowerCase();

    if (!allowedMimeTypes.has(mimeType) || !allowedExtensions.has(extension)) {
        return cb(new Error('Invalid file type: only JPG, PNG and WebP are allowed.'), false);
    }

    cb(null, true);
};

const uploadMiddleware = multer({
    storage,
    fileFilter,
    limits: {
        fileSize: maxFileSize,
        files: 1
    }
});

const handleUploadError = (err, req, res, next) => {
    if (err instanceof multer.MulterError) {
        if (err.code === 'FILE_TOO_LARGE') {
            return res.status(400).json({
                success: false,
                message: `File size exceeds the maximum of ${Math.round(maxFileSize / (1024 * 1024))}MB.`
            });
        }
        if (err.code === 'LIMIT_FILE_COUNT') {
            return res.status(400).json({
                success: false,
                message: 'Only one file is allowed at a time.'
            });
        }
    }

    if (err) {
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
    handleUploadError,
    allowedMimeTypes,
    maxFileSize
};
