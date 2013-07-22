　　终于开始看字符串算法了。。。字典树（trie）可以保存一些字符串-&gt;值的对应关系。基本上，它跟 Java 的 HashMap 功能相同，都是 key-value 映射，只不过 trie 的 key 只能是字符串。

　　trie 强大之处就在它的时间复杂度。它的插入和查询时间复杂度都为 O(k) ，其中 k 为 key 的长度，与 trie 中保存了多少个元素无关。Hash 表号称是 O(1) 的，但在计算 hash 的时候就肯定会是 O(k) ，而且还有碰撞之类的问题。trie 的缺点是空间消耗很高。

　　怎么实现我就不介绍了，可以用数组，也可以用指针动态分配，我做题为了方便就用了数组，静态分配空间。

　　一些字典树题目：

poj 3630 Phone List

　　给出一堆字符串，要求判断这些字符串中有没有一些是另外一些的前缀。典型的 trie 应用。

　　第一个版本，gcc 94 MS ：

#{= highlight([=[
#include <stdio.h>
#include <stdbool.h>
#include <string.h>

struct trie_node {
	char data;
	int child[10];
} nodes[100010];

int endm = 1; // end mark

void init_node(int i) {
	nodes[i].data = 0;
	int j;
	for (j = 0; j < 10; j++) {
		nodes[i].child[j] = -1;
	}
}

void reset() {
	endm = 1;
	init_node(0);
}

bool insert(const char *str) {
	// printf("insert %s, len = %d\n", str, len);
	int index = 0;
	const char *p = str;
	int oldend = endm;
	for (; *p != '\0'; p++) {
		int digit = *p - '0';
		// printf("digit %d insert into %d\n", digit, index);
		if (nodes[index].data) { // == 1
			return false; // prefix found
		}
		if (nodes[index].child[digit] == -1) {
			// allocate a new node
			nodes[index].child[digit] = endm;
			init_node(endm);
			endm++;
		}
		index = nodes[index].child[digit];
	}
	if (endm == oldend) { // did not allocate anything
		// puts("didn't allocate anything!");
		return false; // so it's a prefix
	}
	nodes[index].data = 1;
	// printf("node %d marked\n", index);
	return true;
}

int main(int argc, char *argv[])
{
	int t;
	scanf("%d", &t);
	for (; t > 0; t--) {
		int n;
		scanf("%d", &n);
		char buf[16];
		bool yes = true;
		reset();
		for (; n > 0; n--) {
			scanf("%s", buf);
			if (yes) {
				if (!insert(buf)) {
					yes = false;
				}
			}
		}
		if (yes) {
			puts("YES");
		} else {
			puts("NO");
		}
	}
	return 0;
}
]=], 'cpp', {lineno=true;collapse=true})}#

　　加上 IO 优化，使用 getchar 替代 scanf 读字符串：

#{= highlight([=[
#include <stdio.h>
#include <stdbool.h>
#include <string.h>

struct trie_node {
	char data;
	int child[10];
} nodes[100010];

int endm = 1; // end mark

void init_node(int i) {
	nodes[i].data = 0;
	int j;
	for (j = 0; j < 10; j++) {
		nodes[i].child[j] = -1;
	}
}

void reset() {
	endm = 1;
	init_node(0);
}

bool insert(const char *str) {
	// printf("insert %s, len = %d\n", str, len);
	int index = 0;
	const char *p = str;
	int oldend = endm;
	for (; *p != '\0'; p++) {
		int digit = *p - '0';
		// printf("digit %d insert into %d\n", digit, index);
		if (nodes[index].data) { // == 1
			return false; // prefix found
		}
		if (nodes[index].child[digit] == -1) {
			// allocate a new node
			nodes[index].child[digit] = endm;
			init_node(endm);
			endm++;
		}
		index = nodes[index].child[digit];
	}
	if (endm == oldend) { // did not allocate anything
		// puts("didn't allocate anything!");
		return false; // so it's a prefix
	}
	nodes[index].data = 1;
	// printf("node %d marked\n", index);
	return true;
}

