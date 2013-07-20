　　说起最大公约数，众所周知的当然是辗转相除法。但最近看到一个 Stein 算法，据称比辗转相除法更高效。

　　其基本思想是，完全不使用整数乘除、取余，只使用整数加减、位移完成运算。

　　在网上看了一段代码如下：

#{= highlight([=[
int gcd(int a, int b)
{
	if (a < b) {
		int temp = a;
		a = b;
		b = temp;
	}
	if (b == 0)
		return a;
	if (a%2==0 && b%2==0)
		return 2 * gcd(a/2, b/2);
	if (a % 2 == 0)
		return gcd(a/2, b);
	if (b % 2 == 0)
		return gcd(a, b/2);
	return gcd((a+b)/2, (a-b)/2);
}
]=], 'cpp')}#

　　所以算法思想也就明了了：若 a b 都是偶数，则提出 2 这个公因子；若某一个是偶数，另一个不是，那么约去 2 也是可以的；若都是奇数，则用 (a+b)/2 和 (a-b)/2 计算。

　　这段代码有不少可以改进的地方：

1. 一开始就判断 a b 的大小，实际上只有当 a b 都是奇数的时候才有必要
2. 都是奇数的情况，可以将较大的数改为 (a-b)/2 ，较小的数不变，这样值更小，收敛更快

　　网上不少非递归代码感觉很乱，而且冗余。我的版本如下：

#{= highlight([=[
int gcd_stein(int a, int b)
{
	int k = 0;
	while (1) {
		if (a == 0) {
			return b << k;
		} else if (b == 0) {
			return a << k;
		}
		if (a % 2 == 0) {
			a >>= 1;
			if (b % 2 == 0) {
				b >>= 1;
				k++;
			}
		} else {
			if (b % 2 == 0) {
				b >>= 1;
			} else {
				// 将最大的改为差的一半
				if (a < b) {
					b = (b - a) / 2;
				} else {
					a = (a - b) / 2;
				}
			}
		}
	}
	return 0; // never here
}
]=], 'cpp')}#

　　后来发现，其实这个问题的最优代码还是 wikipedia 上的：[http://en.wikipedia.org/wiki/Binary_GCD_algorithm](http://en.wikipedia.org/wiki/Binary_GCD_algorithm) 。
