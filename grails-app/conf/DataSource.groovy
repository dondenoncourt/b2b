dataSource {
	pooled = true
	driverClassName = "org.hsqldb.jdbcDriver"
	username = "sa"
	password = ""
}
hibernate {
    cache.use_second_level_cache = true
    cache.use_query_cache = true
    cache.provider_class = 'net.sf.ehcache.hibernate.EhCacheProvider'
}
inventory.schema = 'I99FILES'
accounting.schema = 'R99FILES'
orderentry.schema = 'O99FILES'
varsity.schema = 'VARFILES'
purchasing.schema = 'U99FILES'
warranty.schema = 'W99FILES'
// environment specific settings
environments {
	development {
		dataSource {
			pooled = true
		 //   autoreconnect = true 		
			url = "jdbc:as400://brain;libraries=${inventory.schema},${accounting.schema},${orderentry.schema},${varsity.schema};transaction isolation=none"   
			driverClassName = "com.ibm.as400.access.AS400JDBCDriver"
			username = "webuser"
			password = "secret"
			dialect = org.hibernate.dialect.DB2400Dialect.class
			logSql = false
			programLib = "O99LIB"
		}
//		inventory.schema = 'DONFILES'
//		accounting.schema = 'DONFILES'
//		orderentry.schema = 'DONFILES'
//		varsity.schema = 'DONFILES'

        inventory.schema = 'kettler'
        accounting.schema = 'kettler'
        orderentry.schema = 'kettler'
        varsity.schema = 'kettler'
        purchasing.schema = 'kettler'
        warranty.schema = 'kettler'
        dataSource {
            pooled = true

////			url = "jdbc:as400://192.168.1.50;libraries=${inventory.schema},${accounting.schema},${orderentry.schema},${varsity.schema};transaction isolation=none"   
////			driverClassName = "com.ibm.as400.access.AS400JDBCDriver"
////			username = "secret"
////			password = "secret"
////			dialect = org.hibernate.dialect.DB2400Dialect.class
////			programLib = "o99lib"
			
            url = "jdbc:mysql://localhost/kettler"
            driverClassName = "com.mysql.jdbc.Driver"
            dialect = org.hibernate.dialect.MySQLDialect
            username = "secret"
            password = "secret"
            programLib = "kettler"
            dbCreate = "update"
            

            logSql = false

        }
	}
	test {
		inventory.schema = null
		accounting.schema = null
		orderentry.schema = null 
		varsity.schema = null
		purchasing.schema = null
		warranty.schema = null
		dataSource {
			dbCreate = "update"
			url = "jdbc:hsqldb:mem:testDb"
			logSql = false
		}
	}
	production {
		dataSource {
			pooled = true
		 //   autoreconnect = true 		
			url = "jdbc:as400://brain;libraries=${inventory.schema},${accounting.schema},${orderentry.schema},${varsity.schema};transaction isolation=none"   
			driverClassName = "com.ibm.as400.access.AS400JDBCDriver"
			username = "secret"
			password = "secret"
			dialect = org.hibernate.dialect.DB2400Dialect.class
			logSql = false
			programLib = "O99LIB"
		}
	}
}
