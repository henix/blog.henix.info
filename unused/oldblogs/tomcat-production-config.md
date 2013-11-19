### 1. 安装 tomcat-native 包

#{= highlight([=[
yum install tomcat-native
]=], 'bash') }#

　　这个包不需要额外配置，安装后就会自动启用。使用后减少了很多 TIME\_WAIT 和 CLOSE\_WAIT 。可见 [native](http://tomcat.apache.org/native-doc/) 包确实在网络连接上下了很多功夫。

### 2. URIEncoding="UTF-8"

### 3. 配置 gzip

#{= highlight([=[
compression="2048" compressableMimeType="text/html,text/xml,text/plain,text/css,text/javascript,application/json"
]=], 'xml') }#

　　对指定的 mimetype 并且响应大小超过指定的字节数的响应使用 gzip 。

### 4. 开启 JMX

#{= highlight([=[
-Dcom.sun.management.jmxremote
-Dcom.sun.management.jmxremote.port=8390
-Dcom.sun.management.jmxremote.ssl=false
-Dcom.sun.management.jmxremote.authenticate=false
]=], 'objc') }#

　　这个主要是用于远程 profile 。场景：有一 tomcat 运行在远程，本机和远程之间只有 ssh 连接，想对 tomcat 上的程序进行 profile 。

　　方案：[Tunnel VisualVM (JMX) over SSH](https://bowerstudios.com/node/731)（注意看 comments）。大致步骤：

1. 开启 tomcat 的 JMX ，比如我用了端口 8390
2. ssh 连接远程时使用 ssh -D 4646 建立一个 socks5 tunnel
3. 打开 VisualVM ，在网络配置中设置使用 proxy ，为本机的 4646 端口
4. 添加一个远程 JMX 主机，ip 为远程的 ip ，端口为 JMX 的端口

### 附：Java 生产环境常用命令

1. jps -v 列出进程
2. jstack pid 打印 stacktrace
3. jmap -heap pid 检查 GC 情况
4. jinfo -flag flag pid 检查是否设置了某个 flag ，例：
	* jinfo -flag UseG1GC
	* jinfo -flag DoEscapeAnalysis
5. java -XX:+PrintFlagsFinal 列举所有可用的 flags
