package main

import (
	"bufio"
	"bytes"
	"errors"
	"fmt"
	"html"
	"os"
	"os/exec"
	"path/filepath"
	"slices"
	"strings"
	"time"

	"gopkg.in/ini.v1"
)

const SiteVarFilename = "_.ini"

type SiteVars struct {
	SiteTitle string
	SiteUrl   string
	SiteDesc  string
	Author    string
}

func LoadSiteVars(filename string) (vars SiteVars, err error) {
	cfg, err := ini.Load(filename)
	if err != nil {
		return
	}
	sec := cfg.Section("")
	for _, k := range []string{"sitetitle", "siteurl", "sitedesc", "author"} {
		if !sec.HasKey(k) {
			err = errors.New("Var " + k + " not found: " + filename)
			return
		}
	}
	vars = SiteVars{
		SiteTitle: sec.Key("sitetitle").String(),
		SiteUrl:   sec.Key("siteurl").String(),
		SiteDesc:  sec.Key("sitedesc").String(),
		Author:    sec.Key("author").String(),
	}
	return
}

type BlogPost struct {
	Category string
	BlogId   string
}

func (post BlogPost) GetIniName() string {
	return filepath.Join(post.Category, post.BlogId, "_.ini")
}

func (post BlogPost) GetMdName() string {
	return filepath.Join(post.Category, post.BlogId, "_.md")
}

func (post BlogPost) GetUrl(siteurl string) string {
	return siteurl + "/blog/" + post.BlogId + "/"
}

func GetPageMd(page string) string {
	return page + ".md"
}

func GetPageUrl(siteurl string, page string) string {
	return siteurl + "/" + page + ".html"
}

type PostVars struct {
	Title string
	Date  string
	Toc   bool
}

// TODO: 考虑建立 cache ，避免重复加载
func LoadPostVars(filename string) (PostVars, error) {
	cfg, err := ini.Load(filename)
	if err != nil {
		return PostVars{}, err
	}
	sec := cfg.Section("")
	if !sec.HasKey("title") {
		return PostVars{}, errors.New("TitleNotFoundInVars: " + filename)
	}
	if !sec.HasKey("date") {
		return PostVars{}, errors.New("DateNotFoundInVars: " + filename)
	}
	return PostVars{
		Title: sec.Key("title").String(),
		Date:  sec.Key("date").String(),
		Toc:   sec.HasKey("toc"),
	}, nil
}

const CatesFilename = "cats.tsv"

func LoadCates(filename string) (map[string]string, error) {
	file, err := os.Open(filename)
	if err != nil {
		return nil, err
	}
	defer file.Close()
	cats := make(map[string]string)
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		line := scanner.Bytes()
		a, b, found := bytes.Cut(line, []byte("\t"))
		if !found {
			return nil, errors.New("BadCateLine: " + string(line))
		}
		cats[string(a)] = string(b)
	}
	Ok(scanner.Err())
	return cats, nil
}

type BlogIndexItem struct {
	BlogPost
	PostVars
}

type PandocOption struct {
	Template     string
	Heads        []string
	Befores      []string
	Afters       []string
	BlogId       string
	SiteVars     SiteVars
	PostVarsFile string
	CSSPath      string
}

var PandocBaseOptions = []string{"-t", "html5", "--eol=lf", "--wrap=preserve"}

func PandocFull(opt *PandocOption, mdname string, target string) error {
	deps := []string{SiteVarFilename, opt.Template}
	deps = append(deps, opt.Heads...)
	deps = append(deps, opt.Befores...)
	deps = append(deps, opt.Afters...)
	if opt.PostVarsFile != "" {
		deps = append(deps, opt.PostVarsFile)
	}
	deps = append(deps, mdname)
	if NeedGens(deps, target) {
		args := make([]string, 0, 32)
		args = append(args, PandocBaseOptions...)
		args = append(args, []string{
			"--katex", "--highlight-style=kate",
			"--email-obfuscation=references",
			"--template=" + opt.Template,
		}...)
		for _, h := range opt.Heads {
			args = append(args, "-H", h)
		}
		for _, b := range opt.Befores {
			args = append(args, "-B", b)
		}
		for _, a := range opt.Afters {
			args = append(args, "-A", a)
		}
		args = append(args, "-M", "sitetitle="+opt.SiteVars.SiteTitle)
		args = append(args, "-M", "siteurl="+opt.SiteVars.SiteUrl)
		args = append(args, "-M", "author="+opt.SiteVars.Author)
		if opt.PostVarsFile != "" {
			postVars, err := LoadPostVars(opt.PostVarsFile)
			if err != nil {
				return err
			}
			args = append(args, "-M", "title="+postVars.Title)
			args = append(args, "-M", "date="+postVars.Date)
			if postVars.Toc {
				args = append(args, "--toc")
			}
		}
		args = append(args, "-M", "id="+opt.BlogId)
		args = append(args, "--css="+opt.CSSPath)
		args = append(args, mdname)
		proc := exec.Command("pandoc", args...)
		proc.Stderr = os.Stderr
		pandocOut, err := proc.StdoutPipe()
		if err == nil {
			fmt.Println("pandoc", strings.Join(args, " "))
			err = proc.Start()
		}
		var buf []byte
		if err == nil {
			buf, err = PostProcessHtml(pandocOut)
		}
		if err == nil {
			err = proc.Wait()
		}
		if err == nil {
			err = os.WriteFile(target, buf, 0777)
		}
		return err
	}
	return nil
}

