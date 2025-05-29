"use strict";
// img lazy-load
(function() {
	var observer = new IntersectionObserver(function(entries, observer) {
		entries.forEach(function(entry) {
			// 因为最开始当 intersectionRatio = 0 时也会触发回调，故必须加上判断
			if (entry.intersectionRatio > 0) {
				var elem = entry.target;
				observer.unobserve(elem);
				var src = elem.getAttribute("data-src");
				elem.removeAttribute("data-src");
				if (window.URL && URL.createObjectURL) {
					// IE 10+
					var xhr = new XMLHttpRequest();
					xhr.open("GET", src);
					xhr.responseType = "blob";
					xhr.onreadystatechange = function() {
						if (this.readyState == XMLHttpRequest.DONE) {
							if (this.status == 200) {
								var url = URL.createObjectURL(xhr.response);
								elem.setAttribute("src", url);
							}
						}
					};
					xhr.send();
				} else {
					elem.setAttribute("src", src);
				}
			}
		});
	}, { threshold: 0.05 });
	Array.from(document.querySelectorAll("img[data-src]")).forEach(function(elem) {
		observer.observe(elem);
	});
})();
