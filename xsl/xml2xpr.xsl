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
    
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="xpr:xpr">
        <xsl:copy>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="xpr:expertises">
        <xsl:copy>
                <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="xpr:expertise">
        <expertise
            xmlns="xpr">
            <xsl:variable name="unitid" select="replace(xpr:sourceDesc/xpr:idno[@type='unitid'], '/', '')"/>
            <xsl:variable name="item" select="format-number(number(substring-after(xpr:sourceDesc/xpr:idno[@type='item'], ' ')), '000')"/>
            <xsl:attribute name="xml:id" select="lower-case(concat($unitid, 'd', $item))"/>
            <data>
                <xsl:copy-of select="xpr:description/node()"/>
            </data>
            <meta/>
            <sourceDesc>
                <idno type="unitid"><xsl:value-of select="upper-case(normalize-space($unitid))"/></idno>
                <idno type="item"><xsl:value-of select="normalize-space($item)"/></idno>
                <facsimile
                    from=""
                    to=""/>
                <physDesc>
                    <!-- toutes les expertises ont un extent -->
                    <xsl:copy-of select="xpr:sourceDesc/xpr:physDesc/xpr:extent"/>
                    <xsl:choose>
                        <xsl:when test="xpr:description/xpr:entry[xpr:key='Pièces ajoutées'][xpr:value[. != '' and not(matches(., 'aucune', 'i')) and not(matches(., 'Sans objet', 'i'))]]">
                            <appendices>
                                <xsl:apply-templates select="xpr:description/xpr:entry[xpr:key='Pièces ajoutées']/xpr:value"/>
                            </appendices>
                        </xsl:when>
                        <xsl:otherwise/>
                    </xsl:choose>
                </physDesc>
            </sourceDesc>
            <description>
                <sessions>
                    <date
                        when=""
                        type=""/>
                </sessions>
                <places>
                    <!-- @todo -->
                    <place
                        type="paris">
                        <address>
                            <xsl:variable name="street">
                                <xsl:choose>
                                    <xsl:when test="substring-after(xpr:description/xpr:entry[not(xpr:key)][1], 'Paris,')">
                                        <xsl:value-of select="substring-after(xpr:description/xpr:entry[not(xpr:key)][1], 'Paris,')"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="xpr:description/xpr:entry[not(xpr:key)][1]"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            <street><xsl:value-of select="normalize-space($street)"/></street>
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
                        rubric=""><xsl:apply-templates select="xpr:description/xpr:entry[xpr:key='Type d’acte']/xpr:value"/></designation>
                </categories>
                <procedure>
                    <xsl:choose>
                        <xsl:when test="xpr:description/xpr:entry[xpr:key='Institution requérante' or xpr:key='Institution de nomination']/xpr:value[. = 'aucune']">
                            <framework
                                type="a">Commun accord des parties</framework>
                            <origination
                                type="parties">Les parties</origination>
                        </xsl:when>
                        <xsl:otherwise>
                            <framework
                                type=""/>
                            <origination
                                type=""/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <sentences>
                        <xsl:choose>
                            <xsl:when test="xpr:description/xpr:entry[xpr:key='Institution requérante']/xpr:value">
                                <!-- cas vides/accord des parties, prévus dans le template -->
                                <xsl:apply-templates select="xpr:description/xpr:entry[xpr:key='Institution requérante']/xpr:value"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <sentence>
                                    <orgName/>
                                    <date
                                        when=""/>
                                </sentence>
                            </xsl:otherwise>
                        </xsl:choose>
                    </sentences>
                    <case><xsl:apply-templates select="xpr:description/xpr:entry[xpr:key='Cause (ou motif) de l’expertise']/xpr:value"/></case>
                    <objects/>
                </procedure>
                <participants>
                    <experts>
                        <xsl:choose>
                            <xsl:when test="xpr:description/xpr:entry[xpr:key='Expert(s)']/xpr:value">
                                <xsl:apply-templates select="xpr:description/xpr:entry[xpr:key='Expert(s)']/xpr:value"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <expert
                                    ref=""
                                    context=""
                                    appointment="">
                                    <title/>
                                </expert>
                            </xsl:otherwise>
                        </xsl:choose>
                    </experts>
                    <clerks>
                        <xsl:choose>
                            <xsl:when test="xpr:description/xpr:entry[xpr:key='Greffier de l’écritoire']/xpr:value[. != '']">
                                <xsl:apply-templates select="xpr:description/xpr:entry[xpr:key='Greffier de l’écritoire']/xpr:value"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <clerk>
                                    <persName>
                                        <surname/>
                                        <forename/>
                                    </persName>
                                </clerk>
                            </xsl:otherwise>
                        </xsl:choose>
                    </clerks>
                    <parties>
                        <xsl:choose>
                            <xsl:when test="xpr:description/xpr:entry[xpr:key='Partie requérante']
                                | xpr:description/xpr:entry[xpr:key='Partie opposante']">
                                <xsl:apply-templates 
                                    select="xpr:description/xpr:entry[xpr:key='Partie requérante']
                                    | xpr:description/xpr:entry[xpr:key='Partie opposante']"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <party intervention="" presence="" role="">
                                    <person>
                                        <persName>
                                            <surname/>
                                            <forename/>
                                        </persName>
                                        <occupation/>
                                    </person>
                                    <status/>
                                    <expert ref=""/>
                                </party>
                            </xsl:otherwise>
                        </xsl:choose>
                    </parties>
                    <craftmen>
                        <xsl:choose>
                            <xsl:when test="xpr:description/xpr:entry[xpr:key='Entrepreneur, maître d’œuvre ou architecte']/xpr:value">
                                <xsl:apply-templates select="xpr:description/xpr:entry[xpr:key='Entrepreneur, maître d’œuvre ou architecte']/xpr:value"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <craftman xmlns="xpr">
                                    <persName>
                                        <surname/>
                                        <forename/>
                                    </persName>
                                    <occupation/>
                                </craftman>
                            </xsl:otherwise>
                        </xsl:choose>
                    </craftmen>
                </participants>
                <conclusions>
                    <arrangement/>
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
                <xsl:choose>
                    <xsl:when test="xpr:description/xpr:entry[xpr:key='Commentaire libre ou copie d’extraits']">
                        <xsl:apply-templates select="xpr:description/xpr:entry[xpr:key='Commentaire libre ou copie d’extraits']"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <analysis/>
                    </xsl:otherwise>
                </xsl:choose>
                <noteworthy/>
            </description>
        </expertise>
    </xsl:template>
    
    <xsl:template 
        match="xpr:entry[xpr:key='Partie requérante']
        | xpr:entry[xpr:key='Partie opposante']">
        <xsl:choose>
            <xsl:when test="normalize-space(string-join(node())) = '' or matches(normalize-space(string-join(node())), 'aucun', 'i')"></xsl:when>
            <!--<xsl:when test="lower-case(normalize-space(xpr:value)) = 'sans objet'"/>-->
            <xsl:otherwise>
                <xsl:variable name="role">
                    <xsl:choose>
                        <xsl:when test="xpr:key='Partie requérante'"><xsl:value-of select="'petitioner'"/></xsl:when>
                        <xsl:when test="xpr:key='Partie opposante'"><xsl:value-of select="'opponent'"/></xsl:when>
                        <xsl:otherwise><xsl:value-of select="''"/></xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <party
                    xmlns="xpr"
                    role="{$role}"
                    presence=""
                    intervention="">
                    <xsl:for-each select="xpr:value">
                        <xsl:variable name="name" select="tokenize(xpr:name[1], ',')"/>
                        <xsl:variable name="occupation">
                            <xsl:variable name="data" select="normalize-space(string-join(node()[preceding-sibling::xpr:name[1]], ' '))"/>
                            <xsl:choose>
                                <xsl:when test="starts-with($data, ',')">
                                    <xsl:value-of select="normalize-space(substring-after($data, ','))"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="normalize-space($data)"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <person>
                            <xsl:choose>
                                <xsl:when test="$name[2]">
                                    <persName>
                                        <surname><xsl:value-of select="normalize-space($name[1])"/></surname>
                                        <forename><xsl:value-of select="normalize-space($name[2])"/></forename>
                                    </persName>
                                </xsl:when>
                                <xsl:otherwise>
                                    <persName>
                                        <surname><xsl:value-of select="normalize-space($name)"/></surname>
                                        <forename/>
                                    </persName>
                                </xsl:otherwise>
                            </xsl:choose>
                            <occupation><xsl:value-of select="$occupation"/></occupation>
                        </person>
                    </xsl:for-each>
                    <status/>
                    <!-- il ne peut y avoir qu'un seul expert par partie -->
                    <xsl:choose>
                        <xsl:when test="count(xpr:expert/xpr:value) = 1">
                            <expert
                                ref="{xpr:expert/xpr:value/xpr:name/@ref}"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <expert
                                ref=""/>
                        </xsl:otherwise>
                    </xsl:choose>
                    <xsl:apply-templates select="xpr:representant/xpr:value"/>
                    <xsl:apply-templates select="xpr:procureur/xpr:value"/>
                </party>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="xpr:representant/xpr:value">
        <xsl:choose>
            <xsl:when test="normalize-space(.) = '' or matches(., 'aucun', 'i')"/>
            <xsl:when test="xpr:name">
                <xsl:variable name="name" select="tokenize(xpr:name[1], ',')"/>
                <xsl:variable name="occupation">
                    <xsl:variable name="data" select="normalize-space(string-join(node()[preceding-sibling::xpr:name], ' '))"/>
                    <xsl:choose>
                        <xsl:when test="starts-with($data, ',')">
                            <xsl:value-of select="normalize-space(substring-after($data, ','))"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="normalize-space($data)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <representative>
                    <persName>
                        <surname><xsl:value-of select="normalize-space($name[1])"/></surname>
                        <forename><xsl:value-of select="normalize-space($name[2])"/></forename>
                    </persName>
                    <occupation><xsl:value-of select="$occupation"/></occupation>
                </representative>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="xpr:procureur/xpr:value">
        <xsl:choose>
            <xsl:when test="normalize-space(.) = '' or matches(., 'aucun', 'i')"/>
            <xsl:when test="xpr:name">
                <xsl:variable name="name" select="tokenize(xpr:name[1], ',')"/>
                <prosecutor>
                    <persName>
                        <surname><xsl:value-of select="normalize-space($name[1])"/></surname>
                        <forename><xsl:value-of select="normalize-space($name[2])"/></forename>
                    </persName>
                </prosecutor>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="xpr:entry[xpr:key='Greffier de l’écritoire']/xpr:value">
        <xsl:variable name="name" select="tokenize(., ',')"/>
        <xsl:for-each select="xpr:name">
            <clerk xmlns="xpr">
                <persName>
                    <surname><xsl:value-of select="normalize-space($name[1])"/></surname>
                    <forename><xsl:value-of select="normalize-space($name[2])"/></forename>
                </persName>
            </clerk>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="xpr:entry[xpr:key='Entrepreneur, maître d’œuvre ou architecte']/xpr:value">
        <xsl:choose>
            <xsl:when test="xpr:name">
                <xsl:variable name="name" select="tokenize(xpr:name, ',')"/>
                <xsl:variable name="occupation">
                    <xsl:variable name="data" select="normalize-space(string-join(node()[preceding-sibling::xpr:name], ' '))"/>
                    <xsl:choose>
                        <xsl:when test="starts-with($data, ',')">
                            <xsl:value-of select="normalize-space(substring-after($data, ','))"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="normalize-space($data)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <craftman xmlns="xpr">
                    <persName>
                        <surname><xsl:value-of select="normalize-space($name[1])"/></surname>
                        <forename><xsl:value-of select="normalize-space($name[2])"/></forename>
                    </persName>
                    <occupation><xsl:value-of select="normalize-space($occupation)"/></occupation>
                </craftman>
            </xsl:when>
            <xsl:otherwise>
                <craftman xmlns="xpr">
                    <persName>
                        <surname/>
                        <forename/>
                    </persName>
                    <occupation/>
                </craftman>
            </xsl:otherwise>
            <!--<xsl:when test="xpr:name[position() &gt; 1]">
                <xsl:variable name="regex" select="concat('(', string-join(xpr:name, '|'), ')', '\W?(.*?)(?:\p{Z}?;|$)')"/>
                <xsl:analyze-string select="." regex="{$regex}">
                    <xsl:matching-substring>
                        <xsl:variable name="name" select="tokenize(regex-group(1), ',')"/>
                        <craftman xmlns="xpr">
                            <persName>
                                <surname><xsl:value-of select="normalize-space($name[1])"/></surname>
                                <forename><xsl:value-of select="normalize-space($name[2])"/></forename>
                            </persName>
                            <occupation><xsl:value-of select="normalize-space(regex-group(2))"/></occupation>
                        </craftman>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <xsl:if test="normalize-space(.) != ''">
                            <craftman xmlns="xpr">
                                <persName>
                                    <surname/>
                                    <forename/>
                                </persName>
                                <occupation><xsl:value-of select="normalize-space(.)"/></occupation>
                            </craftman>
                        </xsl:if>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </xsl:when>-->
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="xpr:entry[xpr:key='Expert(s)']/xpr:value">
        <xsl:variable name="title">
            <xsl:variable name="data" select="normalize-space(string-join(node()[preceding-sibling::xpr:name], ' '))"/>
            <xsl:choose>
                <xsl:when test="starts-with($data, ',')">
                    <xsl:value-of select="normalize-space(substring-after($data, ','))"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="normalize-space($data)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="xpr:name/@ref[not(. = '')]">
                <expert
                    xmlns="xpr"
                    ref="{xpr:name/@ref}"
                    context=""
                    appointment="">
                    <title><xsl:value-of select="$title"/></title>
                </expert>
            </xsl:when>
            <xsl:otherwise>
                <expert
                    xmlns="xpr"
                    ref=""
                    context=""
                    appointment="">
                    <title/>
                </expert>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="xpr:entry[xpr:key='Cause (ou motif) de l’expertise']/xpr:value">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>
    
    <xsl:template match="xpr:entry[xpr:key='Type d’acte']/xpr:value">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>
    
    <xsl:template match="xpr:entry[xpr:key='Institution requérante']/xpr:value">
        <!-- @todo institution de nomination => l'utiliser pour origination ? => faire attention pour les accords entre les parties -->
        <xsl:choose>
            <xsl:when 
                test="lower-case(normalize-space(.)) = 'aucune' 
                or normalize-space(.)=''">
                <sentence xmlns="xpr">
                    <orgName/>
                    <date
                        when=""/>
                </sentence>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="content" select="."/>
                <xsl:variable name="dates">
                    <xsl:analyze-string select="$content" regex="(\d{{1,2}})\s(janvier|février|mars|avril|mai|juin|juillet|août|aout|septembre|octobre|novembre|décembre)\s(\d{{4}})">
                        <xsl:matching-substring>
                            <xsl:value-of select="."/>
                        </xsl:matching-substring>
                        <xsl:non-matching-substring/>
                    </xsl:analyze-string>
                </xsl:variable>
                <xsl:variable name="date">
                    <xsl:analyze-string select="$dates" regex="(\d{{1,2}})\s(janvier|février|mars|avril|mai|juin|juillet|août|aout|septembre|octobre|novembre|décembre)\s(\d{{4}})">
                        <xsl:matching-substring>
                            <xsl:variable name="day" select="format-number(number(regex-group(1)), '00')"/>
                            <xsl:variable name="month">
                                <xsl:choose>
                                    <xsl:when test="lower-case(regex-group(2)) = 'janvier'"><xsl:value-of select="'01'"/></xsl:when>
                                    <xsl:when test="lower-case(regex-group(2)) = 'février'"><xsl:value-of select="'02'"/></xsl:when>
                                    <xsl:when test="lower-case(regex-group(2)) = 'mars'"><xsl:value-of select="'03'"/></xsl:when>
                                    <xsl:when test="lower-case(regex-group(2)) = 'avril'"><xsl:value-of select="'04'"/></xsl:when>
                                    <xsl:when test="lower-case(regex-group(2)) = 'mai'"><xsl:value-of select="'05'"/></xsl:when>
                                    <xsl:when test="lower-case(regex-group(2)) = 'juin'"><xsl:value-of select="'06'"/></xsl:when>
                                    <xsl:when test="lower-case(regex-group(2)) = 'juillet'"><xsl:value-of select="'07'"/></xsl:when>
                                    <xsl:when test="lower-case(regex-group(2)) = 'août'"><xsl:value-of select="'08'"/></xsl:when>
                                    <xsl:when test="lower-case(regex-group(2)) = 'aout'"><xsl:value-of select="'08'"/></xsl:when>
                                    <xsl:when test="lower-case(regex-group(2)) = 'septembre'"><xsl:value-of select="'09'"/></xsl:when>
                                    <xsl:when test="lower-case(regex-group(2)) = 'octobre'"><xsl:value-of select="'10'"/></xsl:when>
                                    <xsl:when test="lower-case(regex-group(2)) = 'novembre'"><xsl:value-of select="'11'"/></xsl:when>
                                    <xsl:when test="lower-case(regex-group(2)) = 'décembre'"><xsl:value-of select="'12'"/></xsl:when>
                                </xsl:choose>
                            </xsl:variable>
                            <xsl:variable name="year" select="number(regex-group(3))"/>
                            <date when="{concat($year, '-', $month, '-', $day)}"/>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                </xsl:variable>
                    <sentence xmlns="xpr">
                        <orgName><xsl:value-of select="normalize-space(.)"/></orgName>
                        <xsl:sequence select="$date"/>
                    </sentence>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="xpr:entry[xpr:key='Commentaire libre ou copie d’extraits']">
        <analysis xmlns="xpr">
            <xsl:for-each select="xpr:value[normalize-space(.) != '']">
                <xsl:apply-templates select="."/><xsl:text>
                </xsl:text>
            </xsl:for-each>
        </analysis>
    </xsl:template>
    
    <xsl:template match="xpr:entry[xpr:key='Pièces ajoutées']/xpr:value">
        <xsl:variable name="content" select="normalize-space(.)"/>
        <xsl:variable name="regex" select="'(Z/?1j/\d+/dossier\s?\d+/pièce\s?\d+\W;\s?[^Z/?1j]*)'"/>
        <xsl:variable name="appendices" select="tokenize($content, '\d/\s?')"/>
        <xsl:for-each select="$appendices[. != '']">
            <appendice>
                <type type=""/>
                <extent/>
                <desc><xsl:value-of select="normalize-space(replace(., ';', ':'))"/></desc>
                <note/>
            </appendice>
        </xsl:for-each>
        <!--<xsl:analyze-string select="$content" regex="{$regex}">
            <xsl:matching-substring>
                <appendice>
                    <type type=""/>
                    <extent/>
                    <desc><xsl:value-of select="normalize-space(replace(regex-group(1), ';', ':'))"/></desc>
                    <note/>
                </appendice>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <appendice>
                    <type type=""/>
                    <extent/>
                    <desc><xsl:value-of select="normalize-space(.)"/></desc>
                    <note/>
                </appendice>
            </xsl:non-matching-substring>
        </xsl:analyze-string>-->
    </xsl:template>
    
</xsl:stylesheet>