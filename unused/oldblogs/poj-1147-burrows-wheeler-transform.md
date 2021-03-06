　　这道题有点不好想，这里记录一下。

　　[Burrows-Wheeler transform](http://en.wikipedia.org/wiki/Burrows–Wheeler_transform) 是 bzip2 用的一种压缩算法。

　　这题相当于解压运算。只不过跟解压不同，是要求求出第一行。

　　在网上搜索后发现这篇文章：[http://jiangjinhua.zju.blog.163.com/blog/static/600320061174111903/](http://jiangjinhua.zju.blog.163.com/blog/static/600320061174111903/) 我的代码基本上是参考这个。

　　主要思路如下：

　　首先，目前只知道矩阵最后一列 L ，根据题意，矩阵第一列一定是排好序的，又由于每一列都一定是原串的一个排列（permutation），故将 L 排序后可得第一列 F 。

　　然后回顾 [Burrows-Wheeler 逆变换](http://en.wikipedia.org/wiki/Burrows–Wheeler_transform)，其步骤为：将最后一列放入矩阵，排序；然后将最后一列附加到当前矩阵的左边，再排序（这里的排序都是稳定的）；不断重复这个过程。结合 poj 1147 的样例如下图所示：

<p class="center">#{= makeImg('/files/bwt/first-step.png') }#</p>

　　上图中，右边一列即排好序的一列，然后把 L 附加到该列的左边。然后再对第一列进行稳定排序就变成下图的样子，注意到灰色部分跑到第一行了。这意味着什么呢？我们的目标是不重建整个矩阵就求出最终答案（矩阵 M 的第一行）。第一行的第一个肯定跟第一列的第一个是一样的，即 F[1] ，也就是上图中右边一列的第一个。然后，我们从左边一列找出第一个在排序之前的位置，也就是顺着箭头所指的方向。

　　“0”在排序之前，所在的位置是 L[2] ，由于排序是稳定的，所以肯定不是 L[3] 或者 L[5] 。然后顺着虚线箭头所指的方向，我们就找到了 M 中第一行的第二个，即 F[2] 。为什么 F[2] 就是 M 的第一行的第二个呢？看下图，标记为灰色的两个跑到第一行去了。

<p class="center">#{= makeImg('/files/bwt/sorted.png') }#</p>

　　然后我们依次类推，可以得到 M 的第一行的剩下的元素，如下图中箭头所示的方向：

<p class="center">#{= makeImg('/files/bwt/ibwt.png') }#</p>

　　沿着箭头走，输出所有遇到的左边一列的元素，于是我们得到 M 的第一行为：0 0 0 1 1 。

　　最后的代码如下：

#{= highlight([=[
#include <stdio.h>

int main(int argc, char const *argv[])
{
	int n;
	scanf("%d", &n);
	getchar();
	char ar[n];
	int i;
	int num1 = 0;
	int num0 = 0;
	for (i = 0; i < n; ++i) {
		// scanf("%d", ar + i);
		ar[i] = getchar() - '0';
		getchar();
		if (ar[i] == 0) {
			num1++;
		}
	}
	int index;
	short rindex[n];
	for (i = 0; i < n; ++i) {
		index = ar[i] ? num1++ : num0++;
		rindex[index] = i;
	}
	int x = 0;
	// int orig[n];
	for (i = 0; i < n; ++i) {
		x = rindex[x];
		// printf("%d ", ar[x]);
		putchar('0' + ar[x]);
		putchar(' ');
	}
	return 0;
}
]=], 'cpp', {lineno=true})}#

　　由于待排序序列中只有 0 和 1 这两种字符，这里采用了计数排序。

　　这题的方法非常 tricky ，我已经尽最大的努力画图和说明了。但语言基本上还是解释不清楚，所以只有看代码了。
