package com.kettler.domain.orderentry
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
class Cust3rdPartyBill implements Serializable {
	String compCode
	String custNo
	String carrierCode
	String acctNo
	String name
	String addr1
	String addr2
	String addr3
	String city
	String state
	String zipCode
	String countryCode
	String countryName

	static transients = ['makeOrder3rdPartyBill','newEntity']
	boolean makeOrder3rdPartyBill = false
	boolean newEntity = false

	static constraints = {
		compCode(maxSize:2,nullable:false)
		custNo(maxSize:7,nullable:false)
		carrierCode(maxSize:4,nullable:false)
		acctNo(blank:false,maxSize:15,nullable:false)
		name(blank:false,maxSize:30,nullable:false)
		addr1(minSize:1,maxSize:30,nullable:false, 
			validator: { addr1, cust ->
				if (!addr1.size()) {
					return "kettler.addr1.invalid"
				}
			}
		)
		addr2(maxSize:30,nullable:false)
		addr3(maxSize:30,nullable:false)
		city(maxSize:15,nullable:false, 
			validator: { city, cust ->
				if (['USA', 'CAN'].find {it == cust.countryCode}) {
					if (!city.size()) { 
						return "kettler.city.blank"
					}
				} 
				return true
			}
		)
		state(minSize:2,maxSize:2,nullable:false, 
			validator: { state, cust ->
				if (['USA', 'CAN'].find {it == cust.countryCode}) {
					if (!state.size()) { 
						return "kettler.state.blank"
					}
				} 
				return true
			}
		)
		zipCode(maxSize:9,nullable:false, 
			validator: { zipCode, cust ->
				if (cust.countryCode == 'USA') {
					if (!(zipCode ==~ /^\d{5,9}$/) ) { 
						return "kettler.zipCode.usa.invalid"
					}
				} else if (cust.countryCode == 'CAN') {
					if (!(zipCode ==~ /^\w{6}$/) ) { //TODO, what about embedded space{s) 
						return "kettler.zipCode.can.invalid"
					}
				}
				return true
			}
		)
		countryCode(maxSize:3,nullable:false)
		countryName(maxSize:30,nullable:false)
	}
	static final boolean ASSIGNED_KEY = true
	static final boolean COMPOSITE_KEY  = true
	static mapping = {
		table (name:'oebill',schema:CH.config.orderentry.schema)
		version (false)
		id (generator:'assigned')
		id (composite:['compCode','custNo','carrierCode'])
		columns {
			id (composite:['compCode','custNo','carrierCode'])
			compCode (column:'BCOMP', type:'TrimString')
			custNo (column:'BCUST', type:'TrimString')
			carrierCode (column:'BCARR', type:'TrimString')
			acctNo (column:'BACCT', type:'TrimString')
			name (column:'BNAME', type:'TrimString')
			addr1 (column:'BADDR1', type:'TrimString')
			addr2 (column:'BADDR2', type:'TrimString')
			addr3 (column:'BADDR3', type:'TrimString')
			city (column:'BCITY', type:'TrimString')
			state (column:'BSTAT', type:'TrimString')
			zipCode (column:'BZIPC', type:'TrimString')
			countryCode (column:'BCNTRY', type:'TrimString')
			countryName (column:'BCNTNM', type:'TrimString')
		}
	}
}