func RenderDotSVG(dotname string, target string) error {
	proc := exec.Command("dot", "-T", "svg", dotname)
	proc.Stderr = os.Stderr
	out, err := os.Create(target)
	if err != nil {
		return err
	}
	defer out.Close()
	proc.Stdout = out
	fmt.Println("dot -T svg", dotname)
	return proc.Run()
}

// sitemap.xml
func genSitemap(outRoot string, siteVars SiteVars, pages []string, indexItems []BlogIndexItem, deptime time.Time) error {
	// 严谨应该用 xml 转义，但 Go 无法转义成 string 且这里无需转义
	appendUrl := func(buf []byte, loc string, lastmod string) []byte {
		buf = append(buf, []byte("<url>\n")...)
		buf = append(buf, []byte("\t<loc>")...)
		buf = append(buf, []byte(loc)...)
		buf = append(buf, []byte("</loc>\n")...)
		buf = append(buf, []byte("\t<lastmod>")...)
		buf = append(buf, []byte(lastmod)...)
		buf = append(buf, []byte("</lastmod>\n")...)
		buf = append(buf, []byte("</url>\n")...)
		return buf
	}
	deps := make([]string, 0, len(pages))
	for _, page := range pages {
		// TODO: 考虑将 mtime 缓存起来
		deps = append(deps, GetPageMd(page))
	}
	target := filepath.Join(outRoot, "sitemap.xml")
	if NeedGensTime(deptime, deps, target) {
		fmt.Println("gen:", target)
		siteurl := siteVars.SiteUrl
		buf := make([]byte, 0, 8192)
		buf = append(buf, []byte(`<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
`)...)
		buf = appendUrl(buf, siteurl+"/", deptime.Format(time.DateOnly))
		for _, page := range pages {
			dep := GetPageMd(page)
			mtime := modifyTime(dep)
			buf = appendUrl(buf, GetPageUrl(siteurl, page), mtime.Format(time.DateOnly))
		}
		for _, item := range indexItems {
			buf = appendUrl(buf, item.GetUrl(siteurl), item.Date)
		}
		buf = append(buf, []byte("</urlset>\n")...)
		return os.WriteFile(target, buf, 0777)
	}
	return nil
}

