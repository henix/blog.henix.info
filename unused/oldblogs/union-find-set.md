　　并查集（Union-find set）用来表示一些不相交集合（Disjoint set），并且可以高效地实现以下两种操作：

* 查询：查询某个元素在哪个集合里
* 合并：合并两个集合

　　实现一般需要一个 father 数组，将集合实现成树，树的根就是这个集合的代表元。合并两个集合的时候，将其中一个的根节点的 father 设为另外一个。

　　并查集的关键就在于两个优化：

<ol>
<li>路径压缩（path compression）：因为我们只关心一个元素属于哪个集合，查找的时候可以把路径上的所有元素的父亲直接设为根，这样下次查找的时候就一步到位了。

#{= highlight([=[
int find(int x) {
	if (father[x] != x) {
		father[x] = find(father[x]);
	}
	return father[x];
}
]=], 'cpp')}#
</li>
<li>按秩合并（union by rank）：或“启发式合并”。为了避免合并的时候出现某些畸形的情况，比如树退化成一个单链表，导致查询时间变成 O(n) 。我们可以再开一个数组 rank ，rank[i] （当 i 为根时才有意义）表示这棵树的高度。然后我们可以把高度小的树合并到高度大的树上，但又由于路径压缩，高度会改变，所以下面的 rank 相当于是曾经到过的最大高度：

#{= highlight([=[
void union2(int x, int y) {
	int xRoot = find(x);
	int yRoot = find(y);
	if (xRoot == yRoot) {
		return;
	}
	if (rank[xRoot] < rank[yRoot]) {
		father[xRoot] = yRoot;
	} else {
		father[yRoot] = xRoot;
		if (rank[xRoot] == rank[yRoot]) {
			rank[xRoot]++;
		}
	}
}
]=], 'cpp')}#

	若不等，小合并进大的，若相等，随意，且高度 + 1 。
</li>
</ol>

　　以前我不理解并查集。集合嘛，用 STL 的 set 或者 Java 的 HashSet 不就行了？这些虽然也可以实现集合的并交补等运算，但并查集是专门用来高效实现“并”和“查”这两种运算的，单个操作的均摊时间复杂度为 O(α(n)) ，α 是 Ackermann 函数的反函数，α(n) 可以近似看成小于 5 的，所以相当于是 O(1) 。

　　还有人做了[并查集动画演示](http://www.cs.usfca.edu/~galles/visualization/DisjointSets.html)，可以帮助理解。

一些题目：

poj 2524 Ubiquitous Religions

　　最基本的并查集

#{= highlight([=[
#include <cstdio>
#include <cassert>

using namespace std;

class DisjointSet {
private:
	int size;
	int *father;
	int *rank;
public:
	DisjointSet(int size) {
		this->size = size;
		father = new int[size];
		rank = new int[size];
		reset();
	}
	~DisjointSet() {
		delete[] rank;
		delete[] father;
	}
	void reset() {
		for (int i = 0; i < size; i++) {
			father[i] = i;
			rank[i] = 0;
		}
	}
	int find(int x) {
		assert(x >= 0 && x < size);
		if (father[x] != x) {
			father[x] = find(father[x]);
		}
		return father[x];
	}
	/**
	 * Union by height
	 */
	void union2(int x, int y) {
		assert(x >= 0 && x < size);
		assert(y >= 0 && y < size);
		int xRoot = find(x);
		int yRoot = find(y);
		if (xRoot == yRoot) {
			return;
		}
		if (rank[xRoot] < rank[yRoot]) {
			father[xRoot] = yRoot;
		} else if (rank[xRoot] > rank[yRoot]) {
			father[yRoot] = xRoot;
		} else {
			father[yRoot] = xRoot;
			rank[xRoot]++;
		}
	}
	int count() const {
		int s = 0;
		for (int i = 0; i < size; i++) {
			if (father[i] == i) {
				s++;
			}
		}
		return s;
	}
};

int main(int argc, const char *argv[])
{
	int n, m;
	int casen = 1;
	while (1) {
		scanf("%d%d", &n, &m);
		if (n == 0 && m == 0) {
			break;
		}
		DisjointSet unfs(n);
		for (; m > 0; m--) {
			int i, j;
			scanf("%d%d", &i, &j);
			i--;
			j--; // my index start from 0
			unfs.union2(i, j);
		}
		printf("Case %d: %d\n", casen, unfs.count());
		casen++;
	}
	return 0;
}
]=], 'cpp', {lineno=true;collapse=true})}#

