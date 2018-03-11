[].slice.call(document.querySelectorAll(".-Valid")).forEach(function(elem) {
	elem.setAttribute("href", "https://validator.w3.org/check?uri=" + encodeURIComponent(location.href));
});
