<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="login">
		<h2 class="mb-3">Пожалуйста авторизуйтесь</h2>
		<div class="card login-form">
  			<div class="card-body">
				<xsl:apply-templates select="error"/>
				<form action="login/" method="post">
					<div class="mb-3">
						<label for="input-username" class="form-label">Имя пользователя</label>
						<input type="text" name="username" class="form-control" id="input-username" value="{username}"/>
					</div>
					<div class="mb-3">
						<label for="input-password" class="form-label">Пароль</label>
						<input type="password" name="password" class="form-control" id="input-password"/>
					</div>
					<button type="submit" class="btn btn-primary">Авторизоваться</button>
				</form>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="error">
		<div class="alert alert-danger" role="alert">Ошибка: <xsl:value-of select="."/></div>
	</xsl:template>

</xsl:stylesheet>