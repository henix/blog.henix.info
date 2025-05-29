package main

import (
	"fmt"
	"io"
	"os"
	"time"
)

func modifyTime(name string) time.Time {
	return Must(os.Stat(name)).ModTime()
}

func modifyTimeOpt(name string) (time.Time, bool) {
	fi, err := os.Stat(name)
	if err != nil {
		return time.Time{}, false
	}
	t := fi.ModTime()
	return t, true
}

func NeedGenTime(deptime time.Time, target string) bool {
	targetMtime, exist := modifyTimeOpt(target)
	return !exist || deptime.After(targetMtime)
}

func NeedGen(dep string, target string) bool {
	return NeedGenTime(modifyTime(dep), target)
}

func MaxDepTime(deptime time.Time, dep string) time.Time {
	t := modifyTime(dep)
	if t.After(deptime) {
		return t
	}
	return deptime
}

func NeedGens(deps []string, target string) bool {
	targetMtime, exist := modifyTimeOpt(target)
	if !exist {
		return true
	}
	for _, dep := range deps {
		if modifyTime(dep).After(targetMtime) {
			return true
		}
	}
	return false
}

func NeedGensTime(deptime time.Time, deps []string, target string) bool {
	targetMtime, exist := modifyTimeOpt(target)
	if !exist {
		return true
	}
	if deptime.After(targetMtime) {
		return true
	}
	for _, dep := range deps {
		if modifyTime(dep).After(targetMtime) {
			return true
		}
	}
	return false
}

func CopyFile(src string, dst string) error {
	fmt.Println("copy:", src, "->", dst)
	in, err := os.Open(src)
	if err != nil {
		return err
	}
	defer in.Close()
	out, err := os.Create(dst)
	if err != nil {
		return err
	}
	defer out.Close()
	Must(io.Copy(out, in))
	return nil
}
