package com.kettler.domain.orderentry
import org.codehaus.groovy.grails.commons.ConfigurationHolder as CH
class Order3rdPartyBill implements Serializable {
	String compCode
	int orderNo
	int shipNo 
	String acctNo = ''
	String name = ''
	String addr1 = ''
	String addr2 = ''
	String addr3 = ''
	String city = ''
	String state = ''
	String zipCode = ''
	String countryCode  = ''
	String countryName = ''

	static transients = ['makeCust3rdPartyBill']
	boolean makeCust3rdPartyBill = false

	static constraints = {
		compCode(maxSize:2,nullable:false)
		orderNo(max:999999,nullable:false)
		shipNo(max:99,nullable:false)
		
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
		
		acctNo(blank:false,maxSize:15,nullable:false)
		countryCode(maxSize:3,nullable:false)
		countryName(maxSize:30,nullable:false) 
	}
	static mapping = {
		table (name:'oe3rdpty',schema:CH.config.orderentry.schema)
		columns {
			compCode (column:'OCOMP', type:'TrimString')
			orderNo (column:'OORDN', type:'int')
			shipNo (column:'OSHPN', type:'int')
			name (column:'ONAME', type:'TrimString')
			addr1 (column:'OADDR1', type:'TrimString')
			addr2 (column:'OADDR2', type:'TrimString')
			addr3 (column:'OADDR3', type:'TrimString')
			city (column:'OCITY', type:'TrimString')
			state (column:'OSTATE', type:'TrimString')
			zipCode (column:'OZIPC', type:'TrimString')
			acctNo (column:'OACCT', type:'TrimString')
			countryCode (column:'OCNTRY', type:'TrimString')
			countryName (column:'OCNTNM', type:'TrimString')
		}
	}
}
