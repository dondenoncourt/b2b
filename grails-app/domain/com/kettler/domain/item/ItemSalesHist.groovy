package com.kettler.domain.item
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

class ItemSalesHist implements Serializable {
	String compCode
	String itemNo
	String warehouse
	int century
	int year
	String profitCenterClass
	String productGroupClass
	String articleGroupClass
	int timesSold1
	int timesSold2
	int timesSold3
	int timesSold4
	int timesSold5
	int timesSold6
	int timesSold7
	int timesSold8
	int timesSold9
	int timesSold10
	int timesSold11
	int timesSold12
	Long salesQty1
	Long salesQty2
	Long salesQty3
	Long salesQty4
	Long salesQty5
	Long salesQty6
	Long salesQty7
	Long salesQty8
	Long salesQty9
	Long salesQty10
	Long salesQty11
	Long salesQty12
	BigDecimal salesAmt1
	BigDecimal salesAmt2
	BigDecimal salesAmt3
	BigDecimal salesAmt4
	BigDecimal salesAmt5
	BigDecimal salesAmt6
	BigDecimal salesAmt7
	BigDecimal salesAmt8
	BigDecimal salesAmt9
	BigDecimal salesAmt10
	BigDecimal salesAmt11
	BigDecimal salesAmt12
	BigDecimal salesCost1
	BigDecimal salesCost2
	BigDecimal salesCost3
	BigDecimal salesCost4
	BigDecimal salesCost5
	BigDecimal salesCost6
	BigDecimal salesCost7
	BigDecimal salesCost8
	BigDecimal salesCost9
	BigDecimal salesCost10
	BigDecimal salesCost11
	BigDecimal salesCost12
	Long transferToStoreQty1
	Long transferToStoreQty2
	Long transferToStoreQty3
	Long transferToStoreQty4
	Long transferToStoreQty5
	Long transferToStoreQty6
	Long transferToStoreQty7
	Long transferToStoreQty8
	Long transferToStoreQty9
	Long transferToStoreQty10
	Long transferToStoreQty11
	Long transferToStoreQty12
	static constraints = {
		compCode(maxSize:2,nullable:false)
		itemNo(maxSize:15,nullable:false)
		warehouse(maxSize:3,nullable:false)
		century(max:99,nullable:false)
		year(max:99,nullable:false)
		profitCenterClass(maxSize:1,nullable:false)
		productGroupClass(maxSize:3,nullable:false)
		articleGroupClass(maxSize:3,nullable:false)
		timesSold1(max:99999,nullable:false)
		timesSold2(max:99999,nullable:false)
		timesSold3(max:99999,nullable:false)
		timesSold4(max:99999,nullable:false)
		timesSold5(max:99999,nullable:false)
		timesSold6(max:99999,nullable:false)
		timesSold7(max:99999,nullable:false)
		timesSold8(max:99999,nullable:false)
		timesSold9(max:99999,nullable:false)
		timesSold10(max:99999,nullable:false)
		timesSold11(max:99999,nullable:false)
		timesSold12(max:99999,nullable:false)
		salesQty1(max:99999999999,nullable:false)
		salesQty2(max:99999999999,nullable:false)
		salesQty3(max:99999999999,nullable:false)
		salesQty4(max:99999999999,nullable:false)
		salesQty5(max:99999999999,nullable:false)
		salesQty6(max:99999999999,nullable:false)
		salesQty7(max:99999999999,nullable:false)
		salesQty8(max:99999999999,nullable:false)
		salesQty9(max:99999999999,nullable:false)
		salesQty10(max:99999999999,nullable:false)
		salesQty11(max:99999999999,nullable:false)
		salesQty12(max:99999999999,nullable:false)
		salesAmt1(max:new BigDecimal("9999999.99"),nullable:false)
		salesAmt2(max:new BigDecimal("9999999.99"),nullable:false)
		salesAmt3(max:new BigDecimal("9999999.99"),nullable:false)
		salesAmt4(max:new BigDecimal("9999999.99"),nullable:false)
		salesAmt5(max:new BigDecimal("9999999.99"),nullable:false)
		salesAmt6(max:new BigDecimal("9999999.99"),nullable:false)
		salesAmt7(max:new BigDecimal("9999999.99"),nullable:false)
		salesAmt8(max:new BigDecimal("9999999.99"),nullable:false)
		salesAmt9(max:new BigDecimal("9999999.99"),nullable:false)
		salesAmt10(max:new BigDecimal("9999999.99"),nullable:false)
		salesAmt11(max:new BigDecimal("9999999.99"),nullable:false)
		salesAmt12(max:new BigDecimal("9999999.99"),nullable:false)
		salesCost1(max:new BigDecimal("9999999.99"),nullable:false)
		salesCost2(max:new BigDecimal("9999999.99"),nullable:false)
		salesCost3(max:new BigDecimal("9999999.99"),nullable:false)
		salesCost4(max:new BigDecimal("9999999.99"),nullable:false)
		salesCost5(max:new BigDecimal("9999999.99"),nullable:false)
		salesCost6(max:new BigDecimal("9999999.99"),nullable:false)
		salesCost7(max:new BigDecimal("9999999.99"),nullable:false)
		salesCost8(max:new BigDecimal("9999999.99"),nullable:false)
		salesCost9(max:new BigDecimal("9999999.99"),nullable:false)
		salesCost10(max:new BigDecimal("9999999.99"),nullable:false)
		salesCost11(max:new BigDecimal("9999999.99"),nullable:false)
		salesCost12(max:new BigDecimal("9999999.99"),nullable:false)
		transferToStoreQty1(max:99999999999,nullable:false)
		transferToStoreQty2(max:99999999999,nullable:false)
		transferToStoreQty3(max:99999999999,nullable:false)
		transferToStoreQty4(max:99999999999,nullable:false)
		transferToStoreQty5(max:99999999999,nullable:false)
		transferToStoreQty6(max:99999999999,nullable:false)
		transferToStoreQty7(max:99999999999,nullable:false)
		transferToStoreQty8(max:99999999999,nullable:false)
		transferToStoreQty9(max:99999999999,nullable:false)
		transferToStoreQty10(max:99999999999,nullable:false)
		transferToStoreQty11(max:99999999999,nullable:false)
		transferToStoreQty12(max:99999999999,nullable:false)
	}
	static final boolean ASSIGNED_KEY = true
	static final boolean COMPOSITE_KEY  = true
	static mapping = {
		table (name:'inshst',schema:CH.config.inventory.schema)
		version (false)
		id (generator:'assigned')
		id (composite:['compCode','itemNo','warehouse','century','year'])
		columns {
			id (composite:['compCode','itemNo','warehouse','century','year'])
			compCode (column:'HCOMP', type:'string')
			itemNo (column:'HITEM', type:'string')
			warehouse (column:'HWHSE', type:'string')
			century (column:'HCENT', type:'int')
			year (column:'HYEAR', type:'int')
			profitCenterClass (column:'HCLAS1', type:'string')
			productGroupClass (column:'HCLAS2', type:'string')
			articleGroupClass (column:'HCLAS3', type:'string')
			timesSold1 (column:'TMS01', type:'int')
			timesSold2 (column:'TMS02', type:'int')
			timesSold3 (column:'TMS03', type:'int')
			timesSold4 (column:'TMS04', type:'int')
			timesSold5 (column:'TMS05', type:'int')
			timesSold6 (column:'TMS06', type:'int')
			timesSold7 (column:'TMS07', type:'int')
			timesSold8 (column:'TMS08', type:'int')
			timesSold9 (column:'TMS09', type:'int')
			timesSold10 (column:'TMS10', type:'int')
			timesSold11 (column:'TMS11', type:'int')
			timesSold12 (column:'TMS12', type:'int')
			salesQty1 (column:'QTY01', type:'long')
			salesQty2 (column:'QTY02', type:'long')
			salesQty3 (column:'QTY03', type:'long')
			salesQty4 (column:'QTY04', type:'long')
			salesQty5 (column:'QTY05', type:'long')
			salesQty6 (column:'QTY06', type:'long')
			salesQty7 (column:'QTY07', type:'long')
			salesQty8 (column:'QTY08', type:'long')
			salesQty9 (column:'QTY09', type:'long')
			salesQty10 (column:'QTY10', type:'long')
			salesQty11 (column:'QTY11', type:'long')
			salesQty12 (column:'QTY12', type:'long')
			salesAmt1 (column:'AMT01', type:'big_decimal')
			salesAmt2 (column:'AMT02', type:'big_decimal')
			salesAmt3 (column:'AMT03', type:'big_decimal')
			salesAmt4 (column:'AMT04', type:'big_decimal')
			salesAmt5 (column:'AMT05', type:'big_decimal')
			salesAmt6 (column:'AMT06', type:'big_decimal')
			salesAmt7 (column:'AMT07', type:'big_decimal')
			salesAmt8 (column:'AMT08', type:'big_decimal')
			salesAmt9 (column:'AMT09', type:'big_decimal')
			salesAmt10 (column:'AMT10', type:'big_decimal')
			salesAmt11 (column:'AMT11', type:'big_decimal')
			salesAmt12 (column:'AMT12', type:'big_decimal')
			salesCost1 (column:'CST01', type:'big_decimal')
			salesCost2 (column:'CST02', type:'big_decimal')
			salesCost3 (column:'CST03', type:'big_decimal')
			salesCost4 (column:'CST04', type:'big_decimal')
			salesCost5 (column:'CST05', type:'big_decimal')
			salesCost6 (column:'CST06', type:'big_decimal')
			salesCost7 (column:'CST07', type:'big_decimal')
			salesCost8 (column:'CST08', type:'big_decimal')
			salesCost9 (column:'CST09', type:'big_decimal')
			salesCost10 (column:'CST10', type:'big_decimal')
			salesCost11 (column:'CST11', type:'big_decimal')
			salesCost12 (column:'CST12', type:'big_decimal')
			transferToStoreQty1 (column:'RSQ01', type:'long')
			transferToStoreQty2 (column:'RSQ02', type:'long')
			transferToStoreQty3 (column:'RSQ03', type:'long')
			transferToStoreQty4 (column:'RSQ04', type:'long')
			transferToStoreQty5 (column:'RSQ05', type:'long')
			transferToStoreQty6 (column:'RSQ06', type:'long')
			transferToStoreQty7 (column:'RSQ07', type:'long')
			transferToStoreQty8 (column:'RSQ08', type:'long')
			transferToStoreQty9 (column:'RSQ09', type:'long')
			transferToStoreQty10 (column:'RSQ10', type:'long')
			transferToStoreQty11 (column:'RSQ11', type:'long')
			transferToStoreQty12 (column:'RSQ12', type:'long')
		}
	}
	List getTimesSold() {
		List timesSold = []
		(1..12).each {i -> timesSold << this."timesSold$i" }
		return timesSold
	}
	List getSalesQty() {
		List salesQty = []
		(1..12).each {i -> salesQty << this."salesQty$i" }
		return salesQty
	}
	List getSalesAmt() {
		List salesAmt = []
		(1..12).each {i -> salesAmt << this."salesAmt$i" }
		return salesAmt
	}
	List getSalesCost() {
		List salesCost = []
		(1..12).each {i -> salesCost << this."salesCost$i" }
		return salesCost
	}
	List getTransferToStoreQty() {
		List transferToStoreQty = []
		(1..12).each {i -> transferToStoreQty << this."transferToStoreQty$i" }
		return transferToStoreQty
	}

	int getTotalTimesSold() {
		int total = 0
		(1..12).each {i -> total += this."timesSold$i" }
		return total
	}
	int getTotalSalesQty() {
		int total = 0
		(1..12).each {i -> total += this."salesQty$i" }
		return total
	}
	BigDecimal getTotalSalesAmt() {
		BigDecimal total = 0.0g
		(1..12).each {i -> total += this."salesAmt$i" }
		return total
	}
	BigDecimal getTotalSalesCost() {
		BigDecimal total = 0.0g
		(1..12).each {i -> total += this."salesCost$i" }
		return total
	}
	int getTotalTransferToStoreQty() {
		int total = 0
		(1..12).each {i -> total += this."transferToStoreQty$i" }
		return total
	}
	
	
	boolean newEntity = false
	static transients = ['newEntity', 'timesSold', 'salesQty', 'salesAmt', 'salesCost', 'transferToStoreQty',
	                     'totalTimesSold', 'totalSalesQty', 'totalSalesAmt', 'totalSalesCost', 'totalTransferToStoreQty']
}
