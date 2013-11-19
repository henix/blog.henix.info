　　有的时候我觉得程序员其实就是翻译家——把我们想表达的意思翻译成程序。所以写程序的第一要务是清晰明白，你心中想要表达什么意思，就原原本本的写出来，不饶弯子。你所需要做的是认真地审视自己的内心，并在目标语言所能提供的表达方式中选择一种最贴切的方式。

　　说英语需要地道表达，不要 Chinglish ，编程也一样。因为之前自己很熟悉一门语言，所以在使用另一门语言的时候也想回到自己熟悉的模式，这样写出的程序就成了 Chinglish ，不够地道。学一门语言最重要的是学会用该语言的思维方式思维和抽象问题。比如 Java 的核心理念是面向对象、多态、封装；而 javascript 的核心理念是函数式、函数作为第一型。用翻译来比喻，就是要熟悉这门语言的词汇表（vocabulary）和每个词的使用场景。如果核心思想没学到，只学了语法，用 Java 的思维方式套 javascript 的语法，那就成了用中文的思考方式说英文，老外听了要把大牙笑掉。（当然正如 long time no see 也进入了牛津词典，我也不反对在某些地方借用其他语言的思想进行创新）

　　下面随手贴点自以为翻译得漂亮的 Java 代码，好坏请读者自判。

### 参数验证

　　原文：有一个 HTTP 请求处理器，接受一个可选 GET 参数 pageCount ，默认为 1 ，必须是一个合法的 10 进制数，且大于等于 1 。如果此参数不合法，返回 HTTP 400 。

　　例：

* ?page=3 // 使用默认值 1
* ?pageCount= // 使用默认值 1
* ?pageCount=2 // 2
* ?pageCount=0xab // 报错
* ?pageCount=0 // 报错

　　译文：

#{= highlight([=[
import com.google.common.base.Preconditions;
import com.google.common.base.Strings;

@Override
protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    int pageCount = 1;

    try {
        String pageCountStr = req.getParameter("pageCount");
        if (!Strings.isNullOrEmpty(pageCountStr)) {
            pageCount = Integer.parseInt(pageCountStr);
            Preconditions.checkArgument(pageCount >= 1, "Invalid pageCount: " + pageCountStr);
        }
    } catch (IllegalArgumentException e) {
        resp.sendError(HttpServletResponse.SC_BAD_REQUEST, e.getMessage());
        return;
    }

    // ......
}
]=], 'java', {lineno=true})}#

　　评：异常处理就是用在这种地方的

　　注：parseInt 抛出的 NumberFormatException 是一个 IllegalArgumentException

### 参数验证2

　　原文：类构造时传入一个成员的值，此值不能为 null

　　译文：

#{= highlight([=[
import com.google.common.base.Preconditions;

public MyClass(String name) {
    this.name = Preconditions.checkNotNull(name);
}
]=], 'java', {lineno=true})}#

　　小问题：我没有对 checkNotNull 的返回值进行强制类型转换，那么它的返回类型是什么？

### 字符串处理

　　原文：如果 url 以 http://www.example.com 开头，返回后面的部分

　　译文：

#{= highlight([=[
import org.apache.commons.lang3.StringUtils;

final String prefix = "http://www.example.com";

if (url.startsWith(prefix)) {
    return StringUtils.removeStart(url, prefix);
}
]=], 'java', {lineno=true})}#

　　一个更精确表达我的意思的版本：

#{= highlight([=[
import org.apache.commons.lang3.StringUtils;

final String prefix = "http://www.example.com";

if (StringUtils.startsWithIgnoreCase(url, prefix)) {
    return StringUtils.removeStartIgnoreCase(url, prefix);
}
]=], 'java', {lineno=true})}#

　　注：URL 是不区分大小写的

　　如果一个字符串包含（contains）另一个字符串，试比较下面哪个翻译更好：

#{= highlight([=[
if (str.indexOf("test") > -1) {
    ...
}

if (str.contains("test")) {
    ...
}
]=], 'java', {lineno=true})}#

　　如果一个字符串中只包含空白字符（whitespaces），试比较下面两种翻译：

#{= highlight([=[
if (str.trim().length() == 0) {
    ...
}

import org.apache.commons.lang3.StringUtils;

if (StringUtils.isWhitespace(str)) {
    ...
}
]=], 'java', {lineno=true})}#

　　后记：我用的主要库是 [google-guava](http://code.google.com/p/guava-libraries/) 和 [commons-lang](http://commons.apache.org/lang/)（也推荐 [commons-io](http://commons.apache.org/io/)），库相当于对语言的词汇表进行了扩充，掌握一个库就相当于掌握了很多额外的词汇，语言的表达力得到了增强。

　　后记2：有人可能认为没必要对参数做那么多验证和限制。我认为快速失败（fail fast）的设计有助于调试系统中的错误。减少程序错误的要诀就是让程序尽快出错，然后修复。
