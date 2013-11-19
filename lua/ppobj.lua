local ppobj = {}

local function obj2token(obj)
	if obj == nil then
		coroutine.yield('nil')
	elseif type(obj) == 'boolean' then
		coroutine.yield(tostring(obj))
	elseif type(obj) == 'number' then
		coroutine.yield(tostring(obj))
	elseif type(obj) == 'string' then
		coroutine.yield(string.format('%q', obj))
	elseif type(obj) == 'table' then
		coroutine.yield('{')
		for k, v in pairs(obj) do
			if type(k) == 'string' and string.match(k, '^[%a_][%w_]*$') then
				coroutine.yield(k)
			else
				coroutine.yield('[')
				obj2token(k)
				coroutine.yield(']')
			end
			coroutine.yield('=')
			obj2token(v)
			coroutine.yield(',')
		end
		coroutine.yield('}')
	else
		error('Unknown type: '..type(obj))
	end
end

local function decorate(co, tab)
return coroutine.create(function()
	local level = 0
	local atBegin = true

	function indent()
		coroutine.yield(string.rep(tab, level))
		atBegin = false
	end

	local ok, res = coroutine.resume(co)
	while ok and res do
		if res == '{' then
			coroutine.yield(res)
			coroutine.yield('\n')
			atBegin = true
			level = level + 1
		elseif res == '}' then
			if not atBegin then
				coroutine.yield('\n')
			end
			level = level - 1
			indent()
			coroutine.yield(res)
		elseif res == ',' then
			coroutine.yield(res)
			coroutine.yield('\n')
			atBegin = true
		elseif res == '=' then
			coroutine.yield(' ')
			coroutine.yield(res)
			coroutine.yield(' ')
		else
			if atBegin then
				indent()
			end
			coroutine.yield(res)
		end
		ok, res = coroutine.resume(co)
	end
	if not ok then
		error(res)
	end
end)
end

local function collect(co)
	local t = {}
	local ok, res = coroutine.resume(co)
	while ok and res do
		table.insert(t, res)
		ok, res = coroutine.resume(co)
	end
	if not ok then
		error(res)
	end
	return t
end

function ppobj.tostring(obj)
	return table.concat(collect(decorate(coroutine.create(function() obj2token(obj) end), '  ')))
end

return ppobj
