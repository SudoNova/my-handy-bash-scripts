#!/bin/bash


here=$(realpath -s "$(dirname $BASH_SOURCE)")

{ which pcre2grep && which curl || return $?; } > /dev/null

# Enter servers' addresses here
	servers=( "https://calishot-eng-3.herokuapp.com" \
		"https://calishot-eng-3.herokuapp.com" \
		"https://calishot-eng-3.herokuapp.com" \
		"http://0.0.0.0" )
query(){
	query="$@"
	for server in ${servers[*]}; do
		curl -fGo "$here/result.csv" --data-urlencode "_search=$query" --url "$server/index-eng/summary.csv" --data-urlencode "_sort=uuid" --data-urlencode "_size=max" && break 
	done
}

download(){
	list=( $(cat "$here/result.csv" | pcre2grep -o 'https?://[\w\./:-]+get[\w\./:-]+') )
	mkdir "$here/output" 2> /dev/null
	j=0
	for i in ${list[@]}; do
        (( j+=1 ))
        url=$i
        ext=$(echo $i | pcre2grep -o1 'get/([\w]+)/')
        echo $j #; echo $url; echo $ext
		result="$(curl --connect-timeout 10 --retry 3 -D - -fo "$here/book$j.$ext" "$url")" &&\
		filename="$(echo $result | pcre2grep -o1 'filename="([^"]+)"')" &&\
		[[ $(stat -c '%s' "$here/book$j.$ext") -ne 0 ]] &&\
		mv "$here/book$j.$ext" "$here/output/$filename" ||\
		{ rm -rf "$here/book$j.$ext" && echo -e "Failed\n"; }
	done
}

case $1 in 
        query) shift 1; query "$@";
        ;;
        download) download
        ;;
        *) echo -e "Available commands are:\
			\n\t1) 'query' which should be followed by your search string\
			\n\t2) 'download' which downloads results of the query"
esac
