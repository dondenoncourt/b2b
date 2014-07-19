package com.kettler.domain.orderentry
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH

class SalesDivision implements Serializable {
	String id
	String desc
	Long acctNo
	String email1
	String email2
	String email3
	String email4
	String email5
	static constraints = {
		desc(maxSize:30,nullable:false)
		acctNo(max:9999999999999,nullable:false)
		email1(maxSize:50,nullable:false)
		email2(maxSize:50,nullable:false)
		email3(maxSize:50,nullable:false)
		email4(maxSize:50,nullable:false)
		email5(maxSize:50,nullable:false)
	}
	static final boolean ASSIGNED_KEY = true
	static final boolean COMPOSITE_KEY  = false
	static mapping = {
		table (name:'oesdiv',schema:CH.config.orderentry.schema)
		version (false)
		id (generator:'assigned')
		columns {
			id (column:'SDCODE',type:'string')
			desc (column:'SDDESC', type:'string')
			acctNo (column:'SDACCT', type:'long')
			email1 (column:'SDEMA1', email:true, type:'string')
			email2 (column:'SDEMA2', email:true, type:'string')
			email3 (column:'SDEMA3', email:true, type:'string')
			email4 (column:'SDEMA4', email:true, type:'string')
			email5 (column:'SDEMA5', email:true, type:'string')
		}
	}
	boolean newEntity = false
	static transients = ['salesDivCode', 'newEntity']
	def getSalesDivCode() {
		if (id) return id
		return 
	}
	void setSalesDivCode (def vlu) { id = vlu }
}
