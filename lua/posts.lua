-- sitedesc = '一起看那遥远的街市上，发生的一幕幕故事'
-- sitedesc = '多研究些问题，少谈些主义'
sitedesc = 'henix\'s blog'

-- siteurl = 'http://the-distant-town.appspot.com'
-- siteurl = 'http://www.henix-blog.co.cc'
siteurl = 'http://blog.henix.info'

disqus_shortname = 'thedistanttown'

baseurl = ''

-- must be ordered from latest to oldest
blogposts = {
	{
		name = 'lua-js-closure',
		title = '理解 lua 的 for 中的闭包，及其与 js 的闭包的比较',
		publish_time = 1364836704,
		tags = {'Lua', 'js', 'closure'},
		category = 'Lua',
	},
	{
		name = 'haskell-monad-emacs',
		title = 'Haskell 笔记：Monad 和 Emacs 配置',
		publish_time = 1364355772,
		tags = {'Haskell', 'Emacs'},
		category = 'Functional',
	},
	{
		name = 'tomcat-production-config',
		title = 'Tomcat 生产环境配置',
		publish_time = 1359546901,
		tags = {'Java', 'tomcat'},
		category = 'Java',
	},
	{
		name = 'java-code-cookbook',
		title = 'Java 常见代码替换列表',
		publish_time = 1357564561,
		tags = {'Java'},
		category = 'Java',
	},
	{
		name = 'copyright-banner-image-replaced',
		title = '更换了博客的 banner 图片',
		publish_time = 1354281718,
		tags = {'Blog'},
		category = 'Essays',
	},
	{
		name = 'java-code-pieces-programming-translating',
		title = '随手贴点 Java 代码以及编程与翻译的关系',
		publish_time = 1352712804,
		tags = {'Java', '调试', '软件工程'},
		category = 'Java',
	},
	{
		name = 'suffix-array-study-notes',
		title = '后缀数组学习笔记',
		publish_time = 1349455196,
		tags = {'算法', '字符串', '后缀数组'},
		category = 'Algorithm',
	},
	{
		name = 'vimer-try-emacs',
		title = 'Vimer 的 Emacs 初探',
		publish_time = 1345728281,
		tags = {'Vim', 'Emacs'},
		category = 'Linux',
	},
	{
		name = 'try-google-guava',
		title = '试用 Google Guava',
		publish_time = 1345712906,
		tags = {'Java', '调试', '软件工程'},
		category = 'Java',
	},
	{
		name = 'poj-1147-burrows-wheeler-transform',
		title = 'poj 1147 Burrows-Wheeler transform',
		publish_time = 1344506849,
		tags = {'算法', '字符串', 'POJ'},
		category = 'Algorithm',
	},
	{
		name = 'go-io-reader',
		title = '正确理解 Go 的 io.Reader',
		publish_time = 1343880882,
		tags = {'Go', '非阻塞IO'},
		category = 'Programming',
	},
	{
		name = 'blog-algorithms',
		title = '这个 blog 用到的一些算法',
		publish_time = 1336728875,
		tags = {'算法', 'Web', 'Blog'},
		category = 'Algorithm',
	},
	{
		name = 'renren-readall-bookmarklet',
		title = '[bookmarklet]人人网批量已读脚本',
		publish_time = 1334485218,
		tags = {'js', 'bookmarklet'},
		category = 'Computers',
	},
	{
		name = 'greasemonkey-userscripts-recommends',
		title = '一些我使用和开发的油猴脚本',
		publish_time = 1334480918,
		tags = {'js', '油猴脚本'},
		category = 'Computers',
	},
	{
		name = 'tree-dp',
		title = '树形 dp 初探',
		publish_time = 1333469211,
		tags = {'算法', '动态规划', '树形dp'},
		category = 'Algorithm',
	},
	{
		name = 'escape-quote-filename-bash',
		title = '为 bash 转义文件名',
		publish_time = 1333167820,
		tags = {'Linux', 'shell'},
		category = 'Linux',
	},
	{
		name = 'maxflow-shortest-augmenting-path',
		title = '最大流之最短增广路算法',
		publish_time = 1332124797,
		tags = {'算法', '网络流', '图论'},
		category = 'Algorithm',
	},
	{
		name = 'maxflow-edmonds-karp',
		title = '最大流之 Edmonds-Karp',
		publish_time = 1332070027,
		tags = {'算法', '网络流', '图论'},
		category = 'Algorithm',
	},
	{
		name = 'archlinux-awesome-config',
		title = 'archlinux 上 awesome 的安装与配置',
		publish_time = 1330479974,
		tags = {'Linux', 'X11', 'WM'},
		category = 'Linux',
	},
	{
		name = 'ie-css-hacks',
		title = 'IE CSS Hacks',
		publish_time = 1329875828,
		tags = {'CSS', '前端'},
		category = 'Web',
	},
	{
		name = 'poj-2778-aho-corasick-dp',
		title = 'POJ 2778 AC 自动机上的 dp',
		publish_time = 1328864981,
		tags = {'算法', 'POJ', 'AC自动机', '动态规划'},
		category = 'Algorithm',
	},
	{
		name = 'trie-aho-corasick',
		title = 'trie 与 AC 自动机',
		publish_time = 1328673735,
		tags = {'算法', '字符串', 'trie', 'AC自动机', 'POJ'},
		category = 'Algorithm',
	},
	{
		name = 'union-find-set',
		title = '并查集',
		publish_time = 1328447429,
		tags = {'算法', '并查集', 'POJ'},
		category = 'Algorithm',
	},
	{
		name = 'random-shuffle',
		title = '随机混洗（Random Shuffle）算法',
		publish_time = 1328259693,
		tags = {'随机数', '算法'},
		category = 'Algorithm',
	},
	{
		name = 'segment-trees',
		title = '线段树小结',
		publish_time = 1328019358,
		tags = {'算法', '线段树', 'POJ'},
		category = 'Algorithm',
	},
	{
		name = 'binary-indexed-trees',
		title = '树状数组小结',
		publish_time = 1327928594,
		tags = {'算法', '树状数组', 'POJ'},
		category = 'Algorithm',
	},
	{
		name = 'poj-2823-monotonous-queue',
		title = 'POJ 2823 单调队列 + IO 优化',
		publish_time = 1326188374,
		tags = {'算法', '单调队列', 'POJ'},
		category = 'Algorithm',
	},
	{
		name = 'longest-increasing-subsequence-nlogn',
		title = '最长上升子序列的 nlogn 算法',
		publish_time = 1326186330,
		tags = {'算法', '动态规划'},
		category = 'Algorithm',
	},
	{
		name = 'linux-ffmpeg-screencast',
		title = '在 Linux 中用 ffmpeg 录屏',
		publish_time = 1325383681,
		tags = {'Linux', 'X11', 'ffmpeg', '多媒体'},
		category = 'Linux',
	},
	{
		name = 'x11-selection-copy-paste',
		title = 'X11 中的复制粘贴',
		publish_time = 1323789506,
		tags = {'Linux', 'X11', '复制'},
		category = 'Linux',
	},
	{
		name = 'lua-random-seed',
		title = '关于 Lua 的随机数',
		publish_time = 1322453326,
		tags = {'Lua', '随机数'},
		category = 'Lua',
	},
	{
		name = 'wxwidgets-separete-thread',
		title = '在非主线程中使用 wxWidgets',
		publish_time = 1322367531,
		tags = {'wxWidgets', '多线程'},
		category = 'Programming',
	},
	{
		name = 'google-exam-integer-partition',
		title = '听说是 Google 笔试题：整数拆分',
		publish_time = 1322144402,
		tags = {'算法', '动态规划'},
		category = 'Algorithm',
	},
	{
		name = 'multithread-python-c-extension',
		title = '多线程与 Python C 模块',
		publish_time = 1322139463,
		tags = {'Python', '多线程', '并发'},
		category = 'Programming',
	},
	{
		name = 'cpp-vector-iteration-remove',
		title = '一边遍历一边删除 vector 中的元素',
		publish_time = 1322112251,
		tags = {'C++', 'Vector'},
		category = 'Programming'
	},
	{
		name = 'domain-migrate-henix-info',
		title = '博客迁移到 blog.henix.info',
		publish_time = 1322039683,
		tags = {'Blog'},
		category = 'Essays'
	},
	{
		name = 'lua-stdout-binary',
		title = '在 Lua 中设置 stdout 为二进制模式',
		publish_time = 1319468436,
		tags = {'Lua', 'Win32'},
		category = 'Lua',
	},
	{
		name = 'cs-quotes',
		title = '计算机科学名言警句',
		publish_time = 1318561306,
		tags = {'软件工程', '架构'},
		category = 'Programming',
	},
	{
		name = 'js-auto-number-headings',
		title = '用 JavaScript 自动编号 headings',
		publish_time = 1318044789,
		tags = {'js', '文档'},
		category = 'Web',
	},
	{
		name = 'max-subseg-sum',
		title = '最大子段和问题',
		publish_time = 1315930717,
		tags = {'算法', '动态规划'},
		category = 'Algorithm',
	},
	{
		name = 'false-sharing-multi-processor',
		title = '多核系统中的伪共享问题',
		publish_time = 1313323264,
		tags = {'并发', 'CPU', 'Cache', '多核', '系统结构', '性能'},
		category = 'Programming',
	},
	{
		name = 'self-reproducing-program-AI',
		title = '神奇的自产生程序，兼谈人工生命',
		publish_time = 1312631218,
		tags = {'复杂性', '人工智能'},
		category = 'Computers',
	},
	{
		name = 'redis-key-or-hash',
		title = 'Redis：key 还是 hash？',
		publish_time = 1311763340,
		tags = {'Redis', 'NoSQL', '性能'},
		category = 'Programming',
	},
	{
		name = 'linux-cmd-freq',
		title = '统计 Linux 下使用频率最高的命令',
		publish_time = 1310966098,
		tags = {'Linux', 'shell'},
		category = 'Linux',
	},
	{
		name = 'simple-lua-template',
		title = 'Simple Lua Template 0.1 发布',
		publish_time = 1309612196,
		tags = {'Lua', '模板处理'},
		category = 'Lua',
	},
	{
		name = 'draw-diagrams-with-pic',
		title = 'Pic 语言：画示意图的又一利器',
		publish_time = 1307166437,
		tags = {'pic', '文档'},
		category = 'Computers',
	},
	{
		name = 'stein-gcd-algorithm',
		title = '求最大公约数的 Stein 算法',
		publish_time = 1307039387,
		tags = {'算法', '数学'},
		category = 'Algorithm',
	},
	{
		name = 'blas-lapack-do-matrix-operation',
		title = '用 BLAS/LAPACK 编写矩阵运算程序',
		publish_time = 1307023010,
		tags = {'数值分析', '线性代数', '算法', 'BLAS/LAPACK', '数学'},
		category = 'Programming',
	},
	{
		name = 'mingw-a-convert-dll',
		title = 'MinGW 的静态库（.a）转换成 dll',
		publish_time = 1306984034,
		tags = {'MinGW', 'DLL'},
		category = 'Programming',
	},
	{
		name = 'LL-1-ab-equal-counts',
		title = '用 LL(1) 表示含有相同数量 ab 的字符串',
		publish_time = 1306110700,
		tags = {'编译原理', 'LL分析'},
		category = 'Algorithm',
	},
	{
		name = 'hsl-to-rgb',
		title = 'HSL 色彩空间转换成 RGB',
		publish_time = 1305904969,
		tags = {'CG', 'HSL'},
		category = 'Algorithm',
	},
	{
		name = 'use-wxwidgets-with-mingw',
		title = 'MinGW + wxWidgets 小记',
		publish_time = 1305818259,
		tags = {'MinGW', 'wxWidgets'},
		category = 'Programming',
	},
	{
		name = 'software-recommend',
		title = '最近一些软件推荐',
		publish_time = 1305718950,
		tags = {'Windows'},
		category = 'Windows',
	},
	{
		name = 'mathjax-render-latex-math-online',
		title = 'MathJax: 在网页上显示 LaTeX 数学公式',
		publish_time = 1304339910,
		tags = {'前端', 'MathJax', '文档', '数学'},
		category = 'Web',
	},
	{
		name = 'note-comparison-chinese-english-writing',
		title = '英汉写作对比研究-笔记',
		publish_time = 1303739353,
		tags = {'English'},
		category = 'Essays',
	},
	{
		name = 'tcl-syntaxhighlighter-brush',
		title = 'SyntaxHighlighter brush for Tcl',
		publish_time = 1302967872,
		tags = {'js', 'SyntaxHighlighter', 'Tcl/Tk'},
		category = 'Web',
	},
	{
		name = 'future-internet-trends',
		title = '谈互联网未来趋势',
		publish_time = 1301884744,
		tags = {'Web'},
		category = 'Essays',
	},
	{
		name = 'webpage-dancer-js',
		title = '一段 js ，让网页跳舞',
		publish_time = 1301882679,
		tags = {'js', 'Fun', 'bookmarklet'},
		category = 'Web',
	},
	{
		name = 're-qq-ascii-video',
		title = '[重发]字符动画之QQ聊天窗口版',
		publish_time = 1301854323,
		tags = {'技术宅', 'AutoHotKey', 'Fun'},
		category = 'Computers',
	},
	{
		name = 'wmii-intro',
		title = '瓦片式窗口管理器：wmii',
		publish_time = 1301322342,
		tags = {'Linux', 'X11', 'wmii', 'WM'},
		category = 'Linux',
	},
	{
		name = 'tmux-split-terminal',
		title = '用 tmux 分割终端',
		publish_time = 1301319078,
		tags = {'Linux', 'shell', 'screen', 'tmux'},
		category = 'Linux',
	},
	{
		name = 'first-tcl-program',
		title = 'Tcl 的阶乘程序',
		publish_time = 1301062564,
		tags = {'Tcl/Tk'},
		category = 'Programming',
	},
	{
		name = 'win-cmd-basic-1.1',
		title = 'Windows 命令行基础: 修订版1.1',
		publish_time = 1300802855,
		tags = {'cmd.exe', 'Windows'},
		category = 'Windows',
	},
	{
		name = 'participate-css-naked-day-2011',
		title = '再次参加 CSS Naked Day',
		publish_time = 1300723085,
		tags = {'CSS', 'Web', '前端'},
		category = 'Web',
	},
	{
		name = 'read-the-fifth-discipline',
		title = '读《第五项修炼》',
		publish_time = 1300439740,
		tags = {'软件工程', '管理'},
		category = 'Essays',
	},
	{
		name = 'install-iuplua-on-linux',
		title = '在 Linux 上安装 iuplua',
		publish_time = 1300348540,
		tags = {'Lua', 'IUP', 'Linux'},
		category = 'Lua',
	},
	{
		name = 'my-vimrc',
		title = '我的 .vimrc',
		publish_time = 1300347821,
		tags = {'Vim', 'vimrc', 'Linux'},
		category = 'Linux',
	},
	{
		name = 'juhua-wen-intro',
		title = '菊花不带这样玩',
		publish_time = 1298978607,
		tags = {'***', '菊花', 'Unicode', '潮'},
		category = 'Computers',
	},
	{
		name = 'use-gnu-screen',
		title = 'GNU Screen 初探',
		publish_time = 1298651039,
		tags = {'Linux', 'shell', 'screen'},
		category = 'Linux',
	},
	{
		name = 'cmd-du-subdirs',
		title = '列出某文件夹下所有子文件夹占用的空间大小',
		publish_time = 1298527253,
		tags = {'cmd.exe', 'sed', 'Windows'},
		category = 'Windows',
	},
	{
		name = 'lua-program-solve-24-game',
		title = '[旧文重发]一个 Lua 的凑24程序',
		publish_time = 1298006541,
		tags = {'Lua', '算法'},
		category = 'Algorithm',
	},
	{
		name = 'brain-learning-memory-piaget-book-notes',
		title = '《脑的学习与记忆》《皮亚杰的认知发展理论》读书笔记',
		publish_time = 1297674982,
		tags = {'学习', '心理学'},
		category = 'Essays',
	},
	{
		name = 're-switch-ip-dns-batch',
		title = '[旧文重发]切换 IP/DNS 脚本',
		publish_time = 1295886664,
		tags = {'cmd.exe', 'Windows'},
		category = 'Windows',
	},
	{
		name = 're-java-integer-utils',
		title = '[旧文重发]IntegerUtils：一个关于整数操作的工具类',
		publish_time = 1295885344,
		tags = {'Java', '性能'},
		category = 'Java',
	},
	{
		name = "mount-ntfs-user-permissions",
		title = "Linux 中普通用户无法访问 NTFS 分区",
		publish_time = 1294378968,
		tags = {'Linux', 'ntfs', 'mount'},
		category = 'Linux',
	},
	{
		name = 'my-static-blog',
		title = '纯静态博客的实现',
		publish_time = 1294297139,
		tags = {'Blog', 'Web', '前端', '架构'},
		category = 'Web',
	},
	{
		name = 'robocopy-sync-files',
		title = '使用 robocopy 实时同步文件夹', 
		publish_time = 1293944333,
		tags = {'cmd.exe', 'robocopy', '备份', '复制', 'Windows'},
		category = 'Windows',
	},
	{
		name = 'new-year-new-blog',
		title = '新年第一贴/准备启用新博客',
		publish_time = 1293814362,
		tags = {'Blog'},
		category = 'Essays',
	},
	{
		name = 'test',
		title = "第一帖",
		publish_time = 1293723328,
		tags = {},
		category = 'Essays',
	}
}