int main(int argc, char *argv[])
{
	int t;
	scanf("%d", &t);
	for (; t > 0; t--) {
		int n;
		scanf("%d", &n);
		getchar(); // ignore \n
		char buf[16];
		bool yes = true;
		reset();
		for (; n > 0; n--) {
			int len = 0;
			char c = getchar();
			// printf("%d ", c);
			while (c != '\n') {
				buf[len] = c;
				len++;
				c = getchar();
				// printf("%d ", c);
			}
			buf[len] = '\0';
			// printf("\n%s, len = %d\n", buf, len);
			if (yes) {
				if (!insert(buf)) {
					yes = false;
				}
			}
		}
		if (yes) {
			// puts("YES");
			putchar('Y');
			putchar('E');
			putchar('S');
			putchar('\n');
		} else {
			// puts("NO");
			putchar('N');
			putchar('O');
			putchar('\n');
		}
	}
	return 0;
}
]=], 'cpp', {lineno=true;collapse=true})}#

　　这样优化后 47 MS ，IO 果然才是耗时大户！

　　后来，沿着这个思路，我又将 puts 全部替换成一堆 putchar ，结果 32 MS 就过了，IO 优化简直是神器啊！

poj 2503 Babelfish

　　单词查询，典型的字典树。看了下 Discuss ，还有人用 map ，还有用快排 + 二分也可以过，不过字典树肯定是最快的，gcc 79 MS ：

#{= highlight([=[
#include <stdio.h>

char words[100010][16];

struct trie_node {
	int data;
	int child[26];
} nodes[1000010];

int endm = 1;

void init_node(int i) {
	nodes[i].data = -1;
	int j;
	for (j = 0; j < 26; j++) {
		nodes[i].child[j] = -1;
	}
}

void insert(const char *str, int value) {
	int index = 0;
	const char *p = str;
	for (; *p != '\0'; p++) {
		int letter = *p - 'a';
		if (nodes[index].child[letter] == -1) {
			nodes[index].child[letter] = endm;
			init_node(endm);
			endm++;
		}
		index = nodes[index].child[letter];
	}
	nodes[index].data = value;
}

int query(const char *str) {
	int index = 0;
	const char *p = str;
	for (; *p != '\0'; p++) {
		int letter = *p - 'a';
		index = nodes[index].child[letter];
		if (index == -1) {
			return -1;
		}
	}
	return nodes[index].data;
}

int main(int argc, const char *argv[])
{
	char ch = getchar();
	char buf[16];
	int len;
	int lineno = 0;
	init_node(0); // init root node
	while (ch != '\n') {
		// read the english word
		len = 0;
		while (ch != ' ') {
			words[lineno][len] = ch;
			len++;
			ch = getchar();
		}
		words[lineno][len] = '\0';
		// printf("words[%d] = '%s'\n", lineno, words[lineno]);
		// read the foreign word
		len = 0;
		ch = getchar();
		while (ch != '\n') {
			buf[len] = ch;
			len++;
			ch = getchar();
		}
		buf[len] = '\0';
		insert(buf, lineno);

		lineno++;
		ch = getchar();
	}
	// then query
	ch = getchar();
	while (ch != EOF) {
		len = 0;
		while (ch != '\n' && ch != EOF) {
			buf[len] = ch;
			len++;
			ch = getchar();
		}
		buf[len] = '\0';
		int idx = query(buf);
		if (idx != -1) {
			puts(words[idx]);
		} else {
			puts("eh");
		}
		ch = getchar();
	}
	return 0;
}
]=], 'cpp', {lineno=true;collapse=true})}#

poj 2418 Hardwood Species

　　字典树，涉及 trie 的遍历。先看了下 Discuss ，据说输入会有特殊标点符号，所以我的字符范围有点大，ASCII 32 - ASCII 126 。最开始用的是 gets ，719 MS ，后来改成 getchar ，250 MS ：

#{= highlight([=[
#include <stdio.h>
#include <assert.h>

#define START 32
// not include the end
#define END 127

struct trie_node {
	int data;
	int child[END-START];
} nodes[300000];

int endm = 1;

void init_node(int i) {
	nodes[i].data = 0;
	int j;
	for (j = 0; j < END-START; j++) {
		nodes[i].child[j] = -1;
	}
}

void insert(const char *str) {
	int index = 0;
	const char *p = str;
	for (; *p != '\0'; p++) {
		int letter = *p - START;
		assert(letter >= 0 && letter < END-START);
		// printf("insert %c into %d\n", letter + START, index);
		if (nodes[index].child[letter] == -1) {
			nodes[index].child[letter] = endm;
			init_node(endm);
			endm++;
		}
		index = nodes[index].child[letter];
	}
	nodes[index].data++;
}