poj 1308 Is It A Tree?

　　判断一个图是否是一棵树。此题要考虑的细节很多，要排除几种情况：

1. 包含环
2. 一个节点有两个父亲
3. 森林不是树，但空树是树

　　我一开始没考虑到空树，后来看了 [http://poj.org/showmessage?message_id=52986](http://poj.org/showmessage?message_id=52986) 给出的几组数据才恍然大悟。

　　此题我没有用按秩合并，只用了路径压缩，因为判断一个节点不能有两个父亲的时候必须有正确的父子关系。

#{= highlight([=[
#include <cstdio>

using namespace std;

#define N 1000

int father[N];
bool occured[N];

void reset() {
	for (int i = 0; i < N; i++) {
		occured[i] = false;
	}
	for (int i = 0; i < N; i++) {
		father[i] = i;
	}
}

int find(int x) {
	if (father[x] != x) {
		father[x] = find(father[x]);
	}
	return father[x];
}

bool union2(int x, int y) {
	int xRoot = find(x);
	int yRoot = find(y);
	if (xRoot == yRoot) {
		return false;
	}
	father[yRoot] = xRoot;
	return true;
}

enum eResult {
	Unknown, Yes, No
} result;

int main(int argc, const char *argv[])
{
	int casen = 1;
	reset();
	result = Unknown;
	while (1) {
		int x, y;
		scanf("%d%d", &x, &y);
		if (x == -1 && y == -1) {
			break;
		}
		if (x == 0 && y == 0) {
			// count root
			if (result == Unknown) {
				int root = 0;
				for (int i = 0; i < N; i++) {
					if (occured[i] && (father[i] == i)) {
						root++;
						if (root > 1) {
							break;
						}
					}
				}
				if (root > 1) { // empty tree is a tree
					result = No;
				}
			}
			// output
			printf("Case %d is %sa tree.\n", casen, (result == No) ? "not " : "");
			reset();
			result = Unknown;
			casen++;
			continue;
		}
		if (result == Unknown) {
			occured[x] = true;
			occured[y] = true;
			if (father[y] == y) {
				if (! union2(x, y)) {
					result = No; // a loop
				}
			} else {
				// double father, end
				result = No;
			}
		}
	}
	return 0;
}
]=], 'cpp', {lineno=true;collapse=true})}#

poj 1988 Cube Stacking

　　跟黑书上的“银河英雄传说”（NOI 2002 Galaxy）那道题是一样的。增加两个数组：distance[i] 表示 i 与其父节点的距离，maxnum[i] 只有当 i 是根节点时有效，表示 i 所在的那一列的 cube 的总数。

#{= highlight([=[
#include <cstdio>

using namespace std;

#define N 30001

int father[N];
int distance[N];
int maxnum[N];

void reset() {
	for (int i = 0; i < N; i++) {
		father[i] = i;
	}
	for (int i = 0; i < N; i++) {
		distance[i] = 0;
	}
	for (int i = 0; i < N; i++) {
		maxnum[i] = 1;
	}
}

int find(int x) {
	if (father[x] != x) {
		int newfather = find(father[x]);
		distance[x] += distance[father[x]];
		father[x] = newfather;
	}
	return father[x];
}

void move(int from, int to) {
	int x = find(from);
	int y = find(to);
	if (x == y) {
		return;
	}
	father[x] = y;
	distance[x] = maxnum[y];
	maxnum[y] += maxnum[x];
}

int count(int x) {
	find(x);
	return distance[x];
}

