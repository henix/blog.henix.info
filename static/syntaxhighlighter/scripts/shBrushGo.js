;(function()
{
	// CommonJS
	SyntaxHighlighter = SyntaxHighlighter || (typeof require !== 'undefined'? require('shCore').SyntaxHighlighter : null);

	function Brush()
	{
		var datatypes =	'bool byte complex64 complex128 error float32 float64 ' +
				'int int8 int16 int32 int64 rune string ' +
				'uint uint8 uint16 uint32 uint64 uintptr';
		
		var constants = 'true false iota';
		
		var zerovalue = 'nil';
		
		var functions = 'append cap close complex copy delete imag len ' +
				'make new panic print println real recover';

		var keywords =	'break        default      func         interface    select ' +
				'case         defer        go           map          struct ' +
				'chan         else         goto         package      switch ' +
				'const        fallthrough  if     	range        type ' +
				'continue     for          import       return       var';

		this.regexList = [
			{ regex: SyntaxHighlighter.regexLib.singleLineCComments,	css: 'comments' },			// one line comments
			{ regex: SyntaxHighlighter.regexLib.multiLineCComments,		css: 'comments' },			// multiline comments
			{ regex: SyntaxHighlighter.regexLib.doubleQuotedString,		css: 'string' },			// strings
			{ regex: SyntaxHighlighter.regexLib.singleQuotedString,		css: 'string' },			// strings
			{ regex: new RegExp(this.getKeywords(datatypes), 'gmi'),	css: 'color1' },
			{ regex: new RegExp(this.getKeywords(functions), 'gmi'), 	css: 'functions' },
			{ regex: new RegExp(this.getKeywords(constants), 'gmi'),	css: 'constants' },
			{ regex: new RegExp(this.getKeywords(zerovalue), 'gmi'),	css: 'constants' },
			{ regex: new RegExp(this.getKeywords(keywords), 'gmi'),		css: 'keyword' }
			];
	};
	Brush.prototype = new SyntaxHighlighter.Highlighter();
	Brush.aliases = ['go', 'golang'];

	SyntaxHighlighter.brushes.Go = Brush;

	// CommonJS
	typeof(exports) != 'undefined' ? exports.Brush = Brush : null;
})();
