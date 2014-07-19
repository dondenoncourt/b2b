import org.springframework.web.servlet.support.RequestContextUtils as RCU
import org.springframework.beans.SimpleTypeConverter
import org.codehaus.groovy.grails.plugins.web.taglib.FormatTagLib
import org.codehaus.groovy.grails.commons.DomainClassArtefactHandler

import com.kettler.domain.orderentry.share.WebUser
import com.kettler.domain.actrcv.share.ReturnStatus

import org.jsecurity.SecurityUtils


class KettlerTagLib {

	static namespace = 'kettler'
	
	// 	<kettler:message prefix="shipTo.resi.comm" key="C"/>
	def message = {attrs ->
	    def messageSource = grailsAttributes.getApplicationContext().getBean("messageSource")
	    def locale = RCU.getLocale(request)
	    def writer = out
	    def key = attrs.remove('key')
	    def prefix = attrs.remove('prefix')
	
	    def message = messageSource.getMessage("${prefix}.${key}", null, null, locale)
	    writer << message
	    writer.println()
	}
	def formatPhone = {attrs ->
		def phone = attrs.remove("phone").toString()
		if (phone.size() == 10) {
			out << "${phone[0..2]}.${phone[3..5]}.${phone[6..9]}"
		} else {
			out << phone
		}
	    out.println()
	}

	def sortableColumn = { attrs ->
		def writer = out
		if(!attrs.property)
			throwTagError("Tag [sortableColumn] is missing required attribute [property]")
	
		if(!attrs.title && !attrs.titleKey) 
			throwTagError("Tag [sortableColumn] is missing required attribute [title] or [titleKey]")
		
		def property = attrs.remove("property") 
		def action = attrs.action ? attrs.remove("action") : (actionName ?: "list")
		
		def defaultOrder = attrs.remove("defaultOrder") 
		if(defaultOrder != "desc") defaultOrder = "asc"
		
		//current sorting property and order 
		def sort = params.sort 
		def order = params.order
		
		//add sorting property and params to link params 
		def linkParams = [:] 
		if(params.id) 
			linkParams.put("id",params.id) 
		if(attrs.params) 
			linkParams.putAll(attrs.remove("params")) 
		linkParams.sort = property
		
		//determine and add sorting order for this column to link params 
		attrs.class = (attrs.class ? "${attrs.class} sortable" : "sortable") 
		if(property == sort) { 
			attrs.class = attrs.class + " sorted " + order 
			if(order == "asc") { 
				linkParams.order = "desc" 
			} else { 
				linkParams.order = "asc" 
			} 
		} else { 
			linkParams.order = defaultOrder 
		}
		
		//determine column title 
		def title = attrs.remove("title") 
		def titleKey = attrs.remove("titleKey") 
		if(titleKey) { 
			if(!title) title = titleKey 
			def messageSource = grailsAttributes.getApplicationContext().getBean("messageSource") 
			def locale = RCU.getLocale(request) 
			title = messageSource.getMessage(titleKey, null, title, locale) 
		}
		
		// reset linkTitle (which clashed with g:sortable's title, to for use as title in the link tag
		if (attrs.get('linkTitle')) {
			attrs.put("title", attrs.get('linkTitle'))
		} else {
			attrs.put("title", 'Click to sort')
		}
		
		writer << "<th " 
		// process remaining attributes 
		attrs.each { k, v -> 
			writer << "${k}=\"${v.encodeAsHTML()}\" " 
		} 
		writer << ">${link(action:action, params:linkParams) { title }}</th>" 
	}	
	
