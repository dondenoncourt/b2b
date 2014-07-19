/*
 * Copyright 2007-208 the original author or authors.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *      http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */ 
import java.util.*
import java.text.*

class CASTagLib {
	static namespace = 'cas'
	def editCode = { attrs ->
		out << EditCode.format(attrs['edtcde'],  new Integer(attrs['decimals']).intValue(), attrs['value']) 
	}

	public static def format(def code, int decimals, def val) {
		def pattern = ''
		if (decimals) {
			pattern = '.'
			(1..decimals).each { pattern += '0'}
		}
		switch (code) {
		case '1': case '2': case 'A': case 'B': case 'J': case 'K': case 'N': case 'O':
			if (val >= 1) { pattern = '#,###' + pattern	}
			break
		case '3': case '4': case 'C': case 'D': case 'L': case 'M': case 'P': case 'Q':
			if (decimals == 0) {pattern = '#'}
			break
		}
		switch (code) {
		case '1': case '2': case '3': case '4': case 'A': case 'B': case 'C': case 'D': 
		case 'J': case 'K': case 'L': case 'M': case 'N': case 'O': case 'P': case 'Q': 
			break
		case 'W': case 'Y':  
			return formatDate(code, val)
			break
		case 'Z':
			if (decimals == 0) {pattern = '#0'}
			break
		default: 
			throw new RuntimeException('Invalid edit code:'+code)
			return val
		}
		String result = new DecimalFormat(pattern).format(val)
		//print pattern

		// manipulate negative specifier
		if (val < 0) {
			switch (code) {
			case '1': case '2': case '3': case '4': case 'Z':  
				result = result.replaceAll('-', '')
				break
			case 'A': case 'B': case 'C': case 'D':  
				result = result.replaceAll('-', '')
				result += 'CR'
				break
			case 'J': case 'K': case 'L': case 'M':
				result = result.replaceAll('-', '')
				result += '-'
				break
			}
		}

		// manipulate zero result
		if (val == 0) {
			switch (code) {
			case '2': case '4': case 'B': case 'D': case 'K': case 'M': case 'O': case 'Q': case 'Z':
				result = ''
				break
			}
		}
		return result 
		
	}

	/*
		The W edit code suppresses the farthest left zero of a date field that is five digits long. 
		It also suppresses the three farthest left zeros of a field that is six to eight digits long. 
		The W edit code also inserts slashes (/) between the month, day, and year according to the following pattern:
	    nn/nnn     5
	    nnnn/nn    6
	    nnnn/nnn   7
	    nnnn/nn/nn 8
		The Y edit code suppresses the farthest left zero of a date field that is three to six digits long or eight digits long. 
		It also suppresses the two farthest left zeros of a field that is seven positions long. 
		The Y edit code also inserts slashes (/) between the month, day, and year according to the following pattern:
	    nn/n        3
	    nn/nn       4
	    nn/nn/n     5
	    nn/nn/nn    6
	    nnn/nn/nn   7
	    nn/nn/nnnn  8
	    test data in EditCodeTagLibTest.testDDSManPage():
			['W', '1234/567', '1234/567', '0/125', '0/125', '0/000', '0/000'],
			['Y', '123/45/67', '123/45/67', '0/01/25', '0/01/25', '0/00/00', '0/00/00']
	*/
	static def formatDate(def code, def val) {
	    String result = val.toString().replaceAll('-', '')
	    result = result.replaceAll('\\.', '')
	    result = result.replaceAll('/', '')
	    if (result == "0") {
	    	result = "0000"
	    }
		switch (code) {
		case 'W':
			switch (result.length()) {
			case (1..3):
				def matcher = result =~ /(\d{1,3})/
				result = "0/${matcher[0][1]}"
				break
			case (4..5):
				def matcher = result =~ /(\d{1,2})(\d\d\d)/
				result = "${matcher[0][1]}/${matcher[0][2]}"
				break
			case 6:
				def matcher = result =~ /(\d\d\d\d)(\d\d)/
				result = "${matcher[0][1]}/${matcher[0][2]}"
				break
			case 7:
				def matcher = result =~ /(\d\d\d\d)(\d\d\d)/
				result = "${matcher[0][1]}/${matcher[0][2]}"
				break
			case 8:
				def matcher = result =~ /(\d\d\d\d)(\d\d)(\d\d)/
				result =  "${matcher[0][1]}/${matcher[0][2]}/${matcher[0][3]}"
				break
			default:
				throw new RuntimeException('Value with date edit code of W has a digit length not between 1 and 8:'+val)
			}
			break
		case 'Y':
			switch (result.length()) {
			case 1:
				result = "0/00/0${result}"
				break
			case 2:
				result = "0/00/${result}"
				break
			case 3:
				def matcher = result =~ /(\d)(\d\d)/
				result = "0/0${matcher[0][1]}/${matcher[0][2]}"
				break
			case 4:
				def matcher = result =~ /(\d{1,2})(\d\d)/
				result = "0/${matcher[0][1]}/${matcher[0][2]}"
				break
			case (5..6):
				def matcher = result =~ /(\d{1,2})(0[1-9]|[12][0-9]|3[01])(\d{2})/
				result = "${matcher[0][1]}/${matcher[0][2]}/${matcher[0][3]}"
				break
			case (7..8):
				def matcher = result =~ /(\d{1,2})(0[1-9]|[12][0-9]|3[01])(\d{4})/
				result = "${matcher[0][1]}/${matcher[0][2]}/${matcher[0][3]}"
			} 
			break
		default:
			throw new RuntimeException('Date edit code must be W or Y but was:'+code)
		}
	    return result
	}

