Transcriptions of historical documents. This repository holds the
LaTex documents that are used to generate PDF file that are
available on http://bristollia.org/

Playing with TEI ...

Overrding in a bristollia profile. TEIC stylesheets here: https://github.com/TEIC/Stylesheets

./teitohtml5 --profiledir=../../historical-research/tei-xsl/profiles --profile=bristollia ~/Dropbox/test.xml ~/Dropbox/test.html

Running my own xsl file (needs Saxon jar):

java -jar ~/Development/Libraries/Saxon/saxon9he.jar -xsl:../../../workspaces/historical-research/tei-xsl/bristollia-latex.xsl -s:../../../workspaces/historical-research/BRO/JOr-1-1-ff-213v-214v-Nicholas-Thorne-grant.xml