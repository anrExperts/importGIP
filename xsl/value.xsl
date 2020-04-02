<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xpath-default-namespace="xpr"
    xmlns="xpr"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:strip-space elements="*"/>
    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
    
    <xsl:template match="node() | @*">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="entry[key]">
        <entry xmlns="xpr">
            <xsl:copy-of select="key"/>
            <value>
                <xsl:for-each select="(* | text())[position() &gt; 1]">
                    <xsl:apply-templates select="."/>
                </xsl:for-each>
            </value>
        </entry>
    </xsl:template>
    
    <!-- for 1776 -->
    
    <xsl:template match="idno[@type= 'unitid'][parent::sourceDesc/idno[@type = 'item'][. = '']]">
        <xsl:variable name="cote" select="."/>
        <xsl:variable name="carton">
            <xsl:analyze-string select="$cote" regex="(Z/1j/[\d]{{3,4}})(\W+)(.+)">
                <xsl:matching-substring><xsl:value-of select="regex-group(1)"/></xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:value-of select="$carton"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="idno[@type = 'item'][. = '']">
        <xsl:variable name="cote" select="parent::sourceDesc/idno[@type = 'unitid']"/>
        <xsl:variable name="dossier">
            <xsl:analyze-string select="$cote" regex="(Z/1j/[\d]{{3,4}})(\W+)(.+)">
                <xsl:matching-substring><xsl:value-of select="regex-group(3)"/></xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:value-of select="$dossier"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="entry[. = 'Commentaire libre ou copie d’extraits']">
        <xsl:copy>
            <key><xsl:apply-templates/></key>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>