import com.kettler.domain.orderentry.share.InvoicedOrderDetailItem
import com.kettler.domain.orderentry.share.WebUser
import com.kettler.domain.orderentry.SalesDivision

import com.kettler.domain.work.DateUtils

import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
import org.jsecurity.SecurityUtils
import groovy.sql.Sql

/*
 Web-enable existing sales analysis inquiry for employees.  For customers and
reps, allow restricted access to simplified sales analysis inquiry.  For reps,
the sales rep options, customer options and sales division options would be
eliminated.  For customers, the display option would default to customer and
the sales division option would be eliminated.  On the screen displaying the
data requested, the user must be able to get back to the report parameters
screen and the previous parameters must be displayed.  The report screen must
have a print option to create a printable version. It must also have an option
to create a downloadable spreadsheet of the report data.  If no data is
available, the system must display a message informing the user of this.
 */
public class SalesAnalysisController{
	def sessionFactory
	def beforeInterceptor = {
        log.debug("action: $actionName params: $params flash: $flash")
    }
    def afterInterceptor = {model ->
        log.debug("action: $actionName model: $model") 
    }

	def prompt = {ReportCommand cmd ->
		// prompt may be invoked from analyze.gsp, which should have no errors
		// otherwise, don't bother passing cmd as it was build with blank attributes
		WebUser user = WebUser.findByEmail(SecurityUtils.getSubject()?.getPrincipal()?:'')
		List salesDivs = SalesDivision.list().findAll{div -> !['R', 'P'].find{it == div.id} }
		[cmd:cmd.hasErrors()?null:cmd, user:user, salesDivs:salesDivs]
	}
	
