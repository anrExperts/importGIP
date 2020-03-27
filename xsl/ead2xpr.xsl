<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    exclude-result-prefixes="xs" 
    xpath-default-namespace="urn:isbn:1-931666-22-9"
    xmlns="urn:isbn:1-931666-22-9"
    xmlns:rico="rico"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    version="2.0">
    
    <xsl:strip-space elements="*"/>
    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="ead">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="eadheader | frontmatter"/>
    
    <xsl:template match="archdesc">
        <expertises xmlns="xpr">
            <xsl:apply-templates select="dsc"/>
        </expertises>
    </xsl:template>
    
    <xsl:template match="c[parent::dsc]">
        <xsl:apply-templates select="c"/>
    </xsl:template>
    
    <xsl:template match="c[parent::c]">
        <expertise
            xmlns="xpr">
            <meta/>
            <sourceDesc>
                <idno
                    type="unitid"><xsl:apply-templates select="did/unitid[@type = 'cote-de-consultation']"/></idno>
                <idno
                    type="item"><xsl:apply-templates select="did/unitid[@type = 'pieces']"/></idno>
                <facsimile
                    from=""
                    to=""/>
                <physDesc>
                    <extent
                        sketch=""><xsl:apply-templates select="did/physdesc/extent"/></extent>
                </physDesc>
            </sourceDesc>
            <description>
                <sessions>
                    <xsl:apply-templates select="did/unittitle/unitdate/@normal"/>
                </sessions>
                <places>
                    <place
                        type="">
                        <address>
                            <street><xsl:apply-templates select="scopecontent/p[1]"/></street>
                            <buildingNumber/>
                        </address>
                        <complement/>
                        <parish/>
                        <city/>
                        <district/>
                        <owner/>
                    </place>
                </places>
                <categories>
                    <designation
                        rubric=""><xsl:apply-templates select="scopecontent/list[1]/item[matches(., 'Type d’acte', 'i')]"/></designation>
                </categories>
                <procedure>
                    <framework
                        type=""/>
                    <origination
                        type=""/>
                    <sentences>
                        <sentence>
                            <orgName/>
                            <date
                                when=""/>
                        </sentence>
                    </sentences>
                    <case><xsl:apply-templates select="scopecontent/list[1]/item[matches(., 'Cause(.*)?:')]"/></case>
                    <objects/>
                </procedure>
                <participants>
                    <experts>
                        <xsl:apply-templates select="scopecontent/list/item[matches(., 'Expert\(s\)')]"/>
                    </experts>
                    <clerks>
                        <clerk>
                            <persName>
                                <surname/>
                                <forename/>
                            </persName>
                        </clerk>
                    </clerks>
                    <parties>
                        <party
                            role=""
                            presence=""
                            intervention="">
                            <person>
                                <persName>
                                    <surname/>
                                    <forename/>
                                </persName>
                                <occupation/>
                            </person>
                            <status/>
                            <expert
                                ref=""/>
                        </party>
                    </parties>
                    <craftmen>
                        <craftman>
                            <persName>
                                <surname/>
                                <forename/>
                            </persName>
                            <occupation/>
                        </craftman>
                    </craftmen>
                </participants>
                <conclusions>
                    <agreement
                        type=""/>
                    <estimate
                        l=""
                        s=""
                        d=""/>
                    <fees
                        detail="">
                        <total
                            l=""
                            s=""
                            d=""/>
                    </fees>
                    <expenses
                        mentioned=""/>
                </conclusions>
                <keywords
                    type="technical">
                    <term/>
                </keywords>
                <keywords
                    type="tools">
                    <term/>
                </keywords>
                <keywords
                    type="estimation">
                    <term/>
                </keywords>
                <keywords
                    type="law">
                    <term/>
                </keywords>
                <analysis/>
                <noteworthy/>
            </description>
        </expertise>
    </xsl:template>
    
    <xsl:template match="unitid[@type = 'cote-de-consultation']">
        <xsl:value-of select="normalize-space(upper-case(replace(., '/', '')))"/>
    </xsl:template>
    
    <xsl:template match="unitid[@type = 'pieces']">
        <xsl:choose>
            <xsl:when test="contains(., 'bis')">
                <xsl:value-of select="normalize-space(concat(format-number(number(substring-after(substring-before(., ' bis'), 'dossier ')), '000'), 'bis'))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="normalize-space(format-number(number(substring-after(., 'dossier ')), '000'))"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="extent">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>
    
    <xsl:template match="unitdate/@normal">
        <!-- @rmq dates après les virgules certainement à ne pas prendre en compte, vérifier avec 1776-->
        <xsl:variable name="date" select="tokenize(., '[/,]')"/>
        <xsl:for-each select="$date">
            <date xmlns="xpr"
                when="{normalize-space(.)}"
                type=""/>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="scopecontent/list/item[matches(., 'Type d’acte', 'i')]">
        <xsl:variable name="string" select="normalize-space(substring-after(., 'Type d’acte :'))"/>
        <xsl:value-of select="concat(upper-case(substring($string, 1, 1)), substring($string, 2))"/>
    </xsl:template>
    <xsl:template match="scopecontent/list/item[matches(., 'Institution(s)? de nomination\S:')]">
        <!-- @quest à placer dans procedure/sentence ?-->
    </xsl:template>
    <xsl:template match="scopecontent/list/item[matches(., 'Institution(s)? requérante(s)?\S:')]">
        <!-- @todo voir avec EC si vraiment exploitable
            @rmq après discussion avec Robert, c'est peut être une source d'erreur…-->
    </xsl:template>
    
    <xsl:template match="scopecontent/list/item[matches(., 'Nature de l’expertise\S:') or matches(., 'Expertise\S:')]">
        <!-- @rmq (contentieuse/gracieuse) Ne rien en faire, ne correspond plus à la grille d'aujourd'hui + source d'erreur-->
    </xsl:template>
    
    <xsl:template match="scopecontent/list/item[matches(., 'Cause(.*)?:')]">
        <xsl:variable name="string" select="normalize-space(substring-after(., ':'))"/>
        <xsl:value-of select="concat(upper-case(substring($string, 1, 1)), substring($string, 2))"/>
    </xsl:template>
    
    <xsl:template match="scopecontent/list/item[matches(., 'Expert\(s\)')]">
        <xsl:variable name="string" select="."/>
        <xsl:choose>
            <xsl:when test="matches(., '[0-9]/')">
                <xsl:variable name="expert" select="tokenize(substring-after(., '1/'), '[0-9]/')"/>
                <xsl:for-each select="$expert">
                    <xsl:variable name="tokenize" select="tokenize(., ',')"/>
                    <xsl:variable name="name" select="string-join($tokenize[1])"/>
                    <xsl:variable name="title"/>
                    <xsl:variable name="id"/>
                    <expert xmlns="xpr"
                        ref="{normalize-space($tokenize[1])}"
                        context=""
                        appointment="">
                        <title/>
                    </expert>    
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>