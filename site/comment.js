"use strict";
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

function ajax(method, url, onResult, body) {
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
	if (body != null) {
		xhr.send(body);
	} else {
		xhr.send();
	}
}

function genRandomID() {
	return Math.round(Math.random() * 4294967296).toString(36);
}

function formatDate(d) {
	function pad2(x) {
		return ((x < 10) ? "0" : "") + x;
	}
	return d.getFullYear() + "-" + pad2(d.getMonth() + 1) + "-" + pad2(d.getDate());
}

var USERNAME_KEY = "username";
var EMAIL_KEY = "email";
var WEBSITE_KEY = "website";

Array.from(document.querySelectorAll(".-CommentPane")).forEach(function(elem) {
	var blogId = elem.getAttribute("data-id") || "";

	// 定义组件

	/**
	 * @param {{ id, date, name, url, content, replyTo, childs }} comment
	 */
	function Comment(comment) {
		var isDeleted = !comment.date;
		var replyList = h("div", { "class": "comment-reply-list" });
		var commentHeader = (function() {
			if (!isDeleted) {
				var replyButton = h("a", { "class": "comment-reply-button", href: "javascript:;" }, "[回复]");
				var replyForm = null;
				replyButton.addEventListener("click", function() {
					if (!replyForm) {
						replyForm = CommentForm(comment.id, comment.name, replyList);
						replyList.insertBefore(replyForm, replyList.firstChild);
						replyButton.textContent = "[取消回复]";
					} else {
						replyList.removeChild(replyForm);
						replyForm = null;
						replyButton.textContent = "[回复]";
					}
				});
				var userSpan = (function() {
					var link = comment.name;
					if (comment.url) {
						link = h("a", { href: comment.url, target: "_blank" }, link);
					}
					return h("span", { "class": "comment-user" }, link);
				})();
				return h("div", { "class": "comment-header" }, userSpan, h("span", { "class": "comment-date" }, comment.date), replyButton);
			} else {
				var elem = h("div", { "class": "comment-header deleted" });
				elem.innerHTML = "&nbsp;";
				return elem;
			}
		})();
		var elem = h("div", { "class": "comment", "id": "comment-" + comment.id },
			commentHeader,
			h("div", { "class": "comment-content" + (isDeleted ? " deleted" : "") }, isDeleted ? "此评论已被删除" : comment.content)
		);
		if (comment.childs.length > 0) {
			replyList.appendChild(frag(comment.childs.map(Comment)));
		}
		elem.appendChild(replyList);
		return elem;
	}

	/**
	 * @param {string} replyTo
	 * @param {HTMLElement} container
	 * @returns
	 */
	function CommentForm(replyTo, replyName, container) {
		var submitButt = h("button", { type: "submit" }, "发表" + (replyTo ? "回复" : "评论"));
		var errorPanel = h("div", { "class": "error-panel" });
		var form = (function() {
			var contentID = "content-" + genRandomID();
			var nameID = "name-" + genRandomID();
			var emailID = "email-" + genRandomID();
			var urlID = "url-" + genRandomID();
			return h("form", { "class": "comment-form" },
				h("input", { type: "hidden", name: "post_id", value: blogId }),
				h("input", { type: "hidden", name: "reply_to", value: replyTo || "" }),
				h("div",
					h("label", { "for": contentID }, replyTo ? "回复" : "评论"),
					h("textarea", { id: contentID, name: "content", placeholder: replyTo ? "回复 " + replyName : "说点什么", required: "", maxlength: 2046 })
				),
				h("div",
					h("label", { "for": nameID }, "名字"),
					h("input", { type: "text", id: nameID, name: "uname", placeholder: "必填", required: "", maxlength: 31, value: localStorage.getItem(USERNAME_KEY) || "" })
				),
				h("div",
					h("label", { "for": emailID }, "邮箱"),
					h("input", { type: "email", id: emailID, name: "email", placeholder: "必填，不会公开", required: "", maxlength: 63, value: localStorage.getItem(EMAIL_KEY) || "" })
				),
				h("div",
					h("label", { "for": urlID }, "主页"),
					h("input", { type: "url", id: urlID, name: "url", placeholder: "选填", maxlength: 127, value: localStorage.getItem(WEBSITE_KEY) || "" })
				),
				errorPanel,
				h("div",
					h("label"),
					submitButt,
				)
			);
		})();
		form.addEventListener("submit", function(event) {
			event.preventDefault();
			submitButt.disabled = true;
			ajax("POST", "/api/comment", function(err, resp) {
				submitButt.disabled = false;
				localStorage.setItem(USERNAME_KEY, form.uname.value);
				localStorage.setItem(EMAIL_KEY, form.email.value);
				localStorage.setItem(WEBSITE_KEY, form.url.value);
				if (err) {
					// 错误：显示提示
					var msg;
					if (err.name == "ServerError") {
						msg = err.response;
					} else {
						msg = "网络错误";
					}
					errorPanel.textContent = msg;
					return;
				}
				// 成功：构造 comment 并插入
				var commentElem = Comment({
					id: resp,
					date: formatDate(new Date()),
					name: form.uname.value,
					url: form.url.value,
					content: form.content.value,
					replyTo: replyTo,
					childs: [],
				});
				container.insertBefore(commentElem, container.firstChild);
				commentElem.scrollIntoView({ behavior: "smooth" });
				if (replyTo) {
					// 删除自身
					form.parentNode.removeChild(form);
				} else {
					form.content.value = "";
					errorPanel.innerHTML = "";
				}
			}, new URLSearchParams(new FormData(form)));
		});
		return form;
	}

	var commentList = h("div", { "class": "comment-list" });

	elem.appendChild(frag(
		commentList,
		CommentForm("", "", commentList)
	));

	var viewed = false;
	function onView() {
		if (viewed) return;
		viewed = true;
		commentList.textContent = "评论加载中";
		ajax("GET", "/comment/" + blogId + ".tsv", function(err, resp) {
			if (err) {
				var errMsg = err.status == 404 ? "暂无评论" : "评论加载出错";
				commentList.textContent = errMsg;
				return;
			}
			// comment id -> { id, date, name, url, content }
			var comments = {};
			// comment id -> child comment id
			var childs = {};
			childs[""] = [];
			splitLines(resp).forEach(function(line) {
				// id, date, name, url, content, replyTo
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
				var comment = { id: id, date: ar[1], name: ar[2], url: ar[3], content: content, childs: [] };
				comments[id] = comment;
				childs[id] = [];
				childs[replyTo].unshift(id);
			});
			// 将 comments + childs 扩展成树结构
			function expandComment(id) {
				var comment = comments[id];
				comment.childs = childs[id].map(expandComment);
				return comment;
			}
			commentList.innerHTML = "";
			commentList.appendChild(frag(childs[""].map(expandComment).map(Comment)));
		});
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
