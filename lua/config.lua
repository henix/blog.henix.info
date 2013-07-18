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
