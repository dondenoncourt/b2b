import groovy.sql.Sql

Sql iSeries = Sql.newInstance("jdbc:as400://brain;naming=sql;errors=full;libraries=o99files,u99files,r99files,varfiles", "dond", "vo2max", "com.ibm.as400.access.AS400JDBCDriver")
Sql mysql   = Sql.newInstance("jdbc:mysql://localhost/kettler", "donat", "vo2max", "com.mysql.jdbc.Driver")

def tableMap = [ 
        	  /*'oefrdist',  not in win mysql yet*/
         //     'vepctl':'o99files', 
              //'poordh':'u99files', 'poord1':'u99files',
/*
        	  'mfh1mh':'varfiles', 'vppack':'varfiles', 'ctrlpo':'varfiles', 'vsspcchgp':'varfiles',    

              'oeprqh':'o99files', 'oeprq1':'o99files', 'oeprq2':'o99files', 'oeprq3':'o99files',
              'oeinvh':'o99files', 'oeinv1':'o99files', 'oeinv2':'o99files', 'oeinv3':'o99files',
              'ctrlsi':'varfiles',
              'arbalfwd':'r99files', 'arbsum':'r99files', 'oetier':'o99files',
              
              'rtrnstat':'r99files', 'rtrnreas':'r99files','rtrnnote':'r99files','rtrnitmdtl':'r99files','rtrnitm':'r99files','rtrn':'r99files','rtrnnix':'r99files',
              'rtrnfgtdsc':'r99files','rtrndisp':'r99files','rtrncond':'r99files',
              'ordheader':'o99files', 'oeord1':'o99files', 'oeord2':'o99files', 'oeord3':'o99files',
              'ardtbl':'r99files', 'artabl':'r99files', 'arcctl':'r99files', 
               'orddscalw':'o99files',
              'inbomm':'i99files',  'innmfc':'i99files', 'inpctr':'i99files', 'inpric':'i99files', 'inwhse':'i99files', 'inshst':'i99files',
              'oebil1':'o99files', 'oebil2':'o99files', 'oebill':'o99files', 'oecanp':'o99files', 'oeccmt':'o99files', 'oecomp':'o99files', 
              'oersnc':'o99files', 'oecprc':'o99files', 'oectrl':'o99files', 'oedcal':'o99files', 'oefobc':'o99files', 
              'oeplst':'o99files', 'oeprtc':'o99files', 'oerfcd':'o99files', 'oescac':'o99files', 
              'oescmt':'o99files', 'oestac':'o99files', 'oestax':'o99files', 'oeterm':'o99files', 'oeuctl':'o99files', 'oecntr':'o99files',
              'oecda':'o99files', 'exctry':'varfiles', 'oesgrp':'o99files', 'oesdiv':'o99files', 'oeshpweb':'o99files', 
              'custmast':'r99files', 
              'shipto':'o99files', 'oesper':'o99files', 'webuser':'o99files', 'oe3rdpty':'o99files',
*/
              'itemmast':'i99files', 'itemmastex':'i99files', 'itemacsry':'i99files', 'itemwhs':'i99files',
              'webdiv':'i99files','webcat':'i99files',
        	  'coupon':'o99files',

           	  /* consumer tables: */
        	  	'csmr':'o99files', 'csmrbillto':'o99files', 'csmrshipto':'o99files', 'cart':'o99files', 'cartitem':'o99files'
              ]

iSeries.execute("update r99files.rtrn set stkcstdb = 0 where stkcstdb is null".toString())

mysql.execute("SET FOREIGN_KEY_CHECKS=0".toString())     
tableMap.each {file, library -> 
    try {
	mysql.execute("delete from kettler.$file".toString())     
    } catch (e) {
	println e
    }
}
tableMap.each {file, library -> 
    println "processing $library.$file"
    //def rs = iSeries.getConnection().getMetaData().getColumns(null, 'donfiles', file, null)
    def rs = mysql.getConnection().getMetaData().getColumns(null, library, file, null)
    def cols = []
    while (rs.next()) { cols <<  rs.getString("COLUMN_NAME")}
    def insert = "insert into $file ("
    cols.each {insert += "`$it`" + ','}
    insert = insert.replaceAll(/,$/, '')
    insert += ') value('
    cols.each {insert += '?,'}
    insert = insert.replaceAll(/,$/, '')
    insert += ') '
    println insert
    def select = "select * from $library.$file fetch first 3500 rows only".toString()
    if (file == 'shipto') {
        select = "select * from $library.$file where stnumb <> 9999".toString()
    } else if (['oeinvh', 'oeinv1', 'oeinv2', 'oeinv3'].find {it == file}) {
    	select = "select * from $library.$file where OINYMD > 111105".toString() 
    } else if (['ordheader', 'oeord1', 'oeord2', 'oeord3', 'arbfwd', 'arbsum', 'cart', 'cartitem'].find {it == file}) { // get all rows
    	select = "select * from $library.$file ".toString() // get all
    } else if (file == 'mfh1mh') {
    	select = "select * from $library.$file where  MHDATE > 110515".toString()  
    } else if (file == 'vppack') {
    	select = "select * from $library.$file where PKCHGD > 20110515".toString()  
    }

    iSeries.eachRow (select) {row ->
        def data = []
        cols.each { 
    		try {
    			data << row[it] 
    		} catch (e) {
    			println "column name causing error: $it"
    			println e
    			assert false
    		}
    	}
        mysql.execute(insert.toString(), data)     
    }
}
mysql.execute("update ordheader set backorder = 'N' where backorder = ''".toString())
mysql.execute("update ordheader set weborder = 'N' where weborder = ''".toString())
mysql.execute("update webuser set password = '72761796d7a0965604ad321b507a3518c268ec17' where email not like 'dondenoncour%'".toString())
mysql.execute("drop table deleteme".toString())
mysql.execute("create table deleteme (password varchar(256))".toString())
mysql.execute("insert into deleteme  (select password from csmr where email = 'dondenoncourt@gmail.com')".toString())
mysql.execute("select * from deleteme".toString())
mysql.execute("update csmr set password = (select password from deleteme)".toString()) 

mysql.execute("SET FOREIGN_KEY_CHECKS=1".toString())     
println "ALL FILES HAVE BEEN PROCESSED"
