#!/bin/bash
#
# A little wrapper script for using Saxon to transform an XML TEI
# document to a latex document, which is then turned into a PDF
# document.
#
# The SAXON environment variable should be the full path of the 
# SAXON JAR. pdflatex and java need to be installed an on the
# execution path. The script takes two arguments: the xml source
# and the tex output filename. These need to be relative to
# the location of the script.
#
#    sh xml_to_tex.sh BRO/some.xml BRO/some.tex
#
#
# Needs a lot more work :-)

# check that we have the location of saxon
if [ -z ${SAXON+x} ]; then echo "SAXON is unset"; exit 1; fi

# the xsl is relative to the script
STYLE_SHEET=$PWD/tei-xsl/bristollia-latex.xsl;

# full path to the xml file
XML_SOURCE=$PWD/$1;

# full path to output file
OUTPUT_FILE=$PWD/$2


# run the transformation
java -jar $SAXON -s:$XML_SOURCE -xsl:$STYLE_SHEET -o:$OUTPUT_FILE $3

sed -i.bak 's/ \\footnote/\\footnote/' $OUTPUT_FILE

# run pdf latex
pdflatex $OUTPUT_FILE