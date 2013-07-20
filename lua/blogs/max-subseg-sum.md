　　最近恶补算法中……

　　最大子段和问题：若有数组 a[n]，每个元素是一个整数（可正可负），求子数组 a[s:t]，使得 \(\sum_{i=s}^t a[i]\) 最大。

　　解法：动态规划。设 maxf[i] 为 i 之前，且包含 a[i] 的所有子数组的最大和，则有状态转移方程：

> maxf[i] = maxf[i-1] > 0 ? maxf[i-1] + a[i] : a[i]

　　对于 maxf[i]，要么包含前一个数，要么不包含（只有自己），就看哪个更大。

　　最后，再在 maxf[i] 中找出最大值，即为最大子段和。

　　然后还有最大 m 子段和问题，我还没理解清楚……不表

<script type="text/x-mathjax-config">
MathJax.Hub.Config({
  imageFont: null
});
</script>
<script type="text/javascript" src="/MathJax/MathJax.js?config=TeX-AMS_HTML"></script>