int main(int argc, const char *argv[])
{
	int p;
	scanf("%d", &p);
	reset();
	for (; p > 0; p--) {
		char op[4];
		scanf("%s", op);
		if (op[0] == 'M') {
			int x, y;
			scanf("%d%d", &x, &y);
			move(x, y);
		} else if (op[0] == 'C') {
			int x;
			scanf("%d", &x);
			printf("%d\n", count(x));
		}
	}
	return 0;
}
]=], 'cpp', {lineno=true;collapse=true})}#

poj 1703 Find them, Catch them

　　并查集，再加上一个 oppose 数组，oppose[i] 表示 i 的对立者是哪个集合。合并的时候，如果 oppose[i] 没有赋初值，则需要赋初值，否则可以不用更新 oppose 数组。

#{= highlight([=[
#include <cstdio>
#include <cassert>

using namespace std;

#define N 100001

int oppose[N];

class DisjointSet {
private:
	int size;
	int *father;
	int *rank;
public:
	DisjointSet(int size) {
		this->size = size;
		father = new int[size];
		rank = new int[size];
		reset();
	}
	~DisjointSet() {
		delete[] rank;
		delete[] father;
	}
	void reset() {
		for (int i = 0; i < size; i++) {
			father[i] = i;
			rank[i] = 0;
		}
	}
	int find(int x) {
		if (x < 0 || x >= size) {
			return -1;
		}
		if (father[x] != x) {
			father[x] = find(father[x]);
		}
		return father[x];
	}
	/**
	 * Union by height
	 */
	void union2(int x, int y) {
		assert(x >= 0 && x < size);
		assert(y >= 0 && y < size);
		int xRoot = find(x);
		int yRoot = find(y);
		if (xRoot == yRoot) {
			return;
		}
		if (rank[xRoot] < rank[yRoot]) {
			father[xRoot] = yRoot;
		} else if (rank[xRoot] > rank[yRoot]) {
			father[yRoot] = xRoot;
		} else {
			father[yRoot] = xRoot;
			rank[xRoot]++;
		}
	}
};

int main(int argc, const char *argv[])
{
	int t;
	scanf("%d", &t);
	for (; t > 0; t--) {
		int n, m;
		scanf("%d%d", &n, &m);
		// init
		DisjointSet unfs(n + 1);
		for (int i = 1; i <= n; i++) {
			oppose[i] = -1;
		}
		for (; m > 0; m--) {
			char op[4];
			int a, b;
			scanf("%s%d%d", op, &a, &b);
			if (op[0] == 'A') {
				int aRoot = unfs.find(a);
				int bRoot = unfs.find(b);
				if (aRoot == bRoot) {
					puts("In the same gang.");
				} else {
					if (aRoot == unfs.find(oppose[bRoot]) && bRoot == unfs.find(oppose[aRoot])) {
						puts("In different gangs.");
					} else {
						puts("Not sure yet.");
					}
				}
			} else if (op[0] == 'D') {
				int aRoot = unfs.find(a);
				int bRoot = unfs.find(b);
				if (aRoot != bRoot) {
					if (oppose[aRoot] == -1 && oppose[bRoot] == -1) {
						// init
						oppose[aRoot] = bRoot;
						oppose[bRoot] = aRoot;
					} else if (oppose[aRoot] == -1 && oppose[bRoot] != -1) {
						oppose[aRoot] = bRoot;
						unfs.union2(oppose[bRoot], aRoot);
					} else if (oppose[aRoot] != -1 && oppose[bRoot] == -1) {
						oppose[bRoot] = aRoot;
						unfs.union2(oppose[aRoot], bRoot);
					} else {
						unfs.union2(oppose[bRoot], aRoot);
						unfs.union2(oppose[aRoot], bRoot);
					}
				}
			}
		}
	}
	return 0;
}
]=], 'cpp', {lineno=true;collapse=true})}#

poj 2492 A Bug's Life

　　跟 1703 基本一样，把代码改改就 AC 了。

#{= highlight([=[
#include <cstdio>
#include <cassert>

using namespace std;

#define N 100001

int oppose[N];

