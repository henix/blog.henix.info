(function() {

function removeEnd(s, suffix) {
	if (s.endsWith(suffix)) {
		return s.substring(0, s.length - suffix.length);
	} else {
		return s;
	}
}

function splitLines(content) {
	// 对空串直接 split 会得到一个由空串构成的数组，但实际希望得到空数组
	if (content) {
		return removeEnd(content, "\n").split("\n");
	} else {
		return [];
	}
}

function frag() {
	var elem = document.createDocumentFragment();
	for (var i = 0; i < arguments.length; i++) {
		var child = arguments[i];
		if (Array.isArray(child)) {
			for (var j = 0; j < child.length; j++) {
				elem.appendChild(child[j]);
			}
		} else {
			elem.appendChild(child);
		}
	}
	return elem;
}

function h(tag, attrs) {
	function toNode(e) {
		if (typeof e == "string") {
			return document.createTextNode(e);
		}
		else if (Array.isArray(e)) {
			return frag(e);
		}
		else {
			return e;
		}
	}
	var elem = document.createElement(tag);
	if (attrs) {
		if (typeof attrs == "string" || attrs instanceof HTMLElement || Array.isArray(attrs)) {
			elem.appendChild(toNode(attrs));
		} else {
			for (var k in attrs) {
				var v = attrs[k];
				if (v != null) {
					elem.setAttribute(k, v);
				}
			}
		}
	}
	for (var i = 2; i < arguments.length; i++) {
		elem.appendChild(toNode(arguments[i]));
	}
	return elem;
}

function ajax(method, url, onResult) {
	var xhr = new XMLHttpRequest();
	xhr.open(method, url);
	xhr.onload = function() {
		if (this.status == 200) {
			onResult(null, this.response);
		} else {
			var e = new Error();
			e.name = "ServerError";
			e.status = this.status;
			e.response = this.response;
			onResult(e);
		}
	};
	xhr.onerror = function() {
		var e = new Error();
		e.name = "XHRError";
		e.status = 0;
		e.response = "";
		onResult(e);
	};
	xhr.send();
}

var COMMENT_MAIL = ["blog", "henix.info"].join("@");
var PROVIDER_KEY = "email_provider";

/**
 * https://tools.ietf.org/html/rfc6068
 */
function getMailLink(id, to, subject, body) {
	function encodeParams(params) {
		var ar = [];
		for (var k in params) {
			ar.push(k + "=" + encodeURIComponent(params[k]));
		}
		return ar.join("&");
	}
	var mailto = "mailto:" + to + "?" + encodeParams({ subject: subject, body: body });
	switch (id) {
		case "mailto":
			return mailto;
		case "gmail":
			return "https://mail.google.com/mail/?extsrc=mailto&url=" + encodeURIComponent(mailto);
		case "outlook":
			return "https://outlook.live.com/mail/deeplink/compose?" + encodeParams({ to: to, subject: subject, body: body });
		case "qq":
			// TODO: 将 subject 按 GB18030 编码
			var delegate_url = "/cgi-bin/readtemplate?t=compose&" + encodeParams({ toemail: to, initsubject: subject });
			return "https://mail.qq.com/cgi-bin/loginpage?" + encodeParams({ delegate_url: delegate_url });
		case "yahoo":
			return "https://compose.mail.yahoo.com/?" + encodeParams({ to: to, subject: subject, body: body });
		case "yandex":
			return "https://mail.yandex.com/compose?mailto=" + encodeURIComponent(mailto);
		default:
			return "";
	}
}

Array.from(document.querySelectorAll(".-CommentPane")).forEach(function(elem) {
	var urlPrefix = "/comment";
	var blogId = elem.getAttribute("data-id") || "";
	var blogTitle = elem.getAttribute("blog-title") || "";

	var provider = localStorage.getItem(PROVIDER_KEY) || "other";
	var viewed = false;

	var select = (function() {
		function po(id, name) {
			var attrs = { value: id };
			if (id == provider) {
				attrs.selected = "";
			}
			return h("option", attrs, name);
		}
		return h("select",
			po("other", "手动"),
			h("optgroup", { label: "自动跳转" },
				po("mailto", "系统默认"),
				po("gmail", "GMail"),
				po("outlook", "Outlook"),
				// po("qq", "QQ"),
				po("yahoo", "Yahoo"),
				po("yandex", "Yandex")));
	})();
	var submitBut = h("button", "写评论");
	var mailspecTitle = h("input", { type: "text", value: "[评论] " + blogTitle, "readonly": "" });
	var mailspec = (function() {
		var copyButton = h("a", { href: "javascript:;" }, "[复制]");
		copyButton.addEventListener("click", function() {
			mailspecTitle.select();
			document.execCommand("copy");
		});
		return h("blockquote", { "class": "comment-mailspec", "style": "display:" + (provider == "other" ? "block" : "none") },
			"请按照如下格式发邮件：", h("br"),
			h("span", { "class": "field-name" }, "收件人"), h("a", { href: "mailto:" + COMMENT_MAIL }, COMMENT_MAIL), h("br"),
			h("span", { "class": "field-name" }, "标题"), mailspecTitle, copyButton, h("br"),
			h("span", { "class": "field-name" }, "正文"), "评论 / 回复内容，只支持纯文本", h("br"),
			h("span", { "class": "field-name" }, "说明"), "评论用户名为你在邮箱中设置的用户名");
	})();
	var commentList = h("div", { "class": "comment-list" });

	select.addEventListener("change", function() {
		provider = this.value;
		mailspec.style.display = provider == "other" ? "block" : "none";
		localStorage.setItem(PROVIDER_KEY, provider);
	});

	function doComment(subject) {
		if (provider == "other") {
			mailspecTitle.value = subject;
			mailspec.scrollIntoView({ behavior: "smooth" }); // TODO: 浏览器兼容性
		} else {
			window.open(getMailLink(provider, COMMENT_MAIL, subject, "正文只支持纯文本格式，可在编辑器中设置"), "_blank");
		}
	}
	function reply(id) {
		doComment("[回复] " + blogTitle + " #" + id);
	}

	submitBut.addEventListener("click", function() {
		doComment("[评论] " + blogTitle);
	});

	elem.appendChild(frag(
			h("div", { "class": "comment-form" },
				"评论模式 ",
				select,
				" ",
				submitBut,
				" ",
				h("a", { href: "/help.html" }, "评论帮助")),
			mailspec,
			commentList
	));

	function onView() {
		if (!viewed) {
			viewed = true;
			commentList.textContent = "评论加载中";
			ajax("GET", urlPrefix + "/" + blogId + ".tsv", function(err, resp) {
				if (err) {
					var errMsg = err.status == 404 ? "暂无评论" : "评论加载出错";
					commentList.textContent = errMsg;
					return;
				}
					// comment id -> { date, uid, name, content }
					var comments = {};
					// comment id -> child comment id
					var childs = {};
					childs[""] = [];
					// uid -> [function]
					var urlCallbacks = {};
					function addUrlCallback(uid, f) {
						if (!urlCallbacks[uid]) {
							urlCallbacks[uid] = [];
						}
						urlCallbacks[uid].push(f);
					}
					splitLines(resp).forEach(function(line) {
						// id, date, uid, name, content, replyTo
						var ar = line.split("\t");
						var id = ar[0];
						var replyTo = ar[5];
						var content = ar[4].replace(/\\[trn\\]/g, function(m) {
							switch (m) {
								case "\\t": return "\t";
								case "\\r": return "\r";
								case "\\n": return "\n";
								case "\\\\": return "\\";
								default: return m;
							}
						});
						var comment = { date: ar[1], uid: ar[2], name: ar[3], content: content };
						comments[id] = comment;
						childs[id] = [];
						childs[replyTo].unshift(id);
					});
					function renderComment(id) {
						var comment = comments[id];
						var isDeleted = !comment.date;
						var commentHeader = (function() {
							if (!isDeleted) {
								var replyButton = h("a", { "class": "comment-reply-button", href: "javascript:;" }, "[回复]");
								replyButton.addEventListener("click", function() {
									reply(id);
								});
								var uid = comment.uid;
								var userSpan = (function() {
									var name = comment.name;
									if (uid.startsWith("disqus:")) {
										var disqusUid = uid.substring("disqus:".length);
										return h("span", { "class": "comment-user", title: uid }, h("a", { href: "https://disqus.com/by/" + disqusUid + "/", target: "_blank" }, name));
									} else if (!uid) {
										// 通过 disqus 发表的匿名评论没有 uid
										return h("span", { "class": "comment-user" }, name);
									} else {
										var span = h("span", { "class": "comment-user", title: "ID: " + uid }, name);
										// 后期更新 uid -> url
										addUrlCallback(uid, function(url) {
											var link = h("a", { href: url, target: "_blank" }, name);
											span.innerHTML = "";
											span.appendChild(link);
										});
										return span;
									}
								})();
								return h("div", { "class": "comment-header" }, userSpan, h("span", { "class": "comment-date" }, comment.date), replyButton);
							} else {
								var elem = h("div", { "class": "comment-header deleted" });
								elem.innerHTML = "&nbsp;";
								return elem;
							}
						})();
						var elem = h("div", { "class": "comment", "id": "comment-" + id },
							commentHeader,
							h("div", { "class": "comment-content" + (isDeleted ? " deleted" : "") }, isDeleted ? "此评论已被删除" : comment.content)
						);
						if (childs[id].length > 0) {
							elem.appendChild(h("div", { "class": "comment-reply-list" }, childs[id].map(renderComment)));
						}
						return elem;
					} // renderComment
					commentList.innerHTML = "";
					commentList.appendChild(frag(childs[""].map(renderComment)));
					// 渲染完后请求 uid -> url 数据
					ajax("GET", urlPrefix + "/_user.tsv", function(err, resp) {
						if (!err) {
							splitLines(resp).forEach(function(line) {
								var ar = line.split("\t");
								var callbacks = urlCallbacks[ar[0]];
								if (callbacks) {
									for (var i = 0; i < callbacks.length; i++) {
										callbacks[i](ar[1]);
									}
								}
							});
						}
					});
			});
		}
	}

	if (location.hash && location.hash.startsWith("#comment-")) {
		onView();
	} else {
		new IntersectionObserver(function(entries, observer) {
			entries.forEach(function(entry) {
				if (entry.intersectionRatio > 0) {
					observer.unobserve(entry.target);
					onView();
				}
			});
		}).observe(elem);
	}
});

})();
