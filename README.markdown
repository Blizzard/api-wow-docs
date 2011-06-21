
# About

This is the public documentation for the api-wow RESTful web service provided as part of the World of Warcraft community site.

# Documentation

After cloning the repository, open up index.html within the /docs/ folder, or generate new documentation with the commands below.

# Generating 

Open your command line within the cloned repositories folder, and execute the follow commands. The libxml2 and libxslt libraries are required.

    $ xmllint --xinclude docbook.xml > docs/docbook.xml
    $ xsltproc docbook-xsl/html/docbook.xsl --stringparam html.stylesheet docs/style.css docs/docbook.xml > docs/index.html

