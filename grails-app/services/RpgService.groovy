import com.kettler.domain.actrcv.share.Customer
import com.kettler.domain.orderentry.share.Control

import groovy.sql.Sql
import java.sql.Types
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

public class RpgService implements Serializable {
	def sessionFactory
	def customerService
	boolean transactional = false
    def pgmLib = CH.config.dataSource.programLib

	
	
	/*  call o99epo 
		CREATE PROCEDURE O99LIB/O99EPO(
		IN  compNo CHAR(2),
		IN  custNo CHAR(7),
		IN  poNo   CHAR(25), 
		OUT dup    CHAR(1),
		IN  code   CHAR(1), 
		IN  ordNo  CHAR(6)) 
		LANGUAGE RPGLE 
		NOT DETERMINISTIC 
		NO SQL 
		EXTERNAL NAME O99LIB/O99EPO 
		PARAMETER STYLE GENERAL                        
	*/
	boolean isDuplicatePO(String compNo, String custNo, String poNo, String orderNo) {
		if (poNo.trim().size() == 0) {
			return true
		}
		if (CH.config.dataSource.driverClassName != 'com.ibm.as400.access.AS400JDBCDriver') {
			return (poNo as int) % 2 // even po is false, odd is true
		}
		Sql sql = new Sql(sessionFactory.getCurrentSession().connection())
		boolean duplicate = false
		sql.call ("call o99lib.o99epo (?,?,?,?,?,?)",
		   [Sql.in(Types.CHAR, compNo),
		    Sql.in(Types.CHAR, custNo),
		    Sql.in(Types.CHAR, poNo),
		    Sql.out(Types.CHAR),
		    Sql.in(Types.CHAR, 'O'), // not sure what 'O' means
		    Sql.in(Types.CHAR, orderNo)
		   ]
		    ) { dup -> duplicate = (dup == 'Y')}
		return duplicate
	}
/*
		CREATE PROCEDURE DONCHG/WEBACKC(
			IN compNo CHAR ( 2), 
			IN orderNo char(7),    
			IN shipNo CHAR ( 2)                                      
		) NOT DETERMINISTIC CONTAINS SQL EXTERNAL PARAMETER STYLE GENERAL
		
		CREATE PROCEDURE DONCHG/WEBCPYPDF(
			IN rpttyp CHAR ( 7)
		) NOT DETERMINISTIC CONTAINS SQL EXTERNAL PARAMETER STYLE GENERAL
		                                 
 */
	def printAcknowledgement(String compCode, String orderNo, String shipNo) {
		if (CH.config.dataSource.driverClassName != 'com.ibm.as400.access.AS400JDBCDriver') {
			return  new File('/workspaces/kettler/oeackns.pdf') // Don's Ubuntu
		}
		new Sql(sessionFactory.getCurrentSession().connection()).call (
				 "call ${pgmLib}.webackc (?,?,?)", 
				 [Sql.in(Types.CHAR, compCode),  Sql.in(Types.CHAR, orderNo), Sql.in(Types.CHAR, shipNo)  ]
		)  
	
		def i = 0
		def pdfs 
		while (!pdfs) { 
			Object.sleep(1000)	
			pdfs = getIfsPdfList('OEACKNS')
			if (i++ > 10) break
		}
		if (!pdfs.size()) {
			return null
		}
		return new File("\\\\brain\\qprtjob\\webuser\\${(pdfs[pdfs.size()-1])}")
	}

