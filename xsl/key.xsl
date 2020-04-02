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
    
    <xsl:template match="entry/text()[1]">
        <!--^.[^:]+:(^.[^\:\s]+)(\s)(\:)        -->
        <xsl:analyze-string select="." regex="(^.[^:\[\.]+)([\s| ])(:)([\s| ]?)">
            <xsl:matching-substring>
                <key xmlns="xpr"><xsl:value-of select="regex-group(1)"/></key>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:apply-templates select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
</xsl:stylesheet>