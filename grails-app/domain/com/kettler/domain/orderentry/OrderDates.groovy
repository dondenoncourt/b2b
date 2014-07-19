package com.kettler.domain.orderentry
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

class OrderDates implements Serializable {
	String compCode
	int orderNo
	int shipNo
	String dateCode = '010'
	Date date
	static constraints = {
		compCode(maxSize:2,nullable:false)
		orderNo(max:999999,nullable:false)
		shipNo(max:99,nullable:false)
		dateCode(blank:false,maxSize:3,inList:['010'],nullable:false)
		date(nullable:false)
	}
	static final String REQUESTED_SHIP_DATE = '010'
	
	static final boolean ASSIGNED_KEY = true
	static final boolean COMPOSITE_KEY  = true
	static mapping = {
		table (name:'oeordd',schema:CH.config.orderentry.schema)
		version (false)
		id (generator:'assigned')
		id (composite:['compCode','orderNo','shipNo','dateCode'])
		columns {
			id (composite:['compCode','orderNo','shipNo','dateCode'])
			compCode (column:'OCOMP', type:'string')
			orderNo (column:'OORDN', type:'int')
			shipNo (column:'OSHPN', type:'int')
			dateCode (column:'ODATCD', type:'string')
			date (column:'ODATE', type:'date')
		}
	}
	boolean newEntity = false
	static transients = ['newEntity']
}
