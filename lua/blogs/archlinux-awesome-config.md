　　先来张图：

#{= makeImg('/files/awesome.jpg') }#

　　我以前用的是 wmii ，但后来转到 awesome ，主要是因为 awesome 的脚本化能力很强大。

　　使用 linux 的过程中我们经常面对的东西有两样：terminal 和浏览器。前者漆黑，而后者很白。在两者之前来回切换造成的后果是让你的眼睛低亮度的环境还没适应过来，一下子就面对高亮度，眼睛很容易疲劳。

　　所以我首先想到的解决方法是：为不同的程序设置不同的壁纸。对浏览器，设置一个全黑的壁纸；对终端，设置一个比较亮的壁纸。然后让窗口半透明，这样壁纸就可以与窗口本身的亮度中和。

　　当然，实际上我们是做不到对不同的程序设置不同的壁纸的，于是我改成：在不同的桌面上设置不同的壁纸。比如 1 号桌面是黑的，2-6 是白的，7-9 都是黑的。然后只在白的桌面上开终端，只在黑的桌面上开浏览器。

### awesome 的安装

　　<del>先编译 cairo-xcb ，再编译 awesome 。我在编译 awesome-3.4.11-2 的时候遇到一个编译错误，大意是找不到 libiconv.a 。我发现系统里本来就没有这个东西，而且也没有一个叫做 libiconv 的库。最后我发现 libiconv 是包含在 gcc 里面的，在链接的时候直接加上 -liconv 就可以了。所以，需要修改 PKGBUILD ，下面是 diff ：</del>

```
--- PKGBUILD.orig	2011-12-09 16:43:16.517210395 +0800
+++ PKGBUILD	2011-12-09 16:44:28.363881864 +0800
@@ -26,7 +26,7 @@
   cd "$srcdir/$pkgname-$pkgver"
 
   make CMAKE_ARGS=" -DPREFIX=/usr -DSYSCONFDIR=/etc \
-	-DCMAKE_BUILD_TYPE=RELEASE"
+	-DCMAKE_BUILD_TYPE=RELEASE -DCMAKE_EXE_LINKER_FLAGS=-liconv"
 }
 
 package() {
```

　　<del>就是在链接器选项里加一个 -liconv ，我现在已经不知道当时是如何查阅那庞大的 cmake 手册的了。。。</del>

2013-1-7 更新：现在安装 awesome 已经不需要编译，直接 pacman -S awesome

### awesome 的配置

1\. 前面说的为不同的桌面设置不同的壁纸的代码如下：

#{= highlight([=[
-- {{{ Tags
-- Define a tag table which hold all screen tags.
last_desk = 'dark'
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[2])
	awful.tag.attached_add_signal(s, "property::selected", function(t)
		-- local selected = awful.tag.selected(s)
		if last_desk == 'light' and (t.name == "1" or t.name == '7' or t.name == "8" or t.name == "9") then
			awful.util.spawn('feh --bg-fill /home/henix/black.png')
			last_desk = 'dark'
		elseif last_desk == 'dark' and (t.name ~= "1" and t.name ~= '7' and t.name ~= "8" and t.name ~= "9") then
			awful.util.spawn('feh --bg-center /home/henix/57a2ef86e99ba83166096e62.jpg')
			last_desk = 'light'
		end
	end)
end
-- }}}
]=], 'lua', {lineno=true}) }#

　　通过 feh 设置壁纸，且仅在当前桌面和要切换过去的桌面的壁纸不同的时候在调用 feh ，减少 fork 的开销。

2013-1-7 更新：awesome 3.5 中 attached_add_signal 改为 attached_connect_signal 。

2\. 一些自定义快捷键

#{= highlight([=[
-- Win + p 打开 dmenu ：
awful.key({modkey}, "p", function ()
    awful.util.spawn('dmenu_run')
end),

