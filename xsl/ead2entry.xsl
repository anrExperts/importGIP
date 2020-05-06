<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    exclude-result-prefixes="xs" 
    xpath-default-namespace="urn:isbn:1-931666-22-9"
    xmlns="urn:isbn:1-931666-22-9"
    xmlns:rico="rico"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    version="2.0">
    <!--for z1j-999-1010 
        for FRAN_IR_057886 comment template : scopecontent/p/*[1][self::emph[@render='bold']] | scopecontent/list/item/*[1][self::emph[@render='bold']]-->
    
    <xsl:strip-space elements="*"/>
    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="ead">
        <xpr xmlns="xpr">
            <xsl:apply-templates/>
        </xpr>
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
        <expertise xmlns="xpr">
            <xsl:apply-templates/>
        </expertise>
    </xsl:template>
    
    <xsl:template match="did">
        <meta xmlns="xpr"/>
        <sourceDesc xmlns="xpr">
            <idno type="unitid"><xsl:value-of select="normalize-space(unitid[@type = 'cote-de-consultation'])"/></idno>
            <idno type="item"><xsl:value-of select="normalize-space(unitid[@type = 'pieces'])"/></idno>
            <facsimile from="" to=""/>
            <physDesc>
                <extent sketch=""><xsl:apply-templates select="physdesc/extent"/></extent>
            </physDesc>
        </sourceDesc>
        <!-- @rmq les unitdate sont gérées avec scopecontent -->
    </xsl:template>
    
    <xsl:template match="scopecontent">
        <description xmlns="xpr">
            <sessions>
                <xsl:apply-templates select="parent::c/did//unitdate"/>
                <!-- @rmq certaines unitdate ne sont pas dans unittitle -->
            </sessions>
            <xsl:apply-templates/>
        </description>
    </xsl:template>
    
    <xsl:template match="unitdate">
        <xsl:variable name="normal" select="@normal"/>
        <date xmlns="xpr">
            <xsl:if test="@normal">
                <xsl:choose>
                    <xsl:when test="matches($normal, '/')">
                        <xsl:variable name="from" select="normalize-space(substring-before($normal, '/'))"/>
                        <xsl:variable name="to" select="normalize-space(substring-after($normal, '/'))"/>
                        <xsl:attribute name="from" select="$from"/>
                        <xsl:attribute name="to" select="$to"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="when" select="normalize-space($normal)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
            <xsl:apply-templates/>
        </date>
    </xsl:template>
    
    <xsl:template match="p | item">
        <entry xmlns="xpr">
            <xsl:apply-templates/>
        </entry>
    </xsl:template>
    
    <xsl:template match="list">
        <xsl:apply-templates select="item"/>
    </xsl:template>
    
    <!-- @rmq : comment for FRAN_IR_057886-->
    <xsl:template 
        match="scopecontent/p/*[1][self::emph[@render='bold']]
        | scopecontent/list/item/*[1][self::emph[@render='bold']]">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="emph[@render='underline']">
        <name xmlns="xpr"><xsl:apply-templates/></name>
    </xsl:template>
    
    <xsl:template match="daogrp"/>
    
    
</xsl:stylesheet>