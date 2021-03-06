　　poj 2778 DNA Sequence 题目大意：给你一些疾病 DNA 片段，求长度为 n 的 DNA 串中不包含这些片段的串的数量。

　　一开始不知道怎么做，直到看到网上的一句话，“长度为 n 的字符串可以由长度为 n - 1 的字符串后面加一个字符构成”，由此大彻大悟，原来这就是传说中的自动机 dp ！

　　举个例子：{AG, CG} ，首先构造 AC 自动机：

<p class="center">#{= makeImg('/files/poj2778/2778.gif') }#</p>

　　给每个节点加了编号，只有 0 1 2 是合法的，其他状态到达就直接死了，不用处理。

　　然后将上面的 AC 自动机转化成下面这张表：

<table style="margin: auto;">
<tr><td></td><td>A</td><td>C</td><td>T</td><td>G</td></tr>
<tr><td>0</td><td>1</td><td>2</td><td>0</td><td>0</td></tr>
<tr><td>1</td><td>1</td><td>2</td><td>0</td><td>3</td></tr>
<tr><td>2</td><td>1</td><td>2</td><td>0</td><td>4</td></tr>
</table>

　　这张表表示当前状态遇到一个字母后跳转到什么状态。我称之为“跳转表”，对应于我代码中的 jump 域。这个貌似跟传说中的“trie 图”类似，都是把自动机确定化。

　　然后数一下每一行有多少个 0 ，多少个 1 ……将上表转化成下面的递推关系：

<blockquote>
<p>\(f_0(n) = 2 * f_0(n-1) + 1 * f_1(n-1) + 1 * f_2(n-1)\)<br />
\(f_1(n) = 1 * f_0(n-1) + 1 * f_1(n-1) + 1 * f_2(n-1)\)<br />
\(f_2(n) = 1 * f_0(n-1) + 1 * f_1(n-1) + 1 * f_2(n-1)\)</p>
</blockquote>

　　其中 \(f_i(n)\) 表示到第 n 步，有多少个字符串处于状态 i 。\(f_0(n-1)\) 前面的系数 2 是 0 那一行包含的 0 的数量，表示如果上一步有一个处于状态 0 ，那么下一步就会有 2 个处于状态 0（分别对应遇到 T 和 G 的情况）。其他类似。

　　将上面的系数矩阵提出来，立即得到：

<p>$$ \left[ \begin{array}{c} f_0(n)\\f_1(n)\\f_2(n) \end{array} \right] = \left[ \begin{array}{ccc} 2&amp;1&amp;1\\1&amp;1&amp;1\\1&amp;1&amp;1 \end{array} \right]^n \left[ \begin{array}{c} 1\\0\\0 \end{array} \right] $$</p>

　　这就是所谓“常系数线性递推式”，详见黑书练习题 2.1.8 。比如对于 n = 3 ，先计算系数矩阵的 3 次方：

<p>$$ \left[ \begin{array}{ccc} 2&amp;1&amp;1\\1&amp;1&amp;1\\1&amp;1&amp;1 \end{array} \right]^3 = \left[ \begin{array}{ccc} 20&amp;14&amp;14\\14&amp;10&amp;10\\14&amp;10&amp;10 \end{array} \right] $$</p>

　　然后把结果矩阵的第一列加起来即得到答案 48 。

　　题目中 n 可能非常大，这时就轮到快速幂运算出场了。使用快速幂运算，计算 \\(A^n\\) 的时间复杂度为 O(log n) 次乘法（此题是矩阵乘法）。我的代码中这部分用了两个指针，每次计算都交换，这是为了避免矩阵复制。

　　最后，还要考虑一种情况，即有些疾病 DNA 片段互相包含的情况，以 {ACG, C} 为例：

<p class="center">#{= makeImg('/files/poj2778/2778-2.gif') }#</p>

　　其中 C 是死节点，那么 AC（红色的）是不是呢？表面上看 AC 不是疾病片段，但实际上，匹配了 AC 就相当于匹配了 C ，所以 AC 也是死节点！我称这种情况为“疾病的传染”，见代码中用 spread 注释的部分。

　　代码（gcc 63MS）：

#{= highlight([=[
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int dnas[26] = {0, 0, 1, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3};

int dna_seq(char c) {
	return dnas[c - 'A'];
}

struct trie_node {
	char isend;
	struct trie_node *fail;
	struct trie_node *child[4];
	struct trie_node *jump[4];
} nodes[101];

int endm;

void reset() {
	endm = 1;
	memset(nodes, 0, sizeof(struct trie_node));
}

