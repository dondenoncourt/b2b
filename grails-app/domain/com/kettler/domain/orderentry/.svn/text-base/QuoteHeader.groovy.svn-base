package com.kettler.domain.orderentry
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

import com.kettler.domain.actrcv.share.Customer
import org.hibernate.type.CharBooleanType
import org.hibernate.type.YesNoType
import com.kettler.domain.work.DateUtils
import java.sql.Time

class QuoteHeader implements Serializable {
	String compCode = ''
	int orderNo = 0
	int shipNo = 0
	int lineNo = 0
	String statusCode = ' '   
	/*  D - deleted 
		R - release
	    ' '  New Quote
	    E - email
	    P - print	
	 */
	String custNo = ''
	int shipToNo = 0
	int orderCentury = 20
	Date orderDate = new Date()
	int pickCentury = 20
	Date pickDateMDY = new Date()
	String warehouse = '1  '
	String poNo = ''
	String shipVia = ''
	String termsCode = ''
	String salesperson1 = ''
	String salesperson2 = ''
	BigDecimal invoiceDiscPct = 0.0g
	String taxCode1 = ''
	String taxCode2 = ''
	String taxCode3 = ''
	BigDecimal taxPct1 = 0.0g
	BigDecimal taxPct2 = 0.0g
	BigDecimal taxPct3 = 0.0g
	BigDecimal orderTotal = 0.0g
	String jobIdCode = ''
	String enteredBy = ''
	Date dateCreated = new Date() // Note: Grails will set this on insert
	int timeEntered = DateUtils.getTime(new Date())
	String acknowledgement = 'N'
	String freightCode = ''
	String carrierCode = ''
	String fobCode = ''
	String shippedStatus = ''
	String shipInstructions = ''
	String specialChrgCd1 = ''
	String specialChrgCd2 = ''
	String specialChrgCd3 = ''
	int dueCentury = 0
	Date dueDate = DateUtils.getYearOne()
	boolean shipComplete = false
	String packingListCode = '01'
	String custRef1 = ''
	Date custRef1Date = DateUtils.getYearOne()
	String lastF_mPgmName = ''
	String lastF_mUserId = ''
	Date lastF_mDate = DateUtils.getYearOne()
	int lastF_mTime = 0
	Long shippingPhoneNo = 0
	String deletedBy = ''
	Date deletedDate = DateUtils.getYearOne()
	int deletedTime = 0
	String releaseBy = ''
	Date releaseDate = DateUtils.getYearOne()
	int releaseTime = 0
//	int releaseOrderNo = 0

	boolean splitTermsCode = false
	int splitTermsPct1 = 0
	int splitTermsPct2 = 0
	int splitTermsPct3 = 0
	String termsCode1 = ''
	String termsCode2 = ''
	String termsCode3 = ''
	int dueCentury1 = 0
	Date dueDate1 = DateUtils.getYearOne()
	int dueCentury2 = 0
	Date dueDate2 = DateUtils.getYearOne()
	int dueCentury3 = 0
	Date dueDate3 = DateUtils.getYearOne()
	boolean lineDiscCode = false
	String profitCenter1 = ''
	String profitCenter2 = ''
	String profitCenter3 = ''
	String profitCenter4 = ''
	String profitCenter5 = ''
	BigDecimal lineDisc1 = 0.0g
	BigDecimal lineDisc2 = 0.0g
	BigDecimal lineDisc3 = 0.0g
	BigDecimal lineDisc4 = 0.0g
	BigDecimal lineDisc5 = 0.0g
	boolean discAllowCode = false

