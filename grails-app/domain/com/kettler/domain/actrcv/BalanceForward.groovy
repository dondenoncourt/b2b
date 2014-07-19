package com.kettler.domain.actrcv
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

class BalanceForward implements Serializable {
	String type
	String compCode
	String custNo
	String refNo
	BigDecimal amount
	int signCode
	int tranDateMDY // see tranDate which is YMD
	int tranCentury
	Date agingDate
	int agingCentury
	String servChargeCode
	String agingCode
	String billCycle
	String comment
	String userCode1
	String userCode2
	String userCode3
	String salesperson
	int transDateCentury
	Date transDate // YMD
	String previousFutureCurrent
	int recNo
	static constraints = {
		version(nullable:false)
		type(maxSize:1,nullable:false)
		compCode(maxSize:2,nullable:false)
		custNo(maxSize:7,nullable:false)
		refNo(maxSize:7,nullable:false)
		amount(max:new BigDecimal("9999999.99"),nullable:false)
		signCode(max:9,nullable:false)
		tranDateMDY(max:999999,nullable:false)
		tranCentury(max:99,nullable:false)
		agingDate(nullable:false)
		agingCentury(max:99,nullable:false)
		servChargeCode(maxSize:1,nullable:false)
		agingCode(maxSize:1,nullable:false)
		billCycle(maxSize:1,nullable:false)
		comment(maxSize:20,nullable:false)
		userCode1(maxSize:3,nullable:false)
		userCode2(maxSize:3,nullable:false)
		userCode3(maxSize:3,nullable:false)
		salesperson(maxSize:3,nullable:false)
		transDateCentury(max:99,nullable:false)
		transDate(nullable:false)
		previousFutureCurrent(maxSize:1,nullable:false)
		recNo(max:9999999,nullable:false)
	}
	static mapping = {
		table (name:'arbalfwd',schema:CH.config.accounting.schema)
		columns {
			type (column:'TTYPE', type:'string')
			compCode (column:'TCOMP', type:'string')
			custNo (column:'TCUST', type:'string')
			refNo (column:'TREFN', type:'string')
			amount (column:'TAMNT', type:'big_decimal')
			signCode (column:'TSIGN', type:'int')
			tranDateMDY (column:'TSDATE', type:'int')
			tranCentury (column:'TSCENT', type:'int')
			agingDate (column:'TADATE', type:'DateMMDDYYUserType')
			agingCentury (column:'TACENT', type:'int')
			servChargeCode (column:'TSCCOD', type:'string')
			agingCode (column:'TAGECD', type:'string')
			billCycle (column:'TCYCLE', type:'string')
			comment (column:'TCOMT1', type:'string')
			userCode1 (column:'TUSER1', type:'string')
			userCode2 (column:'TUSER2', type:'string')
			userCode3 (column:'TUSER3', type:'string')
			salesperson (column:'TSPCOD', type:'string')
			transDateCentury (column:'TSDCNT', type:'int')
			transDate (column:'TSDYMD', type:'DateYYMMDDUserType')
			previousFutureCurrent (column:'TPCFCD', type:'string')
			recNo (column:'TRECNO', type:'int')
		}
	}
}
