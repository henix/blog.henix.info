#!/usr/bin/luajit

require 'lang'
slt2 = require('slt2')

function escapeHtml(s)
	local tmp = {['>']='&gt;', ['<']='&lt;'}
	local ret
	ret = string.gsub(s, '&', '&amp;')
	ret = string.gsub(ret, '[<>]', tmp)
	return ret
end

lunamark = require('lunamark')

local OUTPUT = '..' .. os.pathsep .. 'static' .. os.pathsep

dofile('posts.lua')

function getPostURL(p)
	return '/blog/'..p.name..'.html'
end

function getCategoryURL(cat)
	return '/#'..cat
end

function getTagURL(tag)
	return '/tags/'..tag.uname..'.html'
end

function makeImg(url)
	return '<a href="'..url..'" title="点击查看大图"><img alt="" src="'..url..'" style="max-width:100%" /></a>'
end

function markdown(str)
	local writer = lunamark.writer.html.new()
	local parse = lunamark.reader.markdown.new(writer, { definition_lists = true })
	local result, metadata = parse(str)
	return result
end

function table.inarray(t, name)
	for _, v in ipairs(t) do
		if v == name then
			return true
		end
	end
	return false	
end

function HSL2RGB(h, s, l)
	local rgb = {}
	if s > 0 then
		local q, p
		local hk
		if l < 0.5 then
			q = l * (1 + s)
		else
			q = l + s - l * s
		end
		p = 2 * l - q
		hk = h / 360
		rgb[1] = hk + 1/3
		rgb[2] = hk;
		rgb[3] = hk - 1/3
		for i = 1, 3 do
			if rgb[i] < 0 then
				rgb[i] = rgb[i] + 1.0
			elseif rgb[i] > 1.0 then
				rgb[i] = rgb[i] - 1.0
			end
		end
		for i = 1, 3 do
			if rgb[i] < 1.0/6.0 then
				rgb[i] = p + (q - p) * 6.0 * rgb[i];
			elseif rgb[i] < 1.0/2.0 then
				rgb[i] = q;
			elseif rgb[i] < 2.0/3.0 then
				rgb[i] = p + (q - p) * 6.0 * (2.0/3.0 - rgb[i]);
			else
				rgb[i] = p;
			end
		end
	else
		rgb[1] = l
		rgb[2] = l
		rgb[3] = l
	end
	return math.floor(rgb[1]*255+0.5), math.floor(rgb[2]*255+0.5), math.floor(rgb[3]*255+0.5)
end

function digestHTML(str, length)
	local ret = string.gsub(str, "</p>", string.char(127))
	ret = string.gsub(ret, "<br />", string.char(127))
	ret = string.gsub(ret, "<.->", "")

	-- truncate UTF-8 string
	local i = 1
	local curlen = 0
	local len = string.len(ret)
	while curlen < length and i <= len do
		local t = string.byte(ret, i)
		if t > 127 then
			i = i + 3
		else
			if t == string.byte('&') then
				while string.byte(ret, i) ~= string.byte(';') and i < len do
					i = i + 1
				end
			end
			i = i + 1
		end
		curlen = curlen + 1
	end

	return string.gsub(string.sub(ret, 1, i - 1), string.char(127), "<br />")
end

function calcRelative(post1, post2)
	-- preprocessing post1
	if post1.tag_table == nil then
		post1.tag_table = {}
		post1.weight = 0
		for _, v in pairs(post1.tags) do
			post1.tag_table[v] = true
			post1.weight = post1.weight + tags[v].weight
		end
	end
	if post2.tag_table == nil then
		post2.tag_table = {}
		post2.weight = 0
		for _, v in pairs(post2.tags) do
			post2.tag_table[v] = true
			post2.weight = post2.weight + tags[v].weight
		end
	end

	local ret = 0
	for _, v in pairs(post2.tags) do
		if post1.tag_table[v] ~= nil then
			ret = ret + tags[v].weight
		end
	end
	if ret ~= 0 then
		ret = ret / math.sqrt(post1.weight * post2.weight)
		-- ret = ret / (post1.weight + post2.weight - ret)
	end
	return ret
end

function getLinkbyId(id)
	if id == 'links' or id == 'guestbook' then
		return '/'..id..'.html'
	end
	return '/blog/'..id..'.html'
end

function getTitlebyId(id)
	if id == 'links' then
		return '友情链接'
	end
	if id == 'guestbook' then
		return '留言板'
	end
	if id == 'about' then
		return '关于'
	end
	return blogposts[posts_table[id]].title
