# Utility to print grep searches in a human friendly way

# Credits: https://www.endpoint.com/blog/2017/01/18/using-awk-to-beautify-grep-searches

BEGIN {
  FS=":"
  file=""
  filestarted=0
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
    print "|"
  }
  out=substr($0, length($1 ":" $2 ": "))
  linum=sprintf("%-4s", $2)
  print linum " " out
  filestarted=1;
}