	private List getIfsPdfList(String reportType) {
		def pdfs = []
		new File("\\\\brain\\qprtjob\\webuser" ).eachFile{pdf ->
		 	if (pdf.name ==~ /.*${reportType}.*PDF/) {
		 		pdfs << pdf.name
		 	}
		}
	 	return pdfs 
	}
/*
	CREATE PROCEDURE DONCHG/WEBINV(
			IN compNo CHAR ( 2), 
			IN invoiceNo CHAR ( 7)
	) NOT DETERMINISTIC NO SQL EXTERNAL PARAMETER STYLE GENERAL
 */
 	def printInvoice(String compCode, String invoiceNo) {
		if (CH.config.dataSource.driverClassName != 'com.ibm.as400.access.AS400JDBCDriver') {
			return  
		}
		Sql sql = new Sql(sessionFactory.getCurrentSession().connection())
		sql.call ("call ${pgmLib}.webinv (?,?)", 
				   [Sql.in(Types.CHAR, compCode),
				    Sql.in(Types.CHAR, invoiceNo)
				   ]
			    )  

		def i = 0
		def pdfs 
		while (!pdfs) { 
			Object.sleep(1000)	
			pdfs = getIfsPdfList('INVCOPY')
			if (i++ > 10) break
		}
		if (!pdfs.size()) {
			return null
		}
		return new File("\\\\brain\\qprtjob\\webuser\\${(pdfs[pdfs.size()-1])}")
	}
 
/*
		CREATE PROCEDURE DONCHG/WEBARSTMTS(
			IN compNo CHAR (2), 
			IN custNo char(7),    
			IN cycle CHAR (1),                                      
			IN opt CHAR (1),                                      
			IN curDue CHAR (10),                                      
			IN ovrDue1 CHAR (10),                                      
			IN ovrDue2 CHAR (10),                                      
			IN ovrDue3 CHAR (10),                                      
			IN ovrDue4 CHAR (10))
		) NOT DETERMINISTIC CONTAINS SQL EXTERNAL PARAMETER STYLE GENERAL                                 
*/
	private List getNoPeriodZeroFillStrings(List agingBuckets, int size) {
		def formattedBuckets = []
		agingBuckets.eachWithIndex {age, bucket ->
			def ageStr = age.setScale(2, BigDecimal.ROUND_HALF_UP).toString().replaceAll(/\./, '')
			formattedBuckets[bucket] = ''
			(1..(size-ageStr.size())).each {formattedBuckets[bucket] += '0'}
			(0..(ageStr.size()-1)).each {formattedBuckets[bucket] += ageStr[it]}
		}
		return formattedBuckets
	}

	def arStatements(Customer cust) {
		if (CH.config.dataSource.driverClassName != 'com.ibm.as400.access.AS400JDBCDriver') {
			return  
		}
		assert cust
		List agingBuckets = getNoPeriodZeroFillStrings(customerService.getAgingBuckets(cust.compCode, cust.custNo), 10)
		Sql sql = new Sql(sessionFactory.getCurrentSession().connection())
		//call donchg/webarstmts parm('01' 'AM0302W' '1' 'E' '0012042300' '0002702900' '0000000000' '0000000000' '0000000000') 
		sql.call ("call ${pgmLib}.WEBARSTMTS (?,?, ?, ?, ?, ?, ?, ?, ?)", 
				   [Sql.in(Types.CHAR, cust.compCode),
				    Sql.in(Types.CHAR, cust.custNo),
				    Sql.in(Types.CHAR, cust.compCode[1]), 
				    Sql.in(Types.CHAR, 'E'),
				    Sql.in(Types.CHAR, agingBuckets[0]),// '0000000000'),
				    Sql.in(Types.CHAR, agingBuckets[1]),//'0000000000'),
				    Sql.in(Types.CHAR, agingBuckets[2]),//'0000000000'),
				    Sql.in(Types.CHAR, agingBuckets[3]),//'0000000000'),
				    Sql.in(Types.CHAR, agingBuckets[4]) //'0000000000')
				   ]
			    )  

		def i = 0
		def pdfs 
		while (!pdfs) { 
			Object.sleep(1000)	
			pdfs = getIfsPdfList('ARSTMTS')
			if (i++ > 10) break
		}
		if (!pdfs.size()) {
			return null
		}
		return new File("\\\\brain\\qprtjob\\webuser\\${(pdfs[pdfs.size()-1])}")
	}
/*
CREATE PROCEDURE DONCHG/WEBPCKLST(
	IN compNo CHAR ( 2), 
	IN orderNo CHAR ( 7),
    IN shipNo CHAR ( 2), 
    IN resiOrComm CHAR ( 1)
) NOT DETERMINISTIC NO SQL EXTERNAL PARAMETER STYLE GENERAL           
 */
 	def printPackList(String compCode, String orderNo, String shipNo) {
		if (CH.config.dataSource.driverClassName != 'com.ibm.as400.access.AS400JDBCDriver') {
			return  
		}
		Sql sql = new Sql(sessionFactory.getCurrentSession().connection())
		sql.call ("call ${pgmLib}.webpcklst (?,?,?,?)", 
				   [Sql.in(Types.CHAR, compCode),
				    Sql.in(Types.CHAR, orderNo),
				    Sql.in(Types.CHAR, shipNo),
				    Sql.in(Types.CHAR, 'C')
				   ]
			    )  
	
		def i = 0
		def pdfs 
		while (!pdfs) { 
			Object.sleep(1000)	
			pdfs = getIfsPdfList('KETPLST')
			if (i++ > 10) break
		}
		if (!pdfs.size()) return null
		return new File("\\\\brain\\qprtjob\\webuser\\${(pdfs[pdfs.size()-1])}")
	}
 	
