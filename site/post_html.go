package main

import (
	"bufio"
	"bytes"
	"errors"
	"io"

	"golang.org/x/net/html"
)

/**
 * 后处理生成的 html ，用于 page 和 post
 * 实现的功能:
 * 1. img lazy load
 */
func PostProcessHtml(in io.Reader) ([]byte, error) {
	lexer := html.NewTokenizer(bufio.NewReader(in))
	// 临时保存输入的 html token
	tmp := make([]byte, 0, 64)
	// 输出缓冲区
	buf := make([]byte, 0, 8192)
	y := func(bs []byte) {
		buf = append(buf, bs...)
	}
	for {
		tt := lexer.Next()
		if tt == html.ErrorToken {
			err := lexer.Err()
			if !errors.Is(err, io.EOF) {
				return nil, err
			} else {
				return buf, nil
			}
		}
		if tt == html.StartTagToken || tt == html.SelfClosingTagToken {
			tmp = tmp[:0]
			tmp = append(tmp, lexer.Raw()...)
			name, hasAttr := lexer.TagName()
			if bytes.Equal(name, []byte("img")) {
				y([]byte("<img"))
				for hasAttr {
					var k, v []byte
					k, v, hasAttr = lexer.TagAttr()
					if bytes.Equal(k, []byte("src")) {
						k = []byte("data-src")
					}
					y([]byte(" "))
					y(k)
					y([]byte("=\""))
					y([]byte(html.EscapeString(string(v))))
					y([]byte("\""))
				}
				if tt == html.SelfClosingTagToken {
					y([]byte("/"))
				}
				y([]byte(">"))
			} else {
				y(tmp)
			}
		} else {
			// 其他 token ，直接输出
			y(lexer.Raw())
		}
	}
}
