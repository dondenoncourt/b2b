package com.kettler.domain.actrcv
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

class BalanceForwardSummary implements Serializable {
	String compCode
	String custNo
	String refNo
	Date transDate
	int transCentury
	BigDecimal charges
	BigDecimal credits
	BigDecimal payments
	BigDecimal adjustments
	Date discDate
	int discCentury
	BigDecimal discAmount
	BigDecimal beginBalance
	BigDecimal payments2
	BigDecimal creditsAdjusts
	String addedCode
	static constraints = {
		compCode(maxSize:2,nullable:false)
		custNo(maxSize:7,nullable:false)
		refNo(maxSize:7,nullable:false)
		transDate(nullable:false)
		transCentury(max:99,nullable:false)
		charges(max:new BigDecimal("9999999.99"),nullable:false)
		credits(max:new BigDecimal("9999999.99"),nullable:false)
		payments(max:new BigDecimal("9999999.99"),nullable:false)
		adjustments(max:new BigDecimal("9999999.99"),nullable:false)
		discDate(nullable:false)
		discCentury(max:99,nullable:false)
		discAmount(max:new BigDecimal("99999.99"),nullable:false)
		beginBalance(max:new BigDecimal("9999999.99"),nullable:false)
		payments2(max:new BigDecimal("9999999.99"),nullable:false)
		creditsAdjusts(max:new BigDecimal("9999999.99"),nullable:false)
		addedCode(maxSize:1,nullable:false)
	}
	static final boolean ASSIGNED_KEY = true
	static final boolean COMPOSITE_KEY  = true
	static mapping = {
		table (name:'arbsum',schema:CH.config.accounting.schema)
		version (false)
		id (generator:'assigned')
		id (composite:['compCode','custNo','refNo'])
		columns {
			id (composite:['compCode','custNo','refNo'])
			compCode (column:'BCOMP', type:'string')
			custNo (column:'BCUST', type:'string')
			refNo (column:'BREFN', type:'string')
			transDate (column:'BDATE', type:'DateYYMMDDUserType')
			transCentury (column:'BCENT', type:'int')
			charges (column:'BTCHG', type:'big_decimal')
			credits (column:'BTCRD', type:'big_decimal')
			payments (column:'BTPMT', type:'big_decimal')
			adjustments (column:'BTADJ', type:'big_decimal')
			discDate (column:'BDDAT', type:'DateYYMMDDUserType')
			discCentury (column:'BDDCN', type:'int')
			discAmount (column:'BDAMT', type:'big_decimal')
			beginBalance (column:'BBBAL', type:'big_decimal')
			payments2 (column:'BPMTS', type:'big_decimal')
			creditsAdjusts (column:'BADJS', type:'big_decimal')
			addedCode (column:'BADCD', type:'string')
		}
	}
	boolean newEntity = false
	static transients = ['newEntity']
}
