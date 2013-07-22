local line

local data = {}

line = io.read()
while line ~= nil do
	local matched = false
	local name, visit
	if not matched then
		name, visit = string.match(line, '^/blog/(.-)[.]html,"(.-)",')
		if name ~= nil then
			matched = true
			visit = string.gsub(visit, ',', '')
			visit = tonumber(visit)
			if data[name] == nil then
				data[name] = visit
			else
				data[name] = data[name] + visit
			end
		end
	end
	if not matched then
		name, visit = string.match(line, '^/blog/(.-)[.]html,(.-),')
		if name ~= nil then
			matched = true
			visit = tonumber(visit)
			if data[name] == nil then
				data[name] = visit
			else
				data[name] = data[name] + visit
			end
		end
	end
	line = io.read()
end

io.write(arg[1], ' = {\n')
for k, v in pairs(data) do
	io.write(string.format('\t[\'%s\'] = %s,\n', k, v))
end
io.write('}\n')
