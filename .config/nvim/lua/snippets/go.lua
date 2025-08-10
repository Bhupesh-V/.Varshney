-- Go snippets using Neovim's built-in snippet API (0.10+)

local function snip(prefix, body)
  vim.keymap.set("i", prefix, function()
    vim.snippet.expand(body)
  end, { buffer = true })
end

-- Imports
snip("im", [[import "${1:package}"]])
snip("ims", [[import (
	"${1:package}"
)]])

-- Consts
snip("co", [[const ${1:name} = ${2:value}]])
snip("cos", [[const (
	${1:name} = ${2:value}
)]])

-- Types
snip("tyf", [[type ${1:name} func($3) $4]])
snip("tyi", [[type ${1:name} interface {
	$0
}]])
snip("tys", [[type ${1:name} struct {
	$0
}]])

-- Package main + func main
snip("pkgm", [[package main

func main() {
	$0
}]])

-- Functions & Vars
snip("func", [[func $1($2) $3 {
	$0
}]])
snip("var", [[var ${1:name} ${2:type}]])
snip("vars", [[var (
	${1:name} ${2:type}
)]])

-- Switch / Select
snip("switch", [[switch ${1:expression} {
case ${2:condition}:
	$0
}]])
snip("sel", [[select {
case ${1:condition}:
	$0
}]])
snip("cs", [[case ${1:condition}:$0]])

-- Loops
snip("for", [[for ${1:i} := ${2:0}; $1 < ${3:count}; $1${4:++} {
	$0
}]])
snip("forr", [[for ${1:_}, ${2:v} := range ${3:v} {
	$0
}]])

-- Basic types
snip("ch", [[chan ${1:type}]])
snip("map", [[map[${1:type}]${2:type}]])
snip("in", [[interface{}]])

-- If / Else
snip("if", [[if ${1:condition} {
	$0
}]])
snip("el", [[else {
	$0
}]])
snip("ie", [[if ${1:condition} {
	$2
} else {
	$0
}]])
snip("iferr", [[if err != nil {
	${1:return ${2:nil, }${3:err}}
}]])

-- Print / Log
snip("fp", [[fmt.Println("${1}")]])
snip("ff", [[fmt.Printf("${1}", ${2:var})]])
snip("lp", [[log.Println("${1}")]])
snip("lf", [[log.Printf("${1}", ${2:var})]])
snip("lv", [[log.Printf("${1:var}: %#+v\n", ${1:var})]])

-- Testing log
snip("tl", [[t.Log("${1}")]])
snip("tlf", [[t.Logf("${1}", ${2:var})]])
snip("tlv", [[t.Logf("${1:var}: %#+v\n", ${1:var})]])

-- Make / New / Panic
snip("make", [[make(${1:type}, ${2:0})]])
snip("new", [[new(${1:type})]])
snip("pn", [[panic("${0}")]])

-- HTTP Handlers
snip("wr", [[${1:w} http.ResponseWriter, ${2:r} *http.Request]])
snip("hf", [[${1:http}.HandleFunc("${2:/}", ${3:handler})]])
snip("hand", [[func $1(${2:w} http.ResponseWriter, ${3:r} *http.Request) {
	$0
}]])
snip("rd", [[http.Redirect(${1:w}, ${2:r}, "${3:/}", ${4:http.StatusFound})]])
snip("herr", [[http.Error(${1:w}, ${2:err}.Error(), ${3:http.StatusInternalServerError})]])
snip("las", [[http.ListenAndServe("${1::8080}", ${2:nil})]])
snip("sv", [[http.Serve("${1::8080}", ${2:nil})]])

-- Goroutines / defer
snip("go", [[go func(${1}) {
	$0
}(${2})]])
snip("gf", [[go ${1:func}($0)]])
snip("df", [[defer ${1:func}($0)]])

-- Tests / Benchmarks / Examples
snip("tf", [[func Test$1(t *testing.T) {
	$0
}]])
snip("tm", [[func TestMain(m *testing.M) {
	$1

	os.Exit(m.Run())
}]])
snip("bf", [[func Benchmark$1(b *testing.B) {
	for ${2:i} := 0; ${2:i} < b.N; ${2:i}++ {
		$0
	}
}]])
snip("ef", [[func Example$1() {
	$2
	//Output:
	$3
}]])
snip("tdt", [[func Test$1(t *testing.T) {
	testCases := []struct {
		desc	string
		$2
	}{
		{
			desc: "$3",
			$4
		},
	}
	for _, tC := range testCases {
		t.Run(tC.desc, func(t *testing.T) {
			$0
		})
	}
}]])

-- Init / Main / Methods
snip("finit", [[func init() {
	$1
}]])
snip("fmain", [[func main() {
	$1
}]])
snip("meth", [[func (${1:receiver} ${2:type}) ${3:method}($4) $5 {
	$0
}]])

-- Hello Web
snip("helloweb", [[package main

import (
	"fmt"
	"net/http"
	"time"
)

func greet(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello World! %s", time.Now())
}

func main() {
	http.HandleFunc("/", greet)
	http.ListenAndServe(":8080", nil)
}]])

-- Sort interface
snip("sort", [[type ${1:SortBy} []${2:Type}

func (a $1) Len() int           { return len(a) }
func (a $1) Swap(i, j int)      { a[i], a[j] = a[j], a[i] }
func (a $1) Less(i, j int) bool { ${3:return a[i] < a[j]} }]])