char curName[32];
int cur;

int total;
float ftotal;

void visit(int index) {
	// printf("visiting %d\n", index);
	if (nodes[index].data) {
		curName[cur] = '\0';
		// output
		register const char *p = curName;
		while (*p != '\0') {
			putchar(*p);
			p++;
		}
		putchar(' ');
		printf("%.4f", (nodes[index].data * 100) / ftotal);
		putchar('\n');
	}
	// visit it's childs
	int i = 0;
	for (i = 0; i < END-START; i++) {
		if (nodes[index].child[i] != -1) {
			curName[cur] = START + i;
			cur++;
			visit(nodes[index].child[i]);
			cur--;
		}
	}
}

int main(int argc, char *argv[])
{
	char buf[32];
	total = 0;
	init_node(0);
	int ch = getchar();
	while (ch != EOF) {
		int len = 0;
		while (ch != '\n' && ch != EOF) {
			buf[len] = ch;
			len++;
			ch = getchar();
		}
		buf[len] = '\0';
		// printf("read %s\n", buf);
		insert(buf);
		total++;
		ch = getchar();
	}
	cur = 0;
	ftotal = (float) total;
	visit(0);
	return 0;
}
]=], 'cpp', {lineno=true;collapse=true})}#

　　其他题目：

* poj 2001 Shortest Prefixes
* poj 1451 T9

## AC 自动机

　　AC 自动机即 Aho-Corasick 算法，用来做多串匹配：给你 n 个字符串，要在一个目标串上匹配这些串，当然可以做 n 次单串匹配，比如 KMP ，但时间复杂度就高了。

　　AC 自动机就是在 trie 上做 KMP ，先构造所有字符串的一个 trie ，再添加失败边（failure links），失败边跟 KMP 里的“失败函数”是一样的道理。

　　下面我们以 {she, he, say, shr, her, e} 这几个单词为例。先构造 trie ：

<p class="center">#{= makeImg('/files/aho-corasick/ac.gif') }#</p>

　　方形节点表示该节点是一个单词的结尾，即匹配成功。

　　再添加失败边：

<p class="center">#{= makeImg('/files/aho-corasick/ac2.gif') }#</p>

　　虚线表示失败边，没有的即默认失败到 root ，这里为了图看起来清晰就省略了。

　　为什么 she 的失败边指向 he ？因为黄色的部分和红色的部分完全一样。当匹配到 she 的时候，实际上已经隐含匹配了 he 。试想，如果在 she 这个节点遇到了 r ，匹配失败，则应退到 he 继续尝试。

### 构造 AC 自动机

　　添加失败边的算法：对每一个节点，找出它的最长的在 trie 中出现过的后缀。比如对 she ，先找 he ，再找 e ，如果都没有则失败到 root 。

　　但这种算法效率比较低，没有充分利用已经计算出来的信息。网上流传的是另外一种算法：比如要找 she 的失败边，可以假定其父节点，sh 的失败边已经求出，沿着父节点的失败边走，如果某个节点有 e 的子节点，则把失败边指向该子节点。比如 she 的父节点 sh ，先走到 h ，假如 h 没有 e 的子节点的话，就继续检查 h 的失败边，即 root 。如果最后到 root 都没有，就把失败边置为 root 。

### 匹配

　　在 AC 自动机上匹配：从根开始，如果当前字符匹配，则移动指针。然后需要沿着失败边检查：看有没有哪个是结尾节点，是则匹配成功（网上有些代码是只有当前整个串匹配成功才找，但实际上只要当前字符是一样的就要找）。比如如果用上面的 AC 自动机匹配 she ，匹配到 she 的时候，she 这个单词匹配成功，还要沿失败边检查，发现 he 和 e 也匹配成功。如果当前字符不匹配，则沿着失败边继续找，如果都没有匹配，则回到 root 。

### 例题

