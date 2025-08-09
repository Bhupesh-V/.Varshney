# Utility to print grep searches in a human friendly way

# Credits: https://www.endpoint.com/blog/2017/01/18/using-awk-to-beautify-grep-searches

BEGIN {
  FS=":"
  file=""
  filestarted=0
  GREEN_FG="\033[1;38;5;154m"
  RESET="\033[m"
}

# $0 : the entire line
# $1 : filepath
# $2 : line number
# $3 : the rest of the line

{
  if($1 != file && $1 != ""){
    file=$1
    print "\n" $1 ":"
    filestarted=0;
  }
  if(filestarted != 0){
    print GREEN_FG "|" RESET
  }
  out=substr($0, length($1 ":" $2 ": "))
  print $2 " " out
  filestarted=1;
}
