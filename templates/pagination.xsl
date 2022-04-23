<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<!-- навигация по страницам -->
<xsl:template name="pagination">
	<xsl:param name="numpages"/>	<!-- общее количество страниц -->
	<xsl:param name="page"/>		<!-- текущая страница -->
	<xsl:param name="url"/>			<!-- url родительского раздела -->
	<xsl:param name="pageparam"/>	<!-- имя параметра пагинации -->
	<xsl:param name="anchor"/>		<!-- якорь (опционально) -->
	<xsl:choose>
		<xsl:when test="$numpages &gt; 1">
			<nav>
				<ul class="pagination mb-3">
					<xsl:choose>
						<xsl:when test="$page = 1">
							<li class="page-item disabled">
								<a class="page-link" aria-label="Предидущая">
									<span aria-hidden="true">«</span>
								</a>
							</li>
						</xsl:when>
						<xsl:otherwise>
							<li class="page-item">
								<a class="page-link" aria-label="Предидущая">
									<xsl:attribute name="href">
										<xsl:value-of select="$url"/>
										<xsl:if test="$page &gt; 2">
											<xsl:choose>
												<xsl:when test="contains($url,'?')">
													<xsl:text>&amp;</xsl:text>
												</xsl:when>
												<xsl:otherwise>
													<xsl:text>?</xsl:text>
												</xsl:otherwise>
											</xsl:choose>
											<xsl:value-of select="$pageparam"/>
											<xsl:text>=</xsl:text>
											<xsl:value-of select="$page - 1"/>
										</xsl:if>
										<xsl:if test="$anchor">#<xsl:value-of select="$anchor"/></xsl:if>
									</xsl:attribute>
									<span aria-hidden="true">«</span>
								</a>
							</li>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="$page - 3 &gt; 2">
							<xsl:call-template name="pages">
								<xsl:with-param name="i" select="1"/>
								<xsl:with-param name="numpages" select="1"/>
								<xsl:with-param name="selected" select="$page"/>
								<xsl:with-param name="url" select="$url"/>
								<xsl:with-param name="pageparam" select="$pageparam"/>
								<xsl:with-param name="anchor" select="$anchor"/>
							</xsl:call-template>
							<li class="page-item">…</li>
							<xsl:call-template name="pages">
								<xsl:with-param name="i" select="$page - 3"/>
								<xsl:with-param name="numpages" select="$page"/>
								<xsl:with-param name="selected" select="$page"/>
								<xsl:with-param name="url" select="$url"/>
								<xsl:with-param name="pageparam" select="$pageparam"/>
								<xsl:with-param name="anchor" select="$anchor"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:otherwise>
							<xsl:call-template name="pages">
								<xsl:with-param name="i" select="1"/>
								<xsl:with-param name="numpages" select="$page"/>
								<xsl:with-param name="selected" select="$page"/>
								<xsl:with-param name="url" select="$url"/>
								<xsl:with-param name="pageparam" select="$pageparam"/>
								<xsl:with-param name="anchor" select="$anchor"/>
							</xsl:call-template>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="$page + 3 &lt; $numpages - 1">
							<xsl:call-template name="pages">
								<xsl:with-param name="i" select="$page + 1"/>
								<xsl:with-param name="numpages" select="$page + 3"/>
								<xsl:with-param name="selected" select="$page"/>
								<xsl:with-param name="url" select="$url"/>
								<xsl:with-param name="pageparam" select="$pageparam"/>
								<xsl:with-param name="anchor" select="$anchor"/>
							</xsl:call-template>
							<li class="page-item">…</li>
							<xsl:call-template name="pages">
								<xsl:with-param name="i" select="$numpages"/>
								<xsl:with-param name="numpages" select="$numpages"/>
								<xsl:with-param name="selected" select="$page"/>
								<xsl:with-param name="url" select="$url"/>
								<xsl:with-param name="pageparam" select="$pageparam"/>
								<xsl:with-param name="anchor" select="$anchor"/>
							</xsl:call-template>
						</xsl:when>
						<xsl:when test="$page &lt; $numpages">
							<xsl:call-template name="pages">
								<xsl:with-param name="i" select="$page + 1"/>
								<xsl:with-param name="numpages" select="$numpages"/>
								<xsl:with-param name="selected" select="$page"/>
								<xsl:with-param name="url" select="$url"/>
								<xsl:with-param name="pageparam" select="$pageparam"/>
								<xsl:with-param name="anchor" select="$anchor"/>
							</xsl:call-template>
						</xsl:when>
					</xsl:choose>
					<xsl:choose>
						<xsl:when test="$page = $numpages">
							<li class="page-item disabled">
								<a class="page-link" aria-label="Следующая">
									<span aria-hidden="true">»</span>
								</a>
							</li>
						</xsl:when>
						<xsl:otherwise>
							<li class="page-item">
								<a class="page-link" aria-label="Следующая">
									<xsl:attribute name="href">
										<xsl:value-of select="$url"/>
										<xsl:choose>
											<xsl:when test="contains($url,'?')">
												<xsl:text>&amp;</xsl:text>
											</xsl:when>
											<xsl:otherwise>
												<xsl:text>?</xsl:text>
											</xsl:otherwise>
										</xsl:choose>
										<xsl:value-of select="$pageparam"/>
										<xsl:text>=</xsl:text>
										<xsl:value-of select="$page + 1"/>
										<xsl:if test="$anchor">#<xsl:value-of select="$anchor"/></xsl:if>
									</xsl:attribute>
									<span aria-hidden="true">»</span>
								</a>
							</li>
						</xsl:otherwise>
					</xsl:choose>
				</ul>
			</nav>
		</xsl:when>
	</xsl:choose>
</xsl:template>
<xsl:template name="pages">
	<xsl:param name="i"/>
	<xsl:param name="numpages"/>
	<xsl:param name="selected"/>
	<xsl:param name="url"/>
	<xsl:param name="pageparam"/>
	<xsl:param name="anchor"/>
	<xsl:if test="$i &lt;= $numpages">
		<li>
			<xsl:attribute name="class">
				<xsl:text>page-item</xsl:text>
				<xsl:if test="$selected=$i"> active</xsl:if>
			</xsl:attribute>
			<a class="page-link">
				<xsl:attribute name="href">
					<xsl:value-of select="$url"/>
					<xsl:if test="$i &gt; 1">
						<xsl:choose>
							<xsl:when test="contains($url,'?')">
								<xsl:text>&amp;</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>?</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:value-of select="$pageparam"/>
						<xsl:text>=</xsl:text>
						<xsl:value-of select="$i"/>
					</xsl:if>
					<xsl:if test="$anchor"><xsl:text>#</xsl:text><xsl:value-of select="$anchor"/></xsl:if>
				</xsl:attribute>
				<xsl:value-of select="$i" />
			</a>
		</li>
		<xsl:call-template name="pages">
			<xsl:with-param name="i" select="$i + 1"/>
			<xsl:with-param name="numpages" select="$numpages"/>
			<xsl:with-param name="selected" select="$selected"/>
			<xsl:with-param name="url" select="$url"/>
			<xsl:with-param name="pageparam" select="$pageparam"/>
			<xsl:with-param name="anchor" select="$anchor"/>
		</xsl:call-template>
	</xsl:if>
</xsl:template>
</xsl:stylesheet>