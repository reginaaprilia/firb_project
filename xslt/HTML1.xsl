<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0">
<xsl:output method="html" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" indent="yes"/>

<xsl:param name="source_uri"/>

<xsl:template match="/">
<div class="THCContent" about="{$source_uri}"><xsl:apply-templates select="*"/></div>
</xsl:template>

<xsl:template match="tei:p">
<p>
  <xsl:choose>
    <xsl:when test="count(tei:lb)!=0">
      <!-- Add text nodes preceding a 'lb' node -->
      <xsl:apply-templates select="tei:lb" />
      <!-- Add text node following the last 'lb' node -->
<!-- used when lb follows text 
      <xsl:variable name="pos"><xsl:number level="any" count="tei:lb"/></xsl:variable>
  <span class="line"><span class="number"><xsl:value-of select="$pos"/></span><xsl:value-of select="lb[last()]/preceding::text()" /></span> <xsl:text>
    </xsl:text>
-->
    </xsl:when>
    <xsl:otherwise>

      <!-- the <p> tag does not contain any <lb> tags -->
      <xsl:apply-templates/> 
    </xsl:otherwise>
  </xsl:choose>
</p>
</xsl:template>

<xsl:template match="tei:lb">
  <!-- Scoop up any text following the <lb /> from the previous node which could be a 'p' node or a 'lb' node -->
 <xsl:variable name="pos"><xsl:number level="any" count="tei:lb"/></xsl:variable>
  <span class="line"><span class="number"><xsl:value-of select="$pos"/></span><xsl:apply-templates select="following::text()[1]"/></span>
</xsl:template>

 
<xsl:template match="tei:graphic">
 <xsl:variable name="pos"><xsl:number level="any" count="tei:graphic"/></xsl:variable>
  <img class="source_img" about="{$source_uri}_img_{$pos}"/><xsl:apply-templates/>
</xsl:template>


</xsl:stylesheet>