 	/*
 	 * CREATE PROCEDURE o99lib.o99dsc (
 	 *   IN  fromDate CHAR(6),
 	 *   IN  toDate   CHAR(6),
 	 *   IN  compNo   CHAR(2),
 	 *   IN  rep      CHAR(3)) 
 	 *   LANGUAGE RPGLE
 	 *   NOT DETERMINISTIC
 	 *   NO SQL 
 	 *   EXTERNAL NAME o99lib.o99dsc
 	 *   PARAMETER STYLE GENERAL
 	 */
 	def commStmts(String fromDate, String toDate, String compCode, String rep) {
		log.debug "commStmts($fromDate, $toDate, $compCode, $rep)"

		if (CH.config.dataSource.driverClassName != 'com.ibm.as400.access.AS400JDBCDriver') {
			log.debug "$CH.config.dataSource.driverClassName != 'com.ibm.as400.access.AS400JDBCDriver' test mode so return"
			return  
		}
		Sql sql = new Sql(sessionFactory.getCurrentSession().connection())
		sql.execute ("delete from ${CH.config.orderentry.schema}.oespcm where comp = ? and slsrep = ? ", [compCode, rep])
		sql.call ("call ${pgmLib}.o99dsc (?,?,?,?)", 
				   [Sql.in(Types.CHAR, fromDate),
				    Sql.in(Types.CHAR, toDate),
				    Sql.in(Types.CHAR, compCode),
				    Sql.in(Types.CHAR, rep)
				   ]
			    )  
			    
 	}
 	/*
 	CREATE PROCEDURE o99lib.nxtordno(
 			IN  compNo CHAR(2),
 			OUT nextOrdNo   decimal(6, 0))
 			LANGUAGE RPGLE 
 			NOT DETERMINISTIC 
 			NO SQL 
 			EXTERNAL NAME o99lib.nxtordno 
 			PARAMETER STYLE GENERAL
 	*/              
 	int getNextOrderNo(String compCode) {
		log.debug "getNextOrderNo($compCode)"
		if (CH.config.dataSource.driverClassName != 'com.ibm.as400.access.AS400JDBCDriver') {
			println "in development directly using Control domain and not calling rpg"
	        Control cont = Control.get(compCode) 
	        cont.nextOrderNo += 1
	        cont.save(flush:true)
	        return cont.nextOrderNo - 1
		}
		int returnOrderNo = 0  
		Sql sql = new Sql(sessionFactory.getCurrentSession().connection())
 		sql.call ("call ${pgmLib}.nxtordno (?,?)",
			   [Sql.in(Types.CHAR, compCode),
			    Sql.out(Types.DECIMAL)
			   ]
			    ) { nextOrdNo -> 
			    returnOrderNo = nextOrdNo
			}
		log.debug "$returnOrderNo getNextOrderNo($compCode)"
		return returnOrderNo 
 	}
 	
}
