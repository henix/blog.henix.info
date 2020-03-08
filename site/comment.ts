declare class XDomainRequest extends XMLHttpRequest {}

function removeEnd(s: string, suffix: string): string {
	if (s.endsWith(suffix)) {
		return s.substring(0, s.length - suffix.length);
	} else {
		return s;
	}
}

function splitLines(content: string): string[] {
	// 对空串直接 split 会得到一个由空串构成的数组，但实际希望得到空数组
	if (content) {
		return removeEnd(content, "\n").split("\n");
	} else {
		return [];
	}
}

type ValueChanged<V> = {
	key: string,
	value: V,
};

class ListenableMap<V> {
	private map: { [k: string]: V } = {};
	private changeListeners: { [k: string]: ((_: ValueChanged<V>) => void)[] } = {};
	onChange(k: string, f: (_: ValueChanged<V>) => void) {
		let fs = this.changeListeners[k];
		if (!fs) {
			fs = [];
			this.changeListeners[k] = fs;
		}
		fs.push(f);
	}
	get(k: string): V | undefined {
		return this.map[k];
	}
	set(k: string, v: V) {
		this.map[k] = v;
		const fs = this.changeListeners[k];
		if (fs) {
			for (const f of fs) {
				f({ key: k, value: v });
			}
		}
	}
}

function frag(...childs: (HTMLElement | HTMLElement[])[]): DocumentFragment;
function frag(): DocumentFragment {
	const elem = document.createDocumentFragment();
	for (let i = 0; i < arguments.length; i++) {
		const child: HTMLElement[] | HTMLElement = arguments[i];
		if (Array.isArray(child)) {
			for (const e of child) {
				elem.appendChild(e);
			}
		} else {
			elem.appendChild(child);
		}
	}
	return elem;
}

type HtmlEl = string | HTMLElement | HTMLElement[];
function h(tag: string, attrs?: { [k: string]: string | undefined } | HtmlEl, ...childs: HtmlEl[]): HTMLElement {
	function toNode(e: HtmlEl): Node {
		if (typeof e == "string") {
			return document.createTextNode(e);
		} else if (Array.isArray(e)) {
			return frag(e);
		} else {
			return e;
		}
	}
	const elem = document.createElement(tag);
	if (attrs) {
		if (typeof attrs == "string" || attrs instanceof HTMLElement || Array.isArray(attrs)) {
			childs.unshift(attrs);
		} else {
			for (const k in attrs) {
				const v = attrs[k];
				if (v != null) {
					elem.setAttribute(k, v);
				}
			}
		}
	}
	for (const child of childs) {
		elem.appendChild(toNode(child));
	}
	return elem;
}

/**
 * 支持 IE 8 9 简单跨域
 */
function newXhr() {
	let xhr = new XMLHttpRequest();
	if (typeof xhr.withCredentials == "undefined" && typeof XDomainRequest != "undefined") {
		xhr = new XDomainRequest();
	}
	return xhr;
}

type EmailProvider = {
	id: string;
	name: string;
};

const COMMENT_MAIL = ["blog", "henix.info"].join("@");
const PROVIDER_KEY = "email_provider";

const providers: EmailProvider[] = [
	{ id: "", name: "--请选择--" },
	{ id: "mailto", name: "系统默认" },
	{ id: "gmail", name: "GMail" },
	{ id: "outlook", name: "Outlook" },
	// { id: "qq", name: "QQ" },
	{ id: "yahoo", name: "Yahoo" },
	{ id: "yandex", name: "Yandex" },
	{ id: "other", name: "其他" },
];

/**
 * https://tools.ietf.org/html/rfc6068
 */
