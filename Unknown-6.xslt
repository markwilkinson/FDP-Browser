<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:phi="http://linkeddata.systems/SemanticPHIBase/Resource/"
xmlns="http://www.w3.org/1999/xhtml"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
version="2.0">
<xsl:output method="html" encoding="utf-8" indent="yes"/>
<xsl:variable name="docroot" select="//rdfs:label/../@rdf:about"/>
<xsl:variable name="label" select="//rdfs:label"/>
<xsl:template match="/">
<html>
<head><title><xsl:value-of select="$label"/></title></head>
<body>
<h1>About: <xsl:value-of select="$label"/></h1>

<xsl:for-each select="//rdf:Description[@rdf:about=$docroot]">
<xsl:for-each select="./∗" >
<xsl:variable name="url" select="./@rdf:resource"></xsl:variable>
<xsl:variable name="content" select="."></xsl:variable>
<h3> <xsl:value-of select="name(.)"/>:</h3>
<p style="text-indent: 50px">
<xsl:choose>
<xsl:when test="$content =''">
<a href='{$url}'><xsl:value-of select="$url"/></a>
</xsl:when>
<xsl:when test="not($content ='')">
<xsl:value-of select="$content"/>
</xsl:when>
</xsl:choose>
</p>
</xsl:for-each>
</xsl:for-each>
</body></html>
</xsl:template>
</xsl:stylesheet>
