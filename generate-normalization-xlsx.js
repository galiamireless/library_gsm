const path = require('path');
const fs = require('fs');

const target = path.join(__dirname, 'scripts', 'generate-normalization-xlsx.js');

if (!fs.existsSync(target)) {
  console.error('No se encontró el generador principal en scripts/generate-normalization-xlsx.js');
  process.exit(1);
}

require(target);