[hdu 2222 Keywords Search](http://acm.hdu.edu.cn/showproblem.php?pid=2222)

　　最基本的 AC 自动机。从中可以学到不少实现 AC 自动机的技巧。我最开始的时候，trie_node 这个结构体里面还存了 parent 和当前节点的 value ，因为构造 AC 自动机的时候会用到。后来在网上看了另一个人的实现，可以使用一些小技巧，不用 parent 和 value 也可以构造。

　　此题的题意理解也有点小问题，keyword 可以有重复，而且还要算成多个。Discuss 中的几组数据：

```
1
2
a
a
a
```

答案：2

```
1
3
c
bcd
abc
abcd
```

```
2
2
sher
he
she
2
sher
he
sher
```

　　上面两组数据是让你考虑一个串是另一个串的子串的情况。

　　性能优化：用指针实现 trie ，而不是索引。

#{= highlight([=[
#include <stdio.h>
#include <string.h>

struct trie_node {
	int count; /* because there can be multiple word */
	struct trie_node *fail;
	struct trie_node *child[26];
} nodes[500000];

int endm;

void reset() {
	endm = 1;
	memset(nodes, 0, sizeof(struct trie_node));
}

void insert(const char *str) {
	struct trie_node *index = nodes;
	const char *p = str;
	for (; *p != '\0'; p++) {
		int i = *p - 'a';
		if (index->child[i] == NULL) {
			index->child[i] = nodes + endm;
			memset(nodes + endm, 0, sizeof(struct trie_node));
			endm++;
		}
		index = index->child[i];
	}
	index->count++;
}

struct trie_node *queue[500000];
int qhead = -1;
int qend = 0;

void queue_reset() {
	qhead = -1;
	qend = 0;
}

void queue_push(struct trie_node *v) {
	queue[qend] = v;
	qend++;
}

int queue_isempty() {
	return (qhead + 1 == qend);
}

struct trie_node *queue_pop() {
	qhead++;
	if (qhead < qend) {
		return queue[qhead];
	} else {
		qhead--;
		return NULL;
	}
}

void add_fail() {
	queue_reset();
	/* add root to the queue */
	queue_push(nodes);
	while (!queue_isempty()) {
		struct trie_node *x = queue_pop();
		int i;
		for (i = 0; i < 26; i++) {
			if (x->child[i] != NULL) {
				struct trie_node *child = x->child[i];
				queue_push(child);
				/* add fail link for x's child i */
				struct trie_node *t = x->fail;
				while ((t != NULL) && (t->child[i] == NULL)) {
					t = t->fail;
				}
				if (t == NULL) {
					child->fail = nodes; /* fails to root */
				} else {
					child->fail = t->child[i];
				}
			}
		}
	}
}

int match(const char *str) {
	const char *p = str;
	struct trie_node *cur = nodes;
	int count = 0;
	while (*p != '\0') {
		int i = *p - 'a';
		while (cur != NULL && cur->child[i] == NULL) {
			cur = cur->fail;
		}
		if (cur != NULL) {
			cur = cur->child[i];
			/* backtrace the fail links */
			struct trie_node *t = cur;
			while (t != NULL) {
				if (t->count > 0) {
					count += t->count;
					t->count = -1;
				}
				t = t->fail;
			}
		} else {
			cur = nodes;
		}
		p++;
	}
	return count;
}

char bigbuffer[1000001];

int main(int argc, const char *argv[])
{
	int t;
	scanf("%d", &t);
	for (; t > 0; t--) {
		int n;
		scanf("%d", &n);
		getchar(); /* ignore a \n */
		reset();
		for (; n > 0; n--) {
			char buf[64];
			gets(buf);
			insert(buf);
		}
		add_fail();
		gets(bigbuffer);
		int count = match(bigbuffer);
		printf("%d\n", count);
	}
	return 0;
}
]=], 'cpp', {lineno=true;collapse=true})}#

　　其他 AC 自动机题目：

* poj 1204 Word Puzzles
* hdu 2896 病毒侵袭

Links:

* [Aho–Corasick string matching algorithm - Wikipedia, the free encyclopedia](http://en.wikipedia.org/wiki/Aho–Corasick_string_matching_algorithm)
* [NotOnlySuccess: 【专辑】AC自动机](http://www.notonlysuccess.com/index.php/aho-corasick-automation/)
* [Aho-Corasick 的动画演示](http://blog.ivank.net/aho-corasick-algorithm-in-as3.html)
* [[汇总]字符串题目推荐及解题报告_The Way to ACM/ICPC..._百度空间](http://hi.baidu.com/zfy0701/blog/item/440e923e1bc4183870cf6c89.html)
