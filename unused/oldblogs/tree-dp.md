　　树形 dp 就是在一颗树上做 dp ，其基本思想是由子节点的信息推出父节点的信息。

　　由于树都是一般树，可能不只二叉，所以要用到一般树的“左儿子右兄弟”表示法（详见代码中的 first\_child 和 next\_sibling）。

### hdu 1520 Anniversary party

　　最基本的树形 dp 。题目大意是，有一群人之间有上下级关系，在一个 party 中，有直接的上下级关系（即树中的父子关系）的人不能同时出席，每个人都有个 rating ，闻如何选择出席的人，使得所有人的 rating 之和最大。

　　每个节点有两个值，表示这个节点及其子节点所能取得的最大 rating 。max\_with 是选择此节点的情况，max\_without 不选择此节点。

　　有状态转移方程：

> 选择此节点的最大值 = 所有子节点不选择的最大值之和
不选择此节点的最大值 = 每个子节点选择或者不选择的最大值之和

　　说得太绕了...还是直接看代码吧

　　另外用了一个技巧，由于题目中没说谁是跟，用了一种很 tricky 的方法得到根节点的 id ，详见 root_id

<!-- 故意的错别字 跟 -->

　　另外我也尝试过非递归的，用了发现非递归反而比递归更耗时，所以就用递归的写法就好。

g++ 31ms

#{= highlight([=[
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define N 6000
#define MAX(a, b) ((a)>(b)?(a):(b))

struct node_t {
	struct node_t *first_child;
	struct node_t *next_sibling;
	int max_with;
	int max_without;
};

struct node_t nodes[N];

void dp(struct node_t *node) {
	struct node_t *child_node = node->first_child;
	// node->max_with = node->rating;
	// node->max_without = 0;
	while (child_node != NULL) {
		dp(child_node);
		node->max_with += child_node->max_without;
		node->max_without += MAX(child_node->max_with, child_node->max_without);
		child_node = child_node->next_sibling;
	}
}

int getint(char end) {
	int s = 0;
	int ch;
	ch = getchar();
	while (ch != end && ch != EOF) {
		s = s * 10 + ch - '0';
		ch = getchar();
	}
	return s;
}

int main(int argc, char const *argv[])
{
	int n;
	while (scanf("%d", &n) == 1) {
		getchar(); // ignore a \n
		memset(nodes, 0, sizeof(struct node_t) * n);
		int i;
		for (i = 0; i < n; ++i) {
			// scanf("%d", &nodes[i].max_with);
			nodes[i].max_with = getint('\n');
		}
		int l, k;
		int root_id = (n - 1) * n / 2;
		while(1) {
			// scanf("%d%d", &l, &k);
			l = getint(' ');
			k = getint('\n');
			if (l == 0 && k == 0) {
				break;
			}
			l--;
			k--;
			/* add the parent-child relation: k - parent, l - child */
			nodes[l].next_sibling = nodes[k].first_child;
			nodes[k].first_child = nodes + l;
			root_id -= l;
		}
		dp(nodes + root_id);
		printf("%d\n", MAX(nodes[root_id].max_with, nodes[root_id].max_without));
	}
	return 0;
}
]=], 'cpp', {lineno=true;collapse=true})}#

### poj 1463 Strategic game

　　跟上题基本上是对偶的，不过这题的输入格式比较变态。

gcc 16ms

#{= highlight([=[
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define N 1500
#define MIN(a, b) ((a)<(b)?(a):(b))

struct node_t {
	struct node_t *first_child;
	struct node_t *next_sibling;
	int min_with;
	int min_without;
};

struct node_t nodes[N];

void dp(struct node_t *node) {
	struct node_t *child_node = node->first_child;
	node->min_with = 1;
	while (child_node != NULL) {
		dp(child_node);
		node->min_without += child_node->min_with;
		node->min_with += MIN(child_node->min_with, child_node->min_without);
		child_node = child_node->next_sibling;
	}
}

int getint(char end) {
	// static char buf[20];
	// int i = 0;
	int s = 0;
	int ch;
	ch = getchar();
	while (ch != end && ch != EOF) {
		// buf[i++] = ch;
		s = s * 10 + ch - '0';
		ch = getchar();
	}
	// buf[i] = '\0';
	return s;
}

int getint2(int *out) {
	// static char buf[20];
	// int i = 0;
	register int s = 0;
	register int ch;
	ch = getchar();
	while (ch < '0' || ch > '9') {
		ch = getchar();
	}
	while (ch >= '0' && ch <= '9') {
		// buf[i++] = ch;
		s = s * 10 + ch - '0';
		ch = getchar();
	}
	// buf[i] = '\0';
	*out = s; // atoi(buf);
	return ch;
}

