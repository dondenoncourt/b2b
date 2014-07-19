package com.kettler.domain.orderentry
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

import org.hibernate.type.CharBooleanType
import org.hibernate.type.YesNoType
import com.kettler.domain.work.DateUtils

/*
create view o99files.ordinv as 
select OCOMP, OORDN, OSHPN, OSEQN, OSTAT, OPONUM, OFRTCD, OINVNO, OCRMEM, OCUSTN, OSPCD1, OSDATE, OUDATE, OPICDT, OBORDT, OCNFDT, OORDDT, OFRTRK, OSHVIA, OCNCDT as canceledDate
from o99files.ordheader
union
select OCOMP, OORDN, OSHPN, OSEQN, OSTAT, OPONUM, OFRTCD, OINVNO, OCRMEM, OCUSTN, OSPCD1, OSDATE, OUDATE, OPICDT, OBORDT, OCNFDT, OORDDT, OFRTRK, OSHVIA, ORTDDT as canceledDate
from o99files.oeinvh
where (ocomp = 01 and oordn > 300000) or (ocomp = 02 and oordn > 10000)                              
*/

class OrderInvoiceMerge implements Serializable {
	String compCode 
	int orderNo
	int shipNo
	int lineNo
	String statusCode   
	String custNo
	String poNo
	String shipVia
	int invoiceNo
	String freightCode	
	boolean creditMemoCode
	String salesperson1
	Date dateShipped
	Date dateCreated
	Date pickDateMDY
	Date backOrderReleaseDate
	Date dateConfirmed
	Date orderDate 
	String freightTrackingNo
	Date canceledDate
	
	static mapping = {
		table (name:'ordinv',schema:CH.config.orderentry.schema)
		version (false)
		id (generator:'assigned')
		id (composite:['compCode','orderNo','shipNo','lineNo'])
		columns {
			id (composite:['compCode','orderNo','shipNo','lineNo'])
			compCode (column:'OCOMP', type:'TrimString')
			orderNo (column:'OORDN', type:'int')
			shipNo (column:'OSHPN', type:'int')
			lineNo (column:'OSEQN', type:'int')
			statusCode (column:'OSTAT', type:'TrimString')
			custNo (column:'OCUSTN', type:'TrimString')
			poNo (column:'OPONUM', type:'TrimString')
			shipVia (column:'OSHVIA', type:'TrimString')
			creditMemoCode (column:'OCRMEM', type:'YesBlankType')
			invoiceNo (column:'OINVNO', type:'int')
			freightCode (column:'OFRTCD', type:'TrimString')
			salesperson1 (column:'OSPCD1', type:'TrimString')
			dateShipped (column:'OSDATE', type:'DateMMDDYYUserType')
			dateCreated (column:'OUDATE', type:'DateMMDDYYUserType')
			pickDateMDY (column:'OPICDT', type:'DateMMDDYYUserType')
			backOrderReleaseDate (column:'OBORDT', type:'DateMMDDYYUserType')
			dateConfirmed (column:'OCNFDT', type:'DateMMDDYYUserType')
			orderDate (column:'OORDDT', type:'DateMMDDYYUserType')
			freightTrackingNo (column:'OFRTRK', type:'TrimString')
			canceledDate (column:'canceledDate', type:'DateMMDDYYUserType')
		}
	}
}