function getMailLink(id: string, to: string, subject: string, body: string): string {
	function encodeParams(params: { [k: string]: string }): string {
		const ar: string[] = [];
		for (const k in params) {
			ar.push(k + "=" + encodeURIComponent(params[k]));
		}
		return ar.join("&");
	}
	const mailto = "mailto:" + to + "?" + encodeParams({ subject, body });
	switch (id) {
		case "mailto":
			return mailto;
		case "gmail":
			return "https://mail.google.com/mail/?extsrc=mailto&url=" + encodeURIComponent(mailto);
		case "outlook":
			return "https://outlook.live.com/mail/deeplink/compose?" + encodeParams({ to, subject, body });
		case "qq":
			// TODO: 将 subject 按 GB18030 编码
			const delegate_url = "/cgi-bin/readtemplate?t=compose&" + encodeParams({ toemail: to, initsubject: subject });
			return "https://mail.qq.com/cgi-bin/loginpage?" + encodeParams({ delegate_url });
		case "yahoo":
			return "https://compose.mail.yahoo.com/?" + encodeParams({ to, subject, body });
		case "yandex":
			return "https://mail.yandex.com/compose?mailto=" + encodeURIComponent(mailto);
		default:
			return "";
	}
}

type BlogComment = {
	date: string,
	uid: string,
	name: string,
	content: string,
};

class CommentPane {
	readonly elem: HTMLElement;
	readonly urlPrefix: string;
	readonly blogId: string;
	readonly blogTitle: string;

	readonly urlByUid: ListenableMap<string> = new ListenableMap();

	viewed = false;
	provider = "";
	submitBut: HTMLButtonElement;
	mailspec: HTMLElement;
	mailspecTitle: HTMLInputElement;