int main(int argc, char const *argv[])
{
	int n;
	while (scanf("%d", &n) == 1) {
		getchar(); // ignore a \n
		memset(nodes, 0, sizeof(struct node_t) * n);
		int i;
		int root_id;
		for (i = 0; i < n; ++i) {
			int parent_id, num;
			// scanf("%d:(%d)", &parent_id, &num);
			// parent_id = getint(':');
			getint2(&parent_id);
			if (i == 0) {
				root_id = parent_id;
			}
			getchar(); // (
			// num = getint(')');
			getint2(&num);
			// getchar(); // space
			int ch;
			for (num--; num >= 0; num--) {
				int node_id;
				ch = getint2(&node_id);
				// node_id = getint2(' ', '\n');
				// scanf("%d", &node_id);
				nodes[node_id].next_sibling = nodes[parent_id].first_child;
				nodes[parent_id].first_child = nodes + node_id;
			}
			while (ch != '\n') {
				ch = getchar();
			}
		}
		dp(nodes + root_id);
		printf("%d\n", MIN(nodes[root_id].min_with, nodes[root_id].min_without));
	}
	return 0;
}
]=], 'cpp', {lineno=true;collapse=true})}#

### poj 1947 Rebuilding Roads

　　这题的递推方法跟前面的有所不同，需要用子树及其兄弟的信息递推。也就是要设 F[i][j] 为：“从节点 i 的子节点及其右边的兄弟节点中选择 j 个节点所需的最小的边切割的数量。”具体的还是看 [Beyond the Void 的解题报告](http://www.byvoid.com/blog/pku-1947/)吧，他讲得比我好得多了。

　　这题各种边界条件，各种特殊情况，很恶心。

gcc 16ms

#{= highlight([=[
#include <stdio.h>
#include <string.h>
#include <limits.h>

#define N 150

#define MIN(a,b) ((a)<(b)?(a):(b))

struct node_t {
	struct node_t *first_child;
	struct node_t *next_sibling;
	int capacity;
	int min_edge_cut[N+1];
} nodes[N];

int infadd(int a, int b) {
	if (a == INT_MAX || b == INT_MAX) {
		return INT_MAX;
	}
	return a + b;
}

int dp(struct node_t *node, int node_num) {
	if (node->min_edge_cut[node_num] != -1) {
		return node->min_edge_cut[node_num]; // calculated
	}

	// case1: not choose node
	int case1_min = INT_MAX;
	if (node->next_sibling) {
		int ret = dp(node->next_sibling, node_num);
		case1_min = infadd(ret, 1);
	} else if (node_num == 0) {
		case1_min = 1;
	}

	// case2: choose node
	int case2_min = INT_MAX;
	if (node_num == 0) {
		// impossible, pass
	} else {
		if (node->first_child == NULL && node->next_sibling == NULL) {
			if (node_num == 1) {
				case2_min = 0;
			}
		} else if (node->first_child == NULL) {
			case2_min = dp(node->next_sibling, node_num - 1);
		} else if (node->next_sibling == NULL) {
			case2_min = dp(node->first_child, node_num - 1);
		} else {
			int k;
			for (k = 0; k < node_num; ++k) {
				int ret = infadd(dp(node->first_child, k), dp(node->next_sibling, node_num - 1 - k));
				if (ret < case2_min) {
					case2_min = ret;
				}
			}
		}
	}

	int tmp = MIN(case1_min, case2_min);
	node->min_edge_cut[node_num] = tmp;
	// printf("node %d provide %d nodes: %d\n", node - nodes + 1, node_num, tmp);
	return tmp;
}

/**
 * init capacity
 */
void init_node(struct node_t *node) {
	struct node_t *child_node = node->first_child;
	node->capacity = 1;
	memset(node->min_edge_cut, -1, sizeof(node->min_edge_cut));
	while (child_node != NULL) {
		init_node(child_node);
		node->capacity += child_node->capacity;
		child_node = child_node->next_sibling;
	}
}

int main(int argc, char const *argv[])
{
	int n, p;
	scanf("%d%d", &n, &p);
	int i;
	int root_id = (n - 1) * n / 2;
	for (i = 0; i < n-1; ++i) {
		int p, c;
		scanf("%d%d", &p, &c);
		p--; c--;
		nodes[c].next_sibling = nodes[p].first_child;
		nodes[p].first_child = nodes + c;
		root_id -= c;
	}
	init_node(nodes + root_id);
	int min_cut = INT_MAX;
	for (i = 0; i < n; ++i) {
		int ret = (i != root_id);
		if (nodes[i].first_child) {
			ret = infadd(ret, dp(nodes[i].first_child, p - 1));
		} else {
			ret = infadd(ret, p == 1 ? 0 : INT_MAX);
		}
		if (ret < min_cut) {
			min_cut = ret;
		}
	}
	printf("%d\n", min_cut);
	return 0;
}
]=], 'cpp', {lineno=true;collapse=true})}#

其他树形 dp 题目：

* hdu 1011 [Starship Troopers](http://www.cnblogs.com/kuangbin/archive/2012/03/14/2396449.html)
* poj 3345 [Bribing FIPA](http://blog.csdn.net/waitfor_/article/details/7235386)
* hdu 2196 [Computer](http://blog.csdn.net/waitfor_/article/details/7182602)
