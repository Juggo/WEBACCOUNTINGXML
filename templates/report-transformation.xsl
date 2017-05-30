<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="3.0">

<xsl:template match="/">
    <html lang="cs">
        <head>
            <meta name="description" content="Webová aplikace pro evidenci příjmů a výdajů"/>
    	    <meta name="keywords" content="evidence, příjmy, výdaje, bilance, platby"/>
    	    <meta name="author" content="Juggo"/>
            <meta name="viewport" content="width=device-width, initial-scale=1"/>
            <title>WEBACCOUNTINGXML</title>
            
            <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous"/>
        </head>
        <body>
            <div class="container">
                <h1>WEBACCOUNTINGXML</h1>
                <h2>Webová aplikace pro evidenci příjmů a výdajů</h2>
                <br/>
                <h3><xsl:value-of select="article/info/title"/> - <xsl:value-of select="article//firstname"/>&#160;<xsl:value-of select="article//surname"/></h3>
                <p>Datum publikace závěrečné zprávy: <xsl:value-of select="article//pubdate"/></p>
                <br/>
                
                <xsl:for-each select="article/section">
                    <h4><xsl:value-of select="title"/></h4>
                    <xsl:for-each select="para">
                        <p><xsl:value-of select="."/></p>
                    </xsl:for-each>
                    <xsl:if test="itemizedlist">
                        <ul>
                            <xsl:for-each select="itemizedlist/listitem">
                                <li><xsl:value-of select="para"/></li>
                            </xsl:for-each>
                        </ul>
                    </xsl:if>
                </xsl:for-each>
                
                <br/>
                <a href="http://localhost:8080/exist/apps/webaccountingxml/index.html" class="btn btn-primary">Zpět</a>
                <br/><br/>
            </div>
        </body>
    </html>
</xsl:template>

</xsl:stylesheet>