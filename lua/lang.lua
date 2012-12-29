local ftest = io.open('/dev/null')
if ftest == nil then
	os.pathsep = '\\' -- windows
else
	ftest:close()
	ftest = nil
	os.pathsep = '/' -- linux
end
