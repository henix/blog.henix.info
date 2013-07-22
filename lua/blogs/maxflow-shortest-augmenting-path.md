　　最短增广路算法在黑书上有介绍，其时间复杂度跟 Edmonds-Karp 是一样的 O(VE<sup>2</sup>) ，而且编程还复杂些。那为什么我还要介绍这个算法呢？因为这个算法引入了“距离标号”的概念，是后面的预推流算法的基础。

### 距离标号

　　节点 i 的距离标号 d[i] 首先被初始化成 i 到汇 sink 的实际距离，即最短路径的长度。

　　然后，在增广的时候要遵循一条规则：增广路上的每一条弧，其起始点的距离标号必须比结束点的距离标号大 1 ，这样的弧称为允许弧（admissible arc）。

　　如果我们把距离标号看成高度（实际上在预推流里面就叫做 height），把图的流看成水流，那么上述规则可以理解成：水流只能从高的地方流向低的地方，且每次只能下降一级。这样一比喻，整个算法就容易理解了。

### 距离标号的修改

　　关键的问题是：为什么要修改距离标号呢？

　　我们先看看最短增广路算法的框架：

　　这个算法框架主要参考了《[网络流：算法、理论与应用](http://book.douban.com/subject/1316052/)》一书的 7.4 节，要注意跟[黑书](http://book.douban.com/subject/1154204/)上讲的最短增广路算法略有不同。

#{= highlight([=[
初始化所有点的距离标号
i = source
while d(s) < n do
	if i 有允许弧 e(i,j) then
		-- 将 (i,j) 这条弧记录进当前的增广路
		pred[j] = i
		i = j
		if i == sink then -- 如果已经到达汇点
			增广
			i = s
		end
	else
		-- 从 i 出发没有允许弧，则修改 i 的距离标号
		d(i) = min(d(j) + 1 | 弧 e(i,j) 在残余网络中且可增广容量 c(i,j) > 0)
		if i != s then
			i = pred[i] -- 若不是源，则退回一步
		end
	end
end
]=], 'lua')}#

　　黑书上的是如果没有允许弧则还要判断是否有弧，而且如果修改了也不会回退。

　　从 i 出发没有允许弧的时候，有两种情况：

1. 从 i 出发有可增广弧，但 i 的 d 值太低，所以修改距离标号，然后就可以增广了
2. 从 i 出发根本就没有可增广路，即满足上面的条件的 j 不存在，此时置 d(i) = n ，然后退一步。在我的代码中的体现是，min 的默认值是 n ，所以如果 j 不存在的话，就会把 n 赋给 d(i) 。

### 算法运行过程

　　下面以 poj 1273 为例，数据是：

```
5 4
1 2 40
1 4 20
2 4 20
2 3 30
3 4 10
```

　　0 是源，3 是汇。每个节点上标注了该节点的 d 值。

　　Step 1. 现在除汇外所有节点的 d 都等于 1 ，找到一条增广路：

#{= makeImg('/files/maxflow/2sp1.gif') }#

　　Step 2. 灰色节点表示此时必须修改距离标号。我们看到从 0 出发有 0 -&gt; 1 这条路还有容量，但由于 0 的距离标号太小，所以这不是允许弧：

#{= makeImg('/files/maxflow/2sp2.gif') }#

　　Step 3. 修改距离标号后，找到一条增广路：

#{= makeImg('/files/maxflow/2sp3.gif') }#

　　Step 4. 然后 1 又找不到允许弧了，于是修改它的距离标号，并回退到 0 ：

#{= makeImg('/files/maxflow/2sp4.gif') }#

　　Step 5. 从 0 开始，发现也没有允许弧，于是修改距离标号：

#{= makeImg('/files/maxflow/2sp5.gif') }#

　　Step 6. 0 的距离标号修改成 3 后，找到一条允许路：

#{= makeImg('/files/maxflow/2sp6.gif') }#

　　Step 7. 注意这张图的布局跟前面的已经不同，大家只要记住 0 是源，3 是汇就行了。

#{= makeImg('/files/maxflow/2sp7.gif') }#

　　Step 8. 

#{= makeImg('/files/maxflow/2sp8.gif') }#

　　Step 9. 0 号节点的距离标号终于被修改成 n = 4 ，算法结束。

#{= makeImg('/files/maxflow/2sp9.gif') }#

### 源代码

　　我的实现，在 oj 上测试，gcc 0ms 。

　　其中 init_distance() 用来获得初始距离。本来以为要用 Dijkstra 单源点最短路径算法的，但实际上，由于这里相当于费用全部等于 1 的特殊情形，所以用一个 BFS 遍历就可以了。

#{= highlight([=[
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <limits.h>
#include <assert.h>

struct edge_t {
	int capacity;
};

int source, sink;

int maxflow(int n, struct edge_t edges[n][n], int source, int sink) {
	int pred[n];
	int d[n]; // distance to sink
	int sum = 0;

	void augment_path() {
		int delta = INT_MAX;
		int nv = sink;
		int v;
		while (nv != source) {
			v = pred[nv];
			int t = edges[v][nv].capacity;
			if (t < delta) {
				delta = t;
			}
			nv = v;
		}
		nv = sink;
		while (nv != source) {
			v = pred[nv];
			edges[v][nv].capacity -= delta;
			edges[nv][v].capacity += delta;
			nv = v;
		}
		sum += delta;
	}

	void init_distance() {
		int queue[n];
		int qhead = 0;
		int qend = 0;
		queue[qend++] = sink;

		memset(d, 0, sizeof(d));

		while (qhead < qend) {
			int v = queue[qhead++];
			int i;
			for (i = 0; i < n; ++i) {
				if (edges[i][v].capacity > 0 && d[i] == 0) {
					d[i] = d[v] + 1;
					queue[qend++] = i;
				}
			}
		}
	}

	init_distance();

	int i = source;
	while (d[source] < n) {
		// find an admissible arc of i
		int j;
		bool found = false;
		int min = n;
		for (j = 0; j < n; ++j) {
			if (edges[i][j].capacity > 0) {
				if (d[i] == d[j] + 1) {
					found = true;
					break;
				}
				if (d[j] + 1 < min) {
					min = d[j] + 1; // btw, find the min
				}
			}
		}
		if (found) {
			pred[j] = i;
			i = j;
			if (i == sink) {
				augment_path();
				i = source;
			}
		} else {
			d[i] = min;
			if (i != source) {
				i = pred[i];
			}
		}
	}

	return sum;
}

int main(int argc, char const *argv[])
{
	int n, m;
	while (scanf("%d%d", &m, &n) == 2) {

		struct edge_t edges[n][n];
		memset(edges, 0, sizeof(edges));

		for (; m > 0; m--) {
			int s, e, c;
			scanf("%d%d%d", &s, &e, &c);
			s--; // my index start from 0
			e--;
			edges[s][e].capacity += c;
		}
		source = 0;
		sink = n - 1;
		int max = maxflow(n, edges, source, sink);
		printf("%d\n", max);
	}
	return 0;
}
]=], 'cpp', {lineno=true;collapse=true})}#

### 与 Dinic 算法的比较

　　Dinic 算法跟最短增广路算法很类似，但还是不一样的。Dinic 算法是建立了距离标号后在上面不断增广，不能增广后重新计算整个图的距离标号。详见参考资料。

### 参考资料

* [Dinic's algorithm - Wikipedia, the free encyclopedia](http://en.wikipedia.org/wiki/Dinic's_algorithm)
* [网络流：算法、理论与应用](http://book.douban.com/subject/1316052/)
* [算法艺术与信息学竞赛](http://book.douban.com/subject/1154204/)
