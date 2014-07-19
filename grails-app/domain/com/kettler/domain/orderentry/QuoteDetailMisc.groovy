package com.kettler.domain.orderentry
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
import com.kettler.domain.actrcv.share.TableCode

class QuoteDetailMisc implements Serializable {
	String compCode
	int orderNo
	int shipNo
	int lineNo
	String lineType = 'M'
	String desc = ''
	String distrCode = ''
	String printCode = ''
	BigDecimal amount = 0.0g
	BigDecimal cost = 0.0g
	boolean subjToTax1 = false
	boolean subjToTax2 = false
	boolean subjToTax3 = false
	static constraints = {
		compCode(maxSize:2,nullable:false)
		orderNo(max:99999,nullable:false)
		shipNo(max:99,nullable:false)
		lineNo(max:9999,nullable:false)
		lineType(maxSize:1,inList:['M'],nullable:false)
		desc(minSize:1, maxSize:30,nullable:false)
		distrCode(maxSize:3,nullable:false,
			validator: { distrCode, misc ->
                return TableCode.findByCompCodeAndCode(misc.compCode, distrCode) != null
			}
		)
		printCode(maxSize:1,nullable:false)
		amount(max:new BigDecimal("9999999.99"),nullable:false)
		cost(max:new BigDecimal("9999999.99"), validator: {cost, misc -> 
				misc.cost = cost ?: 0.0g
				return true
			}, 
			nullable:true
		)
		subjToTax1(maxSize:1,nullable:false)
		subjToTax2(maxSize:1,nullable:false)
		subjToTax3(maxSize:1,nullable:false)
	}
	static final boolean ASSIGNED_KEY = true
	static final boolean COMPOSITE_KEY  = true
	static mapping = {
		table (name:'oeprq2',schema:CH.config.orderentry.schema)
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
			desc (column:'ODESC', type:'TrimString')
			distrCode (column:'ODIST', type:'TrimString')
			printCode (column:'OPCOD', type:'TrimString')
			amount (column:'OEXAMT', type:'big_decimal')
			cost (column:'OEXCST', type:'big_decimal')
			subjToTax1 (column:'OSTXC1', type:'YesBlankType')
			subjToTax2 (column:'OSTXC2', type:'YesBlankType')
			subjToTax3 (column:'OSTXC3', type:'YesBlankType')
		}
	}
	boolean newEntity = false
	static transients = ['newEntity']
}

