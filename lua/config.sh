# TODO: 与 config.lua 重复

SITEURL="http://blog.henix.info"
SITEDESC="henix's blog 每月1号和15号更新"

getPostURL() {
	echo "/blog/${1}.html"
}

getCategoryURL() {
	echo "/#$1"
}

getTagURL() {
	echo "/tags/${1}.html"
}