-- Ctrl + Atl + l 锁屏：
-- 因为 Windows 中是 Win + L ，但在 awesome 中 Win + L 已经被用来干其他事情了
awful.key({"Mod1", "Control"}, "l", function ()
    awful.util.spawn('xscreensaver-command -lock')
end),

-- 取消 Win + Shift + q 的退出，
-- 退出的时候用菜单，因为我老是不小心按了...
-- awful.key({modkey, "Shift"}, "q", awesome.quit),
]=], 'lua', {lineno=true}) }#

　　当然这里又引发了我的另一个思考，如何设计用户界面，我称之为用户界面设计的 henix's law ：

> 用户越需要频繁使用的功能应该越容易被调用；相反，越不需要频繁使用的功能应该越难被找到。

　　容易调用的例子：快捷键、工具栏；难找到的例子：庞大的菜单、一个套一个的对话框、配置文件。

　　比如退出这种事情，实际上不需要快捷键，直接点菜单就行了，因为开一天机可能就用到一两次退出。但锁屏就需要快捷键，因为我离开电脑就需要，使用得更频繁。

2013-1-7 更新：awesome 3.5 自带菜单，而且快捷键也是 Win + p ，故无需再使用 dmenu 。

3\. 窗口背景透明：

　　在 manage 的 signal 里加入：

#{= highlight([=[
    if c.class ~= "MPlayer" then
        c.opacity = 0.72
    end
]=], 'lua') }#

　　将除了 mplayer 外所有窗口的透明度设置为 0.72 。

4\. 添加 vicious 控件：

```
-- vicious

batwidget = widget({ type = "textbox" })
vicious.register(batwidget, vicious.widgets.bat, "$1 $2% $3 | ", 5, "BAT0")

uptimewidget = widget({ type = "textbox" })
vicious.register(uptimewidget, vicious.widgets.uptime, "$4 $5 $6 | ", 7)

cpuwidget = widget({ type = "textbox" })
vicious.register(cpuwidget, vicious.widgets.cpu, "$1% | ", 3)

memwidget = widget({ type = "textbox" })
vicious.register(memwidget, vicious.widgets.mem, "$1% ($2MB/$3MB) | ", 13)

mystatusbar = awful.wibox({ position = "bottom", name = "mystatusbar" })
mystatusbar.widgets = {
    mytextclock,
    memwidget,
    cpuwidget,
    uptimewidget,
    batwidget,
    layout = awful.widget.layout.horizontal.rightleft
}
mystatusbar.screen = 1
```

　　在底部状态栏显示电池、uptime 、CPU 和内存。

2013-1-7 更新：awesome 3.5 各种 API 有更新，请使用以下代码：

#{= highlight([=[
-- vicious
do
	local batwidget = wibox.widget.textbox()
	vicious.register(batwidget, vicious.widgets.bat, "$1 $2% $3 | ", 5, "BAT0")

	local uptimewidget = wibox.widget.textbox()
	vicious.register(uptimewidget, vicious.widgets.uptime, "$4 $5 $6 | ", 7)

	local cpuwidget = wibox.widget.textbox()
	vicious.register(cpuwidget, vicious.widgets.cpu, "$1% | ", 3)

	local memwidget = wibox.widget.textbox()
	vicious.register(memwidget, vicious.widgets.mem, "$1% ($2MB/$3MB) | ", 13)

	local mystatusbar = {}
	for s = 1, screen.count() do
		mystatusbar[s] = awful.wibox {position = 'bottom', screen = s}

		local right_layout = wibox.layout.fixed.horizontal()
		right_layout:add(batwidget)
		right_layout:add(uptimewidget)
		right_layout:add(cpuwidget)
		right_layout:add(memwidget)
		right_layout:add(mytextclock)

		local layout = wibox.layout.align.horizontal()
		layout:set_right(right_layout)

		mystatusbar[s]:set_widget(layout)
	end
end
]=], 'lua', {lineno=true}) }#
