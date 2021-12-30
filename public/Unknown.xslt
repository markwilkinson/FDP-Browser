<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:dc='http://purl.org/dc/terms/' 
xmlns:dcat='http://www.w3.org/ns/dcat#' 
xmlns:fdp='http://rdf.biosemantics.org/ontologies/fdp-o#' 
xmlns:foaf='http://xmlns.com/foaf/0.1/' 
xmlns:ldp='http://www.w3.org/ns/ldp#' 
xmlns:rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#' 
xmlns:rdfs='http://www.w3.org/2000/01/rdf-schema#' 
xmlns:sio='http://semanticscience.org/resource/' 
xmlns:spar='http://purl.org/spar/datacite/' 
xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
 version="2.0">
    <xsl:output method="html" encoding="utf-8" indent="yes" />
    <xsl:variable name="docroot" select="//ldp:DirectContainer/ldp:membershipResource/*/@rdf:about" />
    <xsl:variable name="title" select="//ldp:DirectContainer/ldp:membershipResource/*/dc:title/." />
    <xsl:template match="/">
        <html>
            <head>
                <title>
                    <xsl:value-of select="concat($title, ' : ', $docroot)" />
                </title>
            </head>
            <body>
                <h1></h1>
                <h2><xsl:value-of select="concat($title, ' : ' , $docroot)" /></h2>
                <h3>Content</h3>
                <xsl:for-each select="//ldp:DirectContainer/ldp:contains">
                    <span style="text-indent: 50px">

                        <xsl:variable name="content" select="./@rdf:resource"/>
                        <a href='./proxy?url={$content}'><xsl:value-of select="$content"/></a>
                    </span>
                </xsl:for-each>
                <br/><br/>
                <xsl:for-each select="//ldp:DirectContainer/ldp:membershipResource/*/dc:isPartOf">
                    <h3>Is Part Of Collection:</h3>
                    <span style="text-indent: 50px">

                        <xsl:variable name="content" select="./@rdf:resource"/>
                        <a href='./proxy?url={$content}'><xsl:value-of select="$content"/></a>
                    </span>
                </xsl:for-each>
                <br/><br/>

                <h3>Description:</h3>
                <xsl:for-each select="//ldp:membershipResource/*/node()">
                    <xsl:variable name="restrictednode" select="local-name()"/>
                    <xsl:choose>
                        <xsl:when test='not($restrictednode = "contains" or  $restrictednode = "catalog" or $restrictednode = "dataset" or $restrictednode = "distribution")'>
                            <xsl:if test = "(not(local-name()='' or local-name()='type'  or local-name()='label' or local-name()='title' or local-name()='isPartOf'))">
                                <xsl:variable name="url" select="./@rdf:resource"></xsl:variable>
                                <xsl:variable name="content" select="."></xsl:variable>

                                <b><xsl:value-of select="local-name()"/></b>: 
                                <span style="text-indent: 50px">
                                    <xsl:choose>
                                        <xsl:when test="$content =''">
                                            <a href='{$url}'><xsl:value-of select="$url"/></a>
                                        </xsl:when>
                                        <xsl:when test="not($content ='')">
                                            <xsl:value-of select="$content"/>
                                        </xsl:when>
                                    </xsl:choose>
                                </span><br/>

                            </xsl:if>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
