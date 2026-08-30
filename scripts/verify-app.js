const baseUrl = process.env.APP_URL || 'http://localhost:3000';

const checks = [
    ['health', '/health', 200],
    ['catalog', '/books/catalog', 200],
    ['prefixed catalog', '/library/books/catalog', 200],
    ['styles', '/library/css/styles.css', 200],
    ['client script', '/library/js/script.js', 200],
    ['placeholder', '/library/images/default-cover.svg', 200],
    ['author search', '/library/books/search?q=Martin', 200],
    ['category filter', '/library/books/catalog?category=Programming', 200]
];

(async () => {
    let failures = 0;
    for (const [name, route, expectedStatus] of checks) {
        const response = await fetch(`${baseUrl}${route}`, { redirect: 'manual' });
        const location = response.headers.get('location') || '';
        const passed = response.status === expectedStatus && !location.startsWith('https://');
        console.log(`${passed ? 'PASS' : 'FAIL'} ${name}: ${response.status}${location ? ` -> ${location}` : ''}`);
        if (!passed) failures += 1;
    }

    if (failures > 0) {
        process.exitCode = 1;
    }
})();
