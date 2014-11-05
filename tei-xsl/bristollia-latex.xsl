<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="tei"
    version="2.0">

    <!-- we are creating a tex file ... -->
    <xsl:output method="text" omit-xml-declaration="yes" indent="no"/>

    <!-- strip white space -->
    <xsl:strip-space elements="tei:note tei:choice tei:abbr tei:ex tei:hi tei:locus"/>


    <!-- VARIABLES -->

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

    <!-- abstract (first para) -->
    <xsl:variable name="abstract"
        select="//tei:teiHeader/tei:profileDesc/tei:abstract/tei:p[1]/text()"/>

    <!-- date -->
      <xsl:variable name="subjectdate"
        select="//tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title/tei:date/text()"/>  

    <!-- year -->
      <xsl:variable name="subjectyear">
        <xsl:analyze-string select="$subjectdate" regex="\d{{4}}">
            <xsl:matching-substring>
                <xsl:value-of select="."/>
            </xsl:matching-substring>
        </xsl:analyze-string> 
      </xsl:variable>

    <!-- archive -->
    <xsl:variable name="archive"
        select="//tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:msIdentifier/tei:repository/text()"/>

    <!-- reference -->
    <xsl:variable name="reference">
        <xsl:value-of select="//tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:msIdentifier/tei:idno/text()"/><xsl:call-template name="locus"/>
    </xsl:variable>

    <!-- UUID -->
    <xsl:variable name="uuid"
        select="//tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno/text()"/>

    <!-- licence -->
      <xsl:variable name="licence"
        select="//tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:availability/tei:licence/text()"/> 

    <!-- keywords -->
    <xsl:variable name="keywords"><xsl:call-template name="keywordsList"/></xsl:variable>

    <!-- languages -->
    <xsl:variable name="languages">
        <xsl:for-each select="//tei:teiHeader/tei:profileDesc/tei:langUsage/tei:language">
            <xsl:value-of select="."/><xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
        </xsl:for-each>
    </xsl:variable>

    <!-- TEMPLATES -->

    <xsl:template name="keywordsList">
        <xsl:for-each select="//tei:teiHeader/tei:profileDesc/tei:textClass/tei:keywords/tei:list/tei:item">
            <xsl:value-of select="."/><xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
        </xsl:for-each>
    </xsl:template>

    <!-- folios, pages etc -->
    <xsl:template name="locus">, <xsl:value-of select="//tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:msContents/tei:msItem/tei:locus/text()"/>
    </xsl:template>

    <!-- editorial notes -->
    <xsl:template name="editorial">
        \section*{Editorial Note}

        Original punctuation and spelling are preserved. Superscript characters are lowered and contractions expanded with supplied letters italicised. The thorn (\th\ or y) is replaced with `th' and a terminal graph with `es'. The ampersand brevigraph is silently expanded to `and' in English and `et' in Latin. Letters within square brackets are supplied by the editor. Engrossed hand are shown in bold text.
    </xsl:template>


    <!-- header of the document -->
    <xsl:template match="tei:teiHeader">
        \documentclass[a4paper,12pt]{article}
        \usepackage{anysize}
        \usepackage{hyperref}
        \usepackage{fancyhdr}
        \usepackage{pdflscape}
        \usepackage[T1]{fontenc}
        \setlength{\headheight}{15pt}
        \marginsize{2.5cm}{2.5cm}{1cm}{1cm}
        \setlength{\parskip}{10pt}
        \setlength\parindent{0pt}
        \def\authorname{<xsl:value-of select="$editorName"/>}
        \def\authoremail{<xsl:value-of select="$editorEmail"/>}
        \def\pubdate{<xsl:value-of select="$pubDate"/>}
        \def\shorttitle{<xsl:value-of select="$title"/>}
        \def\archivename{<xsl:value-of select="$archive"/>}
        \def\archiverefno{<xsl:value-of select="$reference"/>}
        \hypersetup{
            pdfinfo={
                Author={\authorname},
                AuthorEmail={\authoremail},
                Title={\shorttitle},
                Subject={<xsl:value-of select="$abstract"/>},
                Keywords={<xsl:value-of select="$keywords"/>},               
                UUID={<xsl:value-of select="$uuid"/>},
                PubDate={\pubdate},
                Language={<xsl:value-of select="$languages"/>},
                SubjectYear={<xsl:value-of select="$subjectyear"/>},
                SubjectDate={<xsl:value-of select="$subjectdate"/>},
                Archive={\archivename},
                ArchiveRefNo={\archiverefno},
                License={<xsl:value-of select="$licence"/>},
            }
        }
        \begin{document}
        \title{\Large \shorttitle\\\normalsize \vspace{1em} \archivename \hspace{0 mm}, \archiverefno \hspace{1 mm}}\vspace{-5em}
        \author{\small Edited by \authorname \hspace{0 mm} (\authoremail)}
        \date{\small \pubdate}
        \maketitle
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:fileDesc"><xsl:apply-templates/></xsl:template>

    <xsl:template match="tei:sourceDesc"><xsl:apply-templates/></xsl:template>

    <xsl:template match="tei:msDesc"><xsl:apply-templates/></xsl:template>

    <xsl:template match="tei:msContents">
        \section*{Introduction}
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:msItem">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:titleStmt"></xsl:template>
    <xsl:template match="tei:publicationStmt"></xsl:template>
    <xsl:template match="tei:msIdentifier"></xsl:template>
    <xsl:template match="tei:locus"></xsl:template>
    <xsl:template match="tei:langUsage"></xsl:template>
    <xsl:template match="tei:textClass"></xsl:template>


    <xsl:template match="tei:profileDesc/tei:abstract">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="tei:text/tei:body">
        <xsl:call-template name="editorial"/>
        \begin{landscape}
        \section*{Text}
        <xsl:apply-templates/>
            \end{landscape}
            \end{document}
    </xsl:template>

    <xsl:template match="tei:pb">

        [<xsl:value-of select="normalize-space(@n)" />]

        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="tei:p">
        <!--<xsl:value-of select="normalize-space(.)"/>-->
                <xsl:choose>
            <xsl:when test="@rend='right'">\begin{flushright}<xsl:apply-templates />\end{flushright}</xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates />
            </xsl:otherwise>
        </xsl:choose>
        \par
    </xsl:template>

    <xsl:template match="tei:lb">\newline </xsl:template>        

    <xsl:template match="tei:ex">\textit{<xsl:value-of select="normalize-space(.)"/>}</xsl:template>

     <xsl:template name="expan" match="tei:expan">
        <xsl:text> </xsl:text>
        <xsl:apply-templates />
    </xsl:template>

     <!-- TODO -> if abbr, but no ex, then put all in square brackets? -->

    <xsl:template match="tei:hi">
        <xsl:choose>
            <xsl:when test="@rend='bold'">\textbf{<xsl:apply-templates/>}</xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:abbr"></xsl:template>

    <xsl:template match="tei:choice"><xsl:call-template name="expan"/></xsl:template>

    <xsl:template match="tei:note">\footnote{<xsl:apply-templates />}</xsl:template>

</xsl:stylesheet>