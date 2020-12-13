#!/bin/bash


here=$(realpath $(dirname $BASH_SOURCE))

{ which pcre2grep && which curl || return $?; } > /dev/null

query(){
	query="$@"
	curl -fGo "$here/result.csv" --data-urlencode "_search=$query" --url 'https://calishot-eng-3.herokuapp.com/index-eng/summary.csv' --data-urlencode "_sort=uuid" --data-urlencode "_size=max"

}

download(){
list=( $(cat "$here/result.csv" | pcre2grep -o 'https?://[\w\./:-]+get[\w\./:-]+') )
mkdir "$here/output" 2> /dev/null
j=0
for i in ${list[@]}; do
        (( j+=1 ))
        url=$i
        ext=$(echo $i | pcre2grep -o1 'get/([\w]+)/')
#        echo $j; echo $url; echo $ext
        curl -vo "$here/book$j.$ext" "$url" && \
		mv "$here/book$j.$ext" "$here/output"
done
}

case $1 in 
        query) shift 1; query "$@";
        ;;
        download) download
        ;;
        *) echo -e "Available commands are:\n\t1) 'query' which should be followed by your search string\n\t2) 'download' which downloads results of the query"
esac
