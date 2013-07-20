-- sitedesc = '一起看那遥远的街市上，发生的一幕幕故事'
-- sitedesc = '多研究些问题，少谈些主义'
sitedesc = 'henix\'s blog 每月1号和15号更新'

-- siteurl = 'http://the-distant-town.appspot.com'
-- siteurl = 'http://www.henix-blog.co.cc'
siteurl = 'http://blog.henix.info'

disqus_shortname = 'thedistanttown'

baseurl = ''

-- Macros
function getPostURL(name)
	return '/blog/'..name..'.html'
end

function getCategoryURL(cat)
	return '/#'..cat
end

function getTagURL(tag)
	return '/tags/'..tag.uname..'.html'
end

function loadFile(path)
	local fin = assert(io.open(path))
	local all = fin:read('*a')
	fin:close()
	return all
end

function makeImg(url)
	return '<a href="'..url..'" title="点击查看大图"><img src="'..url..'" style="max-width:100%" /></a>'
end

function highlight(str, lang, options)
	options = options or {}

	local tmpname = os.tmpname()
	do
		local ftmp = assert(io.open(tmpname, 'w'))
		ftmp:write(str)
		ftmp:close()
	end
	local fin = io.popen('highlight -f '..(options.lineno and '-n ' or '')..'-O xhtml --syntax '..lang..' '..tmpname)
	local all = fin:read('*a')
	fin:close()
	os.remove(tmpname)
	return '<div class="hl'..(options.lineno and ' lineno' or ' nolineno')..'">'..all:gsub('&nbsp;', ' ')..'</div>'
end
