<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="tei"
    version="2.0">

    <!-- import base conversion style -->

    <xsl:import href="../../../../../Stylesheets/html5/html5.xsl"/>

	  <!-- I don't want exanded text to be delimited by brackets,
               but to appear in italics. The expanded text is surrounded
               by a span tag with the ex class, so we can use CSS -->
	  <xsl:template match="tei:expan/tei:ex">
	    <xsl:call-template name="makeInline">
	      <xsl:with-param name="before"></xsl:with-param>
	      <xsl:with-param name="after"></xsl:with-param>
	    </xsl:call-template>
	  </xsl:template>

</xsl:stylesheet>
