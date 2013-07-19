% POJ 2823 单调队列 + IO 优化
% Algorithm; 算法; 单调队列; POJ
% 1326188374

　　最近继续补算法……学习一下单调队列。据说 [POJ 2823](http://poj.org/problem?id=2823) 是道经典题目。

　　给出一个数组和一个固定长度的窗口，这个窗口从左滑到右，要求依次输出每个区间的最大值。

　　用单调队列求解：滑动窗口每往右边移动一步，就有一个元素出队，另一个元素进队。考虑队列中有两个元素依次是 a b（b 在 a 后面），如果 b > a ，那么 a 在任何时刻都不可能作为最大值输出，所以在这种情况下就可以直接忽略掉 a 。于是我们可以保证队列是单调递减的，这样每次输出的时候就输出队首就可以了。

　　不过这道题直接提交就超时了，看了下网上其他人都说要加上 IO 优化，也就是不要用 printf 输出，改用自己写的输出函数以实现更快速的输出一个整数。参见 putint() 函数，什么 register 都出来了，再优化下去就汇编了。这样做了之后果然 AC 。

　　代码（gcc）：

``` {.cpp .numberLines}
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <errno.h>
#include <stdbool.h>
#include <limits.h>

struct monoq_t {
	int *head, *end;
	int *q;
	int size;
};
typedef struct monoq_t monoq_t;

int monoq_init(monoq_t *self, int size)
{
	if (size < 0) {
		return EINVAL;
	}
	self->q = malloc(size * sizeof(int));
	if (self->q == NULL) {
		return ENOMEM;
	}
	self->head = self->q;
	self->end = self->q;
	self->size = size;
	return 0;
}

void monoq_deinit(monoq_t *self)
{
	free(self->q);
}

bool monoq_pop(monoq_t *self, int value)
{
	if (self->end > self->head && (*self->head == value)) {
		self->head++;
		return true;
	}
	return false;
}

void monoq_push_max(monoq_t *self, int value)
{
	while (self->end > self->head && *(self->end-1) < value) {
		self->end--;
	}
	*self->end = value;
	self->end++;
}

void monoq_push_min(monoq_t *self, int value)
{
	while (self->end > self->head && *(self->end-1) > value) {
		self->end--;
	}
	*self->end = value;
	self->end++;
}

inline void putint(int n)
{
	static char buf[20];
	register int pos;
	register int x = n;
	if (x == 0) {
		putchar('0');
		return;
	}
	if (x == INT_MIN) { // x = -x do not work for the minimal value of int, so process it first
		printf("%d", x);
	}
	if (x < 0) {
		putchar('-');
		x = -x;
	}
	pos = 0;
	while (x > 0) {
		buf[pos] = x % 10 + '0';
		x /= 10;
		pos++;
	}
	pos--;
	while (pos >= 0) {
		putchar(buf[pos]);
		pos--;
	}
}

int main(int argc, char *argv[])
{
	int n, k;
	int *ar;
	monoq_t q;

	scanf("%d%d", &n, &k);
	ar = malloc(n * sizeof(int));
	int i;
	for (i = 0; i < n; i++) {
		scanf("%d", ar + i);
	}
	monoq_init(&q, n);

	/* first k into q */
	for (i = 0; i < k; i++) {
		monoq_push_min(&q, ar[i]);
	}
	printf("%d", *q.head);
	for (i = k; i < n; i++) {
		monoq_pop(&q, ar[i-k]);
		monoq_push_min(&q, ar[i]);
		putchar(' ');
		putint(*q.head);
	}
	putchar('\n');

	monoq_deinit(&q);

	monoq_init(&q, n);

	/* first k into q */
	for (i = 0; i < k; i++) {
		monoq_push_max(&q, ar[i]);
	}
	printf("%d", *q.head);
	for (i = k; i < n; i++) {
		monoq_pop(&q, ar[i-k]);
		monoq_push_max(&q, ar[i]);
		putchar(' ');
		putint(*q.head);
	}
	putchar('\n');

	monoq_deinit(&q);

	free(ar);
	return 0;
}
```

Links:

* [http://www.cnblogs.com/liukeke/archive/2011/07/31/2122488.html](http://www.cnblogs.com/liukeke/archive/2011/07/31/2122488.html)