class DisjointSet {
private:
	int size;
	int *father;
	int *rank;
public:
	DisjointSet(int size) {
		this->size = size;
		father = new int[size];
		rank = new int[size];
		reset();
	}
	~DisjointSet() {
		delete[] rank;
		delete[] father;
	}
	void reset() {
		for (int i = 0; i < size; i++) {
			father[i] = i;
			rank[i] = 0;
		}
	}
	int find(int x) {
		if (x < 0 || x >= size) {
			return -1;
		}
		if (father[x] != x) {
			father[x] = find(father[x]);
		}
		return father[x];
	}
	/**
	 * Union by height
	 */
	void union2(int x, int y) {
		assert(x >= 0 && x < size);
		assert(y >= 0 && y < size);
		int xRoot = find(x);
		int yRoot = find(y);
		if (xRoot == yRoot) {
			return;
		}
		if (rank[xRoot] < rank[yRoot]) {
			father[xRoot] = yRoot;
		} else if (rank[xRoot] > rank[yRoot]) {
			father[yRoot] = xRoot;
		} else {
			father[yRoot] = xRoot;
			rank[xRoot]++;
		}
	}
};

int main(int argc, const char *argv[])
{
	int t;
	scanf("%d", &t);
	for (int t1 = 0; t1 < t; t1++) {
		int n, m;
		scanf("%d%d", &n, &m);
		// init
		DisjointSet unfs(n + 1);
		for (int i = 1; i <= n; i++) {
			oppose[i] = -1;
		}
		bool found = false;
		for (; m > 0; m--) {
			int a, b;
			scanf("%d%d", &a, &b);
			int aRoot = unfs.find(a);
			int bRoot = unfs.find(b);
			if (aRoot == bRoot) {
				found = true;
			}
			if (!found) {
				if (oppose[aRoot] == -1 && oppose[bRoot] == -1) {
					// init
					oppose[aRoot] = bRoot;
					oppose[bRoot] = aRoot;
				} else if (oppose[aRoot] == -1 && oppose[bRoot] != -1) {
					oppose[aRoot] = bRoot;
					unfs.union2(oppose[bRoot], aRoot);
				} else if (oppose[aRoot] != -1 && oppose[bRoot] == -1) {
					oppose[bRoot] = aRoot;
					unfs.union2(oppose[aRoot], bRoot);
				} else {
					unfs.union2(oppose[bRoot], aRoot);
					unfs.union2(oppose[aRoot], bRoot);
				}
			}
		}
		printf("Scenario #%d:\n", t1 + 1);
		if (found) {
			puts("Suspicious bugs found!");
		} else {
			puts("No suspicious bugs found!");
		}
		putchar('\n');
	}
	return 0;
}
]=], 'cpp', {lineno=true;collapse=true})}#

poj 1182 食物链

　　此题稍难，加上一个数组 delta 表示 i 与其父亲的关系：

* 1 ：i 吃 father[i]
* 0 ：i 与 father[i] 是同类
* -1 ：i 被 father[i] 吃

