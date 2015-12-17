#Transcripts of historical document

This repository holds either LaTex or TEI XML documents. These are used to generate PDF documents, some of which are available on http://bristollia.org/

The documents are related to my research interests and provide an opportunity to learn LaTex and TEI XML.

To process the TEI XML documents, I use a shell script which uses Saxon to parse the XML and XSL file to generate a LaTex document and pdflatex then creates a PDF document.

A SAXON environment variable is needed:

```
export SAXON=/Users/mikejones/Development/Libraries/Saxonsaxon9he.jar
```

Create a PDF with the text in portrait:

```
sh teitopdf.sh TNA/SP/SP-1-99-f184.xml orient=portrait
```

Create a PDF with the text in portrait and line breaks represented by a pipe (|):

```
sh teitopdf.sh TNA/SP/SP-1-99-f184.xml orient=portrait newline=pipe
```

Create a PDF with the text in landscape:

```
sh teitopdf.sh TNA/SP/SP-1-99-f184.xml orient=landscape
```