	def analyze = {ReportCommand cmd -> 
		def email = SecurityUtils.getSubject()?.getPrincipal()?:params.userEmail
		WebUser user = WebUser.findByEmail(email)
	    if (cmd.hasErrors()) {
	    	render (view:'prompt', model:[cmd:cmd,user:user])
	        return
	    }

	    String andRepOrCust = ''  
	    if (user.custNo) {
	    	andRepOrCust = " AND OCUSTR = '${user.custNo}'"
	    } else if (user.salesperson) {
	    	andRepOrCust = " AND OSPER1 = '${user.salesperson.id}'"
	    }
	    	
	    def headings = ['', '', ''] 
	    int fromDateYMD = DateUtils.getYMD(cmd.fromDate)
	    int toDateYMD = DateUtils.getYMD(cmd.toDate)
	    
		int fromDate2YMD
		int toDate2YMD 
		int fromDate3YMD 
		int toDate3YMD 
		if (cmd.fromDate2) { 
		    fromDate2YMD = DateUtils.getYMD(cmd.fromDate2)
		    toDate2YMD = DateUtils.getYMD(cmd.toDate2)
			if (cmd.fromDate3) {
			    fromDate3YMD = DateUtils.getYMD(cmd.fromDate3)
			    toDate3YMD = DateUtils.getYMD(cmd.toDate3)
			}
		}
	    

	    def limit = "fetch first ${params.rowCount} rows only " // db2/400 
	    if (CH.config.dataSource.dialect == org.hibernate.dialect.MySQLDialect) {
	    	limit = " limit ${params.rowCount} "
	    }
	    def unitOrDollars = ''
	    if (params.unitsOrDollars == 'U') {
	    	unitOrDollars = 'OQTYSH'
	    } else {
	    	unitOrDollars = 'oexamt'
	    }

	    String andDivision = ''

	    String compareQuery1 = "'N'"
	    String compareQuery2 = "'N'"
		
		String compCodeAnd =  params.compCode?" OCOMP = ? and ":""

		Sql sql = new Sql(sessionFactory.getCurrentSession().connection())
	    String query 
	    switch (params.reportType) {
	    case '1': // Division/Item
	    	andDivision = ' AND ODIST IN ('
	    	String select = "select rcode from ${CH.config.accountingLib}.artabl where rslsdv = '${params.salesDivision}'"	    			
	    	sql.eachRow (select) {rcode ->
	    		andDivision += "'${rcode.rcode}',"
	    	}
	    	andDivision = andDivision.replaceAll(/,$/, '') //	remove trailing comma
	    	andDivision += ")"
	    case '4': // Company/Itemselect rcode from kettler.artabl where rslsdv = 'T'select rcode from kettler.artabl where rslsdv = 'T'
	    	if (fromDate2YMD) {
	    		compareQuery1 =     "'SELECT sum(${unitOrDollars}) FROM ${CH.config.orderEntryLib}.oeinv1 WHERE ${compCodeAnd} oitem = ? and oinymd between ${fromDate2YMD} and ${toDate2YMD}'"
	    	    if (fromDate3YMD) {
	    	    	compareQuery2 = "'SELECT sum(${unitOrDollars}) FROM ${CH.config.orderEntryLib}.oeinv1 WHERE ${compCodeAnd} oitem = ? and oinymd between ${fromDate3YMD} and ${toDate3YMD}'"
	    	    }
	    	}
			query = """SELECT oitem, odesc, sum(${unitOrDollars}), ${compareQuery1}, ${compareQuery2}
                       FROM ${CH.config.orderEntryLib}.oeinv1
					   WHERE OCOMP = '${params.compCode}' and oinymd between ${fromDateYMD} and ${toDateYMD}
                             ${andRepOrCust} 
                             ${andDivision}
					   GROUP BY oitem, odesc 
					   ORDER BY sum(${unitOrDollars}) desc
					   ${limit}""" 
			headings[0] = 'Item No'
			headings[1] = 'Description' 
	    	break
	    case '2': // Division/Customer
	    	andDivision = " AND msdiv = '${params.salesDivision}'"
	    case '5': // Company/Customer
	    	if (fromDate2YMD) {
	    		compareQuery1 =     "'SELECT sum(${unitOrDollars}) FROM ${CH.config.orderEntryLib}.oeinv1 WHERE ${compCodeAnd} ocustr = ? and oinymd between ${fromDate2YMD} and ${toDate2YMD}'"
	    	    if (fromDate3YMD) {
	    	    	compareQuery2 = "'SELECT sum(${unitOrDollars}) FROM ${CH.config.orderEntryLib}.oeinv1 WHERE ${compCodeAnd} ocustr = ? and oinymd between ${fromDate3YMD} and ${toDate3YMD}'"
	    	    }
	    	}
			query = """SELECT ocustr, mname, sum(${unitOrDollars}), ${compareQuery1}, ${compareQuery2} 
                       FROM ${CH.config.orderEntryLib}.oeinv1
					   INNER JOIN ${CH.config.accountingLib}.custmast ON ocustr = mcust 
					   		                  ${andDivision}
					   WHERE OCOMP = '${params.compCode}' and oinymd between ${fromDateYMD} and ${toDateYMD}
                             ${andRepOrCust}   
					   GROUP BY ocustr, mname 
					   ORDER BY sum(${unitOrDollars}) desc
					   ${limit}"""  
			headings[0] = 'Cust No'
			headings[1] = 'Name' 
	    	break
	    case '3': // Division/Sales Rep
	    	andDivision = " AND SUBSTR(OSPER1, 1, 1) = '${params.salesDivision}'"  
	    case '6': // Company/Sales Rep
	    	if (fromDate2YMD) {
	    		compareQuery1 =     "'SELECT sum(${unitOrDollars}) FROM ${CH.config.orderEntryLib}.oeinv1 WHERE ${compCodeAnd} osper1 = ? and oinymd between ${fromDate2YMD} and ${toDate2YMD}'"
    	    	if (fromDate3YMD) {
    	    		compareQuery2 = "'SELECT sum(${unitOrDollars}) FROM ${CH.config.orderEntryLib}.oeinv1 WHERE ${compCodeAnd} osper1 = ? and oinymd between ${fromDate3YMD} and ${toDate3YMD}'"
    	    	}
	    	}
	    	query = """SELECT OSPER1, SPNAME, sum(${unitOrDollars}), ${compareQuery1}, ${compareQuery2} 
	                   FROM ${CH.config.orderEntryLib}.oeinv1
					   INNER JOIN ${CH.config.orderEntryLib}.oesper ON OSPER1 = SPCODE 
					   WHERE OCOMP = '${params.compCode}' and oinymd between ${fromDateYMD} and ${toDateYMD}
   		                     ${andDivision}
					   GROUP BY OSPER1, SPNAME 
					   ORDER BY sum(${unitOrDollars}) desc
					   ${limit}"""  
			headings[0] = 'Rep'
			headings[1] = 'Name'
	    	break
	    }
	    log.debug query
		[sql:sql,query:query, headings:headings, cmd:cmd, user:user, params:params]
	}
	
}
class ReportCommand implements Serializable {
    String compCode
    Date fromDate
    Date toDate
    Date fromDate2
    Date toDate2
    Date fromDate3
    Date toDate3
    String reportType
    int rowCount
    String salesDivision
    String unitsOrDollars
    static constraints = {
    	compCode (blank:false, inList:['01', '02'])
    	fromDate (blank:false, validator: {fromDate, obj ->
        	if (fromDate >= obj.toDate) {
        		return 'reportCommand.date.range.invalid'
        	}
        })
		toDate (blank:false)
        fromDate2 (validator: {fromDate2, obj ->
        	if (fromDate2 && fromDate2 >= obj.toDate2) {
        		return 'reportCommand.date2.range.invalid'
        	}
        })
        fromDate3 (validator: {fromDate3, obj ->
        	if (fromDate3 && fromDate3 >= obj.toDate3) {
        		return 'reportCommand.date3.range.invalid'
        	}
        })
		reportType (blank:false, inList:['1','2','3','4','5','6'])
		rowCount (blank:false, range:(1..100))
		unitsOrDollars (inList:['U', 'D'])
    }
}