　　然后在压缩路径和合并的时候更新 delta 数组。几组测试数据：[http://poj.org/showmessage?message_id=93058](http://poj.org/showmessage?message_id=93058)

　　另一种思路是跟 1703 一样，但需要另外两个数组：eat[i] 表示 i 吃的集合，eaten[i] 表示 i 被吃的集合，但这样逻辑判断过于复杂，所以没有采用。

#{= highlight([=[
#include <cstdio>

using namespace std;

#define N 50001

int father[N];
int delta[N];
int rank[N];

/**
 * a, b are both in {-1, 0, 1}
 * 1 + 1 = -1
 * -1 + -1 = 1
 */
inline int add3(int a, int b) {
	return (a == b) ? (-a) : (a + b);
}

int find(int x) {
	if (father[x] != x) {
		int newfather = find(father[x]);
		delta[x] = add3(delta[x], delta[father[x]]);
		father[x] = newfather;
	}
	return father[x];
}

bool union2(int x, int y, int d) {
	int xr = find(x);
	int yr = find(y);
	if (xr == yr) {
		if (delta[x] != add3(d, delta[y])) {
			return false;
		}
		return true;
	}
	int tmp = add3(d, delta[y]);
	if (rank[xr] < rank[yr]) {
		father[xr] = yr;
		delta[xr] = add3(tmp, -delta[x]);
	} else {
		father[yr] = xr;
		delta[yr] = add3(delta[x], -tmp);
		if (rank[xr] == rank[yr]) {
			rank[xr]++;
		}
	}
	return true;
}

int main(int argc, const char *argv[])
{
	int n, k;
	scanf("%d%d", &n, &k);
	// make set
	for (int i = 1; i <= n; i++) {
		father[i] = i;
	}
	for (int i = 1; i <= n; i++) {
		delta[i] = 0;
	}
	for (int i = 1; i <= n; i++) {
		rank[i] = 0;
	}
	int falsehood = 0;
	for (; k > 0; k--) {
		int d, x, y;
		scanf("%d%d%d", &d, &x, &y);
		if (x > n || y > n) {
			falsehood++;
		} else if (!union2(x, y, d - 1)) {
			falsehood++;
		}
	}
	printf("%d\n", falsehood);
	return 0;
}
]=], 'cpp', {lineno=true;collapse=true})}#

poj 2236 Wireless Network

　　一个比较基础的并查集，但也有一些注意点：

1. 判断两点间距离小于某值，可以用平方，从而避免 double 和 sqrt ，浮点数比较大小是个坑
2. 我通过将 father[i] 设为 -1 来表示机器没有修好，一开始好几次 WA 。后来自己生成数据测试，马上发现了问题，查询的时候，必须判断 father[i] != -1 ，assert 帮了我很大的忙

#{= highlight([=[
#include <cstdio>
#include <cassert>

using namespace std;

const int N = 1010;

struct point_t {
	int x, y;
} points[N];

int father[N];
int rank[N];

int find(int x) {
	if (father[x] != x) {
		father[x] = find(father[x]);
	}
	return father[x];
}

void union2(int x, int y) {
	// printf("union %d, %d\n", x, y);
	int xr = find(x);
	int yr = find(y);
	if (xr == yr) {
		return;
	}
	if (rank[xr] < rank[yr]) {
		father[xr] = yr;
	} else {
		father[yr] = xr;
		if (rank[xr] == rank[yr]) {
			rank[xr]++;
		}
	}
}

int distance2(int a, int b) {
	int dx = points[a].x - points[b].x;
	int dy = points[a].y - points[b].y;
	return dx * dx + dy * dy;
}

int main(int argc, const char *argv[])
{
	int n, d;
	scanf("%d%d", &n, &d);
	int d2 = d * d;
	for (int i = 1; i <= n; i++) {
		scanf("%d%d", &points[i].x, &points[i].y);
		father[i] = -1;
		rank[i] = 0;
	}
	char op[4];
	while (scanf("%s", op) == 1) {
		if (op[0] == 'O') {
			int p;
			scanf("%d", &p);
			if (father[p] == -1) {
				father[p] = p;
				// printf("%d repaired\n", p);
				for (int i = 1; i <= n; i++) {
					if ((i != p) && (father[i] != -1)) { // repaired
						if (distance2(i, p) <= d2) { // in the area
							union2(i, p);
						}
					}
				}
			}
		} else if (op[0] == 'S') {
			int p, q;
			scanf("%d%d", &p, &q);
			// printf("testing %d and %d\n", p, q);
			if (father[p] != -1 && father[q] != -1 && find(p) == find(q)) {
				puts("SUCCESS");
			} else {
				puts("FAIL");
			}
		}
	}
	return 0;
}
]=], 'cpp', {lineno=true;collapse=true})}#

Links:

* [并查集 - 维基百科，自由的百科全书](http://zh.wikipedia.org/wiki/并查集)
* [Disjoint-set data structure - Wikipedia, the free encyclopedia](http://en.wikipedia.org/wiki/Disjoint-set_data_structure)
