/**
 * SyntaxHighlighter brush for Tcl
 *
 * more info:
 * http://blog.henix.info/blog/tcl-syntaxhighlighter-brush.html
 *
 * @version 0.3
 *
 * @copyright
 * Copyright (C) 2011 henix.
 *
 * @license
 * Dual licensed under the MIT and GPL licenses.
 */

/**
 * ChangeLog
 *
 * 2012-2-28 henix
 *     move some commands to keywords
 *     render [] in color2
 *     add array, dict and string subcommands
 *
 * 2011-12-23 henix
 *     website moved to blog.henix.info
 *
 * 2011-4-16 henix
 *     Version 1.0
 */

SyntaxHighlighter.brushes.Tcl = function()
{
	// According to: http://www.tcl.tk/man/tcl8.5/TclCmd/contents.htm
	var commands = 'after append apply array bgerror binary cd chan clock close concat dde dict encoding eof error eval exec exit expr fblocked fconfigure fcopy file fileevent filename flush format gets glob history http incr info interp join lappend lassign lindex linsert list llength load lrange lrepeat lreplace lreverse lsearch lset lsort mathfunc mathop memory msgcat open parray pid platform puts pwd read refchan regexp registry regsub rename scan seek socket source split string subst switch tcltest tclvars tell time tm trace unknown unload update uplevel variable vwait';

	/**
	 * According to http://www.tcl.tk/man/tcl8.5/tutorial/Tcl11.html , there are no reserved words in Tcl,
	 * but in practice, we usually treat these commands as keywords.
	 */
	var keywords = 'proc if then return while for set unset break continue foreach package namespace catch upvar global';

	this.regexList = [
		{ regex: new RegExp('^\\s*#.*$', 'gm'), css: 'comments' }, // JavaScript doesn't support lookbehind zero-width assertions, so...
		{ regex: new RegExp(';\\s*#.*$', 'gm'), css: 'comments' },
		{ regex: SyntaxHighlighter.regexLib.doubleQuotedString, css: 'string' },
		{ regex: new RegExp('\\$[A-Za-z]\\w*', 'g'), css: 'variable'},
		{ regex: new RegExp('\\b\\d+\\b', 'g'), css: 'constants' },
		{ regex: new RegExp('[\\[\\]]', 'g'), css: 'color2' },
		{ regex: new RegExp(this.getKeywords(keywords), 'g'), css: 'keyword' },
		{ regex: new RegExp(this.getKeywords(commands), 'g'), css: 'functions bold' },
		{ regex: /array (anymore|donesearch|exists|get|names|nextelement|set|size|startsearch|statistics|unset)/g, css: 'functions bold' },
		{ regex: /dict (append|create|exists|filter|for|get|incr|info|keys|lappend|merge|remove|replace|set|size|unset|update|values|with)/g, css: 'functions bold' },
		{ regex: /string (bytelength|compare|equal|first|index|is|last|length|map|match|range|repeat|replace|reverse|tolower|totitle|toupper|trim|trimleft|trimright|wordend|wordstart)/g, css: 'functions bold' }
		];
};
SyntaxHighlighter.brushes.Tcl.prototype	= new SyntaxHighlighter.Highlighter();
SyntaxHighlighter.brushes.Tcl.aliases	= ['tcl'];
