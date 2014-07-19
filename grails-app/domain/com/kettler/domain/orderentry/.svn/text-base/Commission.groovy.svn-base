package com.kettler.domain.orderentry

import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

class Commission implements Serializable {
	String compCode
	String rep
	String custNo
	String name
	String poNo
	String invoiceDate
	String invoiceNo
	String itemNo
	BigDecimal salesAmt
	BigDecimal discAmt
	BigDecimal miscAmt
	BigDecimal netAmt
	BigDecimal commRate
	BigDecimal commAmt
	static constraints = {
		compCode(maxSize:2,nullable:false)
		rep(maxSize:3,nullable:false)
		custNo(maxSize:7,nullable:false)
		name(maxSize:30,nullable:false)
		poNo(maxSize:25,nullable:false)
		invoiceDate(maxSize:8,nullable:false)
		invoiceNo(maxSize:7,nullable:false)
		itemNo(maxSize:15,nullable:false)
		salesAmt(max:new BigDecimal("9999999.99"),nullable:false)
		discAmt(max:new BigDecimal("99999.99"),nullable:false)
		miscAmt(max:new BigDecimal("99999.99"),nullable:false)
		netAmt(max:new BigDecimal("9999999.99"),nullable:false)
		commRate(max:new BigDecimal("99.99"),nullable:false)
		commAmt(max:new BigDecimal("99999.99"),nullable:false)
	}
	static final boolean ASSIGNED_KEY = true
	static final boolean COMPOSITE_KEY  = true
	static mapping = {
		table name:'oespcm', schema:CH.config.orderentry.schema
		version (false)
		id (generator:'assigned')
		id (composite:['compCode','rep','custNo','name','poNo','invoiceDate','invoiceNo','itemNo'])
		columns {
			id (composite:['compCode','rep','custNo','name','poNo','invoiceDate','invoiceNo','itemNo'])
			compCode (column:'COMP', type:'string')
			rep (column:'SLSREP', type:'string')
			custNo (column:'CUST', type:'string')
			name (column:'NAME', type:'string')
			poNo (column:'PONUM', type:'string')
			invoiceDate (column:'INVDAT', type:'string')
			invoiceNo (column:'INVNO', type:'string')
			itemNo (column:'ITEM', type:'string')
			salesAmt (column:'SLSAMT', type:'big_decimal')
			discAmt (column:'DSCAMT', type:'big_decimal')
			miscAmt (column:'MSCAMT', type:'big_decimal')
			netAmt (column:'NETAMT', type:'big_decimal')
			commRate (column:'COMRAT', type:'big_decimal')
			commAmt (column:'COMAMT', type:'big_decimal')
		}
	}
	boolean newEntity = false
	static transients = ['newEntity']
}