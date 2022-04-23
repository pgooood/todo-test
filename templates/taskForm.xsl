<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="task-item">
		<h2 class="mb-3">Добавление задачи</h2>
		<div class="card mb-5 task-form">
  			<div class="card-body">
			  	<xsl:apply-templates select="error" mode="form"/>
				<form action="task/{@url-params}" method="post">
					<xsl:apply-templates select="*[not(self::error)]" mode="form"/>
					<button type="submit" class="btn btn-primary">Сохранить задачу</button>
				</form>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="task-item[number(id) > 0]" priority="1">
		<h2 class="mb-3">Редактирование задачи</h2>
		<div class="card mb-5 task-form">
  			<div class="card-body">
				<form action="task/{@url-params}" method="post">
					<xsl:apply-templates select="*" mode="form"/>
					<button type="submit" class="btn btn-primary">Сохранить изменения</button>
				</form>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="error" mode="form" priority="1">
		<div class="alert alert-danger" role="alert">Ошибка: <xsl:value-of select="."/></div>
	</xsl:template>

	<xsl:template match="id" mode="form" priority="1">
		<input type="hidden" name="{name()}" value="{text()}"/>
	</xsl:template>

	<xsl:template match="name" mode="form" priority="1">
		<div class="mb-3">
			<label for="field-{name()}" class="form-label">Имя пользователя</label>
			<input type="text" name="{name()}" class="form-control" id="field-{name()}" value="{text()}" required="required"/>
		</div>
	</xsl:template>

	<xsl:template match="email" mode="form" priority="1">
		<div class="mb-3">
			<label for="field-{name()}" class="form-label">Электронная почта</label>
			<input type="email" name="{name()}" class="form-control" id="field-{name()}" value="{text()}" required="required"/>
		</div>
	</xsl:template>

	<xsl:template match="content" mode="form" priority="1">
		<div class="mb-3">
			<label for="field-{name()}" class="form-label">Описание задачи</label>
			<textarea name="{name()}" class="form-control" id="field-{name()}" cols="60" rows="5" required="required">
				<xsl:value-of select="text()" disable-output-escaping="yes"/>
			</textarea>
		</div>
	</xsl:template>

	<xsl:template match="status" mode="form" priority="1">
		<div class="mb-3">
			<label for="field-{name()}" class="form-label">Статус</label>
			<select class="form-select" name="{name()}" id="field-{name()}">
				<option value="">
					<xsl:if test="not('Выполнена' = text())">
						<xsl:attribute name="selected" select="'selected'"/>
					</xsl:if>
					<xsl:text>Не выполнена</xsl:text>
				</option>
				<option value="Выполнена">
					<xsl:if test="'Выполнена' = text()">
						<xsl:attribute name="selected" select="'selected'"/>
					</xsl:if>
					<xsl:text>Выполнена</xsl:text>
				</option>
			</select>
		</div>
	</xsl:template>

	<xsl:template match="task-item/*" mode="form"></xsl:template>

</xsl:stylesheet>