	def raColText = {attrs ->
	    attrs.type = "text"
	    attrs.tagName = "textField"
	    	
	    /* begin denoncourt additions */
    	def disabled = attrs.remove('disabled')   
		if(disabled != null && disabled == 'true') {
			attrs.disabled='disabled'
		}
	    def status = attrs.remove('status')  
	    def lockStatus = attrs.remove('lockStatus') 
	    if (status && lockStatus && 
	    	ReturnStatus.get(status?.id)?.colLockLevel  >= 
	    	ReturnStatus.get(lockStatus)?.colLockLevel) {
			attrs.disabled='disabled'
		}
	    attrs.id = attrs.name
	    /* end denoncourt additions */
	    
	    def result = field(attrs)
	    if (result) {
	        out << result
	    }
	}
	def raColChk = {attrs ->
	    attrs.id = attrs.id ? attrs.id : attrs.name
	    def value = attrs.remove('value')
	    def name = attrs.remove('name')
	    def disabled = attrs.remove('disabled')
	    if (disabled && Boolean.valueOf(disabled)) {
	        attrs.disabled = 'disabled'
	    }

	    /* begin denoncourt additions */
	    def status = attrs.remove('status')  
	    def lockStatus = attrs.remove('lockStatus') 
	    if (status && lockStatus && 
	    	ReturnStatus.get(status?.id)?.colLockLevel  >= 
	    	ReturnStatus.get(lockStatus)?.colLockLevel) {
			attrs.disabled='disabled'
		}
	    /* end denoncourt additions */
	
		//Deal with the "checked" attribute. If it doesn't exist, we 
	    // default to a value of "true", otherwise we use Groovy Truth 
	    // to determine whether the HTML attribute should be displayed 
	    // or not. 
	    def checked = true 
	    if (attrs.containsKey('checked')) { 
	    	checked = attrs.remove('checked') 
	    }
		
		if (checked instanceof String) checked = Boolean.valueOf(checked)
		
		if (value == null) value = false
		
		//the hidden field name should begin with an underscore unless it is 
		// a dotted name, then the underscore should be inserted after the last 
		// dot 
		def lastDotInName = name.lastIndexOf('.') 
		def hiddenFieldName = lastDotInName == -1 ? '_' + name : name[0..lastDotInName] + '_' + name[(lastDotInName+1)..-1]
		
		if (attrs.disabled != 'disabled') { // denoncourt added if block
			out << "<input type=\"hidden\" name=\"${hiddenFieldName}\" /> " 
		}
		out << "<input type=\"checkbox\" name=\"${name}\" " 
		if (value && checked) { 
			out << 'checked="checked" ' 
		} 
		def outputValue = !(value instanceof Boolean || value?.class == boolean.class) 
		if (outputValue) out << "value=\"${value}\" " 
		// process remaining attributes 
		outputAttributes(attrs)
		
		//close the tag, with no body 
		out << ' />'
	
	}
	def raSelect = {attrs ->

		def messageSource = grailsAttributes.getApplicationContext().getBean("messageSource")
	    def locale = RCU.getLocale(request)
	    def writer = out
	    attrs.id = attrs.id ? attrs.id : attrs.name
	    def from = attrs.remove('from')
	    def keys = attrs.remove('keys')
	    def optionKey = attrs.remove('optionKey')
	    def optionValue = attrs.remove('optionValue')
	    def value = attrs.remove('value')
	    if (value instanceof Collection && attrs.multiple == null) {
	        attrs.multiple = 'multiple'
	    }
	    def valueMessagePrefix = attrs.remove('valueMessagePrefix')
	    def noSelection = attrs.remove('noSelection')
	    if (noSelection != null) {
	        noSelection = noSelection.entrySet().iterator().next()
	    }
	    def disabled = attrs.remove('disabled')
	    if (disabled && Boolean.valueOf(disabled)) {
	        attrs.disabled = 'disabled'
	    }
	    /* begin denoncourt additions */
	    def status = attrs.remove('status')  
	    def lockStatus = attrs.remove('lockStatus') 
	    if (status && lockStatus && 
	    	ReturnStatus.get(status?.id)?.colLockLevel  >= 
	    	ReturnStatus.get(lockStatus)?.colLockLevel) {
			attrs.disabled='disabled'
		}
	    /* end denoncourt additions */
	
		writer << "<select name=\"${attrs.remove('name')}\" " 
		// process remaining attributes 
		outputAttributes(attrs)
	
		writer << '>' 
		writer.println()
	
		if (noSelection) { 
			renderNoSelectionOption(noSelection.key, noSelection.value, value) 
			writer.println() 
		}
	
		// create options from list 
		if (from) { 
			from.eachWithIndex {el, i -> 
				def keyValue = null 
				writer << '<option ' 
				if (keys) { 
					keyValue = keys[i] 
					writeValueAndCheckIfSelected(keyValue, value, writer) 
				} else if (optionKey) { 
					if (optionKey instanceof Closure) { 
						keyValue = optionKey(el) 
					} else if (el != null && optionKey == 'id' && grailsApplication.getArtefact(DomainClassArtefactHandler.TYPE, el.getClass().name)) { 
						keyValue = el.ident() 
					} else { 
						keyValue = el[optionKey] 
					} 
					writeValueAndCheckIfSelected(keyValue, value, writer) 
				} else { 
					keyValue = el 
					writeValueAndCheckIfSelected(keyValue, value, writer) 
				} 
				writer << '>' 
				if (optionValue) { 
					if (optionValue instanceof Closure) { 
						writer << optionValue(el).toString().encodeAsHTML() 
					} else { 
						writer << el[optionValue].toString().encodeAsHTML() 
					} 
				} else if (valueMessagePrefix) { 
					def message = messageSource.getMessage("${valueMessagePrefix}.${keyValue}", null, null, locale) 
					if (message != null) { 
						writer << message.encodeAsHTML() 
					} else if (keyValue) { 
						writer << keyValue.encodeAsHTML() 
					} else { 
						def s = el.toString() 
						if (s) writer << s.encodeAsHTML() 
					} 
				} else { 
					def s = el.toString() 
					if (s) writer << s.encodeAsHTML() 
				} 
				writer << '</option>' 
				writer.println() 
			} 
		} 
		// close tag 
		writer << '</select>' 
	}
	