	static constraints = {
		compCode(maxSize:2,nullable:false)
		orderNo(max:99999,nullable:false)
		shipNo(max:99,nullable:false)
		lineNo(max:9999,nullable:false)
		statusCode(maxSize:1,nullable:false, inList:['N', 'B','C','F','H','N','O','P','S','X'])
		custNo(minSize:1,maxSize:7,blank:false,nullable:false, 
			validator: { custNo, ord ->
				return Customer.findByCustNo(custNo) != null
			}
		)
		shipToNo(max:9999,nullable:false, 
			validator: { shipToNo, ord ->
			    if (!shipToNo || shipToNo == 9999) {
			    	return true
			    }
				def shipTo = ShipTo.withCriteria {
					and {
						eq('compCode', ord.compCode)
						eq('custNo', ord.custNo)
						eq('shipToNo', shipToNo)
					}
				}
				return shipTo as boolean
			}
		)
		orderCentury(max:99,nullable:false)
		orderDate(nullable:false)
		pickCentury(max:99,nullable:false)
		pickDateMDY(nullable:false)
		warehouse(maxSize:3,nullable:false)
		poNo(maxSize:25,nullable:false)
		shipVia(maxSize:15,nullable:false)
		termsCode(maxSize:3,nullable:false)
		salesperson1(maxSize:3,nullable:false,
            validator: { slsp, ord ->
				return SalesPerson.get(slsp) as boolean
			}
		)
		salesperson2(maxSize:3,nullable:false)
		invoiceDiscPct(max:new BigDecimal("99.99"),nullable:false)
		taxCode1(maxSize:3,nullable:false)
		taxCode2(maxSize:3,nullable:false)
		taxCode3(maxSize:3,nullable:false)
		taxPct1(max:new BigDecimal(".99999"),nullable:false)
		taxPct2(max:new BigDecimal(".99999"),nullable:false)
		taxPct3(max:new BigDecimal(".99999"),nullable:false)
		orderTotal(max:new BigDecimal("9999999.99"),nullable:false)
		jobIdCode(maxSize:10,nullable:false)
		enteredBy(maxSize:10,nullable:false)
		dateCreated(nullable:false)
		timeEntered(max:999999,nullable:false)
		acknowledgement(maxSize:1,inList:[' ', 'Y', 'N', 'P'],nullable:false)
		freightCode(maxSize:1,nullable:false)
		carrierCode(maxSize:4,nullable:false)
		fobCode(maxSize:2,nullable:false)
		shippedStatus(maxSize:2,nullable:false)
		shipInstructions(maxSize:15,nullable:false)
		specialChrgCd1(maxSize:5,nullable:false)
		specialChrgCd2(maxSize:5,nullable:false)
		specialChrgCd3(maxSize:5,nullable:false)
		dueCentury(max:99,nullable:false)
		dueDate(nullable:false)
		shipComplete(maxSize:1,nullable:false)
		packingListCode(maxSize:2,nullable:false)
		custRef1(maxSize:25,nullable:false)
		custRef1Date(nullable:false)
		lastF_mPgmName(maxSize:10,nullable:false)
		lastF_mUserId(maxSize:10,nullable:false)
		lastF_mDate(nullable:false)
		lastF_mTime(max:999999,nullable:false)
		shippingPhoneNo(max:9999999999,nullable:false)
		deletedBy(maxSize:10,nullable:false)
		deletedDate(nullable:false)
		deletedTime(max:999999,nullable:false)
		releaseBy(maxSize:10,nullable:false)
		releaseDate(nullable:false)
		releaseTime(max:999999,nullable:false)
//		releaseOrderNo(max:999999,nullable:false)
		splitTermsCode(maxSize:1,nullable:false)
		splitTermsPct1(max:99,nullable:false)
		splitTermsPct2(max:99,nullable:false)
		splitTermsPct3(max:99,nullable:false)
		termsCode1(maxSize:3,nullable:false)
		termsCode2(maxSize:3,nullable:false)
		termsCode3(maxSize:3,nullable:false)
		dueCentury1(max:99,nullable:false)
		dueDate1(nullable:false)
		dueCentury2(max:99,nullable:false)
		dueDate2(nullable:false)
		dueCentury3(max:99,nullable:false)
		dueDate3(nullable:false)
		lineDiscCode(maxSize:1,nullable:false)
		profitCenter1(maxSize:1,nullable:false)
		profitCenter2(maxSize:1,nullable:false)
		profitCenter3(maxSize:1,nullable:false)
		profitCenter4(maxSize:1,nullable:false)
		profitCenter5(maxSize:1,nullable:false)
		lineDisc1(max:new BigDecimal("99.9"),nullable:false)
		lineDisc2(max:new BigDecimal("99.9"),nullable:false)
		lineDisc3(max:new BigDecimal("99.9"),nullable:false)
		lineDisc4(max:new BigDecimal("99.9"),nullable:false)
		lineDisc5(max:new BigDecimal("99.9"),nullable:false)
		discAllowCode(maxSize:1,nullable:false)
	}
	static mapping = {
		table (name:'oeprqh',schema:CH.config.orderentry.schema)
		version (false)
		id (generator:'assigned')
		id (composite:['compCode','orderNo','shipNo','lineNo'])
		columns {
    		id (composite:['compCode','orderNo','shipNo','lineNo'])
			compCode (column:'OCOMP', type:'TrimString')
			orderNo (column:'OQUOT', type:'int')
			shipNo (column:'OSHPN', type:'int')
			lineNo (column:'OSEQN', type:'int')
			statusCode (column:'OSTATC', type:'TrimString')
			custNo (column:'OCUSTN', type:'TrimString')
			shipToNo (column:'OSHPTO', type:'int')
			orderCentury (column:'OORDCN', type:'int')
			orderDate (column:'OORDDT', type:'DateMMDDYYUserType')
			pickCentury (column:'OPICCN', type:'int')
			pickDateMDY (column:'OPICDT', type:'DateMMDDYYUserType')
			warehouse (column:'OWHSE', type:'TrimString')
			poNo (column:'OPONUM', type:'TrimString')
			shipVia (column:'OSHVIA', type:'TrimString')
			termsCode (column:'OTMCOD', type:'TrimString')
			salesperson1 (column:'OSPCD1', type:'TrimString')
			salesperson2 (column:'OSPCD2', type:'TrimString')
			invoiceDiscPct (column:'OINDIS', type:'big_decimal')
			taxCode1 (column:'OTXCD1', type:'TrimString')
			taxCode2 (column:'OTXCD2', type:'TrimString')
			taxCode3 (column:'OTXCD3', type:'TrimString')
			taxPct1 (column:'OTXPC1', type:'big_decimal')
			taxPct2 (column:'OTXPC2', type:'big_decimal')
			taxPct3 (column:'OTXPC3', type:'big_decimal')
			orderTotal (column:'OTOTAL', type:'big_decimal')
			jobIdCode (column:'OJOBID', type:'TrimString')
			enteredBy (column:'OUSRID', type:'TrimString')
			dateCreated (column:'OUDATE', type:'DateMMDDYYUserType')
			timeEntered (column:'OUTIME', type:'int')
			acknowledgement (column:'OPACKN', type:'string')
			freightCode (column:'OFRTCD', type:'TrimString')
			carrierCode (column:'OSVCOD', type:'TrimString')
			fobCode (column:'OFOBCD', type:'TrimString')
			shippedStatus (column:'OSHSTS', type:'TrimString')
			shipInstructions (column:'OSHIN', type:'TrimString')
			specialChrgCd1 (column:'OCHCD1', type:'TrimString')
			specialChrgCd2 (column:'OCHCD2', type:'TrimString')
			specialChrgCd3 (column:'OCHCD3', type:'TrimString')
			dueCentury (column:'ODUECN', type:'int')
			dueDate (column:'ODUEDT', type:'DateMMDDYYUserType')
			shipComplete (column:'OSCMPL', type:'YesBlankType')
			packingListCode (column:'OPLCD', type:'TrimString')
			custRef1 (column:'OCRFNO', type:'TrimString')
			custRef1Date (column:'OCRFDT', type:'DateCCYYMMDDUserType')
			lastF_mPgmName (column:'OLMPGM', type:'TrimString')
			lastF_mUserId (column:'OLMUSR', type:'TrimString')
			lastF_mDate (column:'OLMDAT', type:'DateMMDDYYUserType')
			lastF_mTime (column:'OLMTIM', type:'int')
			shippingPhoneNo (column:'OPHONE', type:'long')
			deletedBy (column:'ODLUSR', type:'TrimString')
			deletedDate (column:'ODLDAT', type:'DateMMDDYYUserType') 
			deletedTime (column:'ODLTIM', type:'int')
			releaseBy (column:'ORLUSR', type:'TrimString')
			releaseDate (column:'ORLDAT', type:'DateMMDDYYUserType') 
			releaseTime (column:'ORLTIM', type:'int')
//			releaseOrderNo (column:'ORORDN', type:'int')
			splitTermsCode (column:'OSTCOD', type:'org.hibernate.type.YesNoType')
			splitTermsPct1 (column:'OSTPC1', type:'int')
			splitTermsPct2 (column:'OSTPC2', type:'int')
			splitTermsPct3 (column:'OSTPC3', type:'int')
			termsCode1 (column:'OTMCD1', type:'TrimString')
			termsCode2 (column:'OTMCD2', type:'TrimString')
			termsCode3 (column:'OTMCD3', type:'TrimString')
			dueCentury1 (column:'ODUEC1', type:'int')
			dueDate1 (column:'ODUED1', type:'DateMMDDYYUserType')
			dueCentury2 (column:'ODUEC2', type:'int')
			dueDate2 (column:'ODUED2', type:'DateMMDDYYUserType')
			dueCentury3 (column:'ODUEC3', type:'int')
			dueDate3 (column:'ODUED3', type:'DateMMDDYYUserType')
			lineDiscCode (column:'OLDISC', type:'YesBlankType')
			profitCenter1 (column:'OLDPC1', type:'TrimString')
			profitCenter2 (column:'OLDPC2', type:'TrimString')
			profitCenter3 (column:'OLDPC3', type:'TrimString')
			profitCenter4 (column:'OLDPC4', type:'TrimString')
			profitCenter5 (column:'OLDPC5', type:'TrimString')
			lineDisc1 (column:'OLDDP1', type:'big_decimal')
			lineDisc2 (column:'OLDDP2', type:'big_decimal')
			lineDisc3 (column:'OLDDP3', type:'big_decimal')
			lineDisc4 (column:'OLDDP4', type:'big_decimal')
			lineDisc5 (column:'OLDDP5', type:'big_decimal')
			discAllowCode (column:'ODCAL', type:'YesBlankType')
		}
	}
	
	String toString() {"compCode: $compCode custNo: $custNo orderNo: $orderNo"}
}
