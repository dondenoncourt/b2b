package com.kettler.domain.purchasing

import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

class PurchaseOrderHeader implements Serializable {
	String compCode
	int orderNo
	int releaseNo
	int lineNo
	String statusCode
	String orderType
	String vendorNo
	int shipToNo
	Date orderDate
	Date thruRequiredDate
	Date deliveryDate
	String warehouse
	String shipVia
	String fobPoint
	String termsCode
	String buyerCode
	BigDecimal orderDiscPct
	String whsRecCode
	Date receiptDate
	Date invoiceDateMDY
	String invoiceNo
	int shipNo
	Date fromRequiredDate
	String custNo
	String containerNo
	String vesselName
	String portName
	String bookingRef
	Date etaDate
	String receivedBy
	String scacCode
	String shipTermsCode
	String shipTermsLocn
	Date doorDate
	String costCurrencyCode
	String lcNoOrWireNo
	String bankCode
	int expensePeriod
	Date dueDate
	Date discDate
	BigDecimal discPercent
	BigDecimal discAmount
	BigDecimal prepaidDiscPct
	BigDecimal prepayAmount
	BigDecimal prepaidAmount
	BigDecimal prepaidDiscAmt
	int shipNo2
	Date invoiceDate
	String authorizedBy
	static constraints = {
		compCode(maxSize:2,nullable:false)
		orderNo(max:99999,nullable:false)
		releaseNo(max:99,nullable:false)
		lineNo(max:9999,nullable:false)
		statusCode(maxSize:1,nullable:false)
		orderType(maxSize:1,nullable:false)
		vendorNo(maxSize:7,nullable:false)
		shipToNo(max:999,nullable:false)
		warehouse(maxSize:3,nullable:false)
		shipVia(maxSize:15,nullable:false)
		fobPoint(maxSize:2,nullable:false)
		termsCode(maxSize:2,nullable:false)
		buyerCode(maxSize:3,nullable:false)
		orderDiscPct(max:new BigDecimal("99.99"),nullable:false)
		whsRecCode(maxSize:1,nullable:false)
		invoiceNo(maxSize:12,nullable:false)
		shipNo(max:99,nullable:false)
		custNo(maxSize:7,nullable:false)
		containerNo(maxSize:15,nullable:false)
		vesselName(maxSize:20,nullable:false)
		portName(maxSize:20,nullable:false)
		bookingRef(maxSize:15,nullable:false)
		receivedBy(maxSize:10,nullable:false)
		scacCode(maxSize:4,nullable:false)
		shipTermsCode(maxSize:3,nullable:false)
		shipTermsLocn(maxSize:20,nullable:false)
		costCurrencyCode(maxSize:3,nullable:false)
		lcNoOrWireNo(maxSize:15,nullable:false)
		bankCode(maxSize:2,nullable:false)
		expensePeriod(max:9999,nullable:false)
		discPercent(max:new BigDecimal("99.99"),nullable:false)
		discAmount(max:new BigDecimal("99999.99"),nullable:false)
		prepaidDiscPct(max:new BigDecimal("99.99"),nullable:false)
		prepayAmount(max:new BigDecimal("9999999.99"),nullable:false)
		prepaidAmount(max:new BigDecimal("9999999.99"),nullable:false)
		prepaidDiscAmt(max:new BigDecimal("9999999.99"),nullable:false)
		shipNo2(max:99,nullable:false)
		authorizedBy(maxSize:10,nullable:false)
	}
	static final boolean ASSIGNED_KEY = true
	static final boolean COMPOSITE_KEY  = true
	static mapping = {
		table name:'poordh', schema:CH.config.purchasing.schema
		version (false)
		id (generator:'assigned')
		id (composite:['compCode','orderNo','releaseNo','lineNo'])
		columns {
			id (composite:['compCode','orderNo','releaseNo','lineNo'])
			compCode (column:'OCOMP', type:'string')
			orderNo (column:'OORDN', type:'int')
			releaseNo (column:'ORELN', type:'int')
			lineNo (column:'OSEQN', type:'int')
			statusCode (column:'OSTAT', type:'string')
			orderType (column:'OORTYP', type:'string')
			vendorNo (column:'OVENDN', type:'string')
			shipToNo (column:'OSHPTO', type:'int')
			orderDate (column:'OORDDT', type:'DateMMDDYYUserType')
			thruRequiredDate (column:'OREQDT', type:'DateMMDDYYUserType')
			deliveryDate (column:'ODELDT', type:'DateMMDDYYUserType')
			warehouse (column:'OWHSE', type:'string')
			shipVia (column:'OSHVIA', type:'string')
			fobPoint (column:'OFPCOD', type:'string')
			termsCode (column:'OTMCOD', type:'string')
			buyerCode (column:'OBYCOD', type:'string')
			orderDiscPct (column:'OORDIS', type:'big_decimal')
			whsRecCode (column:'OWRCOD', type:'string')
			receiptDate (column:'ORECDT', type:'DateMMDDYYUserType')
			invoiceDateMDY (column:'OINVDT', type:'DateMMDDYYUserType')
			invoiceNo (column:'OINVNO', type:'string')
			shipNo (column:'OSHPNO', type:'int')
			fromRequiredDate (column:'OREQDF', type:'DateMMDDYYUserType')
			custNo (column:'OCUSTN', type:'string')
			containerNo (column:'OCONTR', type:'string')
			vesselName (column:'OVESSL', type:'string')
			portName (column:'OPORT', type:'string')
			bookingRef (column:'OBKREF', type:'string')
			etaDate (column:'OETADT', type:'DateMMDDYYUserType')
			receivedBy (column:'ORECBY', type:'string')
			scacCode (column:'OSVCOD', type:'string')
			shipTermsCode (column:'OINCO', type:'string')
			shipTermsLocn (column:'OSHLOC', type:'string')
			doorDate (column:'ODORDT', type:'DateMMDDYYUserType')
			costCurrencyCode (column:'OCCUR', type:'string')
			lcNoOrWireNo (column:'OLCNO', type:'string')
			bankCode (column:'OBNKCD', type:'string')
			expensePeriod (column:'OEXPER', type:'int')
			dueDate (column:'ODUEDT', type:'DateMMDDYYUserType')
			discDate (column:'ODISDT', type:'DateMMDDYYUserType')
			discPercent (column:'ODISCP', type:'big_decimal')
			discAmount (column:'ODISCA', type:'big_decimal')
			prepaidDiscPct (column:'OPDISC', type:'big_decimal')
			prepayAmount (column:'OPAMNT', type:'big_decimal')
			prepaidAmount (column:'OPPAMT', type:'big_decimal')
			prepaidDiscAmt (column:'OPPDIS', type:'big_decimal')
			shipNo2 (column:'OSHPN', type:'int')
			invoiceDate (column:'OINYMD', type:'DateYYMMDDUserType')
			authorizedBy (column:'OAUTH', type:'string')
		}
	}
	boolean newEntity = false
	static transients = ['newEntity']
}