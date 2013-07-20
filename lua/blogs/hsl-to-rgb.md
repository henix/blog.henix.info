　　因为最近要做彩色云图，研究了一下 HSL 色彩空间，即色相（Hue）、饱和度（Saturation）、亮度（Lightness）。

　　如果你需要用颜色的冷暖来表示数值的多少，那你就需要使用 HSL 色彩空间了。从冷色到暖色在 HSL 空间中只需把 H 分量从 240° 取到 0° 。

　　转换算法详见[维基百科](http://zh.wikipedia.org/wiki/HSL和HSV色彩空间)：

　　若 s = 0 ，则返回 (l, l, l) 。否则，使用下列过程：

$$ q= \begin{cases} l \times (1+s), & \mbox{if } l < \frac{1}{2} \\ l+s-(l \times s), & \mbox{if } l \ge \frac{1}{2} \end{cases} $$

$$ p = 2 \times l - q $$

$$ h_k = {h \over 360} \  （h规范化到值域[0,1)内） $$

$$ t_R = h_k+\frac{1}{3} $$

$$ t_G = h_k $$

$$ t_B = h_k-\frac{1}{3} $$

$$ \mbox{if } t_C < 0 \rightarrow t_C = t_C + 1.0 \quad \mbox{for each}\,C \in \{R,G,B\} $$

$$ \mbox{if } t_C > 1 \rightarrow t_C = t_C - 1.0 \quad \mbox{for each}\,C \in \{R,G,B\} $$

$$ {Color}_C = \begin{cases} p+ \left((q-p) \times 6 \times t_C\right), & \mbox{if } t_C &lt; \frac{1}{6} \\ q, & \mbox{if } \frac{1}{6} \le t_C < \frac{1}{2} \\ p+\left((q-p) \times 6 \times (\frac{2}{3} - t_C) \right), & \mbox{if } \frac{1}{2} \le t_C < \frac{2}{3} \\ p, & \mbox{otherwise } \end{cases} $$

$$ \mbox{for each}\,C \in \{R,G,B\} $$

　　一个 C 实现如下：

#{= highlight([=[
/**
 * rgb[] 分量的取值范围：0.0 - 1.0
 */
void HSL2RGB(float h, float s, float l, float rgb[])
{
	if (s > 0.0) {
		double q, p;
		double hk;
		if (l < 0.5) {
			q = l * (1 + s);
		} else {
			q = l + s - l * s;
		}
		p = 2 * l - q;
		hk = h / 360.0;
		rgb[0] = hk + 1.0/3.0;
		rgb[1] = hk;
		rgb[2] = hk - 1.0/3.0;
		int i;
		for (i = 0; i < 3; i++) {
			if (rgb[i] < 0.0) {
				rgb[i] += 1.0;
			} else if (rgb[i] > 1.0) {
				rgb[i] -= 1.0;
			}
		}
		for (i = 0; i < 3; i++) {
			if (rgb[i] < 1.0/6.0) {
				rgb[i] = p + (q - p) * 6.0 * rgb[i];
			} else if (rgb[i] < 1.0/2.0) {
				rgb[i] = q;
			} else if (rgb[i] < 2.0/3.0) {
				rgb[i] = p + (q - p) * 6.0 * (2.0/3.0 - rgb[i]);
			} else {
				rgb[i] = p;
			}
		}
	} else {
		rgb[0] = rgb[1] = rgb[2] = l;
	}
}
]=], 'cpp', {lineno=true})}#

　　现在，我的博客的标签列表（Tags）已经应用了这个，文章数量越多，相应的标签颜色越暖。

参考链接：

* [http://oldj.net/article/hsl-to-rgb/](http://oldj.net/article/hsl-to-rgb/)

#{include: 'mathjax.seg.htm'}#
