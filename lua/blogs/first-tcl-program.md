% Tcl 的阶乘程序
% Programming; Tck/Tk
% 1301062564

　　最近学了下 [Tcl/Tk](http://www.tcl.tk/) ，语法还比较容易理解，但很纠结：

``` {.tcl .numberLines}
# 递归版
proc fac {n} {
	if {$n == 1} {
		return 1
	} else {
		return [expr {$n * [fac [expr {$n-1}]]}]
	}
}

# 非递归版
proc fac2 {n} {
	set r 1
	for {set i 2} {$i &lt;= $n} {incr i} {
		set r [expr {$r * $i}]
	}
	return $r
}

puts [fac2 1000] ; # 高精度
```

　　全是方括号和花括号，而且还不能写错了……不过 Tcl 有个好处是整数运算是高精度的，速度也很快。
