　　最近发现 Google 的 Java 基础库 google-guava 很好用。我用的主要有下面这些：

### Optional&lt;T&gt;

　　guava 的[文档](http://code.google.com/p/guava-libraries/wiki/UsingAndAvoidingNullExplained)一上来就引用 Dong Lea 的话：“Null sucks”。

　　的确，我发现 null 在很多时候都被滥用了。null 的含义太多了，它可以表示空指针，也可以表示一个不存在的值，也可以表示出错了，但这些含义往往被混淆。一句话，null 不能准确地表达我们的意思，事实上是一种 Magic Number 。这跟 true 和 false [作为 Magic Number](http://coolshell.cn/articles/5444.html) 有点像。

　　于是 guava 引入了一个专门用来表示“可能存在、也可能不存在的值”的类，这就是 Optional&lt;T&gt; ，这使我想到 Haskell 的 Maybe 。

　　Optional 的使用很简单，可以使用以下方法创建一个 Optional ：

* Optional.of(T) ：参数必须不为 null
* Optional.absent() ：创建一个“不存在”的值
* Optional.fromNullable(T) ：如果参数是 null ，则跟 absent 一样

　　使用以下方法查询 Optional ：

* boolean Optional.isPresent() ：查询值是否存在
* T Optional.get() ：如果存在则返回，否则抛异常
* T Optional.or(T) ：如果值不存在，则返回指定的默认值
* T Optional.orNull() ：如果值不存在，返回 null

　　我仔细地检查过我最近写的代码，发现果然有很多使用 null 的地方，实际上用 Optional 可以更准确地表达。Optional 不仅仅是一个库里的一个类，更是一种表达和思考问题的方式。

### 前置条件检查

　　但在实践的过程中我发现有时 Optional 也会被滥用。Optional 的确用来表达“可能存在、也可能不存在的值”，但有时候，“可能不存在”的这种情况，根本就是一种错误，它并不是一种预期的情况。这时候更准确的表达应该是 Preconditions 。

* Preconditions.checkNotNull(Object obj) ：我敢肯定，obj 一定不是 null（否则会抛出 NullPointerException）
* Preconditions.checkArgument(boolean condition) ：我敢肯定，condition 一定为真（否则抛出 IllegalArgumentException）

　　前置条件检查表示这些条件是要继续执行下去就必须满足的，如果条件不满足则可能是某些地方出了问题。这些函数跟 C 中的 assert 很类似，都是“断言”，表达“我敢肯定，否则就不要往下执行”的意思。

　　前置条件检查还可以放在函数的 return 前面，这时就变成了该函数的后置条件（Post-condition）检查。

　　在程序中添加断言可以增强我们对程序的信心，单元测试也可以，而断言更方便，能在真实的运行环境中发现错误，我认为是很有效的 practice 。

### 新的集合类型

　　ArrayListMultimap&lt;K,V&gt; 可以让一个 key 对应到多个 value ，这些 value 以 list 的方式存储。这个类正好可以用来抽象 url 的 query 部分，或者说 html 的 form 表单数据。
