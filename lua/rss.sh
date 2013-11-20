#!/bin/sh
awk '{ print "* [" $2 "](/rss/" $1 ".xml)" }' category.db
