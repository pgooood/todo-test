<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:include href="pagination.xsl"/>

	<xsl:template match="tasks">
		<h2 class="mb-4">Список задач</h2>
		<p class="mb-3"><a href="task/create/" class="btn btn-primary">Добавить задачу</a></p>
		<div class="mb-5 task-list">
			<form action="{$_path}" method="get">
				<div class="input-group mb-3">
					<span class="input-group-text">Сортировать по:</span>
					<select class="form-select" name="order-field" onchange="this.form.submit()">
						<option value="name">
							<xsl:if test="'name' = @order-field">
								<xsl:attribute name="selected" select="'selected'"/>
							</xsl:if>
							Имя пользователя
						</option>
						<option value="email">
							<xsl:if test="'email' = @order-field">
								<xsl:attribute name="selected" select="'selected'"/>
							</xsl:if>
							Электронная почта
						</option>
						<option value="status">
							<xsl:if test="'status' = @order-field">
								<xsl:attribute name="selected" select="'selected'"/>
							</xsl:if>
							Статус
						</option>
					</select>
					<select class="form-select" name="order" onchange="this.form.submit()">
						<option value="asc">
							<xsl:if test="'asc' = @order">
								<xsl:attribute name="selected" select="'selected'"/>
							</xsl:if>
							по возрастанию
						</option>
						<option value="desc">
							<xsl:if test="'desc' = @order">
								<xsl:attribute name="selected" select="'selected'"/>
							</xsl:if>
							по убыванию
						</option>
					</select>
				</div>
				<input type="hidden" name="page" value="{@page}"/>
			</form>
			<xsl:apply-templates select="row"/>
		</div>
		<!--пагинация-->
		<xsl:call-template name="pagination">
			<xsl:with-param name="numpages" select="number(@num-pages)"/>
			<xsl:with-param name="page" select="number(@page)"/>
			<xsl:with-param name="url">
				<xsl:value-of select="$_path"/>
				<xsl:text>?order-field=</xsl:text>
				<xsl:value-of select="@order-field"/>
				<xsl:text>&amp;order=</xsl:text>
				<xsl:value-of select="@order"/>
			</xsl:with-param>
			<xsl:with-param name="pageparam" select="'page'"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="tasks/row">
		<div class="card mb-3 task-list__item">
			<div class="card-body">
				<h5 class="card-title">
					<xsl:value-of select="name"/>
				</h5>
				<h6 class="card-subtitle mb-2 text-muted">
					<a href="mailto:{email}"><xsl:value-of select="email"/></a>
				</h6>
				<p class="card-text">
					<xsl:value-of select="content" disable-output-escaping="yes"/>
				</p>
				<xsl:if test="status/text() or edited/text() = '1'">
					<p class="card-text">
						<xsl:if test="status/text()">
							<small class="text-muted me-3"><xsl:value-of select="status"/></small>
						</xsl:if>
						<xsl:if test="edited/text() = '1'">
							<small class="text-muted">Отредактировано администратором</small>
						</xsl:if>
					</p>
				</xsl:if>
				<xsl:if test="@edit-url">
					<p><a href="{@edit-url}" class="btn btn-primary">Редактировать</a></p>
				</xsl:if>
			</div>
		</div>
	</xsl:template>



</xsl:stylesheet>