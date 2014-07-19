package com.kettler.domain.orderentry
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

import com.kettler.domain.work.DateUtils

class ContractPrice implements Serializable {
	String compCode
	String custNo
	String itemNo
	int beginCentury
	Date beginDate
	int expireCentury
	Date expireDate
	String comments
	String qtyUnitMeasCode
	int thruQty1
	int thruQty2
	int thruQty3
	int thruQty4
	int thruQty5
	int thruQty6
	int thruQty7
	BigDecimal unitPrice1
	BigDecimal unitPrice2
	BigDecimal unitPrice3
	BigDecimal unitPrice4
	BigDecimal unitPrice5
	BigDecimal unitPrice6
	BigDecimal unitPrice7
	static constraints = {
		compCode(maxSize:2,nullable:false)
		custNo(maxSize:7,nullable:false)
		itemNo(maxSize:15,nullable:false)
		beginCentury(max:99,nullable:false)
		beginDate(nullable:false)
		expireCentury(max:99,nullable:false)
		expireDate(nullable:false)
		comments(maxSize:15,nullable:false)
		qtyUnitMeasCode(maxSize:1,nullable:false)
		thruQty1(max:99999,nullable:false)
		thruQty2(max:99999,nullable:false)
		thruQty3(max:99999,nullable:false)
		thruQty4(max:99999,nullable:false)
		thruQty5(max:99999,nullable:false)
		thruQty6(max:99999,nullable:false)
		thruQty7(max:99999,nullable:false)
		unitPrice1(max:new BigDecimal("999999.999"),nullable:false)
		unitPrice2(max:new BigDecimal("999999.999"),nullable:false)
		unitPrice3(max:new BigDecimal("999999.999"),nullable:false)
		unitPrice4(max:new BigDecimal("999999.999"),nullable:false)
		unitPrice5(max:new BigDecimal("999999.999"),nullable:false)
		unitPrice6(max:new BigDecimal("999999.999"),nullable:false)
		unitPrice7(max:new BigDecimal("999999.999"),nullable:false)
	}
	static final boolean ASSIGNED_KEY = true
	static final boolean COMPOSITE_KEY  = true
	static mapping = {
		table (name:'oecprc',schema:CH.config.orderentry.schema)
		version (false)
		id (generator:'assigned')
		id (composite:['compCode','custNo','itemNo'])
		columns {
			id (composite:['compCode','custNo','itemNo'])
			compCode (column:'CPCOMP', type:'string')
			custNo (column:'CPCUST', type:'string')
			itemNo (column:'CPITEM', type:'string')
			beginCentury (column:'CPBCNT', type:'int')
			beginDate (column:'CPBDAT', type:'DateMMDDYYUserType')
			expireCentury (column:'CPECNT', type:'int')
			expireDate (column:'CPEDAT', type:'DateMMDDYYUserType')
			comments (column:'CPCOMT', type:'string')
			qtyUnitMeasCode (column:'CPQUMC', type:'string')
			thruQty1 (column:'CPQTY1', type:'int')
			thruQty2 (column:'CPQTY2', type:'int')
			thruQty3 (column:'CPQTY3', type:'int')
			thruQty4 (column:'CPQTY4', type:'int')
			thruQty5 (column:'CPQTY5', type:'int')
			thruQty6 (column:'CPQTY6', type:'int')
			thruQty7 (column:'CPQTY7', type:'int')
			unitPrice1 (column:'CPPRC1', type:'big_decimal')
			unitPrice2 (column:'CPPRC2', type:'big_decimal')
			unitPrice3 (column:'CPPRC3', type:'big_decimal')
			unitPrice4 (column:'CPPRC4', type:'big_decimal')
			unitPrice5 (column:'CPPRC5', type:'big_decimal')
			unitPrice6 (column:'CPPRC6', type:'big_decimal')
			unitPrice7 (column:'CPPRC7', type:'big_decimal')
		}
	}
	boolean newEntity = false
	static transients = ['newEntity']

	static List getItemNosForCust(String compCode, String custNo) {
		return ContractPrice.executeQuery('select itemNo from ContractPrice cp where cp.compCode = ? and  cp.custNo = ?' +
			' AND ? BETWEEN mod((cp.beginDate * 10000.01), 1000000) AND mod((cp.expireDate * 10000.01), 1000000) ',
			compCode, custNo, DateUtils.getNowYMD())
	}

	static boolean inEffectForCust(String compCode, String custNo) {
		def gotSome = ContractPrice.executeQuery('from ContractPrice cp where cp.compCode = ? and cp.custNo = ?' +
			' AND ? BETWEEN mod((cp.beginDate * 10000.01), 1000000) AND mod((cp.expireDate * 10000.01), 1000000) ',
			compCode, custNo, DateUtils.getNowYMD())
		return gotSome?.size()
	}
	
}

