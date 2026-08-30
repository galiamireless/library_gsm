// ===================================================================
// Servicio de Conceptos y Definiciones
// Gestión de conceptos asociados a libros
// ===================================================================

const db = require('../config/db');

// Obtener todos los conceptos
async function getAllConcepts() {
    try {
        const result = await db.query(
            `SELECT concept_id, name, description FROM concepts ORDER BY name ASC`
        );

        return {
            success: true,
            concepts: result.rows
        };
    } catch (error) {
        return {
            success: false,
            error: error.message
        };
    }
}

// Obtener concepto por ID
async function getConceptById(conceptId) {
    try {
        const result = await db.query(
            `SELECT concept_id, name, description FROM concepts WHERE concept_id = $1`,
            [conceptId]
        );

        if (result.rows.length === 0) {
            throw new Error('Concept not found');
        }

        return {
            success: true,
            concept: result.rows[0]
        };
    } catch (error) {
        return {
            success: false,
            error: error.message
        };
    }
}

// Obtener conceptos de un libro con sus definiciones
async function getBookConcepts(isbn) {
    try {
        const result = await db.query(
            `SELECT 
                c.concept_id,
                c.name as concept_name,
                bc.definition,
                bc.created_at
            FROM concepts c
            INNER JOIN book_concepts bc ON c.concept_id = bc.concept_id
            WHERE bc.isbn = $1
            ORDER BY c.name ASC`,
            [isbn]
        );

        return {
            success: true,
            concepts: result.rows,
            count: result.rows.length
        };
    } catch (error) {
        return {
            success: false,
            error: error.message
        };
    }
}

// Crear nuevo concepto
async function createConcept(name, description) {
    try {
        if (!name) {
            throw new Error('Concept name is required');
        }

        // Verificar si ya existe
        const existingConcept = await db.query(
            `SELECT concept_id FROM concepts WHERE LOWER(name) = LOWER($1)`,
            [name]
        );

        if (existingConcept.rows.length > 0) {
            throw new Error('Concept already exists');
        }

        const result = await db.query(
            `INSERT INTO concepts (name, description) VALUES ($1, $2) RETURNING concept_id, name, description`,
            [name, description]
        );

        return {
            success: true,
            concept: result.rows[0]
        };
    } catch (error) {
        return {
            success: false,
            error: error.message
        };
    }
}

// Actualizar concepto
async function updateConcept(conceptId, name, description) {
    try {
        if (!name) {
            throw new Error('Concept name is required');
        }

        const result = await db.query(
            `UPDATE concepts SET name = $1, description = $2 WHERE concept_id = $3
            RETURNING concept_id, name, description`,
            [name, description, conceptId]
        );

        if (result.rows.length === 0) {
            throw new Error('Concept not found');
        }

        return {
            success: true,
            concept: result.rows[0]
        };
    } catch (error) {
        return {
            success: false,
            error: error.message
        };
    }
}

// Eliminar concepto
async function deleteConcept(conceptId) {
    try {
        const result = await db.query(
            `DELETE FROM concepts WHERE concept_id = $1 RETURNING concept_id`,
            [conceptId]
        );

        if (result.rows.length === 0) {
            throw new Error('Concept not found');
        }

        return {
            success: true,
            message: 'Concept deleted successfully'
        };
    } catch (error) {
        return {
            success: false,
            error: error.message
        };
    }
}

// Agregar concepto a un libro con definición específica
async function addConceptToBook(isbn, conceptId, definition) {
    try {
        if (!definition) {
            throw new Error('Definition is required');
        }

        // Verificar que el libro existe
        const bookCheck = await db.query(`SELECT isbn FROM books WHERE isbn = $1`, [isbn]);
        if (bookCheck.rows.length === 0) {
            throw new Error('Book not found');
        }

        // Verificar que el concepto existe
        const conceptCheck = await db.query(
            `SELECT concept_id FROM concepts WHERE concept_id = $1`,
            [conceptId]
        );
        if (conceptCheck.rows.length === 0) {
            throw new Error('Concept not found');
        }

        const result = await db.query(
            `INSERT INTO book_concepts (isbn, concept_id, definition) VALUES ($1, $2, $3)
            RETURNING isbn, concept_id`,
            [isbn, conceptId, definition]
        );

        return {
            success: true,
            message: 'Concept added to book'
        };
    } catch (error) {
        return {
            success: false,
            error: error.message
        };
    }
}

// Actualizar definición de concepto en un libro
async function updateBookConceptDefinition(isbn, conceptId, definition) {
    try {
        if (!definition) {
            throw new Error('Definition is required');
        }

        const result = await db.query(
            `UPDATE book_concepts SET definition = $1 WHERE isbn = $2 AND concept_id = $3
            RETURNING isbn, concept_id`,
            [definition, isbn, conceptId]
        );

        if (result.rows.length === 0) {
            throw new Error('Book concept not found');
        }

        return {
            success: true,
            message: 'Definition updated successfully'
        };
    } catch (error) {
        return {
            success: false,
            error: error.message
        };
    }
}

// Eliminar concepto de un libro
async function removeConceptFromBook(isbn, conceptId) {
    try {
        const result = await db.query(
            `DELETE FROM book_concepts WHERE isbn = $1 AND concept_id = $2
            RETURNING isbn, concept_id`,
            [isbn, conceptId]
        );

        if (result.rows.length === 0) {
            throw new Error('Book concept not found');
        }

        return {
            success: true,
            message: 'Concept removed from book'
        };
    } catch (error) {
        return {
            success: false,
            error: error.message
        };
    }
}

// Buscar conceptos por nombre
async function searchConcepts(searchTerm) {
    try {
        const searchPattern = `%${searchTerm}%`;

        const result = await db.query(
            `SELECT concept_id, name, description FROM concepts 
            WHERE LOWER(name) LIKE LOWER($1) OR LOWER(description) LIKE LOWER($1)
            ORDER BY name ASC`,
            [searchPattern]
        );

        return {
            success: true,
            concepts: result.rows
        };
    } catch (error) {
        return {
            success: false,
            error: error.message
        };
    }
}

module.exports = {
    getAllConcepts,
    getConceptById,
    getBookConcepts,
    createConcept,
    updateConcept,
    deleteConcept,
    addConceptToBook,
    updateBookConceptDefinition,
    removeConceptFromBook,
    searchConcepts
};