	def formatCurrency = { attrs ->
	   if ( attrs?.value )
			out << "\$" + new java.math.BigDecimal(attrs.value).setScale(2, BigDecimal.ROUND_HALF_UP).toString()
	   else
		    out << ""	
	}

	def flowSubmitImage = {attrs ->
	    attrs.tagName = "flowSubmitImage"
	    if (!attrs.value)       {throwTagError("Tag [$attrs.tagName] is missing required attribute [value]") }
	    if (!attrs.src)          {throwTagError("Tag [$attrs.tagName] is missing required attribute [src]") }
	    if (!attrs.event)    {throwTagError("Tag [$attrs.tagName] is missing required attribute [event]") }

		def value = attrs.remove('value') 
		def src = attrs.src ? attrs.remove('src') : value
		def event = attrs.event ? attrs.remove('event') : value
		out << "<input name=\"_eventId_${event}\" value=\"${value}\" id=\"_eventId_${event}\" type=\"image\" src=\"${src}\" "
		
		//process remaining attributes 
		outputAttributes(attrs)
		//close tag 
		out << '/>'
	
	}
	
	def hiddenInputKey = {attrs ->
		attrs.tagName = "hiddenInputKeys"
	    if (!attrs.domain)          {throwTagError("Tag [$attrs.tagName] is missing required attribute [domain]") }

		if (attrs.domain.class.COMPOSITE_KEY) {
			attrs.domain.class.mapping.getDelegate().mapping.identity.propertyNames.each { 
			
				def value =  attrs.domain."$it"
				out << "<input type=\"hidden\" name=\"${it}\" value=\"$value\" id=\"${it}\"  />"
			}
		} else {
			def id = attrs.domain.id
			if (attrs.domain.id.class.name == "java.lang.String") {
				id = attrs.domain.id.trim()
			}
			out << "<input type=\"hidden\" name=\"id\" value=\"${id}\" id=\"id\"  />"
		}
	}
	
	def linkWithKey = {attrs ->
		attrs.tagName = "hiddenInputKeys"
	    if (!attrs.domain)          {throwTagError("Tag [$attrs.tagName] is missing required attribute [domain]") }
	    if (!attrs.action)          {throwTagError("Tag [$attrs.tagName] is missing required attribute [action]") }
		
	    def action = attrs.action
	    
		out <<  "<a href=\""+createLink(attrs).encodeAsHTML()+"?"	

  	   if (attrs.domain.class.COMPOSITE_KEY) {
			attrs.domain.class.mapping.getDelegate().mapping.identity.propertyNames.each { 
				out << it
				out << "="
				out << attrs.domain."$it"
				out << "&"
			}
			out << "\">$action</a>"
  	   } else {
  		   out << "id=${attrs.domain.id}+\">${attrs.domain.id}</a>"
  	   }
	}
	
    /**
     * Dump out attributes in HTML compliant fashion
     */
    void outputAttributes(attrs)
    {
        attrs.remove('tagName') // Just in case one is left
        attrs.each {k, v ->
            out << k << "=\"" << v.encodeAsHTML() << "\" "
        }
    }
	
}