% 用 BLAS/LAPACK 编写矩阵运算程序
% Programming; 数值分析; 线性代数; 算法; BLAS/LAPACK; 数学
% 1307023010

　　因为最近要编写数值计算程序，对线性代数库做了一些研究。线性代数库就是别人已经写好的、高性能的矩阵运算库，可以做矩阵乘法、求逆、行列式、解线性方程组、LU 分解、QR 分解等等。

　　其实我最想说的是：boost::ublas 就是个渣！除了重载了运算符看起来好像很“美观”以外，性能比直接调用 LAPACK 函数低大约 50 倍（是的，即使用 Release 编译），任何一个严肃的数值应用都不会用 boost::ublas 的。

　　看文档的时候常常看到 BLAS 或者 LAPACK ，它们究竟是什么？我现在终于明白了，其实 BLAS 和 LAPACK 都只是**一组 API** ，只是定义了接口，至于实现，那就交给不同的库去实现了。比如我用的商业软件 Intel MKL 和开源的 [ATLAS](http://math-atlas.sourceforge.net/) 。

　　那么 BLAS 和 LAPACK 定义了那些函数呢？可以查[官方文档](http://www.netlib.org/blas/)，不过 [Intel MKL Reference Manual](http://software.intel.com/sites/products/documentation/hpc/mkl/mklman/index.htm) 看起来写得易懂些。

　　矩阵有实矩阵和复矩阵，按线性代数的分法又可分为一般矩阵、对称阵、Hermit 阵、三对角阵等，这些在 BLAS/LAPACK 中都有体现。这里只讨论一般矩阵。

### BLAS 1 ：向量-向量运算

　　向量乘标量：

axpy ：\(y \leftarrow \alpha x + y\)

```cpp
void cblas_daxpy(const int N, const double alpha, const double *X,
                 const int incX, double *Y, const int incY);
```

　　N 是向量的长度，incX 是 X 向量的增量（i += incX），用 1 即可。

scal ：\(x \leftarrow \alpha x\)

```cpp
void cblas_dscal(const int N, const double alpha, double *X, const int incX);
```

### BLAS 2 ：矩阵-向量运算

　　矩阵乘向量

gemv ：\(y \leftarrow \alpha A x + \beta y\) 或 \(y \leftarrow \alpha A^T x + \beta y\)

```
void cblas_dgemv(const enum CBLAS_ORDER Order,
                 const enum CBLAS_TRANSPOSE TransA, const int M, const int N,
                 const double alpha, const double *A, const int lda,
                 const double *X, const int incX, const double beta,
                 double *Y, const int incY);
```

　　其中最难理解的是 lda 这个参数，文档上的解释是：“声明 A 的时候，A 的第一个维度的大小”。也就是说，如果在 C 语言里面声明 a[5][5] ，那么 lda 即是 5 。其实意思是说，lda 可以跟 M 不一样。

### BLAS 3 ：矩阵-矩阵运算

　　矩阵乘矩阵

gemm ：\(C\leftarrow\alpha op(A)op(B) + \beta C\)

　　LAPACK 中的 getrf 可以做 LU 分解，getri 可以求逆。

　　有了以上这些做基础，就可以写一些稍微实用的程序了。比如下面这段求行列式和矩阵求逆：

``` {.cpp .numberLines}
#define BLAS(name) cblas_##name
#define LAPACK(name) LAPACKE_##name

/**
 * 求行列式并取逆矩阵
 */
double det_and_invert(double *a, int n)
{
	int info;
	int *ipiv = new int[n];
	assert(ipiv != NULL);

	info = LAPACK(dgetrf)(LAPACK_ROW_MAJOR, n, n, (double *)a, n, ipiv);
	double det = 1.0;
	if (info == 0)
	{
		for (int i = 0; i < n; i++)
		{
			if (ipiv[i] != (i + 1))
			{
				det *= -1.0;
			}
			det *= a[i * n + i];
		}
		LAPACK(dgetri)(LAPACK_ROW_MAJOR, n, (double *)a, n, ipiv);
	}
	else
	{
		det = 0.0;
	}

	delete[] ipiv;
	return det;
}
```

　　以上也参考了某些网上的求行列式代码。

　　求逆矩阵；

``` {.cpp .numberLines}
#define BLAS(name) cblas_##name
#define LAPACK(name) LAPACKE_##name

int invert_matrix(double *x, int n)
{
	int *ipiv = new int[n];
	assert(ipiv != NULL);

	int info = LAPACK(dgetrf)(LAPACK_ROW_MAJOR, n, n, (double *)x, n, ipiv);
	if (info != 0)
	{
		goto _EOF;
	}
	info = LAPACK(dgetri)(LAPACK_ROW_MAJOR, n, (double *)x, n, ipiv);
	if (info != 0)
	{
		goto _EOF;
	}

_EOF:
	delete[] ipiv;
	return info;
}
```

　　做了 LU 分解之后，还可以直接用 getrs 函数求解线性方程组 \(Ax = b\) ，比先求出逆矩阵再乘高效。

<script type="text/x-mathjax-config">
MathJax.Hub.Config({
  imageFont: null
});
</script>
<script type="text/javascript" src="/MathJax/MathJax.js?config=TeX-AMS_HTML"></script>
