<link rel="stylesheet" href="/syntaxhighlighter/styles/shCore.css" type="text/css" />
<link rel="stylesheet" href="/syntaxhighlighter/styles/shThemeDefault.css" type="text/css" />

　　[SyntaxHighlighter](http://alexgorbatchev.com/SyntaxHighlighter/) 是一个基于 JavaScript 的代码着色器。默认没有支持 Tcl 语言，所以我写了一个 Tcl 的语法定义，让它可以高亮 Tcl 源代码。

[SyntaxHighlighter](http://alexgorbatchev.com/SyntaxHighlighter/) is a syntax highlighter based on JavaScript. But it doesn't have built-in support for the Tcl programming language. I write a syntax definition for Tcl, so that it can highlight Tcl source code.

　　下载(Download)：0.3: [shBrushTcl.js](/myworks/shBrushTcl.js) 。

　　Source code on github: [https://github.com/henix/syntax-brushes](https://github.com/henix/syntax-brushes)

　　例子(Example)：

<pre class="brush: tcl">
package provide procfs 1.0
package require Tcl 8.5

namespace eval ::procfs {
	namespace export lsproc lsmod cpuinfo ostype osrelease osversion
	namespace ensemble create
}

# list all process
# @return dict[pid] list
proc ::procfs::lsproc {} {
	set tmp [glob -types d "/proc/*"]
	foreach card $tmp {
		if { [regexp {^/proc/\d+$} $card] } {
			lappend pidds $card
		}
	}
	foreach pidd $pidds {
		set fin [open "$pidd/stat" r]
		gets $fin line
		set p [split $line " "]
		dict set ret [lindex $p 0] $p
		close $fin
	}
	return $ret
}

proc ::procfs::lsmod {} {
	set fin [open "/proc/modules" r]
	while { [gets $fin line] &gt; 0 } {
		set tmp [split $line " "]
		lappend ret $tmp
	}
	close $fin
	return $ret
}

# {} -&gt; dict
proc ::procfs::cpuinfo {} {
	set infile [open "/proc/cpuinfo" r]
	while { [gets $infile line] &gt; 0 } {
		regexp {([^:]*):(.*)} $line match key value
		dict set ret [string trim $key] [string trim $value]
	}
	close $infile
	return $ret
}

proc ::procfs::ostype {} {
	set fin [open "/proc/sys/kernel/ostype" r]
	gets $fin ostype
	close $fin
	return $ostype
}

proc ::procfs::osrelease {} {
	set fin [open "/proc/sys/kernel/osrelease" r]
	gets $fin osrelease
	close $fin
	return $osrelease
}

proc ::procfs::osversion {} {
	set fin [open "/proc/sys/kernel/version" r]
	gets $fin osversion
	close $fin
	return $osversion
}
</pre>

　　已在 SyntaxHighlighter 的网站上[留言](http://www.undermyhat.org/blog/2009/09/list-of-brushes-syntaxhighligher/comment-page-3/#comment-18706)，请求将这个 brush 加入。

<script type="text/javascript" src="/syntaxhighlighter/scripts/shCore.js"></script>

<script type="text/javascript" src="/syntaxhighlighter/scripts/shBrushTcl.js"></script>

<script type="text/javascript">
SyntaxHighlighter.all();
</script>
