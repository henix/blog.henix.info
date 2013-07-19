% 最长上升子序列的 nlogn 算法
% Algorithm; 算法; 动态规划
% 1326186330

　　[最长上升子序列](http://en.wikipedia.org/wiki/Longest_increasing_subsequence)（Longest increasing subsequence, LIS）是个经典的动态规划问题，用动态规划可以在 O(n^2) 的时间内解决。

　　问题描述参见 [POJ 2533](http://poj.org/problem?id=2533) 。

　　但还有另外一种利用决策的单调性的算法，可以在 O(n log n) 的时间解决。

　　设 min[i] 为长度为 i 的最长子序列的最后一个元素最小可以是多少。每次将原序列的一个元素 a 插入到 min 数组中，并更新数组 min ，每次只需找到 min 中第一个比 a 大的数，并用 a 替换那个数。在查找的时候可以用二分查找，于是时间复杂度是 O(n log n) 。

　　代码：

```cpp
#include <stdio.h>
#include <stdbool.h>

int main(int argc, char *argv[])
{
	int n;
	scanf("%d", &n);
	int ar[n];
	int i;
	for (i = 0; i < n; i++) {
		scanf("%d", ar + i);
	}
	int min[n];
	int len = 0;
	for (i = 0; i < n; i++) {
		/* insert ar[i] into min */
		int l = 0, r = len;
		int mid;
		bool found = false;
		while (l < r) {
			mid = (l + r) / 2;
			if (ar[i] < min[mid]) {
				r = mid;
			} else if (ar[i] > min[mid]) {
				l = mid + 1;
			} else {
				found = true;
				break;
			}
		}
		if (! found) {
			min[r] = ar[i];
			if (r == len) {
				len++;
			}
		}
	}
	printf("%d\n", len);
	return 0;
}
```
