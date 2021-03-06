　　archlinux 这段时间在推 [systemd](https://wiki.archlinux.org/index.php/Systemd) ，于是我也不知不觉地用上了，在此记录一下那些曾经栽过的坑。

### 1. 笔记本电源管理

　　systemd 由于代替了 init ，也接管了一部分 BIOS 事件，比如休眠什么的。然后就发现关上笔记本突然就自动休眠了，我之前在 pm-suspend 或者 acpid 里配置的明明应该是关上盖子什么也不做才对呀...

　　最后去提问才发现要配置 /etc/systemd/logind.conf

	HandleLidSwitch=ignore
	LidSwitchIgnoreInhibited=no

### 2. systemd-journal

　　这东西据说替代了 syslog ，本来我没注意到它的，直到有一天 systemd-journald 这个进程占了 99% CPU 和 800MB+ 内存，我顺手一看，发现 /var/log/journal 占了 5GB+ 的空间。所以一定要在 /etc/system/journald.conf 里加上：

	SystemMaxUse=128M

### 3. systemd-coredump

　　我们知道 openjdk + eclipse 这个组合经常 crash -_-b 我每次一 crash 系统就慢得不得了，uptime 8 以上，sar -u 1 发现 iowait 80%+ ，然后 iotop 了几次，每次都发现 opera 以 5MB/s 的速度读写磁盘，果断 kill -9 ，没有把 systemd-coredump 这个罪魁祸首揪出来。直到最近一次 iotop 才发现 systemd-coredump 这逼在疯狂地写磁盘！

　　实际上应该是我内存不够所致（2GB 不知道现在是个什么水平，但 systemd-coredump 消耗的内存真的有点多），内存用完导致 swap ，然后就看到写磁盘和大量 page fault 。

　　[[Solved] Systemd: how to disable core dumps on application crashes?](https://bbs.archlinux.org/viewtopic.php?id=154511)

　　这里我才发现 systemd 居然在我不知情的情况下擅自向内核注册 coredump 钩子，而且没有在 systemd 的配置里找到取消这个的选项，简直丧心病狂！

　　上面的帖子也给出了解决方案：

	# ln -s /dev/null /etc/sysctl.d/coredump.conf
	# /lib/systemd/systemd-sysctl

　　在我看来最彻底的办法是在启动脚本 rc.local 里加入：

	echo > /proc/sys/kernel/core_pattern
