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

\$HTTP["url"] =~ ".*\\.html" {
  server.error-handler-404 = "/404.html"
}

# logs

server.modules += ( "mod_accesslog" )
accesslog.filename = "|/usr/bin/cronolog logs/%Y%m%d.log"

# https

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

url.redirect-code = 302

\$SERVER["socket"] == ":$HTTP_PORT" {
  \$HTTP["host"] =~ "(.*):$HTTP_PORT" {
    url.redirect = (".*" => "https://%1$(httpsport)\$0")
  }
  else \$HTTP["host"] =~ "(.*)" {
    url.redirect = (".*" => "https://%1$(httpsport)\$0")
  }
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
