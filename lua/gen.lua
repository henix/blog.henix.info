#!/usr/bin/env lua

local ppobj = require('ppobj')

local function updateFile(fname, content)
	local fin = io.open(fname)
	local all = nil
	if fin ~= nil then
		all = fin:read('*a')
		fin:close()
	end
	if all ~= content then
		local fout = assert(io.open(fname, 'w'))
		fout:write(content)
		fout:close()
	end
end

local function split(s)
	local t = {}
	for w in string.gmatch(s, '[^\t]+') do
		table.insert(t, w)
	end
	return t
end

local CatnameById = {}
local fcate = io.open('category.db')
for line in fcate:lines() do
	local t = split(line)
	CatnameById[t[1]] = t[2]
end
fcate:close()

-- 0. mkdirs

os.execute('mkdir -p build/post')
os.execute('mkdir -p build/page')
os.execute('mkdir -p build/rss')

-- 1. posts.db -> build/post/%.lua

local CatpostById = {}
local posts = {}

local fposts = io.open('posts.db')
for line in fposts:lines() do
	local id, title, date, catid = unpack(split(line))
	local post = {
		id = id,
		title = title,
		publish_time = date,
		catid = catid,
		catname = CatnameById[catid],
		postfile = 'build/post/'..id..'.htm',
	}
	table.insert(posts, post)
	updateFile('build/post/'..id..'.lua', ppobj.tostring(post)..'\n')

	if CatpostById[catid] == nil then
		CatpostById[catid] = {}
	end
	table.insert(CatpostById[catid], post)
end
fposts:close()

-- 2. pages.db -> build/page/%.lua

local pages = {}

local fpages = io.open('pages.db')
for line in fpages:lines() do
	local id, title, ename = unpack(split(line))
	updateFile('build/page/'..id..'.lua', string.format('{ id = %q, title = %q, ename = %q, postfile = %q }\n', id, title, ename, 'build/page/'..id..'.htm'))

	table.insert(pages, { id = id, title = title, ename = ename })
end
fpages:close()

-- 3. index.lua

local categories = {}

for k, v in pairs(CatpostById) do
	table.insert(categories, { catid = k, catname = CatnameById[k], posts = v })
end

table.sort(categories, function(a, b)
	return a.posts[1].publish_time > b.posts[1].publish_time
end)

updateFile('build/index.lua', ppobj.tostring({ categories = categories, pages = pages })..'\n')

-- 4. rss.lua

updateFile('build/rss.lua', ppobj.tostring({ posts = posts })..'\n')

-- 4.1 categories -> build/rss/%.lua

for _, c in ipairs(categories) do
	updateFile('build/rss/'..c.catid..'.lua', ppobj.tostring(c)..'\n')

	local t = {}
	for _, p in ipairs(c.posts) do
		table.insert(t, p.postfile)
	end

	updateFile('build/rss/'..c.catid..'.xml.d', 'output/rss/'..c.catid..'.xml: '..table.concat(t, ' ')..'\n')
end
