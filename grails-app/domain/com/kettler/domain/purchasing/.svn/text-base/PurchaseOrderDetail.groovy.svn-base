package com.kettler.domain.purchasing
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

class PurchaseOrderDetail implements Serializable {
	String compCode
	int orderNo
	int releaseNo
	int lineNo
	String recordType
	String itemNo
	String desc
	String distrCode
	int orderQty
	String qtyUnitMeas
	BigDecimal orderWeight
	BigDecimal orderCost
	String costUnitMeas
	String convCode
	int convFactor
	BigDecimal itemDiscPct
	String discDistrCode
	BigDecimal orderAmount
	String backOrderCode
	int receiptQty
	BigDecimal receiptWeight
	BigDecimal receiptCost
	BigDecimal receiptAmount
	String serNoQtysCode
	String locnQtysCode
	String exceptionFlag
	String toString() {"$itemNo order:$orderNo:$lineNo, orderQty:$orderQty"}
	PurchaseOrderHeader getHeader() {
		return PurchaseOrderHeader.withCriteria(uniqueResult:true) {
			eq ('compCode', compCode)
			eq ('orderNo', orderNo)
			eq ('releaseNo', releaseNo)
		//	eq ('lineNo', lineNo) doesn't work, must not be used by KETTLER
		}
	}
	private void setHeader(def x) {/*not used*/}
	
	static constraints = {
		compCode(maxSize:2,nullable:false)
		orderNo(max:99999,nullable:false)
		releaseNo(max:99,nullable:false)
		lineNo(max:9999,nullable:false)
		recordType(maxSize:1,nullable:false)
		itemNo(maxSize:15,nullable:false)
		desc(maxSize:30,nullable:false)
		distrCode(maxSize:3,nullable:false)
		orderQty(max:9999999,nullable:false)
		qtyUnitMeas(maxSize:3,nullable:false)
		orderWeight(max:new BigDecimal("9999.999"),nullable:false)
		orderCost(max:new BigDecimal("999999.999"),nullable:false)
		costUnitMeas(maxSize:3,nullable:false)
		convCode(maxSize:1,nullable:false)
		convFactor(max:9999,nullable:false)
		itemDiscPct(max:new BigDecimal("99.99"),nullable:false)
		discDistrCode(maxSize:3,nullable:false)
		orderAmount(max:new BigDecimal("9999999.99"),nullable:false)
		backOrderCode(maxSize:1,nullable:false)
		receiptQty(max:9999999,nullable:false)
		receiptWeight(max:new BigDecimal("9999.999"),nullable:false)
		receiptCost(max:new BigDecimal("999999.999"),nullable:false)
		receiptAmount(max:new BigDecimal("9999999.99"),nullable:false)
		serNoQtysCode(maxSize:1,nullable:false)
		locnQtysCode(maxSize:1,nullable:false)
		exceptionFlag(maxSize:1,nullable:false)
	}
	static final boolean ASSIGNED_KEY = true
	static final boolean COMPOSITE_KEY  = true
	static mapping = {
		table name:'poord1', schema:CH.config.purchasing.schema
		version (false)
		id (generator:'assigned')
		id (composite:['compCode','orderNo','releaseNo','lineNo'])
		columns {
			id (composite:['compCode','orderNo','releaseNo','lineNo'])
			compCode (column:'OCOMP', type:'string')
			orderNo (column:'OORDN', type:'int')
			releaseNo (column:'ORELN', type:'int')
			lineNo (column:'OSEQN', type:'int')
			recordType (column:'OTYPE', type:'string')
			itemNo (column:'OITEM', type:'string')
			desc (column:'ODESC', type:'string')
			distrCode (column:'ODIST', type:'string')
			orderQty (column:'OQTYOR', type:'int')
			qtyUnitMeas (column:'OQUNM', type:'string')
			orderWeight (column:'OOWGHT', type:'big_decimal')
			orderCost (column:'OOCOST', type:'big_decimal')
			costUnitMeas (column:'OCUNM', type:'string')
			convCode (column:'OCONC', type:'string')
			convFactor (column:'OCONF', type:'int')
			itemDiscPct (column:'OIDISC', type:'big_decimal')
			discDistrCode (column:'ODDIST', type:'string')
			orderAmount (column:'OOAMNT', type:'big_decimal')
			backOrderCode (column:'OBOCOD', type:'string')
			receiptQty (column:'OQTYRC', type:'int')
			receiptWeight (column:'ORWGHT', type:'big_decimal')
			receiptCost (column:'ORCOST', type:'big_decimal')
			receiptAmount (column:'ORAMNT', type:'big_decimal')
			serNoQtysCode (column:'OSERQC', type:'string')
			locnQtysCode (column:'OLOCQC', type:'string')
			exceptionFlag (column:'OEXCFL', type:'string')
		}
	}
	boolean newEntity = false
	static transients = ['newEntity', 'header']
}
