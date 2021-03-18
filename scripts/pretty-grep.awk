BEGIN {
  # FROM: https://www.endpoint.com/blog/2017/01/18/using-awk-to-beautify-grep-searches
  # USAGE: grep -nir --color=always --exclude-dir={_site,.git,.github} $@ | awk -f pretty-grep.awk
  FS=":"

  # we are going to need to "remember" if the <file-name>
  # changes to print it's name and to do that only
  # once per file:
  file=""

  # we'll be printing line numbers too; the non-consecutive
  # ones will be marked with the special line with vertical
  # dots; let's have a variable to keep track of the last
  # line number:
  ln=0

  # we also need to know we've just encountered a new file
  # not to print these vertical dots in such case:
  filestarted=0
}

!/(--|Binary)/ {

  if($1 != file && $1 != "")
  {
    file=$1
    print "\n" $1 ":"
    ln = $2
    filestarted=0
  }

  if($2 > ln + 1 && filestarted != 0)
  {
    print "|"
  }

  out=substr($0, length($1 ":" $2 ": "))

  # let's deal with only the lines that make sense:
  if($2 >= ln && $2 != "")
  {
    linum=sprintf("%-4s", $2)
    print linum " " out
    ln=$2
    filestarted=1
  }
}
