import static grails.util.Environment.*

grails.config.locations = ["file:/opt/webapps/${appName}-config.groovy"]

// locations to search for config files that get merged into the main config
// config files can either be Java properties files or ConfigSlurper scripts

// grails.config.locations = [ "classpath:${appName}-config.properties",
//                             "classpath:${appName}-config.groovy",
//                             "file:${userHome}/.grails/${appName}-config.properties",
//                             "file:${userHome}/.grails/${appName}-config.groovy"]

// if(System.properties["${appName}.config.location"]) {
//    grails.config.locations << "file:" + System.properties["${appName}.config.location"]
// }
grails.mime.file.extensions = true // enables the parsing of file extensions from URLs into the request format
grails.mime.use.accept.header = false
grails.mime.types = [ html: ['text/html','application/xhtml+xml'],
                      xml: ['text/xml', 'application/xml'],
                      text: 'text/plain',
                      js: 'text/javascript',
                      rss: 'application/rss+xml',
                      atom: 'application/atom+xml',
                      css: 'text/css',
                      csv: 'text/csv',
                      all: '*/*',
                      json: ['application/json','text/json'],
                      form: 'application/x-www-form-urlencoded',
                      multipartForm: 'multipart/form-data'
                    ]
// The default codec used to encode data with ${}
grails.views.default.codec="none" // none, html, base64
grails.views.gsp.encoding="UTF-8"
grails.converters.encoding="UTF-8"

// enabled native2ascii conversion of i18n properties files
grails.enable.native2ascii = true

accountingLib='R99FILES'
inventoryLib='I99FILES'
orderEntryLib='O99FILES'
varsityLib='VARFILES'
purchasingLib='U99FILES'

environments {
	development {
		logFile = "./grailsOrderEntry.log"
		apache.URL = "https://www.kettlerusa.com"
		accountingLib='kettler'
		inventoryLib='kettler'
		orderEntryLib='kettler'
		varsityLib='kettler'
		purchasingLib='kettler'
	}
	test {
		logFile = "./grailsOrderEntry.log"
		apache.URL = "https://www.kettlerusa.com"
		accountingLib=''
		inventoryLib=''
		orderEntryLib=''
		varsityLib=''
		purchasingLib=''
	}
    production {
		logFile = "/opt/logs/grailsOrderEntry.log"
		apache.URL = "https://www.kettlerusa.com"
    }
}

grails {
	serverURL = "https://www.kettlerusa.com"
}

// log4j configuration
log4j = {
    appenders {
          rollingFile name:"rollingFile", file:logFile, maxFileSize:'3MB', append:false, layout: pattern(conversionPattern: '%-5p %c{1} %d{dd MMM HH:mm:ss} %m%n')
//        appender new org.apache.log4j.DailyRollingFileAppender(name:"rollLog", layout:pattern(conversionPattern: '%d{ISO8601} %-5p [%c{2}] %m%n'), file:logFile, datePattern:"'.'yyyy-MM-dd")
    }
    debug rollingFile:"grails.app"
    
	error  'org.codehaus.groovy.grails.web.servlet',  //  controllers
	       'org.codehaus.groovy.grails.web.pages', //  GSP
	       'org.codehaus.groovy.grails.web.sitemesh', //  layouts
	       'org.codehaus.groovy.grails."web.mapping.filter', // URL mapping
	       'org.codehaus.groovy.grails."web.mapping', // URL mapping
	       'org.codehaus.groovy.grails.commons', // core / classloading
	       'org.codehaus.groovy.grails.plugins', // plugins
	       'org.codehaus.groovy.grails.orm.hibernate', // hibernate integration
	       'org.springframework',
	       'org.hibernate',
	       'grails.app.realm'				// jsecurity

    warn   'org.mortbay.log'
    
    // to see values for inserts etc.
  	//trace "org.hibernate.SQL", "org.hibernate.type"
}
     
// The following properties have been added by the Upgrade process...
grails.views.default.codec="none" // none, html, base64
grails.views.gsp.encoding="UTF-8"
