package com.kettler.domain.orderentry
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

class SalesTermsTier implements Serializable {
	String compCode
	String salesDivision
	String salesGroup
	int tier
	int amount
	String termsCode
	int amountShow
	String termsCodeShow
	static constraints = {
		compCode(maxSize:2,nullable:false)
		salesDivision(maxSize:1,nullable:false)
		salesGroup(maxSize:3,nullable:false)
		tier(max:99,nullable:false)
		amount(max:9999999,nullable:false)
		termsCode(maxSize:3,nullable:false)
		amountShow(max:9999999,nullable:false)
		termsCodeShow(maxSize:3,nullable:false)
	}
	static final boolean ASSIGNED_KEY = true
	static final boolean COMPOSITE_KEY  = true
	static mapping = {
		table (name:'oetier',schema:CH.config.orderentry.schema)
		version (false)
		id (generator:'assigned')
		id (composite:['compCode','salesDivision','salesGroup','tier'])
		columns {
			id (composite:['compCode','salesDivision','salesGroup','tier'])
			compCode (column:'TCOMP', type:'string')
			salesDivision (column:'TSDIV', type:'string')
			salesGroup (column:'TSGRP', type:'string')
			tier (column:'TTIER', type:'int')
			amount (column:'TAMT', type:'int')
			termsCode (column:'TTRMC', type:'string')
			amountShow (column:'TSAMT', type:'int')
			termsCodeShow (column:'TSTRMC', type:'string')
		}
	}
	static String getTermByTier(String compCode, String salesDivision, String salesGroup, BigDecimal orderTotal) {
		return SalesTermsTier.getTier(compCode, salesDivision, salesGroup, orderTotal)?.termsCode
	}
	static SalesTermsTier getTier(String compCode, String salesDivision, String salesGroup, BigDecimal orderTotal) {
		def tiers = SalesTermsTier.withCriteria() { 
	        eq('compCode',		compCode)
	        eq('salesDivision', salesDivision)
	        eq('salesGroup', 	salesGroup)
	        ge('amount', 		orderTotal.intValue())
            order('amount', 'asc')
	    }
		if (!tiers) { // try with blank salesGroup
			tiers = SalesTermsTier.withCriteria() { 
		        eq('compCode',		compCode)
		        eq('salesDivision', salesDivision)
		        eq('salesGroup', 	'') 
		        ge('amount', 		orderTotal.intValue())
	            order('amount', 'asc')
		    }
		}
		if (!tiers) {
			return null
		}
		
		return tiers[0] 
	}
	static SalesTermsTier getNextTier(String compCode, String salesDivision, String salesGroup, BigDecimal orderTotal) {
		def tiers = SalesTermsTier.withCriteria() { 
	        eq('compCode',		compCode)
	        eq('salesDivision', salesDivision)
	        eq('salesGroup', 	salesGroup)
	        ge('amount', 		orderTotal.intValue())
            order('amount', 'asc')
	    }
		if (!tiers) { // try with blank salesGroup
			tiers = SalesTermsTier.withCriteria() { 
		        eq('compCode',		compCode)
		        eq('salesDivision', salesDivision)
		        eq('salesGroup', 	'') 
		        ge('amount', 		orderTotal.intValue())
	            order('amount', 'asc')
		    }
		}
		if (tiers && tiers.size() > 1) {
			return tiers[1]
		}
		return null
	}
			
	
	boolean newEntity = false
	static transients = ['newEntity']
}
