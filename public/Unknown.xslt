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
xmlns:fn="http://www.w3.org/2005/xpath-functions"
xmlns:str="http://exslt.org/strings"
xmlns:vcard="http://www.w3.org/2006/vcard/ns#"

xmlns:regexp="http://exslt.org/regular-expressions"
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
            <link rel="stylesheet"  type="text/css" href="http://yui.yahooapis.com/2.7.0/build/reset-fonts-grids/reset-fonts-grids.css" media="all" /> 
            <link rel="stylesheet"  type="text/css" href="./css/resume.css" media="all" />

        </head>
        <body>
        <div id="doc2" class="yui-t7">
            <div id="inner">
            
                <div id="hd">
                    <div class="yui-gc">
                        <div class="yui-u first">

                        <h2>Resource Type: Unknown  </h2>
                        </div>

                        <div class="yui-u">
                            <div class="contact-info">

                        <h3><xsl:value-of select="concat($title, ' : ' , $docroot)" /></h3>
                            </div> <!-- contact info-->
                        </div> <!-- yui-u-->
                    </div> <!-- yui-gc-->
                </div> <!-- hd-->


                <div id="bd">
                    <div id="yui-main">


                        <div class="yui-b">

                            <div class="yui-gf">

                                <div class="yui-u first">
                                    <h2>Content</h2>
                                </div> <!-- first -->

                                <div class="yui-u">
                                    <p style="font-size: 120%;">
                                        <xsl:for-each select="//ldp:DirectContainer/ldp:contains">
                                            <xsl:variable name="content" select="./@rdf:resource"/>
                                            <a href='./proxy?url={$content}'><xsl:value-of select="regexp:replace($content, '^.*\/', 'i', '')"/></a>
                                        </xsl:for-each>
                                    </p>
                                </div> <!-- yui-u -->
                            </div><!--// .yui-gf -->
                        
                        

                            <xsl:if test="//dc:isPartOf">
                            <div class="yui-gf">

                                <div class="yui-u first">
                                    <h2>Is Part Of Collection: a<xsl:value-of select="$partof"/>a</h2>
                                </div>

                                <div class="yui-u">
                                    <p style="font-size: 120%;">
                                        <xsl:for-each select="//ldp:DirectContainer/ldp:membershipResource/*/dc:isPartOf">
                                                <xsl:variable name="content" select="./@rdf:resource"/>
                                                <a href='./proxy?url={$content}'><xsl:value-of select="$content"/></a>
                                        </xsl:for-each>
                                    </p>
                                </div> <!-- yui u-->
                            </div><!--// .yui-gf -->

                            </xsl:if>




                            <div class="yui-gf">

                                <div class="yui-u first">
                                    <h2>Description:</h2>
                                </div>

                                <div class="yui-u">
<!--                                    <p class="enlarge"> -->

                                        <xsl:for-each select="//ldp:membershipResource/*/node()">
                                            <xsl:variable name="restrictednode" select="local-name()"/>
                                            <xsl:choose>
                                                <xsl:when test='not($restrictednode = "SIO_000628" or $restrictednode = "contactPoint" or $restrictednode = "accessService" or $restrictednode = "contains" or  $restrictednode = "catalog" or $restrictednode = "dataset" or $restrictednode = "distribution")'>
                                                    <xsl:if test = "(not(local-name()='' or local-name()='type'  or local-name()='label' or local-name()='title' or local-name()='isPartOf'))">
                                                        <xsl:variable name="url" select="./@rdf:resource"></xsl:variable>
                                                        <xsl:variable name="content" select="."></xsl:variable>

                                                        <b><xsl:value-of select="local-name()"/></b>: 
                                                        <span style="text-indent: 50px">
                                                            <xsl:choose>
                                                                <xsl:when test="$content =''">
                                                                    <a href='{$url}'><xsl:value-of select="regexp:replace($url, '^.*\/', 'i', '')"/></a>
                                                                </xsl:when>
                                                                <xsl:when test="not($content ='')">
                                                                    <xsl:value-of select="$content"/>
                                                                </xsl:when>
                                                            </xsl:choose>
                                                        </span><br/>

                                                    </xsl:if>
                                                </xsl:when>
                                                <xsl:when test='$restrictednode = "accessService" or $restrictednode = "contactPoint"'>
                                                    <xsl:apply-templates select="."/>
                                                </xsl:when>
                                            </xsl:choose>
                                        </xsl:for-each>


                                        <xsl:if test="//ldp:membershipResource/*/dcat:themeTaxonomy">
                                            <br/><br/>
                                            <h2>Associated Taxonomy:</h2><br/>
                                            <div clear="both" class="container">
                                            <xsl:for-each select="//ldp:membershipResource/*/dcat:themeTaxonomy">
                                                <xsl:variable name="ontology" select="@rdf:resource"/>
                                                <a class="item" href='{$ontology}'><xsl:value-of select="regexp:replace($ontology, '^.*\/', 'i', '')"/></a>
                                            </xsl:for-each>
                                            </div>
                                        </xsl:if>

                                        <xsl:if test="//ldp:membershipResource/*/dcat:theme">
                                            <br/><br/>
                                            <h2>Associated Ontology Terms:</h2><br/>
                                            <div clear="both" class="container">
                                            <xsl:for-each select="//ldp:membershipResource/*/dcat:theme">
                                                <xsl:variable name="ontology" select="@rdf:resource"/>
                                                <a class="item" href='{$ontology}'><xsl:value-of select="regexp:replace($ontology, '^.*\/', 'i', '')"/></a>
                                            </xsl:for-each>
                                            </div>
                                        </xsl:if>


<!--                                    </p> -->
                                </div> <!-- yui u-->
                            </div><!--// .yui-gf -->
                        </div> <!-- yui b -->


                        <div id="ft">
                            <br/><br/><br/><p>Created By : <a href="mailto:info@fairdata.systems">info@fairdata.systems</a> : (XXX) - XXX-XXXX</p>
                        </div><!--// footer -->

                    </div><!--// .yui-main -->
                </div><!--// .yui-bd -->



            </div><!-- // inner -->
        </div><!--// doc -->


        </body>
        </html>
    </xsl:template>
    <xsl:template match="dcat:accessService">
        <xsl:variable name="desc" select="//dcat:endpointDescription/@rdf:resource"></xsl:variable>
        <xsl:variable name="loc" select="//dcat:endpointURL/@rdf:resource"></xsl:variable>
       
        <b>Access Service</b>
        <div style="text-indent: 50px;">
        <b>Description: </b><a href='{$desc}'>  <xsl:value-of select="regexp:replace($desc, '^.*\/', 'i', '')"/>  </a><br/>
        </div>
        <div style="text-indent: 50px;">
        <b>URL: </b><a href='{$loc}'>            <xsl:value-of select="regexp:replace($loc, '^.*\/', 'i', '')"/>   </a>
        </div>
    </xsl:template>

    <xsl:template match="dcat:contactPoint">
        <xsl:variable name="name" select="//vcard:Individual/vcard:fn/node()"></xsl:variable>
        <xsl:variable name="email" select="//vcard:Individual/vcard:hasEmail/@rdf:resource"></xsl:variable>
       
        <b>Contact Point</b>
        <div style="text-indent: 50px;">
            <b>Name: </b><xsl:value-of select="$name"/><br/>
        </div>
        <div style="text-indent: 50px;">
            <b>Email: </b><a href='{$email}'>  <xsl:value-of select="$email"/>   </a>
        </div>
    </xsl:template>

</xsl:stylesheet>