tags = {
	['Blog']={uname='Blog', desc='博客', posti={}},
	['cmd.exe']={uname='cmd.exe', desc='Windows命令行', posti={}},
	['备份']={uname='backup', desc='Backup', posti={}},
	['复制']={uname='copy', desc='copy', posti={}},
	['Web']={uname='Web', desc='Web', posti={}},
	['前端']={uname='front-end', desc='Front End', posti={}},
	['架构']={uname='architecture', desc='Architecture', posti={}},
	['Linux']={uname='Linux', desc='开源的操作系统', posti={}},
	['ntfs']={uname='ntfs', desc='New Technology File System', posti={}},
	['mount']={uname='mount', desc='mount', posti={}},
	['Java']={uname='Java', desc='Java', posti={}},
	['学习']={uname='learning', desc='learning', posti={}},
	['心理学']={uname='psychology', desc='psychology', posti={}},
	['Lua']={uname='Lua', desc='小巧的动态函数式脚本语言', posti={}},
	['算法']={uname='Algorithm', desc='Algorithm', posti={}},
	['shell']={uname='shell', desc='Linux 命令行', posti={}},
	['screen']={uname='screen', desc='GNU Screen', posti={}},
	['***']={uname='---', desc='** 和 ***', posti={}},
	['菊花']={uname='juhua', desc='jú huā', posti={}},
	['Unicode']={uname='Unicode', desc='万国码', posti={}},
	['潮']={uname='the-hit', desc='the hit', posti={}},
	['性能']={uname='Performance', desc='Performance', posti={}},
	['robocopy']={uname='robocopy', desc='robocopy', posti={}},
	['Vim']={uname='Vim', desc='Vim 文本编辑器', posti={}},
	['vimrc']={uname='vimrc', desc='Vim 配置文件', posti={}},
	['IUP']={uname='IUP', desc='Lua 的界面库', posti={}},
	['sed']={uname='sed', desc='stream editor', posti={}},
	['软件工程']={uname='software-engineering', desc='Software Engineering', posti={}},
	['管理']={uname='management', desc='Management', posti={}},
	['CSS']={uname='CSS', desc='Cascading Style Sheets: 层叠样式表', posti={}},
	['Tcl/Tk']={uname='Tcl-Tk', desc='Tool Command Language/Tk GUI tookit', posti={}},
	['tmux']={uname='tmux', desc='Terminal Multiplexer', posti={}},
	['X11']={uname='X11', desc='X Window System', posti={}},
	['wmii']={uname='wmii', desc='window manager improved 2', posti={}},
	['技术宅']={uname='tech-otaku', desc='宅技术', posti={}},
	['AutoHotKey']={uname='AutoHotKey', desc='键盘宏工具', posti={}},
	['js']={uname='JavaScript', desc='JavaScript', posti={}},
	['Fun']={uname='Fun', desc='Just For Fun', posti={}},
	['SyntaxHighlighter']={uname='SyntaxHighlighter', desc='代码着色器', posti={}},
	['English']={uname='English', desc='英语', posti={}},
	['MathJax']={uname='MathJax', desc='Beautiful math in all browsers', posti={}},
	['文档']={uname='Documenting', desc='Documenting', posti={}},
	['数学']={uname='Math', desc='Math', posti={}},
	['Windows']={uname='Windows', desc='视窗操作系统', posti={}},
	['MinGW']={uname='MinGW', desc='Windows 的 GCC', posti={}},
	['wxWidgets']={uname='wxWidgets', desc='跨平台的 GUI 库', posti={}},
	['CG']={uname='CG', desc='Computer Graphics', posti={}},
	['编译原理']={uname='Compilers', desc='Compilers', posti={}},
	['LL分析']={uname='LL-parsing', desc='LL parsing', posti={}},
	['HSL']={uname='HSL', desc='HSL 色彩空间', posti={}},
	['DLL']={uname='DLL', desc='Dynamic Link Library', posti={}},
	['数值分析']={uname='numerical-analysis', desc='Numerical Analysis', posti={}},
	['线性代数']={uname='linear-algebra', desc='Linear Algebra', posti={}},
	['BLAS/LAPACK']={uname='blas-lapack', desc='线性代数库', posti={}},
	['pic']={uname='pic', desc='pic', posti={}},
	['Redis']={uname='Redis', desc='Redis key-value store', posti={}},
	['NoSQL']={uname='NoSQL', desc='非关系型数据库', posti={}},
	['复杂性']={uname='Complexity', desc='Complexity', posti={}},
	['人工智能']={uname='AI', desc='Artificial Intelligence', posti={}},
	['并发']={uname='Concurrency', desc='Concurrency', posti={}},
	['动态规划']={uname='DP', desc='Dynamic Programming', posti={}},
	['Win32']={uname='Win32', desc='Win32 编程', posti={}},
	['C++']={uname='cpp', desc='C++', posti={}},
	['Python']={uname='Python', desc='Python', posti={}},
	['多线程']={uname='multi-threading', desc='Multi-threading', posti={}},
	['随机数']={uname='random', desc='Random', posti={}},
	['CPU']={uname='cpu', desc='中央处理单元', posti={}},
	['Cache']={uname='cache', desc='高速缓存', posti={}},
	['多核']={uname='multi-core', desc='Multi core', posti={}},
	['系统结构']={uname='computer-architecture', desc='Computer architecture', posti={}},
	['WM']={uname='window-manager', desc='Window Manager', posti={}},
	['Vector']={uname='vector', desc='动态数组', posti={}},
	['ffmpeg']={uname='ffmpeg', desc='视频音频解决方案', posti={}},
	['多媒体']={uname='multimedia', desc='Multimedia', posti={}},
	['模板处理']={uname='templating', desc='Templating', posti={}},
	['单调队列']={uname='monotonous-queue', desc='单调队列', posti={}},
	['POJ']={uname='poj', desc='北京大学 Online Judge', posti={}},
	['树状数组']={uname='binary-indexed-trees', desc='Binary Indexed Trees', posti={}},
	['线段树']={uname='segment-trees', desc='Segment Trees', posti={}},
	['并查集']={uname='union-find-set', desc='Union-find set', posti={}},
	['字符串']={uname='strings', desc='Strings', posti={}},
	['trie']={uname='trie', desc='字典树', posti={}},
	['AC自动机']={uname='aho-corasick', desc='Aho-Corasick', posti={}},
	['网络流']={uname='network-flows', desc='Network Flows', posti={}},
	['图论']={uname='graph-theory', desc='Graph theory', posti={}},
	['树形dp']={uname='tree-dp', desc='树形动态规划', posti={}},
	['油猴脚本']={uname='greasemonkey', desc='GreaseMonkey', posti={}},
	['bookmarklet']={uname='bookmarklet', desc='Bookmarklet', posti={}},
	['Go']={uname='go', desc='go-lang', posti={}},
	['非阻塞IO']={uname='non-blocking-io', desc='Non-blocking IO', posti={}},
	['调试']={uname='debug', desc='Debug', posti={}},
	['Emacs']={uname='emacs', desc='Emacs', posti={}},
	['后缀数组']={uname='suffix-array', desc='Suffix Array', posti={}},
	['tomcat']={uname='tomcat', desc='Tomcat', posti={}},
	['Haskell']={uname='haskell', desc='Haskell', posti={}},
	['closure']={uname='closure', desc='闭包', posti={}},
}

-- store index of blog
local table_category = {
	{'Linux', 'Linux'},
	{'Algorithm', '算法'},
	{'Windows', 'Windows 技巧'},
	{'Computers', '计算机应用'},
	{'Web', 'Web'},
	{'Lua', 'Lua'},
	{'Java', 'Java'},
	{'Programming', '编程其他'},
	{'Essays', '随感'},
	{'Functional', 'Functional Programming'},
}

categories = {}

local inserted = {};
for _, post in ipairs(blogposts) do
	if inserted[post.category] == nil then
		table.insert(categories, post.category)
		inserted[post.category] = true
	end
end

for _, row in ipairs(table_category) do
	assert(inserted[row[1]])
	categories[row[1]] = {}
	categories[row[1]].showname = row[2]
end

--[[categories = {
	['Linux']={showname='Linux'},
	['Algorithm']={showname='算法'},
	['Windows']={showname='Windows 技巧'},
	['Computers']={showname='计算机应用'},
	['Web']={showname='Web'},
	['Lua']={showname='Lua'},
	['Java']={showname='Java'},
	['Programming']={showname='编程其他'},
	['Essays']={showname='随感'},
}]]
