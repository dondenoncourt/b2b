import com.kettler.domain.actrcv.share.Customer
import com.kettler.domain.work.DateUtils

import groovy.sql.Sql
import java.sql.Types
import org.codehaus.groovy.grails.commons.ConfigurationHolder

public class CustomerService implements Serializable {
	def sessionFactory
	boolean transactional = false

	List getAgingBuckets(String compCode, String custNo) {

		int today = DateUtils.getYMD(new Date())
		int longAgo = 010101 // 1/1/2001
		int yearFromNow = DateUtils.getYMD(new Date() + 365)
		int daysAgo30 = DateUtils.getYMD(new Date() - 30)
		int daysAgo60 = DateUtils.getYMD(new Date() - 60)
		int daysAgo90 = DateUtils.getYMD(new Date() - 90)
		println("30 = " + daysAgo30)
		println("60 = " + daysAgo60)
		println("90 = " + daysAgo90)


		def library = 'R99FILES'
		if (ConfigurationHolder.config.dataSource.driverClassName != 'com.ibm.as400.access.AS400JDBCDriver') {
			library = 'kettler'   // Don's MySql test database
		}

		
		def query = """
		   select trefn as refNo, tamnt as amount, mod((tadate * 10000.01), 1000000) as refDate
		   from  ${library}.arbalfwd c
		   where c.tcomp = ? and c.tcust = ? and TTYPE <> 'D' and tpcfcd <> 'F'
		   order by tcomp, tcust, trefn, tsign DESC
		   """
	   def sql = new Sql(sessionFactory.getCurrentSession().connection())

	   BigDecimal ageCurrent = 0.00g
	   BigDecimal age1to30 = 0.00g
	   BigDecimal age31to60 = 0.00g
	   BigDecimal age61to90 = 0.00g
	   BigDecimal age90Plus = 0.00g
	   
	   BigDecimal amount = 0.00g
	   String holdRefNo = ""
	   String refNo = ""
	   int refDate = 0
	   int bucket = 0
	   int dt = 0
	   sql.eachRow (query.toString(), [ compCode, custNo]) {row ->
		   if (!holdRefNo.equals(row.refNo)){
			   if (row.refDate >= today ){
				   bucket = 0
			   }else if (row.refDate > daysAgo30){
				   bucket = 1
			   }else if (row.refDate > daysAgo60){
				   bucket = 2
			   }else if (row.refDate > daysAgo90){
				   bucket = 3
			   }else {
				   bucket = 4
			   }
			   holdRefNo = row.refNo
		   }
		   switch (bucket){
			   case 0:
				   ageCurrent += row.amount?new BigDecimal(row.amount):0.0g
				   break
			   case 1:
				   age1to30 += row.amount?new BigDecimal(row.amount):0.0g
				   break
			   case 2:
				   age31to60 += row.amount?new BigDecimal(row.amount):0.0g
				   println ("date = ${row.refDate} bkt2 amount = ${row.amount} refn = ${row.refNo}")
				   break
			   case 3:
				   age61to90 += row.amount?new BigDecimal(row.amount):0.0g
				   break
			   case 4:
				   age90Plus += row.amount?new BigDecimal(row.amount):0.0g
				   break
		   }
	   }
	   return [ageCurrent, age1to30, age31to60, age61to90, age90Plus]
   }

}
