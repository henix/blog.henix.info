#!/bin/sh

httpsport() {
	if [ "$HTTPS_PORT" != "443" ]; then
		echo ":$HTTPS_PORT"
	fi
}

genconf() {
cat <<EOF
dir-listing.activate = "disable"
server.username = "$HTTP_USER"
server.groupname = "$HTTP_USER"

server.port = $HTTP_PORT
server.document-root = "$DOCROOT"

index-file.names = ( "index.html" )

mimetype.assign = (
  ".html" => "text/html",
  ".htm" => "text/html",
  ".css" => "text/css",
  ".txt" => "text/plain",
  ".js" => "text/javascript",
  ".gif" => "image/gif",
  ".jpg" => "image/jpeg",
  ".png" => "image/png",
  ".ico" => "image/x-icon",
  ".svg" => "image/svg+xml",
  ".xml" => "text/xml"
)

\$HTTP["url"] == "/rss2.0.xml" {
  mimetype.assign = ( "" => "application/rss+xml" )
}

# logs

server.modules += ( "mod_accesslog" )
accesslog.filename = "|/usr/bin/cronolog logs/%Y%m%d.log"

# https

server.modules += ( "mod_openssl" )

\$SERVER["socket"] == ":$HTTPS_PORT" {
  ssl.engine = "enable"
  ssl.pemfile = "$PEM_FILE"
  ssl.ca-file = "$CA_FILE"

  # http://disablessl3.com/
  ssl.use-sslv2 = "disable"
  ssl.use-sslv3 = "disable"

  # https://wiki.mozilla.org/Security/Server_Side_TLS
  # Intermediate compatibility
  ssl.cipher-list = "ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:ECDHE-RSA-DES-CBC3-SHA:ECDHE-ECDSA-DES-CBC3-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA"

  # https://weakdh.org/sysadmin.html
  ssl.dh-file = "$DH_FILE"
}

server.modules += ( "mod_redirect" )

\$SERVER["socket"] == ":$HTTP_PORT" {
  \$HTTP["host"] =~ "(.*):$HTTP_PORT" {
    url.redirect = (".*" => "https://%1$(httpsport)\$0")
  }
  else \$HTTP["host"] =~ "(.*)" {
    url.redirect = (".*" => "https://%1$(httpsport)\$0")
  }
}

\$SERVER["socket"] == ":$HTTPS_PORT" {
	url.redirect = (
		"^/hacks/build-personal-search-engine/_.html" => "/blog/build-personal-search-engine/_.html",
		"^/hacks/html-presentation/_.html" => "/blog/html-presentation/_.html",
		"^/hacks/dmenu-run/_.html" => "/blog/dmenu-run/_.html",
		"^/hacks/html-presentation-annotate/_.html" => "/blog/html-presentation-annotate/_.html",
		"^/hacks/mathjax-render-latex-math-online/_.html" => "/blog/mathjax-render-latex-math-online/_.html",
		"^/works/psiphon3-intro/_.html" => "/blog/psiphon3-intro/_.html",
		"^/works/my-yahoo-pipes/_.html" => "/blog/my-yahoo-pipes/_.html",
		"^/works/archer-rpc-scala/_.html" => "/blog/archer-rpc-scala/_.html",
		"^/works/greasemonkey-userscripts-recommends/_.html" => "/blog/greasemonkey-userscripts-recommends/_.html",
		"^/works/windows-cmdbasic/_.html" => "/blog/windows-cmdbasic/_.html",
		"^/works/bash-history-alias/_.html" => "/blog/bash-history-alias/_.html",
		"^/works/simple-lua-template/_.html" => "/blog/simple-lua-template/_.html",
		"^/views/why-https-so-important/_.html" => "/blog/why-https-so-important/_.html",
		"^/views/program-information-reverse-run/_.html" => "/blog/program-information-reverse-run/_.html",
		"^/views/use-chinese-identifier/_.html" => "/blog/use-chinese-identifier/_.html",
		"^/views/self-reproducing-program-AI/_.html" => "/blog/self-reproducing-program-AI/_.html",
		"^/dig/scala-bug-macro-cannot-find-annotation/_.html" => "/blog/scala-bug-macro-cannot-find-annotation/_.html",
		"^/dig/scala-program-solve-24-game/_.html" => "/blog/scala-program-solve-24-game/_.html",
		"^/dig/enumerate-2n-on-physical-switches-with-least-steps/_.html" => "/blog/enumerate-2n-on-physical-switches-with-least-steps/_.html",
		"^/dig/prolog-24-game-solver/_.html" => "/blog/prolog-24-game-solver/_.html",
		"^/dig/lua-js-closure/_.html" => "/blog/lua-js-closure/_.html",
		"^/dig/escape-quote-filename-bash/_.html" => "/blog/escape-quote-filename-bash/_.html",
		"^/dig/lua-program-solve-24-game/_.html" => "/blog/lua-program-solve-24-game/_.html",
		"^/dig/reverse-polish-notation-catalan-number/_.html" => "/blog/reverse-polish-notation-catalan-number/_.html",
	)
}

# cache

server.modules += ( "mod_expire" )

\$HTTP["url"] =~ "^/" {
  expire.url = ( "" => "access plus 10 minutes" )
}
\$HTTP["url"] =~ "^/lib/" {
  expire.url = ( "" => "access plus 1 years" )
}

# gzip

server.modules += ( "mod_compress" )

compress.filetype = ("text/plain", "text/html", "text/xml", "text/css", "text/javascript", "text/css", "image/svg+xml", "application/rss+xml")
compress.cache-dir = "cache.tmp"
EOF
}

genconf > lighttpd.conf

exec lighttpd -D -f lighttpd.conf
