## 检查是否包含某字符串

一般：

#{= highlight([=[
if (str.indexOf("xxx") != -1)
]=], 'java')}#

好：

#{= highlight([=[
if (str.contains("xxx"))
]=], 'java')}#

## 定时任务

一般：

#{= highlight([=[
Timer timer = new Timer();
timer.schedule(TimerTask);
]=], 'java')}#

好：

#{= highlight([=[
ScheduledExecutorService executor = Executors.newScheduledThreadPool(3);
executor.scheduleWithFixedDelay(Runnable);
]=], 'java')}#

## 某个变量，有多个线程会读取，只有一个线程修改它，需要保证读到正确值

差：

互斥（synchronized 同步化块）

一般：

读写锁（ReentrantReadWriteLock）

好：

volatile 变量

参考文章：

* [聊聊并发（一）——深入分析Volatile的实现原理](http://www.infoq.com/cn/articles/ftf-java-volatile)
* [聊聊并发（四）——深入分析ConcurrentHashMap](http://www.infoq.com/cn/articles/ConcurrentHashMap)

## 关闭流

一般：

#{= highlight([=[
InputStream in = null;
try {
	in = new InputStream(...);
} finally {
	if (in != null) {
		try { in.close(); } catch (IOException e) {}
	}
}
]=], 'java')}#

好：

#{= highlight([=[
import org.apache.commons.io.IOUtils;

InputStream in = null;
try {
	in = new InputStream(...);
} finally {
	IOUtils.closeQuietly(in);
}
]=], 'java')}#

## String 和 byte[] 互转

一般：

#{= highlight([=[
try {
	str.getBytes("UTF-8");
} catch (UnsupportedEncodingException e) {
	throw RuntimeException(e);
}
]=], 'java')}#

好：

#{= highlight([=[
import org.apache.commons.io.Charsets;

str.getBytes(Charsets.UTF_8);
]=], 'java')}#

注：JDK7 中引入了 `java.nio.charset.StandardCharsets` ，`org.apache.commons.io.Charsets` 相当于一个垫片（shim）

## 数据库连接池

一般：commons-dhcp 或 c3p0

好：tomcat-jdbc

## 初始化 String[] 常量

一般：

#{= highlight([=[
static final String[] X = new String[]{"a", "b"}; 
]=], 'java')}#

好：

#{= highlight([=[
static final String[] X = {"a", "b"};
]=], 'java')}#

## 标记某个类是非线程安全的

一般：

#{= highlight([=[
/**
 * 非线程安全
 */
public class X {
    ...
}
]=], 'java')}#

好：

#{= highlight([=[
import net.jcip.annotations.NotThreadSafe;

@NotThreadSafe
public class X {
    ...
}
]=], 'java')}#

注：能用代码表达的就不用注释
