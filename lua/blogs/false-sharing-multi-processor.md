　　最近读《[多核计算与程序设计](http://book.douban.com/subject/3624015/)》，其中提到了伪共享问题。

　　伪共享（false sharing）是多核编程中特有的问题。而且牵扯到 Cache ……什么东西一牵扯到 Cache 就变得异常复杂。

　　我们知道 CPU Cache 是按行进行的，位置相近的内存会被放入同一个 Cache 行，这被称为程序的局部性（RAM Locality）。但是，如果多个 CPU 访问的内存单元距离很近，以至于落入了同一个 Cache 行，这时表面上访问的是不同的内存单元，但实际上这几个 CPU 会把同一块内存放入自己的 Cache 中（多核架构中，每个 CPU 都有自己的 Cache），如果此时多个 CPU 再同时修改这块内存，就会导致 Cache 间的不一致性。所以，CPU 内部为了避免不一致性，当一个核心修改一块内存时，会把其他核心的同一行的 Cache 作废，结果使性能严重下降。

　　为了验证是否真的存在伪共享，以及伪共享会造成多大的性能损失，我使用了如下代码来测试（需要 OpenMP）：

```cpp
#include <stdio.h>

int main(int argc, const char *argv[])
{
	int ar[80];
	#pragma omp parallel num_threads(2)
	{
		int n = omp_get_thread_num() ? 16 : 0;
		int i;
		for (i = 0; i < 1000000000; i++) {
			ar[n] = i;
		}
	}
	return 0;
}
```

　　这段代码用两个线程写入数组中的两个不同的位置。这里的 16 是两个变量距离了多少个 4 字节。测试结果如下（time 命令测量，单位秒）：

<table style="width:100%">
<tr><th>距离/4字节</th><th>real</th><th>user</th><th>sys</th></tr>
<tr><td>1</td><td>10.387</td><td>15.616</td><td>0.047</td></tr>
<tr><td>2</td><td>8.392</td><td>12.316</td><td>0.047</td></tr>
<tr><td>4</td><td>8.251</td><td>12.436</td><td>0.030</td></tr>
<tr><td>8</td><td>8.323</td><td>12.646</td><td>0.047</td></tr>
<tr><td>16</td><td>4.114</td><td>6.410</td><td>0.020</td></tr>
<tr><td>32</td><td>5.113</td><td>7.110</td><td>0.013</td></tr>
<tr><td>64</td><td>4.470</td><td>6.626</td><td>0.027</td></tr>
</table>

　　在 16 x 4 = 64 字节处有一次突变，64 字节就是我的电脑的 Cache 行大小。也可以通过这个命令查到：

```bash
cat /proc/cpuinfo | grep cache_alignment
```

Further reading:

* [多处理器系统下的伪共享（false sharing）问题 « Sheen Space](http://sheenspace.wordpress.com/2010/09/20/02/)
* [多核编程伪共享问题及其对策 – 中文 - 英特尔® 软件网络](http://software.intel.com/zh-cn/blogs/2009/03/26/400001186/)
* [False sharing - Wikipedia, the free encyclopedia](http://en.wikipedia.org/wiki/False_sharing)
