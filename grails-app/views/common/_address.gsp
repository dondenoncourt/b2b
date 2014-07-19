<%@ page import="com.kettler.domain.orderentry.StateCode" %>
<%@ page import="com.kettler.domain.orderentry.CanadianProvinceCode" %>
<%@ page import="com.kettler.domain.varsity.Country" %>

<dl>
	<dt>Name:</dt>				<dd><g:textField name="name"  size="30" maxLength="30" value="${objWithAddr?.name?.encodeAsHTML()}" /></dd>                                                            
	<dt>Address Line 1:</dt>	<dd><g:textField name="addr1" size="30" maxLength="30" value="${objWithAddr?.addr1?.encodeAsHTML()}" /></dd>                                                           
	<dt>             2:</dt>	<dd><g:textField name="addr2" size="30" maxLength="30" value="${objWithAddr?.addr2?.encodeAsHTML()}" /></dd>                                                      
	<dt>             3:</dt>	<dd><g:textField name="addr3" size="30" maxLength="30" value="${objWithAddr?.addr3?.encodeAsHTML()}" /></dd>                                                      
    <g:if test="${['USA', 'CAN'].find {it == objWithAddr?.countryCode}}">
		<dt>City/State/Zip:</dt><dd>
									<g:textField name="city" maxlength="15" value="${objWithAddr?.city}"/> 
    								<g:if test="${'USA' == objWithAddr?.countryCode}">
	                                	<g:select name="state" from="${StateCode.list(sort:'id')}" optionKey="id" optionValue="name" value="${objWithAddr?.state}"  noSelection="${['':'Select One...']}"/>
	                                </g:if>
	                                <g:else>
	                                	<g:select name="state" from="${CanadianProvinceCode.list()}" optionKey="id" optionValue="name"  value="${objWithAddr?.state}" noSelection="${['':'Select One...']}"/>
	                                </g:else>
                                    <g:textField name="zipCode" size="9" maxlength="9" value="${objWithAddr?.zipCode}"/>
								</dd>                                
								  
	</g:if>
	<g:else>	
		<dt>Country Name:</dt>	<dd>${Country.findByIsoCode(objWithAddr?.countryCode).desc}</dd>
		<g:hiddenField name="city" value=""/> 
		<g:hiddenField name="state" value=""/> 
		<g:hiddenField name="zipCode" value=""/> 
	</g:else>
		                                                                             
</dl>
