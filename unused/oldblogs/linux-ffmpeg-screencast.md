　　ffmpeg 是个跨平台的全套视频音频解决方案，可以录屏、录音、转码。

　　为了能在 Linux 中录音，必须先安装 PulseAudio 。

　　启动 PulseAudio ：

	pulseaudio --start

　　退出 PulseAudio ：

	pulseaudio --kill

　　然后就可以在 ffmpeg 中使用 pulse 这个音频设备了。ffmpeg 命令：

	ffmpeg -f alsa -ac 1 -i pulse -f x11grab -s 1366x768 -r 20 -i :0.0 -acodec aac -strict experimental -vcodec libx264 -vf scale=852:480 /tmp/test2.mp4

　　其中 -r 指定帧率。我采用了 H.264 的视频编码和 AAC 的音频编码。AAC 还是处于试验阶段，所以必须加上 -strict experimental ，而我试了实际的录音效果还可以，但有时会出现音频落后于视频的情况。你也可以用 libmp3lame 来录制 mp3 音频。

　　列出所有可用的编码器：

	ffmpeg -codecs
