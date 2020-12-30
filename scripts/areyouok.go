package main

import (
    "fmt"
    "io/ioutil"
    "regexp"
    "os"
    "net/http"
    "net/url"
    "time"
    "log"
)

func checkLink(link string, ch chan<- string) {
    reqURL, _ := url.Parse(link)
    req := &http.Request {
        Method: "GET",
        URL: reqURL,
        Header: map[string][]string {
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

func main() {
    filepath := os.Args[1]
    data, err := ioutil.ReadFile(filepath)
    if err != nil {
        fmt.Println("File reading error", err)
        return
    }
    // file_content := `https://www.suon.co.uk/product/1/7/3/`
    file_content := string(data)

    re := regexp.MustCompile(`https?:\/\/[^)\n,\s\"]+`)
    fmt.Printf("Pattern: %v\n", re.String()) // print pattern
    fmt.Println(re.MatchString(file_content)) // true

    submatchall := re.FindAllString(file_content,-1)
    start := time.Now()
    ch := make(chan string)
    for _, element := range submatchall {
        go checkLink(element, ch)
    }
    for range submatchall {
        fmt.Println(<-ch)
    }
    fmt.Printf("Total Time: %.2fs\n", time.Since(start).Seconds())
}
