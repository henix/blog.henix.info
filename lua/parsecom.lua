require 'lxp'

local threads = {}
local comments = {}

-- status
local inPost = false
local inThread = false

local tid

local inThreadId = false
local inPostMessage = false
local inPostName = false

local function filter(str)
	if str == '2011_01_my-static-blog' then
		return 'my-static-blog'
	elseif str == '2011_01_mount-ntfs-user-permissions' then
		return 'mount-ntfs-user-permissions'
	end
	return str
end

local callbacks = {
	StartElement = function(parser, elementName, attr)
		if elementName == 'post' then
			inPost = true
			table.insert(comments, {})
			comments[#comments].dsqid = attr['dsq:id']
		elseif not inPost and elementName == 'thread' then
			inThread = true
			tid = attr['dsq:id']
			threads[tid] = {comnum = 0}
		elseif inThread then
			if elementName == 'link' then
				inThreadId = true
			end
		elseif inPost then
			if elementName == 'message' then
				inPostMessage = true
			elseif elementName == 'name' then
				inPostName = true
			elseif elementName == 'thread' then
				local t = threads[attr['dsq:id']]
				t.comnum = t.comnum + 1
				comments[#comments].threadid = t.id
			end
		end
	end,
	EndElement = function(parser, elementName)
		if elementName == 'post' then
			inPost = false
		elseif elementName == 'thread' and not inPost then
			inThread = false
		elseif inThread and inThreadId and elementName == 'link' then
			inThreadId = false
		elseif inPost and inPostMessage and elementName == 'message' then
			inPostMessage = false
		elseif inPost and inPostName and elementName == 'name' then
			inPostName = false
		end
	end,
	CharacterData = function(parser, str)
		if inThread and inThreadId then
			local myid = string.match(str, ".*/([^/]*)%.html$")
			assert(myid, '"'..str..'" cannot find a match')
			threads[tid].id = filter(myid)
		elseif inPost and inPostMessage then
			comments[#comments].msg = str
		elseif inPost and inPostName then
			comments[#comments].author = str
		end
	end
}

local parser = lxp.new(callbacks)

local fin = io.open(arg[1])
local all = fin:read('*a')
fin:close()

parser:parse(all)

print('comnum_table = {')
for id, v in pairs(threads) do
	io.write('\t[\'', v.id, '\'] = ', v.comnum, ',\n')
end
print('}')

function data2code(data)
	local t = type(data)
	if t == 'number' then
		return tostring(data)
	elseif t == 'string' then
		return string.format('%q', data)
	elseif t == 'table' then
		local ret = {'{\n'}
		for k, v in pairs(data) do
			table.insert(ret, '['..data2code(k)..']'..' = '..data2code(v)..',\n')
		end
		table.insert(ret, '}')
		return table.concat(ret)
	end
	return 'nil'
end

io.write('comments_table = ', data2code(comments), '\n')
