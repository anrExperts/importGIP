<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    exclude-result-prefixes="xs xpr" 
    xpath-default-namespace=""
    xmlns="xpr"
    xmlns:xpr="xpr"
    xmlns:rico="rico"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    version="2.0">
    
    <xsl:strip-space elements="*"/>
    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
    
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    
    <!--<xsl:template match="xpr:entry[xpr:key='Commentaire ou copie d’extrait'][following-sibling::*[1][self::xpr:entry[xpr:key='Motivations']]]">
        <xsl:copy>
            <xsl:apply-templates/>
            <toto/>
            <xsl:apply-templates select="following-sibling::*[1][self::xpr:entry[xpr:key='Motivations']]" mode="copy"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="xpr:entry[xpr:key='Motivations'][preceding-sibling::*[1][self::xpr:entry[xpr:key='Commentaire ou copie d’extrait']]]"/>
    <xsl:template match="xpr:entry[xpr:key='Motivations'][preceding-sibling::*[1][self::xpr:entry[xpr:key='Commentaire ou copie d’extrait']]]" mode="copy">
        <xsl:for-each select="*">
            <value><xsl:value-of select="."/></value>
        </xsl:for-each>
    </xsl:template>-->
    
    <!--<xsl:template match="xpr:entry[xpr:key='Commentaire ou copie d’extrait'][following-sibling::*[1][self::xpr:entry[xpr:key='Conclusions']]]">
        <xsl:copy>
            <xsl:apply-templates/>
            <toto2/>
            <xsl:apply-templates select="following-sibling::*[1][self::xpr:entry[xpr:key='Conclusions']]" mode="copy"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="xpr:entry[xpr:key='Conclusions'][preceding-sibling::*[1][self::xpr:entry[xpr:key='Commentaire ou copie d’extrait']]]"/>
    <xsl:template match="xpr:entry[xpr:key='Conclusions'][preceding-sibling::*[1][self::xpr:entry[xpr:key='Commentaire ou copie d’extrait']]]" mode="copy">
        <xsl:for-each select="*">
            <value><xsl:value-of select="."/></value>
        </xsl:for-each>
    </xsl:template>-->
    
    <xsl:template match="xpr:toto | xpr:toto2 | xpr:value[normalize-space(.) = '']"/>
    
    <xsl:template match="xpr:entry/xpr:entry">
        <value xmlns="xpr"><xsl:value-of select="normalize-space(.)"/></value>
    </xsl:template>
    
</xsl:stylesheet>