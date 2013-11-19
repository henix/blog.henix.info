　　最近遇到这样一个问题：生成 1 - N 的随机排列。这是一个比较常见的问题，生成一个有限集合的随机排列的时候就要用到。一种 naive 的算法是：

```
for i = 1..n do
  r = 1..n 之间的随机数
  while (r 已经被选择) do
    r = 1..n 之间的随机数
  end
  ar[i] = r
  将 r 标记为已被选择
end
```

　　这种算法的问题是，当可供选择的数很少的时候（极端情况是只剩最后一个），大量的时间都浪费在 while 循环上了，理论上平均时间复杂度达到 O(n<sup>2</sup>) ，而且还需要额外空间记录是否已经使用。

　　实际上，前人早已研究过这个问题。Random Shuffle 算法可以在 O(n) 的时间内随机打乱一个数组，所以只需要把 1..N 保存在一个数组中，再 shuffle 这个数组即可。实现方法参见维基百科 [Fisher–Yates shuffle](http://en.wikipedia.org/wiki/Fisher–Yates_shuffle) 。正确性证明参见 Knuth 的《计算机程序设计艺术（第二卷）：半数值算法》。

　　不少语言已经在标准库中包含了这个函数：

Python

#{= highlight([=[
import random

random.shuffle(ar)
]=], 'python')}#

Java

#{= highlight([=[
import java.util.Collections;

Collections.shuffle(List<?> list);
]=], 'java')}#

C++

#{= highlight([=[
#include <algorithm>

const int N = 8;
int ar[] = {1, 2, 3, 4, 5, 6, 7, 8};
random_shuffle(ar, ar + N);
]=], 'cpp')}#

　　Lua 标准库中没有这个函数，我的实现：

#{= highlight([=[
-- random shuffle a table in place
function shuffle(t)
	for i = #t,1,-1 do
		local j = math.random(1, i)
		-- exchange t[i] and t[j]
		local tmp = t[i]
		t[i] = t[j]
		t[j] = tmp
	end
end
]=], 'lua')}#

　　下载了 [JDK6 源代码](http://download.java.net/jdk6/source/)来看，java.util.Collections.shuffle() 实现如下：

#{= highlight([=[
public static void shuffle(List<?> list, Random rnd) {
	int size = list.size();
	if (size < SHUFFLE_THRESHOLD || list instanceof RandomAccess) {
		for (int i=size; i>1; i--)
			swap(list, i-1, rnd.nextInt(i));
	} else {
		Object arr[] = list.toArray();

		// Shuffle array
		for (int i=size; i>1; i--)
			swap(arr, i-1, rnd.nextInt(i));

		// Dump array back into list
		ListIterator it = list.listIterator();
		for (int i=0; i<arr.length; i++) {
			it.next();
			it.set(arr[i]);
		}
	}
}

public static void swap(List<?> list, int i, int j) {
	final List l = list;
	l.set(i, l.set(j, l.get(i)));
}
]=], 'java')}#

　　基本原理是一样的。上面的代码还给了我们一个在 Java 中交换 list 中两元素的比较高效的写法（不需要额外局部变量）。

Links:

* [Fisher–Yates shuffle - Wikipedia, the free encyclopedia](http://en.wikipedia.org/wiki/Fisher–Yates_shuffle)
* [SGI STL 的 random_shuffle 文档](http://www.sgi.com/tech/stl/random_shuffle.html)
