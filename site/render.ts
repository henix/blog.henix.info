/**
 * render.ts: 博客文章、页面 html 后处理
 */
import { StartTagToken } from "parse5-sax-parser";
import RewritingStream from "parse5-html-rewriting-stream";

const rewriter = new RewritingStream();

function rewrite(startTag: StartTagToken): StartTagToken | undefined {
	// img 标签 lazy-load
	if (startTag.tagName == "img") {
		const src = startTag.attrs.find(attr => attr.name == "src");
		if (src) {
			src.name = "data-src";
			return startTag;
		}
	}
}

/**
 * 不需要处理时通过 emitRaw 保留原始 html
 * https://github.com/inikulin/parse5/blob/master/packages/parse5-html-rewriting-stream/docs/index.md#events-1
 */
rewriter.on("startTag", function(startTag, rawHtml) {
	const res = rewrite(startTag);
	if (res) {
		rewriter.emitStartTag(res);
	} else {
		rewriter.emitRaw(rawHtml);
	}
});

process.stdin.setEncoding("utf8");
process.stdin.pipe(rewriter).pipe(process.stdout);
