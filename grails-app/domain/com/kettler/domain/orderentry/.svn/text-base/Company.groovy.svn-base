package com.kettler.domain.orderentry
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
class Company implements Serializable {
	String id
	String name
	String address1
	String address2
	String city
	String state
	String zipCode
	String remitToName
	String remitToAddr1
	String remitToAddr2
	String remitToCity
	String remitToState
	String remitToZipCode
	Date   lastCommissionFinal
	static constraints = {
		name(maxSize:30,nullable:false)
		address1(maxSize:30,nullable:false)
		address2(maxSize:30,nullable:false)
		city(maxSize:15,nullable:false)
		state(maxSize:2,nullable:false)
		zipCode(maxSize:9,nullable:false)
		remitToName(maxSize:30,nullable:false)
		remitToAddr1(maxSize:30,nullable:false)
		remitToAddr2(maxSize:30,nullable:false)
		remitToCity(maxSize:15,nullable:false)
		remitToState(maxSize:2,nullable:false)
		remitToZipCode(maxSize:9,nullable:false)
	}
	static final boolean ASSIGNED_KEY = true
	static final boolean COMPOSITE_KEY  = false
	static mapping = {
		table (name:'oecomp',schema:CH.config.orderentry.schema)
		version (false)
		id (generator:'assigned')
		columns {
			id (column:'CCOMP',type:'TrimString')
			name (column:'CNAME', type:'TrimString')
			address1 (column:'CADDR1', type:'TrimString')
			address2 (column:'CADDR2', type:'TrimString')
			city (column:'CCITY', type:'TrimString')
			state (column:'CSTAT', type:'TrimString')
			zipCode (column:'CZIPC', type:'TrimString')
			remitToName (column:'CRNAME', type:'TrimString')
			remitToAddr1 (column:'CRADR1', type:'TrimString')
			remitToAddr2 (column:'CRADR2', type:'TrimString')
			remitToCity (column:'CRCITY', type:'TrimString')
			remitToState (column:'CRSTAT', type:'TrimString')
			remitToZipCode (column:'CRZIPC', type:'TrimString')
			lastCommissionFinal (column:'ccomfdat')
		}
	}
	boolean newEntity = false
	static transients = ['compCode', 'newEntity']
	def getcompCode() {
		if (id) return id
		return 
	}
	void setcompCode (def vlu) { id = vlu }
}
