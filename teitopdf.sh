#!/bin/bash
#
# A little wrapper script to transform an XML TEI document
# to PDF (via latex).
#
# The script uses SAXON to tranform the TEI XML to a tex
# document via an XSLT file. The pdflatex utility 
# creates a PDF document from the tex file. The PDF
# document will be created in the output directory.
# 
# The SAXON environment variable should be the full path
# of the SAXON JAR. pdflatex and java need to be installed
# an on the execution path.
# 
# The script takes one mandatory argument: the xml source
# (relative to the location if the script).
#
# sh teitopdf.sh BRO/some.xml
#
# By default, the orientation of the transript text is
# landscape, but we can set it to portrait.
#
# sh teitopdf.sh BRO/some.xml orient=portrait
#
# We can also set the newline to be indicated by a pipe
#
# sh teitopdf.sh BRO/some.xml orient=portrait newline=pipe 

# check that we have the location of saxon
if [ -z ${SAXON+x} ]; then echo "SAXON is unset"; exit 1; fi

# the xsl is relative to the script
STYLE_SHEET=$PWD/tei-xsl/bristollia-latex.xsl;

# full path to the xml file
XML_SOURCE=$PWD/$1;

# calculate the name of the file
XML_FILE_NAME=${XML_SOURCE##*/}
NAME=${XML_FILE_NAME%.*}

# full path to output tex file
OUTPUT_FILE="./output/$NAME.tex"

# run the transformation
java -jar $SAXON -s:$XML_SOURCE -xsl:$STYLE_SHEET -o:$OUTPUT_FILE $2 $3

# remove a space if it appears before the footnote command,
# otherwise a space appears before the superscript number
sed -i.bak 's/ \\footnote/\\footnote/' $OUTPUT_FILE

# run pdf latex
pdflatex -output-directory=./output $OUTPUT_FILE