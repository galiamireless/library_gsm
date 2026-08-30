// Redirecciones globales principales
app.get('/', (req, res) => res.redirect('/library/books/catalog'));
app.get('/library', (req, res) => res.redirect('/library/books/catalog'));
app.get('/books', (req, res) => res.redirect('/library/books/catalog'));

// Asegurar montaje de las rutas de libros
// (Ajusta la ruta de require según el nombre de tu archivo de rutas)
const bookRoutes = require('./routes/bookRoutes'); 
app.use('/library/books', bookRoutes);
app.use('/books', bookRoutes);

// Manejador de rutas no encontradas (404)
app.use((req, res, next) => {
    const err = new Error('La página o recurso solicitado no existe.');
    err.status = 404;
    next(err);
});