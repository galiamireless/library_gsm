document.addEventListener('DOMContentLoaded', () => {
    const root = document.documentElement;
    const themeToggle = document.getElementById('themeToggle');
    const themeIcon = document.getElementById('themeIcon');
    const baseUrl = root.dataset.baseUrl || '';

    const setTheme = (theme) => {
        const selectedTheme = theme === 'dark' ? 'dark' : 'light';
        root.setAttribute('data-theme', selectedTheme);
        if (themeIcon) {
            themeIcon.className = selectedTheme === 'dark' ? 'fa-solid fa-sun' : 'fa-solid fa-moon';
        }
    };

    setTheme(localStorage.getItem('theme') || 'light');

    if (themeToggle) {
        themeToggle.addEventListener('click', () => {
            const nextTheme = root.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
            localStorage.setItem('theme', nextTheme);
            setTheme(nextTheme);
        });
    }

    const searchInput = document.getElementById('searchInput');
    const searchForm = document.getElementById('catalogSearchForm');
    if (!searchInput || !searchForm) return;

    let debounceTimer;
    searchInput.addEventListener('input', () => {
        clearTimeout(debounceTimer);
        const value = searchInput.value.trim();
        if (!value) return;

        debounceTimer = setTimeout(() => {
            const searchUrl = new URL(`${baseUrl}/books/search`, window.location.origin);
            searchUrl.searchParams.set('q', value);
            window.location.assign(searchUrl.href);
        }, 300);
    });
});
