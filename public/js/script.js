(function () {
    const html = document.documentElement;
    const toggle = document.getElementById('themeToggle');
    const themeIcon = document.getElementById('themeIcon');

    const applyTheme = (theme) => {
        const resolvedTheme = theme === 'dark' ? 'dark' : 'light';
        html.setAttribute('data-theme', resolvedTheme);

        if (themeIcon) {
            themeIcon.className = resolvedTheme === 'dark'
                ? 'fa-solid fa-sun'
                : 'fa-solid fa-moon';
        }
    };

    const savedTheme = localStorage.getItem('library-theme');
    if (savedTheme) {
        applyTheme(savedTheme);
    } else {
        const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
        applyTheme(prefersDark ? 'dark' : 'light');
    }

    if (toggle) {
        toggle.addEventListener('click', () => {
            const currentTheme = html.getAttribute('data-theme') === 'dark' ? 'dark' : 'light';
            const nextTheme = currentTheme === 'dark' ? 'light' : 'dark';
            localStorage.setItem('library-theme', nextTheme);
            applyTheme(nextTheme);
        });
    }

    const searchInput = document.getElementById('searchInput');
    const searchForm = document.getElementById('catalogSearchForm');

    if (searchInput && searchForm) {
        let debounceTimer = null;

        const submitIfValue = () => {
            const value = searchInput.value.trim();
            if (!value) {
                return;
            }
            searchForm.submit();
        };

        searchInput.addEventListener('input', () => {
            clearTimeout(debounceTimer);
            debounceTimer = setTimeout(() => {
                const value = searchInput.value.trim();
                if (!value) {
                    return;
                }

                const url = new URL(window.location.href);
                url.pathname = '/books/search';
                url.searchParams.set('q', value);
                window.history.pushState({}, '', url);
                fetch(url, { method: 'GET', headers: { Accept: 'text/html' } })
                    .then((response) => response.text())
                    .then((htmlText) => {
                        const temp = document.createElement('html');
                        temp.innerHTML = htmlText;
                        const pageContent = temp.querySelector('body');
                        if (pageContent) {
                            document.body.innerHTML = pageContent.innerHTML;
                        }
                    })
                    .catch(() => {
                        submitIfValue();
                    });
            }, 300);
        });
    }
})();
