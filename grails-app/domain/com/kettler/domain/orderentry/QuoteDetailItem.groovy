package com.kettler.domain.orderentry
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
import com.kettler.domain.item.share.ItemMaster
import com.kettler.domain.item.share.NatlMotorFreightClass

class QuoteDetailItem implements Serializable {
	String compCode
	Integer orderNo
	Integer shipNo = 0
	Integer lineNo
	String lineType
	String itemNo
	String desc = ''
	String distrCode = ''
	String qtyUnitMeas = 'EA '
	Integer orderQty = 0
	Integer shipQty = 0
	Integer backOrderQty = 0
	String backOrderCode = ''
	BigDecimal orderWeight = 0.0g
	boolean priceOverride = false
	BigDecimal unitPrice = 0.0g
	BigDecimal unitCost = 0.0g
	String priceUnitMeas = ''
	String convCode = ''
	Integer convFactor = 0
	BigDecimal itemDiscPct = 0.0g
	String discDistrCode = ''
	boolean subjToTax1 = false
	boolean subjToTax2 = false
	boolean subjToTax3 = false
	BigDecimal amount = 0.0g
	BigDecimal cost = 0.0g
	String discAllowProfitCenter = ''
	String discAllowCode = ''
	String discAllowEDICode = ''
	BigDecimal discAllowPct = 0.0g

	static constraints = {
		compCode(maxSize:2,nullable:false)
		orderNo(max:99999)
		shipNo(max:99,nullable:false)
		lineNo(min:1,max:9999,nullable:false)
		lineType(maxSize:1,inList:['I', 'N'],nullable:false)
		itemNo(maxSize:15,nullable:false,
			validator: { itemNo, ordDtl ->
                if (ordDtl.lineType == 'N') { // non-inventory
                	if (!itemNo.trim().size()) {
                		return "kettler.QuoteDetailItem.itemNo.required"
                	}
                	return true
                }
				def item = ItemMaster.findByCompCodeAndItemNo(ordDtl.compCode, itemNo)
                if (!item) {
                    return "kettler.QuoteDetailItem.itemNo.invalid" 
                } else if ((item.activeCode ==~ /D|I/) ) { // Deleted or Inactive
                    return "kettler.QuoteDetailItem.itemNo.deleted.or.inactive" 
                }
                return true
			}
		)
		desc(maxSize:30,nullable:false)
		distrCode(maxSize:3,nullable:false)
		qtyUnitMeas(maxSize:3,nullable:false)
		orderQty(min:-1,max:99999,nullable:false,
			validator: { qty, ordDtl ->
                if (!qty) { // but it can be negative
                	return "kettler.QuoteDetailItem.orderQty.cannot.be.zero"
                }
			}
		)
		shipQty(min:-1, max:99999,nullable:false)
		backOrderQty(max:99999,nullable:false)
		backOrderCode(maxSize:1,nullable:false)
		orderWeight(max:new BigDecimal("9999.999"),nullable:false)
		priceOverride(maxSize:1,nullable:false)
		unitPrice(max:new BigDecimal("999999.999"),nullable:false)
		unitCost(max:new BigDecimal("999999.999"),nullable:false)
		priceUnitMeas(maxSize:3,nullable:false)
		convCode(maxSize:1,nullable:false)
		convFactor(max:9999,nullable:false)
		itemDiscPct(max:new BigDecimal("99.99"),nullable:false)
		discDistrCode(maxSize:3,nullable:false)
		subjToTax1(maxSize:1,nullable:false)
		subjToTax2(maxSize:1,nullable:false)
		subjToTax3(maxSize:1,nullable:false)
		amount(max:new BigDecimal("9999999.99"),nullable:false)
		cost(max:new BigDecimal("9999999.99"),nullable:false)
		discAllowProfitCenter(maxSize:1,nullable:false)
		discAllowCode(maxSize:4,nullable:false)
		discAllowEDICode(maxSize:4,nullable:false)
		discAllowPct(max:new BigDecimal("99.999"),nullable:false)
	}
	static final Boolean ASSIGNED_KEY = true
	static final Boolean COMPOSITE_KEY  = true
	static mapping = {
		table (name:'oeprq1',schema:CH.config.orderentry.schema)
		version (false)
		id (generator:'assigned')
		id (composite:['compCode','orderNo','shipNo','lineNo'])
		columns {
    		id (composite:['compyCode','orderNo','shipNo','lineNo'])
			compCode (column:'OCOMP', type:'TrimString')
			orderNo (column:'OQUOT', type:'int')
			shipNo (column:'OSHPN', type:'int')
			lineNo (column:'OSEQN', type:'int')
			lineType (column:'OTYPE', type:'TrimString')
			itemNo (column:'OITEM', type:'TrimString')
			desc (column:'ODESC', type:'TrimString')
			distrCode (column:'ODIST', type:'TrimString')
			qtyUnitMeas (column:'OQUNM', type:'TrimString')
			orderQty (column:'OQTYOR', type:'int')
			shipQty (column:'OQTYSH', type:'int')
			backOrderQty (column:'OQTYBO', type:'int')
			backOrderCode (column:'OBOCOD', type:'TrimString')
			orderWeight (column:'OOWGHT', type:'big_decimal')
			priceOverride (column:'OPROVR', type:'YesBlankType')
			unitPrice (column:'OPRICE', type:'big_decimal')
			unitCost (column:'OCOST', type:'big_decimal')
			priceUnitMeas (column:'OPUNM', type:'TrimString')
			convCode (column:'OCONC', type:'TrimString')
			convFactor (column:'OCONF', type:'int')
			itemDiscPct (column:'OIDISC', type:'big_decimal')
			discDistrCode (column:'ODDIST', type:'TrimString')
			subjToTax1 (column:'OSTXC1', type:'YesBlankType')
			subjToTax2 (column:'OSTXC2', type:'YesBlankType')
			subjToTax3 (column:'OSTXC3', type:'YesBlankType')
			amount (column:'OEXAMT', type:'big_decimal')
			cost (column:'OEXCST', type:'big_decimal')
			discAllowProfitCenter (column:'ODAPC', type:'TrimString')
			discAllowCode (column:'ODACOD', type:'TrimString')
			discAllowEDICode (column:'ODAEDI', type:'TrimString')
			discAllowPct (column:'ODAP', type:'big_decimal')
		}
	}
	Boolean newEntity = true
	static transients = ['newEntity']
}

