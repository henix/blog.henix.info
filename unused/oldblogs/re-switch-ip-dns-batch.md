　　// 旧地址 [http://blog.csdn.net/shell_picker/archive/2010/07/21/5753226.aspx](http://blog.csdn.net/shell_picker/archive/2010/07/21/5753226.aspx)：

　　平时奔走于寝室和实验室两地，经常需要切换 IP/DNS 配置。曾经在网上看了一段用 netsh 的切换脚本，下面这段是我对其的改进版：

#{= highlight([=[
set OUT=%tmp%\telecom.txt
set name="本地连接"

echo interface ip set address %name% static 192.168.7.24 255.255.255.0 192.168.7.1 0 > %OUT%
echo interface ip set dns %name% static 202.114.0.242 >> %OUT%
echo interface ip add dns %name% 202.112.20.131 >> %OUT%
echo interface ip add dns %name% 202.103.24.68 >> %OUT%
echo interface ip add dns %name% 202.103.0.117 >> %OUT%
echo interface ip add dns %name% 58.205.224.44 >> %OUT%
echo interface ip add dns %name% 202.103.44.150 >> %OUT%

netsh -f %OUT%

pause
]=], 'bat', {lineno=true})}#

　　网上很多都是每条指令一个 netsh ，这样 netsh 每次都要初始化，速度比较慢。而我这个先写到一个文件里面，再把整个当成一个脚本运行，netsh 只初始化一次，速度较快。
