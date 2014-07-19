package com.kettler.domain.item
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
class ItemPrice implements Serializable {
	String compCode
	String itemNo
	String priceCode
	int thruQuantity
	String qtyUnitMeasCode
	BigDecimal unitPrice
	static constraints = {
		compCode(maxSize:2,nullable:false)
		itemNo(maxSize:15,nullable:false)
		priceCode(maxSize:1,nullable:false)
		thruQuantity(max:99999,nullable:false)
		qtyUnitMeasCode(maxSize:1,nullable:false)
		unitPrice(max:new BigDecimal("999999.999"),nullable:false)
	}
	static final boolean ASSIGNED_KEY = true
	static final boolean COMPOSITE_KEY  = true
	static mapping = {
		table (name:'inpric',schema:CH.config.inventory.schema)
		version (false)
		id (generator:'assigned')
		id (composite:['compCode','itemNo','priceCode','thruQuantity'])
		columns {
			id (composite:['compCode','itemNo','priceCode','thruQuantity'])
			compCode (column:'PCOMP', type:'string')
			itemNo (column:'PITEM', type:'string')
			priceCode (column:'PPRCD', type:'string')
			thruQuantity (column:'PQNTY', type:'int')
			qtyUnitMeasCode (column:'PQUMC', type:'string')
			unitPrice (column:'PPRIC', type:'big_decimal')
		}
	}
	boolean newEntity = false
	static transients = ['newEntity']
}
