<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output media-type="text/html" method="html" omit-xml-declaration="yes" indent="no" encoding="utf-8"/>

	<xsl:variable name="_basepath" select="/main/@basepath"/>
	<xsl:variable name="_path" select="/main/@path"/>

	<xsl:template match="/">
		<xsl:text disable-output-escaping="yes">&lt;!DOCTYPE HTML&gt;</xsl:text>
		<html>
			<head>
				<base href="{$_basepath}"/>
				<meta charset="utf-8"/>
				<meta name="viewport" content="width=device-width, initial-scale=1"/>
				<title>Todo</title>
				<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous"/>
				<link href="assets/default.css" rel="stylesheet"/>
			</head>
			<body>
				<header class="container hero py-5">
					<h1 class="display-2 text-bold">todo</h1>
					<h5 class="text-gray-soft text-regular mb-4">Тестовое задание</h5>
					<xsl:apply-templates select="/main/auth"/>
				</header>
				<main class="container">
					<xsl:apply-templates select="/main/*[not(self::auth)]"/>
				</main>
				<xsl:if test="/main/@message">
					<div aria-live="polite" aria-atomic="true" class="d-flex justify-content-center align-items-center w-100 fixed-top">
						<div id="meassage-toast" class="toast mt-5" role="alert" aria-live="assertive" aria-atomic="true">
							<div class="toast-header">
								<strong class="me-auto">Todo</strong>
								<small></small>
								<button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
							</div>
							<div class="toast-body">
								<xsl:value-of select="/main/@message"/>
							</div>
						</div>
					</div>
				</xsl:if>
				<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>
				<script src="assets/default.js"></script>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="auth[user]" priority="1">
		<p>Привет, <xsl:value-of select="user"/>! <a href="logout/">Выйти</a></p>
	</xsl:template>

	<xsl:template match="/main[not(@path = 'login/')]/auth">
		<p><a href="login/" class="btn btn-primary">Авторизоваться</a></p>
	</xsl:template>

	<xsl:template match="error">
		<div class="alert alert-danger" role="alert"><xsl:value-of select="."/></div>
	</xsl:template>

</xsl:stylesheet>