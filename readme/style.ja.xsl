<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output
	doctype-public = "-//W3C//DTD XHTML 1.1//EN"
	doctype-system = "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"/>
<xsl:template match="manual">
<html xml:lang="ja">
<head>
<title>ReadMe for <xsl:value-of select="head/name"/></title>
<meta http-equiv="content-style-type" content="text/css" />
<link rel="stylesheet" href="readme/style.css" type="text/css" />
</head>
<body>
<div id="container">

<xsl:apply-templates/>

</div>
</body>
</html>

</xsl:template>

<xsl:template match="head">

<div id="head">
<h1><xsl:value-of select="name"/></h1>
<p id="summary">コレは何? : <xsl:value-of select="summary"/></p>

<table>
<xsl:attribute name="summary"><xsl:value-of select="name"/>に関するライセンスや更新日などの情報です</xsl:attribute>
<tr class="even">
<th>初回リリース日</th>
<td><xsl:value-of select="../read/section/dl[@type='repository']/dt[position() = last()]"/></td>
</tr>
<xsl:if test="../read/section/dl[@type='repository']/dt[position() = last()] != ../read/section/dl[@type='repository']/dt[position() = '1']">
<tr class="odd">
<th>最終更新日</th>
<td><xsl:value-of select="../read/section/dl[@type='repository']/dt[position() = '1']"/>
<xsl:if test="../read/section/dl[@type='repository']/dt[position() = '1']/@revision"> (v<xsl:value-of select="../read/section/dl[@type='repository']/dt[position() = '1']/@revision"/>)
</xsl:if>
</td></tr>
</xsl:if>
<xsl:for-each select="items/item">
<tr>
<xsl:choose>
<xsl:when test="../read/section/dl[@type='repository']/dt[position() = last()] != ../read/section/dl[@type='repository']/dt[position() = '1']">
	<xsl:choose>
		<xsl:when test="position() mod 2 = 0"><xsl:attribute name="class">even</xsl:attribute></xsl:when>
		<xsl:otherwise><xsl:attribute name="class">odd</xsl:attribute></xsl:otherwise>
	</xsl:choose>
</xsl:when>
<xsl:otherwise>
	<xsl:choose>
		<xsl:when test="position() mod 2 = 0"><xsl:attribute name="class">odd</xsl:attribute></xsl:when>
		<xsl:otherwise><xsl:attribute name="class">even</xsl:attribute></xsl:otherwise>
	</xsl:choose>
</xsl:otherwise>
</xsl:choose>

<xsl:choose>
	<xsl:when test="@type='ライセンス'">
		<th>ライセンス</th>
		<xsl:if test="text()='All Rights Reserved'">
			<td>全てのリソースの著作権を保有します</td>
		</xsl:if>
		<td><a>
		<xsl:attribute name="href">http://ja.wikipedia.org/w/index.php?search=<xsl:value-of select="text()"/>	</xsl:attribute>
		<xsl:value-of select="text()"/>
		</a>
		<xsl:if test="@price!=0">
			価格: <xsl:value-of select="@price"/>
		</xsl:if>
		<xsl:if test="@exclude">
			（<xsl:value-of select="@exclude"/>を除く）
		</xsl:if>
		</td>
	</xsl:when>
	<xsl:when test="@type='ウェブサイト' or @type='謝辞'">
	
	<th><xsl:value-of select="@type"/></th>
	<xsl:choose>
	<xsl:when test="count(link) = 1">
		<td><a><xsl:attribute name="href"><xsl:value-of select="link/@url"/></xsl:attribute>
		<xsl:value-of select="link/text()"/></a></td>
	</xsl:when>
	<xsl:otherwise>
		<td><ul><xsl:for-each select="link">
		<li><a><xsl:attribute name="href"><xsl:value-of select="@url"/></xsl:attribute>
		<xsl:value-of select="text()"/></a></li>
		</xsl:for-each></ul></td>
	</xsl:otherwise>
	</xsl:choose>
	
	</xsl:when>
	<xsl:otherwise>
		<th><xsl:value-of select="@type"/></th>
		<td><xsl:value-of select="text()"/><xsl:if test="@address"> &lt;<xsl:value-of select="@address"/>&gt;</xsl:if></td>
		</xsl:otherwise>
</xsl:choose>
</tr>
</xsl:for-each>
</table>
</div>
</xsl:template>


<xsl:template match="section">
<div class="section">
<xsl:apply-templates/>
</div>
</xsl:template>

<xsl:template match="tree">
	<xsl:if test="li">
		<!-- 1st level -->
		<ol class="tree"><li class="root">
		<xsl:value-of select="@name"/>
		<ol class="root">
		<xsl:for-each select="li">
		<xsl:sort select="text()" data-type="text" />
			<!-- 3rd level -->
			<xsl:for-each select="tree">
				<li class="folder"><xsl:value-of select="@name"/><ol>
				<xsl:for-each select="li">
				<xsl:sort select="text()" data-type="text" />
					<!-- 4th level -->
					<xsl:for-each select="tree">
					<xsl:sort select="text()" data-type="text" />
						<li class="folder"><xsl:value-of select="@name"/><ol>
						<xsl:for-each select="li">
							<xsl:choose>
							<xsl:when test="not(text())"></xsl:when>
							<xsl:when test="position() = last()">
								<li class="last-item"><xsl:value-of select="text()"/></li>
							</xsl:when>
							<xsl:otherwise>
								<li><xsl:value-of select="text()"/></li>
							</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
						</ol></li>
					</xsl:for-each>
					<xsl:choose>
					<xsl:when test="not(text())"></xsl:when>
					<xsl:when test="position() = last()">
						<li class="last-item"><xsl:value-of select="text()"/></li>
					</xsl:when>
					<xsl:otherwise>
						<li><xsl:value-of select="text()"/></li>
					</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>
				</ol></li>
			</xsl:for-each>
			<!-- 2nd level -->
			<xsl:choose>
			<xsl:when test="not(text())"></xsl:when>
			<xsl:when test="position() = last()">
				<li class="last-item"><xsl:value-of select="text()"/></li>
			</xsl:when>
			<xsl:otherwise>
				<li><xsl:value-of select="text()"/></li>
			</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		</ol>
		</li></ol>
	</xsl:if>
</xsl:template>

<!-- タイトル -->
<xsl:template match="h">
<h2><xsl:value-of select="text()"/></h2>
</xsl:template>

<!-- リスト -->
<xsl:template match="ol"><ol><xsl:apply-templates/></ol></xsl:template>
<xsl:template match="ul"><ul><xsl:apply-templates/></ul></xsl:template>
<xsl:template match="li"><li><xsl:value-of select="text()"/></li></xsl:template>

<xsl:template match="a">
 <xsl:element name="a">
   <xsl:attribute name="href">
     <xsl:value-of select="@href"/>
   </xsl:attribute>
   <xsl:apply-templates/>
 </xsl:element>
</xsl:template>

<!-- 段落 -->
<xsl:template match="p">
<p><xsl:value-of select="text()"/></p>
</xsl:template>

<!-- 定義リスト -->
<xsl:template match="dl">
<dl>
<xsl:apply-templates/>
</dl>
</xsl:template>

<xsl:template match="dt">
<dt><xsl:value-of select="text()"/><xsl:if test="@revision"> (v<xsl:value-of select="@revision"/>)</xsl:if></dt>
</xsl:template>

<xsl:template match="dd">
<dd><xsl:value-of select="text()"/></dd>
</xsl:template>

</xsl:stylesheet>