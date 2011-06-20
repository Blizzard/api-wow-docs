
# About

This is the public documentation for the api-wow RESTful web service provided
as part of the World of Warcraft community site.

# Building documentation

    $ xmllint --xinclude docbook.xml > docbook-a.xml
    $ xsltproc docbook-xsl/html/docbook.xsl docbook-a.xml  > index-new.html