end

-- load visits data
dofile('visits_table.lua')

-- load comments data
dofile('comments.lua')

posts_table = {}

pop_table = {}

-- prepare data we needed
for i, v in ipairs(blogposts) do
	v.year = os.date('%Y', v.publish_time)
	v.month = os.date('%m', v.publish_time)
	local fin = assert(io.open('blogs/'..v.name..'.txt'))
	v.content = fin:read('*a')
	fin:close()

	-- 通过名字反向查询到 index
	posts_table[v.name] = i

	-- visits data
	v.visits = visits_table[v.name] or 0

	-- comments data
	v.comnum = comnum_table[v.name] or 0

	-- process category
	assert(categories[v.category], v.category)
	table.insert(categories[v.category], i)

	for _, tag in ipairs(v.tags) do
		table.insert(tags[tag].posti, i)
	end
end

-- calculate tags' weight
for tag, obj in pairs(tags) do
	obj.weight = 1 / (1 + math.log(#obj.posti))
end

-- -1: calculate popularity

local function pop_cmp(a, b)
	return blogposts[a].comnum * 5 + blogposts[a].visits > blogposts[b].comnum * 5 + blogposts[b].visits
end

for i = 1, #blogposts do
	--visits_table[i] = i
	pop_table[i] = i
end
table.sort(pop_table, pop_cmp)

--[[local function popm_cmp(a, b)
	return blogposts[a].visits_month > blogposts[b].visits_month
end

for i = 1, #blogposts do
	visits_table_month[i] = i
end
table.sort(visits_table_month, popm_cmp)]]--

-- 1. each blog post
do
	local tmpl = slt2.loadfile('post.temp.htm')
	for i, v in ipairs(blogposts) do
		local fout = assert(io.open(OUTPUT .. 'blog'..os.pathsep..v.name..'.html', 'w'))
		fout:write(slt2.render(tmpl, {post = v, i = i}))
		fout:close()
	end
end

-- 2. tags/*.html
do
	local tmpl = assert(slt2.loadfile('tag.temp.htm'))
	for tagname, tag in pairs(tags) do
		local fout = assert(io.open(OUTPUT .. 'tags'..os.pathsep..tag.uname..'.html', 'w'))
		fout:write(slt2.render(tmpl, {
			si = 1,
			ei = #tag.posti,
			tag = tag,
			tagname = tagname
		}))
		fout:close()
	end
end

-- 3. non-rainy pages
for _, name in ipairs({'links', 'guestbook', 'myworks', 'collections', 'winsoft', 'linux-shell', 'about', 'search'}) do
	local tmpl = slt2.loadfile(name..'.temp.htm')
	local fout = assert(io.open(OUTPUT..name..'.html', 'w'))
	fout:write(slt2.render(tmpl))
	fout:close()
end

-- 3.5 xmls
for _, name in ipairs({'rss2.0', 'sitemap'}) do
	local tmpl = slt2.loadfile(name..'.temp.xml')
	local fout = assert(io.open(OUTPUT..name..'.xml', 'w'))
	fout:write(slt2.render(tmpl))
	fout:close()
end

-- 4. rainy pages
local rainy = require('rainy')

local rain = rainy.new()

-- config rainy
local jslibs_path = '/home/henix/jslibs'
rain:add_incpath(jslibs_path)
rain:add_moddef(jslibs_path..os.pathsep..'csv.js'..os.pathsep..'csv.moddef')
rain:add_moddef(jslibs_path..os.pathsep..'base.js'..os.pathsep..'base.moddef')
rain:add_moddef(jslibs_path..os.pathsep..'flower.js'..os.pathsep..'flower.moddef')
rain:add_moddef(jslibs_path..os.pathsep..'flower-widgets'..os.pathsep..'flowerui.moddef')

for _, name in ipairs({'index', 'search'}) do
	local tmpl = slt2.loadfile(name..'.temp.htm')
	local tmpname = os.tmpname()
	do -- slt2 render to tmp file
		local ftmp = assert(io.open(tmpname, 'w'))
		ftmp:write(slt2.render(tmpl))
		ftmp:close()
	end
	do -- rainy render to output
		local fout = assert(io.open(OUTPUT..name..'.html', 'w'))
		local f = coroutine.wrap(rainy.process_html)
		local line = f(rain, tmpname)
		while line ~= nil do
			fout:write(line, '\n')
			line = f(rain, tmpname)
		end
		fout:close()
	end
	os.remove(tmpname)
end
