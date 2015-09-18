#!/usr/bin/bash

function searchResult()
{
	URL="http://google.com/search?q="
	STRING=`echo $1 | sed 's/ /%20/g'`
	URI="$URL$STRING"
	lynx -dump $URI > gone.tmp
	sed 's/http/\^http/g' gone.tmp | tr -s "^" "\n" | grep http| sed 's/\ .*//g' > gtwo.tmp
	rm gone.tmp
	sed '/google.com/d' gtwo.tmp > urls
	rm gtwo.tmp
	INPUT=`sed -n '2p' < urls`
	rm urls
	echo $INPUT| cut -d'&' -f 1
}

filename="$1"
wkhtmltopdf --disable-javascript blank.html final.pdf
while read -r line
do

#result=$(curl -s --get --data-urlencode "q=$line" http://ajax.googleapis.com/ajax/services/search/web\?v\=1.0 | sed 's/"unescapedUrl":"\([^"]*\).*/\1/;s/.*GwebSearch",//')

#url=$(echo "http://www.google.com/search?hl=en&q=$line&btnI=I%27m+Feeling+Lucky&aq=f&oq=" | sed 's/ /+/g');

#url=$(echo "http://www.google.com/search?&sourceid=navclient&btnI=I&q=$line" | sed 's/ /+/g'); 

#result=$(curl -s --get --data "num=1" --data-urlencode "q=$line" https://www.googleapis.com/customsearch/v1 | sed 's/"unescapedUrl":"\([^"]*\).*/\1/;s/.*GwebSearch",//')

url=$(searchResult "$line") 

echo $url

curl -o temp.html $url
#find ./temp.html -type f -exec sed -i -e 's#id="sidebar"#id="sidebar" style="display: none;"#g' {} \;
#find ./temp.html -type f -exec sed -i -e 's#id="disqus_thread"#id="disqus_thread" style="display: none;"#g' {} \;
#find ./temp.html -type f -exec sed -i -e 's#id="menu"#id="menu" style="display: none;"#g' {} \;
find ./temp.html -type f -exec sed -i -e 's#id="disqus_thread"#id="disqus_thread" style="display: none;"#g' {} \;
wkhtmltopdf --disable-javascript temp.html temp.pdf
mv final.pdf final_temp.pdf
pdftk final_temp.pdf temp.pdf cat output final.pdf

done < "$filename"

rm temp.pdf
rm temp.html
rm final_temp.pdf


