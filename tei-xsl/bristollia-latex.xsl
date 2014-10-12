<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="tei"
    version="2.0">

    <!-- we are creating a tex file ... -->
    <xsl:output method="text" omit-xml-declaration="yes" indent="no"/>
    <xsl:strip-space elements="note" />

    <!-- editor name -->
     <xsl:variable name="editorName"
        select="//tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:editor/tei:name/text()"/>   

    <!-- editor email -->
         <xsl:variable name="editorEmail"
        select="//tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:editor/tei:email/text()"/> 

    <!-- publication date -->
    <xsl:variable name="pubDate"
        select="//tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:date/text()"/>

    <!-- title -->
    <xsl:variable name="title"
        select="//tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title/text()"/>

    <xsl:template name="editorial">
        \section*{Editorial Note}

        The transcription was made from a digital photograph. Original punctuation and spelling are preserved. Superscript characters are lowered and contractions expanded with supplied letters italicised. The thorn (\th\ or y) is replaced with `th' and a terminal graph with `es'. The ampersand brevigraph is silently expanded to `and' in English and `et' in Latin. Letters within square brackets are supplied by the editor. Engrossed hand are shown in bold text.
    </xsl:template>


    <!-- header of the document -->
    <xsl:template match="tei:teiHeader">
        \documentclass[a4paper,12pt]{article}
        \usepackage{anysize}
        \usepackage{hyperref}
        \usepackage{fancyhdr}
        \usepackage{pdflscape}
        \usepackage[T1]{fontenc}
        \usepackage[none]{hyphenat}%%%%
        \setlength{\headheight}{15pt}
        \marginsize{2.5cm}{2.5cm}{1cm}{1cm}
        \setlength{\parskip}{10pt}
        \setlength\parindent{0pt}
        \def\authorname{<xsl:value-of select="$editorName"/>}
        \def\authoremail{<xsl:value-of select="$editorEmail"/>}
        \def\pubdate{<xsl:value-of select="$pubDate"/>}
        \def\shorttitle{<xsl:value-of select="$title"/>}
        \begin{document}
        \title{\shorttitle}\vspace{-5em}
        \author{\small Edited by \authorname \hspace{0 mm} (\authoremail)}
        \date{\small \pubdate}
        \maketitle
    </xsl:template>

    <!-- body of the document -->
    <xsl:template match="tei:text/tei:body">
        <xsl:call-template name="editorial"/>
        <xsl:text>\section*{Text}</xsl:text>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:pb">

        [<xsl:value-of select="normalize-space(@n)" />]

        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:p">
        <!--<xsl:value-of select="normalize-space(.)"/>-->
                <xsl:apply-templates />
        \end{document}
    </xsl:template>

    <xsl:template match="tei:lb">
        <xsl:text>\newline</xsl:text>
    </xsl:template>        

    <xsl:template match="tei:ex">\textit{<xsl:value-of select="."/>}</xsl:template>

     <xsl:template name="expand" match="tei:expand">

        <xsl:apply-templates />
     </xsl:template>

     <!-- TODO -> if abbr, but no ex, then put all in square brackets? -->

    <xsl:template match="tei:hi">
        <xsl:choose>
            <xsl:when test="@rend='bold'">\textbf{<xsl:apply-templates />}</xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:abbr"></xsl:template>

    <xsl:template match="tei:choice">
        <xsl:call-template name="expand"/>
    </xsl:template>

    <xsl:template match="tei:note">\footnote{<xsl:apply-templates />}</xsl:template>

</xsl:stylesheet>