func genIndex(outRoot string, siteVars SiteVars, categories map[string]string, indexItems []BlogIndexItem, deptime time.Time) {
	appendCateBox := func(buf []byte, title string, items []BlogIndexItem) []byte {
		buf = append(buf, []byte(`<div class="box">
<h5 class="cate-title">`)...)
		buf = append(buf, []byte(html.EscapeString(title))...)
		buf = append(buf, []byte(`</h5>
<ul class="box-body post-list">
`)...)
		for _, item := range items {
			li := "<li>" + item.Date + "<a href=\"blog/" + item.BlogId + "/\">" + html.EscapeString(item.Title) + "</a></li>\n"
			buf = append(buf, []byte(li)...)
		}
		buf = append(buf, []byte(`</ul>
</div>
`)...)
		return buf
	}
	makeFooterLink := func(page string) string {
		filename := GetPageMd(page)
		file := Must(os.Open(filename))
		scanner := bufio.NewScanner(file)
		if !scanner.Scan() {
			panic("FileEmpty: " + filename)
		}
		line := scanner.Bytes()
		if line[0] == '%' {
			line = line[1:]
		}
		line = bytes.TrimSpace(line)
		ret := "| <a href=\"" + page + ".html\">" + html.EscapeString(string(line)) + "</a>\n"
		Ok(scanner.Err())
		Ok(file.Close())
		return ret
	}
	deps := []string{CatesFilename, "myhead.seg.htm", "js-start.seg.htm", "all-end.seg.htm"}
	footerPages := []string{"about", "updates"}
	for _, page := range footerPages {
		dep := GetPageMd(page)
		deps = append(deps, dep)
	}
	target := filepath.Join(outRoot, "index.html")
	if NeedGensTime(deptime, deps, target) {
		fmt.Println("gen:", target)
		// 准备数据
		sitetitle := siteVars.SiteTitle
		cats := make([]string, 0, len(categories))
		catitems := make(map[string][]BlogIndexItem, len(categories))
		for _, item := range indexItems {
			catitem := catitems[item.Category]
			if catitem == nil {
				cats = append(cats, item.Category)
			}
			catitems[item.Category] = append(catitem, item)
		}
		// 不想用 html/template 且 Go 很难为 HTML 生成定义 EDSL（因为没有 C 的宏）
		// 因此直接用字节数组生成
		buf := make([]byte, 0, 8192)
		buf = append(buf, []byte(`<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>`)...)
		buf = append(buf, []byte(sitetitle)...)
		buf = append(buf, []byte("</title>\n")...)
		buf = append(buf, Must(os.ReadFile("myhead.seg.htm"))...)
		buf = append(buf, []byte(`<link rel="stylesheet" href="root.css">
<link rel="alternate" type="application/rss+xml" title="RSS 2.0" href="rss2.0.xml">
</head>
<body>
<div id="page">
<h1 class="sitetitle">`)...)
		buf = append(buf, []byte(sitetitle)...)
		buf = append(buf, []byte(`</h1>
<p id="banner"><img src="banner2.jpg" alt=""></p>
`)...)
		for _, cat := range cats {
			buf = appendCateBox(buf, categories[cat], catitems[cat])
		}
		buf = append(buf, []byte(`<div id="footer">
<div style="float:left">
<a class="-Valid" href="https://validator.w3.org/check?uri=referer">Valid</a>
`)...)
		for _, page := range footerPages {
			buf = append(buf, []byte(makeFooterLink(page))...)
		}
		buf = append(buf, []byte(`</div>
</div>
</div><!-- end of page -->
`)...)
		buf = append(buf, Must(os.ReadFile("js-start.seg.htm"))...)
		buf = append(buf, Must(os.ReadFile("all-end.seg.htm"))...)
		buf = append(buf, []byte("</body>\n</html>\n")...)
		Ok(os.WriteFile(target, buf, 0777))
	}
}

func genRSS(outRoot string, siteVars SiteVars, indexItems []BlogIndexItem, deptime time.Time) {
	chinaLoc := Must(time.LoadLocation("Asia/Shanghai"))
	appendRssItem := func(buf []byte, siteurl string, author string, item BlogIndexItem) []byte {
		// 运行 pandoc
		// TODO: 考虑 content 缓存到文件里？
		var content []byte
		{
			mdname := item.GetMdName()
			args := make([]string, 0, 16)
			args = append(args, PandocBaseOptions...)
			args = append(args, []string{
				"--katex", "--no-highlight",
				"--template=content.temp.htm",
				"-M", "title=" + item.Title,
			}...)
			if item.Toc {
				args = append(args, "--toc")
			}
			args = append(args, mdname)
			proc := exec.Command("pandoc", args...)
			proc.Stderr = os.Stderr
			fmt.Println("pandoc", strings.Join(args, " "))
			content = Must(proc.Output())
		}
		link := item.GetUrl(siteurl)
		guid := item.BlogId + ":" + item.Date
		buf = append(buf, []byte(`<item>
<title>`)...)
		buf = append(buf, []byte(html.EscapeString(item.Title))...)
		buf = append(buf, []byte(`</title>
<link>`)...)
		buf = append(buf, []byte(link)...)
		buf = append(buf, []byte(`</link>
<description>`)...)
		buf = append(buf, []byte(html.EscapeString(string(content)))...)
		buf = append(buf, []byte(`</description>
<author>`)...)
		buf = append(buf, []byte(author)...)
		buf = append(buf, []byte(`</author>
<guid isPermaLink="false">`)...)
		buf = append(buf, []byte(guid)...)
		buf = append(buf, []byte(`</guid>
<pubDate>`)...)
		publishTime := Must(time.ParseInLocation(time.DateOnly, item.Date, chinaLoc))
		buf = append(buf, []byte(publishTime.Format(time.RFC1123Z))...)
		buf = append(buf, []byte(`</pubDate>
</item>
`)...)
		return buf
	}
	deps := []string{"content.temp.htm"}
	// 依赖最新的 10 篇文章的 md 文件
	recentItems := indexItems[:min(10, len(indexItems))]
	for _, item := range recentItems {
		dep := item.GetMdName()
		deps = append(deps, dep)
	}
	target := filepath.Join(outRoot, "rss2.0.xml")
	if NeedGensTime(deptime, deps, target) {
		fmt.Println("gen:", target)
		siteurl := siteVars.SiteUrl
		buf := make([]byte, 0, 8192)
		buf = append(buf, []byte(`<?xml version="1.0" encoding="utf-8"?>
<rss version="2.0">
<channel>
<title>`)...)
		buf = append(buf, []byte(siteVars.SiteTitle)...)
		buf = append(buf, []byte(`</title>
<link>`)...)
		buf = append(buf, []byte(siteurl)...)
		buf = append(buf, []byte(`/</link>
<description>`)...)
		buf = append(buf, []byte(siteVars.SiteDesc)...)
		buf = append(buf, []byte(`</description>
<language>zh-cn</language>
<lastBuildDate>`)...)
		buf = append(buf, []byte(time.Now().Format(time.RFC1123Z))...)
		buf = append(buf, []byte("</lastBuildDate>\n")...)
		for _, item := range recentItems {
			buf = appendRssItem(buf, siteurl, siteVars.Author, item)
		}
		buf = append(buf, []byte(`</channel>
</rss>
`)...)
		Ok(os.WriteFile(target, buf, 0777))
	}
}

