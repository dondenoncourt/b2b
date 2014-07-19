package com.kettler.domain.varsity
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

class Country implements Serializable {
	String id
	String desc
	String isoCode
	String isoNumericCntryCd
	String phoneCountryCode
	String phoneNumberMask
	String scheduleC
	String proscribedY_n
	String defaultCurrency
	String naftaY_n
	String termsOfTradeReqQuestion
	String invoiceNoRequiredQuestion
	String allowDdpToQuestion
	String allowDdpFromQuestion
	String allowDduQuestion
	String allowDvuQuestion
	String allowNdsQuestion
	String postalCodeFormat1
	int noOfCharsToCheck1
	String postalCodeFormat2
	int noOfCharsToCheck2
	String postalCodeFormat3
	int noOfCharsToCheck3
	String postalCodeFormat4
	int noOfCharsToCheck4
	String postalCodeFormat5
	int noOfCharsToCheck5
	String postalCodeFormat6
	int noOfCharsToCheck6
	String postalCodeFormat7
	int noOfCharsToCheck7
	String postalCodeFormat8
	int noOfCharsToCheck8
	String postalCodeFormat9
	int noOfCharsToCheck9
	String postalCodeFormat10
	int noOfCharsToCheck10
	String reservedAlphaA
	String reservedAlphaB
	String reservedAlphaC
	String reservedAlphaD
	String reservedAlphaE
	Long reservedNumeric1
	Long reservedNumeric2
	BigDecimal reservedNumeric3
	BigDecimal reservedNumeric4
	String lastChgUser
	int lastChgTime
	int lastChgDate
	String lastChgDspStn
	static constraints = {
		desc(maxSize:35,nullable:false)
		isoCode(maxSize:3,nullable:false)
		isoNumericCntryCd(maxSize:3,nullable:false)
		phoneCountryCode(maxSize:3,nullable:false)
		phoneNumberMask(maxSize:25,nullable:false)
		scheduleC(maxSize:4,nullable:false)
		proscribedY_n(maxSize:1,nullable:false)
		defaultCurrency(maxSize:3,nullable:false)
		naftaY_n(maxSize:1,nullable:false)
		termsOfTradeReqQuestion(maxSize:1,nullable:false)
		invoiceNoRequiredQuestion(maxSize:1,nullable:false)
		allowDdpToQuestion(maxSize:1,nullable:false)
		allowDdpFromQuestion(maxSize:1,nullable:false)
		allowDduQuestion(maxSize:1,nullable:false)
		allowDvuQuestion(maxSize:1,nullable:false)
		allowNdsQuestion(maxSize:1,nullable:false)
		postalCodeFormat1(maxSize:12,nullable:false)
		noOfCharsToCheck1(max:99,nullable:false)
		postalCodeFormat2(maxSize:12,nullable:false)
		noOfCharsToCheck2(max:99,nullable:false)
		postalCodeFormat3(maxSize:12,nullable:false)
		noOfCharsToCheck3(max:99,nullable:false)
		postalCodeFormat4(maxSize:12,nullable:false)
		noOfCharsToCheck4(max:99,nullable:false)
		postalCodeFormat5(maxSize:12,nullable:false)
		noOfCharsToCheck5(max:99,nullable:false)
		postalCodeFormat6(maxSize:12,nullable:false)
		noOfCharsToCheck6(max:99,nullable:false)
		postalCodeFormat7(maxSize:12,nullable:false)
		noOfCharsToCheck7(max:99,nullable:false)
		postalCodeFormat8(maxSize:12,nullable:false)
		noOfCharsToCheck8(max:99,nullable:false)
		postalCodeFormat9(maxSize:12,nullable:false)
		noOfCharsToCheck9(max:99,nullable:false)
		postalCodeFormat10(maxSize:12,nullable:false)
		noOfCharsToCheck10(max:99,nullable:false)
		reservedAlphaA(maxSize:30,nullable:false)
		reservedAlphaB(maxSize:30,nullable:false)
		reservedAlphaC(maxSize:30,nullable:false)
		reservedAlphaD(maxSize:30,nullable:false)
		reservedAlphaE(maxSize:30,nullable:false)
		reservedNumeric1(max:999999999999,nullable:false)
		reservedNumeric2(max:999999999999,nullable:false)
		reservedNumeric3(max:new BigDecimal("999999999999.9999"),nullable:false)
		reservedNumeric4(max:new BigDecimal("999999999999.9999"),nullable:false)
		lastChgUser(maxSize:10,nullable:false)
		lastChgTime(max:999999,nullable:false)
		lastChgDate(max:99999999,nullable:false)
		lastChgDspStn(maxSize:10,nullable:false)
	}
	static final boolean ASSIGNED_KEY = true
	static final boolean COMPOSITE_KEY  = false
	static mapping = {
		table (name:'exctry',schema:CH.config.varsity.schema)
		version (false)
		id (generator:'assigned')
		columns {
			id (column:'CTCCDE',type:'TrimString')
			desc (column:'CTDESC', type:'TrimString')
			isoCode (column:'CTAICC', type:'TrimString')
			isoNumericCntryCd (column:'CTNMCC', type:'TrimString')
			phoneCountryCode (column:'CTPHCC', type:'TrimString')
			phoneNumberMask (column:'CTPMSK', type:'TrimString')
			scheduleC (column:'CTSCHC', type:'TrimString')
			proscribedY_n (column:'CTPROS', type:'TrimString')
			defaultCurrency (column:'CTCURR', type:'TrimString')
			naftaY_n (column:'CTNAFT', type:'TrimString')
			termsOfTradeReqQuestion (column:'CTTRMR', type:'TrimString')
			invoiceNoRequiredQuestion (column:'CTINVR', type:'TrimString')
			allowDdpToQuestion (column:'CTDDPT', type:'TrimString')
			allowDdpFromQuestion (column:'CTDDPF', type:'TrimString')
			allowDduQuestion (column:'CTDDU', type:'TrimString')
			allowDvuQuestion (column:'CTDVU', type:'TrimString')
			allowNdsQuestion (column:'CTNDS', type:'TrimString')
			postalCodeFormat1 (column:'CTPOF1', type:'TrimString')
			noOfCharsToCheck1 (column:'CTSIG1', type:'int')
			postalCodeFormat2 (column:'CTPOF2', type:'TrimString')
			noOfCharsToCheck2 (column:'CTSIG2', type:'int')
			postalCodeFormat3 (column:'CTPOF3', type:'TrimString')
			noOfCharsToCheck3 (column:'CTSIG3', type:'int')
			postalCodeFormat4 (column:'CTPOF4', type:'TrimString')
			noOfCharsToCheck4 (column:'CTSIG4', type:'int')
			postalCodeFormat5 (column:'CTPOF5', type:'TrimString')
			noOfCharsToCheck5 (column:'CTSIG5', type:'int')
			postalCodeFormat6 (column:'CTPOF6', type:'TrimString')
			noOfCharsToCheck6 (column:'CTSIG6', type:'int')
			postalCodeFormat7 (column:'CTPOF7', type:'TrimString')
			noOfCharsToCheck7 (column:'CTSIG7', type:'int')
			postalCodeFormat8 (column:'CTPOF8', type:'TrimString')
			noOfCharsToCheck8 (column:'CTSIG8', type:'int')
			postalCodeFormat9 (column:'CTPOF9', type:'TrimString')
			noOfCharsToCheck9 (column:'CTSIG9', type:'int')
			postalCodeFormat10 (column:'CTPOF0', type:'TrimString')
			noOfCharsToCheck10 (column:'CTSIG0', type:'int')
			reservedAlphaA (column:'CTRSVA', type:'TrimString')
			reservedAlphaB (column:'CTRSVB', type:'TrimString')
			reservedAlphaC (column:'CTRSVC', type:'TrimString')
			reservedAlphaD (column:'CTRSVD', type:'TrimString')
			reservedAlphaE (column:'CTRSVE', type:'TrimString')
			reservedNumeric1 (column:'CTRSV1', type:'long')
			reservedNumeric2 (column:'CTRSV2', type:'long')
			reservedNumeric3 (column:'CTRSV3', type:'big_decimal')
			reservedNumeric4 (column:'CTRSV4', type:'big_decimal')
			lastChgUser (column:'CTUSER', type:'TrimString')
			lastChgTime (column:'CTCHGT', type:'int')
			lastChgDate (column:'CTCHGD', type:'int')
			lastChgDspStn (column:'CTDSTN', type:'TrimString')
		}
	}
	boolean newEntity = false
	static transients = ['isoCountryCode', 'newEntity']
	def getIsoCountryCode() {
		if (id) return id
		return 
	}
	void setIsoCountryCode (def vlu) { id = vlu }
	static List listUsaCanFirst() {
		def list = []
		list << Country.findByIsoCode('USA')
		list << Country.findByIsoCode('CAN')
		Country.listOrderByDesc().each {country ->
			if (!(['USA', 'CAN'].find {it == country.isoCode}) ) {
				list << country
			}
		}
		return list
	}
}