	constructor(elem: HTMLElement) {
		this.elem = elem;
		this.urlPrefix = elem.getAttribute("data-url-prefix") || "";
		this.blogId = elem.getAttribute("data-id") || "";
		this.blogTitle = elem.getAttribute("blog-title") || "";
	}
	setProvider(id: string) {
		this.provider = id;
		this.submitBut.disabled = !this.provider;
		this.mailspec.style.display = this.provider == "other" ? "block" : "none";
	}
	init() {
		const $this = this;

		const select = <HTMLSelectElement>h("select", providers.map(provider => h("option", { value: provider.id }, provider.name)));
		select.value = localStorage.getItem(PROVIDER_KEY) || "";
		select.addEventListener("change", function() {
			$this.onProviderChanged((<HTMLSelectElement>this).value);
		});
		this.submitBut = <HTMLButtonElement>h("button", "写评论");
		this.submitBut.addEventListener("click", function() {
			$this.submit();
		});
		this.mailspecTitle = <HTMLInputElement>h("input", { type: "text", value: "[评论] " + this.blogTitle, "readonly": "" });
		const copyButton = h("a", { href: "javascript:;" }, "[复制]");
		copyButton.addEventListener("click", function() {
			$this.mailspecTitle.select();
			document.execCommand("copy");
		});
		this.mailspec = h("blockquote", { "class": "comment-mailspec" },
			"请按照如下格式发邮件：", h("br"),
			h("span", { "class": "field-name" }, "收件人"), h("a", { href: "mailto:" + COMMENT_MAIL }, COMMENT_MAIL), h("br"),
			h("span", { "class": "field-name" }, "标题"), this.mailspecTitle, copyButton,
			h("span", { "class": "field-name" }, "正文"), "评论 / 回复内容，只支持纯文本");

		this.setProvider(select.value);
		this.elem.appendChild(
			h("div", { "class": "comment-form" },
				"评论邮箱 ",
				select,
				" ",
				this.submitBut,
				" ",
				h("a", { href: "/help.html" }, "评论帮助"))
		);
		this.elem.appendChild(this.mailspec);

		if (location.hash && location.hash.startsWith("#comment-")) {
			this.onView();
		} else {
			new IntersectionObserver(function(entries, observer) {
				entries.forEach(function(entry) {
					if (entry.intersectionRatio > 0) {
						observer.unobserve(entry.target);
						$this.onView();
					}
				});
			}).observe(this.elem);
		}
	}
	onProviderChanged(id: string) {
		localStorage.setItem(PROVIDER_KEY, id);
		this.setProvider(id);
	}
	doComment(subject: string) {
		if (this.provider == "other") {
			this.mailspecTitle.value = subject;
			this.mailspec.scrollIntoView({ behavior: "smooth" }); // TODO: 浏览器兼容性
		} else {
			window.open(getMailLink(this.provider, COMMENT_MAIL, subject, "正文只支持纯文本格式，可在编辑器中设置"), "_blank");
		}
	}
	submit() {
		this.doComment("[评论] " + this.blogTitle);
	}
	reply(id: string) {
		if (this.provider) {
			this.doComment("[回复] " + this.blogTitle + " #" + id);
		} else {
			alert("请先选择评论邮箱");
		}
	}
	onView() {
		if (!this.viewed) {
			this.viewed = true;
			const xhr = newXhr();
			const $this = this;
			xhr.open("GET", this.urlPrefix + "/" + this.blogId + ".tsv");
			xhr.responseType = "text";
			xhr.onreadystatechange = function() {
				if (this.readyState == XMLHttpRequest.DONE) {
					if (this.status == 200) {
						$this.onCommentData(this.responseText);
					}
				}
			};
			xhr.send();
		}
	}
	onCommentData(data: string) {
		// 拿到评论数据就开始渲染，uid -> url 数据可后期添加
		const comments: { [k: string]: BlogComment } = {};
		const childs: { [k: string]: string[] } = {};
		childs[""] = [];
		splitLines(data).forEach(function(line) {
			const [id, date, uid, name, content0, replyTo ] = line.split("\t");
			const content = content0.replace(/\\[trn\\]/g, function(m) {
				switch (m) {
					case "\\t": return "\t";
					case "\\r": return "\r";
					case "\\n": return "\n";
					case "\\\\": return "\\";
					default: return m;
				}
			});
			const comment: BlogComment = { date, uid, name, content };
			comments[id] = comment;
			childs[id] = [];
			childs[replyTo].unshift(id);
		});
		const $this = this;
		function renderComment(id: string): HTMLElement {
			const comment = comments[id];
			const isDeleted = !comment.date;
			const commentHeader = (function() {
				if (!isDeleted) {
					const replyButton = h("a", { "class": "comment-reply-button", href: "javascript:;" }, "[回复]");
					replyButton.addEventListener("click", function() {
						$this.reply(id);
					});
					const uid = comment.uid;
					const userLink = (function() {
						if (uid.startsWith("disqus:")) {
							const disqusUid = uid.substring("disqus:".length);
							return h("a", { "class": "comment-user", href: `https://disqus.com/by/${disqusUid}/`, target: "_blank", title: uid }, comment.name);
						} else {
							const userLink = h("a", { "class": "comment-user", href: $this.urlByUid.get(uid), target: "_blank", title: uid ? "ID: " + uid : "" }, comment.name);
							// 后期更新 uid -> url
							$this.urlByUid.onChange(uid, function({ value }) {
								userLink.setAttribute("href", value);
							});
							return userLink;
						}
					})();
					return h("div", { "class": "comment-header" },
						userLink,
						h("span", { "class": "comment-date" }, comment.date),
						replyButton);
				} else {
					const elem = h("div", { "class": "comment-header deleted" });
					elem.innerHTML = "&nbsp;";
					return elem;
				}
			})();
			const elem = h("div", { "class": "comment", "id": "comment-" + id },
				commentHeader,
				h("div", { "class": "comment-content" + (isDeleted ? " deleted": "") }, isDeleted ? "此评论已被删除" : comment.content));
			if (childs[id].length > 0) {
				// TODO: only-child
				elem.appendChild(h("div", { "class": "comment-reply-list" }, childs[id].map(renderComment)));
			}
			return elem;
		}
		this.elem.appendChild(frag(
			childs[""].map(renderComment)
		));
		// 渲染完后请求 uid -> url 数据
		if (childs[""].length > 0) {
			const xhr = newXhr();
			xhr.open("GET", this.urlPrefix + "/_user.tsv");
			xhr.responseType = "text";
			xhr.onreadystatechange = function() {
				if (this.readyState == XMLHttpRequest.DONE) {
					if (this.status == 200) {
						for (const line of splitLines(this.responseText)) {
							const [k, v] = line.split("\t");
							$this.urlByUid.set(k, v);
						}
					}
				}
			};
			xhr.send();
		}
	}
}