func main() {
	outRoot := filepath.Join("..", "public")
	siteVars := Must(LoadSiteVars(SiteVarFilename))
	// 直接复制的文件
	for _, dep := range []string{"root.css", "valid.js", "post.js", "comment.js", "banner2.jpg", "robots.txt"} {
		target := filepath.Join(outRoot, dep)
		if NeedGen(dep, target) {
			Ok(CopyFile(dep, target))
		}
	}
	// 所有 pages 的 id
	pages := make([]string, 0, 4)
	for _, md := range Must(filepath.Glob("*.md")) {
		var id string
		{
			ext := filepath.Ext(md)
			id = md[:len(md)-len(ext)]
			pages = append(pages, id)
		}
		target := filepath.Join(outRoot, id+".html")
		var pathPrefix string
		if id == "404" {
			pathPrefix = "/"
		}
		Ok(PandocFull(&PandocOption{
			Template: "page.temp.htm",
			Heads:    []string{"myhead.seg.htm"},
			Befores:  []string{"js-start.seg.htm"},
			Afters:   []string{"comment.seg.htm", "all-end.seg.htm"},
			BlogId:   id,
			SiteVars: siteVars,
			CSSPath:  pathPrefix + "root.css",
		}, md, target))
	}
	categories := Must(LoadCates(CatesFilename))
	// posts
	posts := make([]BlogPost, 0, 16)
	for cat := range categories {
		for _, catent := range Must(os.ReadDir(cat)) {
			if catent.IsDir() {
				id := catent.Name()
				posts = append(posts, BlogPost{
					Category: cat,
					BlogId:   id,
				})
				dirname := filepath.Join(cat, id)
				outdir := filepath.Join(outRoot, "blog", id)
				Ok(os.MkdirAll(outdir, 0o777))
				// 调用 pandoc 渲染 post
				{
					target := filepath.Join(outdir, "index.html")
					Ok(PandocFull(&PandocOption{
						Template:     "post.temp.htm",
						Heads:        []string{"myhead.seg.htm"},
						Befores:      []string{"js-start.seg.htm"},
						Afters:       []string{"comment.seg.htm", "all-end.seg.htm"},
						BlogId:       id,
						SiteVars:     siteVars,
						PostVarsFile: filepath.Join(dirname, "_.ini"),
						CSSPath:      "../../root.css",
					}, filepath.Join(dirname, "_.md"), target))
				}
				// 遍历目录并复制其他文件
				for _, ent := range Must(os.ReadDir(dirname)) {
					name := ent.Name()
					if ent.Type().IsRegular() && !strings.HasPrefix(name, "_.") {
						var target string
						var genAction func(dep string, target string) error
						if strings.HasSuffix(name, ".dot") {
							target = filepath.Join(outdir, name[0:len(name)-len(".dot")]+".svg")
							genAction = RenderDotSVG
						} else {
							target = filepath.Join(outdir, name)
							genAction = CopyFile
						}
						if NeedGenTime(Must(ent.Info()).ModTime(), target) {
							fmt.Println("gen:", target)
							Ok(genAction(filepath.Join(dirname, name), target))
						}
					}
				}
			}
		}
	}
	sitePostIniMtime := modifyTime(SiteVarFilename)
	indexItems := make([]BlogIndexItem, 0, len(posts))
	for _, post := range posts {
		dep := post.GetIniName()
		sitePostIniMtime = MaxDepTime(sitePostIniMtime, dep)
		vars := Must(LoadPostVars(dep))
		indexItems = append(indexItems, BlogIndexItem{
			BlogPost: post,
			PostVars: vars,
		})
	}
	// 按日期倒序
	slices.SortFunc(indexItems, func(a, b BlogIndexItem) int {
		return strings.Compare(b.Date, a.Date)
	})
	Ok(genSitemap(outRoot, siteVars, pages, indexItems, sitePostIniMtime))
	genIndex(outRoot, siteVars, categories, indexItems, sitePostIniMtime)
	genRSS(outRoot, siteVars, indexItems, sitePostIniMtime)
}