void insert(const char *str) {
	struct trie_node *index = nodes;
	const char *p = str;
	for (; *p != '\0'; p++) {
		int i = dna_seq(*p);
		if (index->child[i] == NULL) {
			index->child[i] = nodes + endm;
			memset(nodes + endm, 0, sizeof(struct trie_node));
			endm++;
		}
		index = index->child[i];
	}
	index->isend = 1;
}

struct trie_node *queue[100];
int qhead, qend;

void add_fail() {
	qhead = -1;
	qend = 0;
	/* add root to the queue */
	queue[qend++] = nodes;
	while (qhead + 1 < qend) {
		struct trie_node *x = queue[++qhead];
		int i;
		for (i = 0; i < 4; i++) {
			struct trie_node *child = x->child[i];
			struct trie_node *t = x->fail;
			while ((t != NULL) && (t->child[i] == NULL)) {
				t = t->fail;
			}
			if (child != NULL) {
				queue[qend++] = child;
				child->fail = t ? t->child[i] : nodes;
				if (child->fail->isend) {
					child->isend = 1; // spread
				}
				x->jump[i] = child;
			} else {
				x->jump[i] = t ? t->child[i] : nodes;
			}
		}
	}
}

/**
 * c = a * b
 */
void matrix_mul(int n, int a[n][n], int b[n][n], int c[n][n]) {
	int i, j, k;
	for (i = 0; i < n; i++) {
		for (j = 0; j < n; j++) {
			long long sum = 0;
			for (k = 0; k < n; k++) {
				sum += ((long long)a[i][k] * b[k][j]);
			}
			c[i][j] = sum % 100000;
		}
	}
}

int main(int argc, const char *argv[])
{
	int m, n;
	scanf("%d%d", &m, &n);
	getchar(); // ignore a \n
	char buf[16];
	reset();
	int i;
	for (i = 0; i < m; i++) {
		gets(buf);
		insert(buf);
	}
	add_fail();
	// construct the matrix
	int len = endm - m; // max len, but may not correct
	// printf("len = %d, endm = %d\n", len, endm);
	int matrix[len][len];
	int j, k;
	int id = 0;
	for (i = 0; i < endm; i++) {
		if (! nodes[i].isend) {
			// collect how many i occured in others
			int id2 = 0;
			for (j = 0; j < endm; j++) {
				if (! nodes[j].isend) {
					int count = 0;
					for (k = 0; k < 4; k++) {
						if (nodes[j].jump[k] == nodes + i) {
							count++;
						}
					}
					matrix[id][id2] = count;
					id2++;
				}
			}
			id++;
		}
	}
	len = id; // true len
	/*for (i = 0; i < len; i++) {
		for (j = 0; j < len; j++) {
			printf("%d ", matrix[i][j]);
		}
		putchar('\n');
	}*/
	int *d1 = malloc(len * len * sizeof(int));
	int *d2 = malloc(len * len * sizeof(int));
	int *c1 = malloc(len * len * sizeof(int));
	int *c2 = malloc(len * len * sizeof(int));
	int *result;
	if (n == 1) {
		result = matrix;
	} else {
		memset(c1, 0, len * len * sizeof(int));
		for (i = 0; i < len; i++) {
			c1[i * len + i] = 1;
		}
		for (i = 0; i < len; i++) {
			for (j = 0; j < len; j++) {
				d1[i * len + j] = matrix[i][j];
			}
		}
		while (n > 0) {
			if (n & 1) {
				matrix_mul(len, c1, d1, c2);
				int *tmp = c1;
				c1 = c2;
				c2 = tmp;
			}
			n >>= 1;
			matrix_mul(len, d1, d1, d2);
			int *tmp = d1;
			d1 = d2;
			d2 = tmp;
		}
		result = c1;
	}
	/*for (i = 0; i < len; i++) {
		for (j = 0; j < len; j++) {
			printf("%d ", result[i * len + j]);
		}
		putchar('\n');
	}*/
	int sum = 0;
	for (i = 0; i < len; i++) {
		sum = (sum + result[i * len]) % 100000;
	}
	printf("%d\n", sum);
	free(d1);
	free(d2);
	free(c1);
	free(c2);
	return 0;
}
]=], 'cpp', {lineno=true}) }#

　　其他相关题目：

* poj 3691 DNA repair
* poj 1625 Censored!
* hdu 2825 Wireless Password

　　贴两个解题报告：

* [POJ 2778 DNA Sequence [AC自动机+矩阵递推]_Lily's OI space_百度空间](http://hi.baidu.com/lilymona/blog/item/4c0252dd3d8cbf1949540390.html)
* [POJ2778 - AC自动机+非递归的矩阵乘法 - Jacob's zone - 博客频道 - CSDN.NET](http://blog.csdn.net/kk303/article/details/6936046)

#{include: 'mathjax.seg.htm' }#
