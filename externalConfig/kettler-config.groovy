// copy this file to /opt/webapps
invoiceCutoffMonths=-18

returns.image.directory="/opt/webapps/ra_images/"
returns.image.max.size=1048576
returns.image.delete.days=365
returns.image.delete.job.cron="0 3 0 * * ?"

app.error.email.to.addresses=["dondenoncourt@gmail.com"]
app.error.email.from.address="dondenoncourt@gmail.com"

grails {
   mail {
	     host = "smtp.gmail.com"
	     port = 465
	     username = "dondenoncourt@gmail.com"
	     password = "secret"
	     props = ["mail.smtp.auth":"true", 					   
	              "mail.smtp.socketFactory.port":"465",
	              "mail.smtp.socketFactory.class":"javax.net.ssl.SSLSocketFactory",
	              "mail.smtp.socketFactory.fallback":"false"]

	} 
}
