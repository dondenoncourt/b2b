package com.kettler.domain.varsity
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

class SpecialCharges implements Serializable {
	String activeStatus
	String carrierCode
	String serviceType
	String chargeCode
	String billCustFlag
	String chargeDescr
	BigDecimal fromWeight
	BigDecimal toWeight
	BigDecimal fromValue
	BigDecimal toValue
	BigDecimal flatFee
	BigDecimal poundRate
	BigDecimal dollarRate
	BigDecimal incrementalRate
	BigDecimal incrementalUnits
	static constraints = {
		activeStatus(maxSize:1,nullable:false)
		carrierCode(maxSize:5,nullable:false)
		serviceType(maxSize:2,nullable:false)
		chargeCode(maxSize:5,nullable:false)
		billCustFlag(maxSize:1,nullable:false)
		chargeDescr(maxSize:15,nullable:false)
		fromWeight(max:new BigDecimal("99999.99"),nullable:false)
		toWeight(max:new BigDecimal("99999.99"),nullable:false)
		fromValue(max:new BigDecimal("99999.99"),nullable:false)
		toValue(max:new BigDecimal("99999.99"),nullable:false)
		flatFee(max:new BigDecimal("99999.99"),nullable:false)
		poundRate(max:new BigDecimal("99999.99"),nullable:false)
		dollarRate(max:new BigDecimal("99999.99"),nullable:false)
		incrementalRate(max:new BigDecimal("99999.99"),nullable:false)
		incrementalUnits(max:new BigDecimal("99999.99"),nullable:false)
	}
	static final boolean ASSIGNED_KEY = true
	static final boolean COMPOSITE_KEY  = true
	static mapping = {
		table (name:'ctrlpo',schema:CH.config.varsity.schema)
//		cache usage:'read-only', include:'non-lazy'  Second-level cache is not enabled
		version (false)
		id (generator:'assigned')
		id (composite:['carrierCode','serviceType','chargeCode'])
		columns {
			id (composite:['carrierCode','serviceType','chargeCode'])
			activeStatus (column:'POACCD', type:'string')
			carrierCode (column:'POCRCD', type:'string')
			serviceType (column:'POSVTP', type:'string')
			chargeCode (column:'POCHCD', type:'string')
			billCustFlag (column:'POBCUS', type:'string')
			chargeDescr (column:'POSDSC', type:'string')
			fromWeight (column:'"POFR#"', type:'big_decimal')
			toWeight (column:'"POTO#"', type:'big_decimal')
			fromValue (column:'POFR$', type:'big_decimal')
			toValue (column:'POTO$', type:'big_decimal')
			flatFee (column:'POFLAT', type:'big_decimal')
			poundRate (column:'"PO#RTE"', type:'big_decimal')
			dollarRate (column:'PO$RTE', type:'big_decimal')
			incrementalRate (column:'POIRTE', type:'big_decimal')
			incrementalUnits (column:'POIUNT', type:'big_decimal')
		}
	}
	boolean newEntity = false
	static transients = ['newEntity']
}
