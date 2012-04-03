all: index-new.html

docbook-new.xml: docbook.xml *.json
	xmllint --xinclude docbook.xml > docbook-new.xml

index-new.html: docbook-new.xml style.css
	xsltproc --stringparam html.stylesheet style.css api-wow.xsl docbook-new.xml > index-new.html

clean:
	rm -f index-new.html docbook-new.xml
