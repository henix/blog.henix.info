　　网络流问题定义什么的我就不介绍了，网上到处都找得到。

　　我第一次听说“最大流有 4 种做法”，大约是在这篇帖子里：[http://tieba.baidu.com/p/1359675218](http://tieba.baidu.com/p/1359675218) ，现在知道最大流的求法不止 4 种。

寻找增广路派：

1. 原始的 Ford-Fulkerson 算法，用 DFS 寻找增广路
2. Edmonds-Karp 算法，用 BFS 寻找增广路
3. 最短增广路算法，引入距离标号、允许弧，每次在允许弧上增广
4. Dinic 算法，引入层次网络

预推流派：

1. 原始预推流
2. FIFO 实现预推流
3. 最高标号预推流

　　还有 R.E.Tarjan 大神的 link/cut tree ，使得时间复杂度降到 log 级。

　　Edmonds-Karp 就是用 BFS 在残余网络上寻找增广路，时间复杂度 O(VE<sup>2</sup>) 。以 poj 1273 这题为例，下面是我第一次写的代码：

#{= highlight([=[
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <limits.h>
#include <assert.h>

struct edge_t {
	int capacity;
	int flow;
};

int source, sink;

int step = 0;

int maxflow(int n, struct edge_t edges[n][n], int source, int sink) {
	int parent[n];

	void augment_path() {
		int delta = INT_MAX;
		int nv = sink;
		int v;
		while (nv != source) {
			v = parent[nv];
			int t = edges[v][nv].capacity - edges[v][nv].flow;
			if (t < delta) {
				delta = t;
			}
			nv = v;
		}
		nv = sink;
		while (nv != source) {
			v = parent[nv];
			edges[v][nv].flow += delta;
			edges[nv][v].flow -= delta;
			nv = v;
		}
	}

	bool find_path() {
		int queue[n];
		int qhead = 0;
		int qend = 0;
		queue[qend++] = source;

		bool occured[n];
		memset(occured, 0, sizeof(occured));
		occured[source] = true;

		while (qhead < qend) {
			int v = queue[qhead++];
			if (edges[v][sink].flow < edges[v][sink].capacity) {
				parent[sink] = v;
				return true;
			}
			int i;
			for (i = 0; i < n; ++i) {
				if (!occured[i]) {
					if (edges[v][i].flow < edges[v][i].capacity) {
						occured[i] = true;
						parent[i] = v;
						queue[qend++] = i;
					}
				}
			}
		}
		return false;
	}

	while (find_path()) {
		augment_path();
		// dump(sink);
	}

	int sum = 0;
	int i;
	for (i = 0; i < n; ++i) {
		sum += edges[source][i].flow;
	}
	return sum;
}

int main(int argc, char const *argv[])
{
	int n, m;
	while (scanf("%d%d", &m, &n) == 2) {

		struct edge_t edges[n][n];
		memset(edges, 0, sizeof(edges));

		bool soccured[n];
		bool eoccured[n];
		memset(soccured, 0, sizeof(soccured));
		memset(eoccured, 0, sizeof(eoccured));

		for (; m > 0; m--) {
			int s, e, c;
			scanf("%d%d%d", &s, &e, &c);
			s--; // my index start from 0
			e--;
			edges[s][e].capacity += c;
			edges[s][e].flow = 0;
			soccured[s] = true;
			eoccured[e] = true;
		}
		source = 0;
		sink = n - 1;
		// puts("digraph G {");
		// puts("rankdir=LR");
		int max = maxflow(n, edges, source, sink);
		printf("%d\n", max);
		// puts("}");
	}
	return 0;
}
]=], 'cpp', {lineno=true;collapse=true})}#

　　主要参考了 [wiki](http://en.wikipedia.org/wiki/Edmonds–Karp_algorithm) 。但后来看了别人写的代码，发现其实 flow 可以不用保存，第二版：

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

int step = 0;

int maxflow(int n, struct edge_t edges[n][n], int source, int sink) {
	int parent[n];
	int sum = 0;

	void augment_path() {
		int delta = INT_MAX;
		int nv = sink;
		int v;
		while (nv != source) {
			v = parent[nv];
			int t = edges[v][nv].capacity;
			if (t < delta) {
				delta = t;
			}
			nv = v;
		}
		nv = sink;
		while (nv != source) {
			v = parent[nv];
			edges[v][nv].capacity -= delta;
			edges[nv][v].capacity += delta;
			nv = v;
		}
		sum += delta;
	}

	bool find_path() {
		int queue[n];
		int qhead = 0;
		int qend = 0;
		queue[qend++] = source;

		bool occured[n];
		memset(occured, 0, sizeof(occured));
		occured[source] = true;

		while (qhead < qend) {
			int v = queue[qhead++];
			if (edges[v][sink].capacity > 0) {
				parent[sink] = v;
				return true;
			}
			int i;
			for (i = 0; i < n; ++i) {
				if (!occured[i]) {
					if (edges[v][i].capacity > 0) {
						occured[i] = true;
						parent[i] = v;
						queue[qend++] = i;
					}
				}
			}
		}
		return false;
	}

	while (find_path()) {
		augment_path();
		// dump(sink);
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
		// puts("digraph G {");
		// puts("rankdir=LR");
		int max = maxflow(n, edges, source, sink);
		printf("%d\n", max);
		// puts("}");
	}
	return 0;
}
]=], 'cpp', {lineno=true;collapse=true})}#

　　capacity 可以看成“这条边上可以增加的流的大小”，当前找到的增广路保存在 parent 数组里。

### 实测效率

　　在 OJ 上实测，如果用原始的 Ford-Fulkerson 算法，则 TLE ，因为原始算法的时间复杂度跟最大流的大小有关。而用 Edmonds-Karp 就 0ms 过了。

### 参考资料

* [Edmonds–Karp algorithm - Wikipedia, the free encyclopedia](http://en.wikipedia.org/wiki/Edmonds–Karp_algorithm)
