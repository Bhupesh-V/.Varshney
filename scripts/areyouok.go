package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"net/url"
	"os"
	"path/filepath"
	"regexp"
	"strings"
	"time"
)

/*
TODO:
1. Concurrent reading of files?
2. Report Generator (JSON/HTML/TXT)
*/

// its not perfect (look for edge cases)
// https://www.suon.co.uk/product/1/7/3/
var re = regexp.MustCompile(`https?:\/\/[^)\n,\s\"*]+`)

func checkLink(link string, ch chan<- string) {
	reqURL, _ := url.Parse(link)
	req := &http.Request{
		Method: "GET",
		URL:    reqURL,
		Header: map[string][]string{
			"User-Agent": {"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/77.0.3865.90 Safari/537.36"},
		},
	}
	start := time.Now()
	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		log.Fatalln(err)
	}
	// fmt.Println("HTTP Response Status:", resp.StatusCode, http.StatusText(resp.StatusCode))
	secs := time.Since(start).Seconds()
	ch <- fmt.Sprintf("Took %.2fs to fetch %s, Status: %d", secs, link, resp.StatusCode)
}

func In(a string, list []string) bool {
	for _, b := range list {
		if b == a {
			return true
		}
	}
	return false
}

func GetFiles(user_path string, filetype string, ignore []string) []string {
	var validFiles []string

	err := filepath.Walk(user_path,
		func(path string, info os.FileInfo, err error) error {
			if err != nil {
				return err
			}
			if info.IsDir() {
				if In(info.Name(), ignore) {
					return filepath.SkipDir
				}
			}
			if strings.HasSuffix(filepath.Base(path), filetype) && !In(info.Name(), ignore) {
				validFiles = append(validFiles, path)
			}
			return nil
		})
	if err != nil {
		log.Println(err)
	}
	return validFiles
}

func Indent(v interface{}) string {
	b, err := json.MarshalIndent(v, "", "  ")
	if err != nil {
		return fmt.Sprintf("%#v", v)
	}
	return string(b)
}

func GetLinks(files []string) []string {
	hyperlinks := make(map[string][]string)
    var totalLinks int
    var allLinks []string

	for _, file := range files {
		data, err := ioutil.ReadFile(file)
		if err != nil {
			fmt.Println("File reading error", err)
		}
		file_content := string(data)
		submatchall := re.FindAllString(file_content, -1)
		if len(submatchall) > 0 {
			hyperlinks[file] = submatchall
		}
	}
	for _, v := range hyperlinks {
		totalLinks += len(v)
        allLinks = append(allLinks, v...)
	}
	// yay! Jackpot!!
	fmt.Printf("%d links found across %d files\n\n", totalLinks, len(hyperlinks))
    // fmt.Println(Indent(hyperlinks))

    return allLinks
}

func Driver(links []string) {
    // fmt.Println(links)
	start := time.Now()
	ch := make(chan string)
	for _, element := range links {
		go checkLink(element, ch)
	}
	for range links {
		fmt.Println(<-ch)
	}
	fmt.Printf("Total Time: %.2fs\n", time.Since(start).Seconds())
}

func main() {
	var (
		typeOfFile string
		ignoreDirs string
		user_dir   string
		dirs       []string
	)
	flag.StringVar(&typeOfFile, "t", "md", "Specify type of files to scan")
	flag.StringVar(&ignoreDirs, "i", "", "Comma separated directory and/or file names to ignore")
	flag.Parse()
	// fmt.Printf("type = %s\n", typeOfFile)
	// fmt.Printf("ignore = %s\n", ignoreDirs)

	if ignoreDirs != "" {
		dirs = strings.Split(ignoreDirs, ",")
	}

	if len(flag.Args()) == 0 {
		user_dir = "."
	} else {
		user_dir = flag.Args()[0]
	}

	var valid_files = GetFiles(user_dir, typeOfFile, dirs)
    // fmt.Println(GetLinks(valid_files))
	Driver(GetLinks(valid_files))
}
