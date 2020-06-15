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
    
    <!--<xsl:template match="xpr:toto | xpr:toto2 | xpr:value[normalize-space(.) = '']"/>-->
    
    <xsl:template match="xpr:entry/xpr:entry">
        <value xmlns="xpr"><xsl:value-of select="normalize-space(.)"/></value>
    </xsl:template>
    
    <xsl:template match="xpr:description/xpr:entry[xpr:key = 'Expert']">
        <expert xmlns="xpr">
            <xsl:apply-templates/>
        </expert>
    </xsl:template>
    
    <xsl:template match="xpr:description/xpr:entry[xpr:key = 'Procureur']">
        <procureur xmlns="xpr">
            <xsl:apply-templates/>
        </procureur>
    </xsl:template>
    
    <xsl:template match="xpr:description/xpr:entry[xpr:key = 'Représentant'] 
        | xpr:description/xpr:entry[xpr:key = 'Représentant tuteur']
        | xpr:description/xpr:entry[xpr:key = 'Subrogé tuteur']
        | xpr:description/xpr:entry[xpr:key = 'Tuteur']">
        <representant xmlns="xpr">
            <xsl:apply-templates/>
        </representant>
    </xsl:template>
    
    <xsl:template match="xpr:description/xpr:entry[matches(xpr:key,'partie', 'i')]">
        <entry xmlns="xpr">
            <xsl:apply-templates/>
            <xsl:apply-templates select="xpr:value"/>
        </entry>
    </xsl:template>
    
    <!--<xsl:template match="xpr:description/xpr:entry[matches(xpr:key,'partie', 'i')]/xpr:value" mode="tokenize">
        <xsl:variable name="regex" select="'(?:\s?\d/\s?)'"/>
        <xsl:analyze-string select="." regex="{$regex}">
            <xsl:matching-substring/>
            <xsl:non-matching-substring>
                <toto><xsl:apply-templates select="."/></toto>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>-->
    
</xsl:stylesheet>