    void outputAttributes(attrs) {
        attrs.remove('tagName') // Just in case one is left
        attrs.each {k, v ->
            out << k << "=\"" << v.encodeAsHTML() << "\" "
        }
    }
	
	def typeConverter = new SimpleTypeConverter() 
	private writeValueAndCheckIfSelected(keyValue, value, writer) {
	
		boolean selected = false 
		def keyClass = keyValue?.getClass() 
		if (keyClass.isInstance(value)) { 
			selected = (keyValue == value) 
		} else if (value instanceof Collection) { 
			selected = value.contains(keyValue) 
		} else if (keyClass && value) { 
			try { 
				value = typeConverter.convertIfNecessary(value, keyClass) 
				selected = (keyValue == value) 
			} catch (Exception) { 
				// ignore 
			} 
		} 
		writer << "value=\"${keyValue}\" " 
		if (selected) { 
			writer << 'selected="selected" ' 
		} 
	}
	 def renderNoSelectionOption = {noSelectionKey, noSelectionValue, value ->
	     // If a label for the '--Please choose--' first item is supplied, write it out
	     out << '<option value="' << (noSelectionKey == null ? "" : noSelectionKey) << '"'
	     if (noSelectionKey.equals(value)) {
	         out << ' selected="selected" '
	     }
	     out << '>' << noSelectionValue.encodeAsHTML() << '</option>'
	 }
	
	 // http://dahernan.net/2008/01/grails-tag-for-prototype-observe.html
	 def observe = {attrs ->
	 if(!attrs.noScript){
	  out << '<script type="text/javascript">'
	 }
	 if(attrs.element && attrs.element instanceof String){ 
	  printObserve("\$('${attrs.element}')", attrs.event, attrs.function, out) 
	 }
	 if(attrs.element && attrs.element instanceof List){
	  attrs.element.each{it -> printObserve("\$('${it}')", attrs.event, attrs.function, out)}
	 }
	 if(attrs.classes && attrs.classes instanceof String){
	  printObserveClass(attrs.classes, attrs.event, attrs.function, out)
	 }
	 if(attrs.classes && attrs.classes instanceof List){
	  attrs.classes.each{ it -> printObserveClass(it, attrs.event, attrs.function, out)}
	 }
	 if(!attrs.noScript){
	  out << '</script>'
	 }
	 }

	 def printObserveClass(className, event, function, out){
	 out <<  "var classes  = \$\$('.' + '${className}');"
	 out <<  "for(i = 0; i < classes.length; i++) {"
	 printObserve("classes[i]", event, function, out)
	 out <<  "}"
	 }

	 def printObserve(element, event, function, out){
	 if(event && event instanceof String){
	  out << "${element}.observe('${event}', ${function});"
	 }
	 if(event && event instanceof List){
	  attrs.event.each{ it -> out << "${element}.observe('${it}', ${function});"}
	 }
	 }
	 
}