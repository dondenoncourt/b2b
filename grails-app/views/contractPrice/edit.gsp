
<%@ page import="com.kettler.domain.orderentry.ContractPrice" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Edit ContractPrice</title>
        <resource:dateChooser />
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLinkTo(dir:'')}">Home</a></span>
            <span class="menuButton"><g:link class="list" action="list">ContractPrice List</g:link></span>
            <span class="menuButton"><g:link class="create" action="create">New ContractPrice</g:link></span>
        </div>
        <div class="body">
            <h1>Edit ContractPrice</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${contractPriceInstance}">
            <div class="errors">
                <g:renderErrors bean="${contractPriceInstance}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" >
                <g:if test="${contractPriceInstance.COMPOSITE_KEY == false}">
                    <g:if test="${contractPriceInstance.id.class.name == 'String'}">
                        <input type="hidden" name="id" value="${contractPriceInstance?.id.trim()}" />
                    </g:if>
                    <g:else>
                        <input type="hidden" name="id" value="${contractPriceInstance?.id}" />
                    </g:else>
                </g:if>
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="compCode">Company Code:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:contractPrice,field:'compCode','errors')}">
                                    <input type="text" maxlength="2" id="compCode" name="compCode" value="${fieldValue(bean:contractPrice,field:'compCode')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="custNo">Customer No:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:contractPrice,field:'custNo','errors')}">
                                    <input type="text" maxlength="7" id="custNo" name="custNo" value="${fieldValue(bean:contractPrice,field:'custNo')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="itemNo">Item No:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:contractPrice,field:'itemNo','errors')}">
                                    <input type="text" maxlength="15" id="itemNo" name="itemNo" value="${fieldValue(bean:contractPrice,field:'itemNo')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="beginCentury">Begin Century:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:contractPrice,field:'beginCentury','errors')}">
                                    <input type="text" id="beginCentury" name="beginCentury" value="${fieldValue(bean:contractPrice,field:'beginCentury')}" />
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="beginDate">Begin Date:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:contractPrice,field:'beginDate','errors')}">
                                    <richui:dateChooser class="date" name="beginDate" value="${contractPrice?.beginDate}" ></richui:dateChooser> mm/dd/yyyy
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="expireCentury">Expire Century:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:contractPrice,field:'expireCentury','errors')}">
                                    <input type="text" id="expireCentury" name="expireCentury" value="${fieldValue(bean:contractPrice,field:'expireCentury')}" />
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="expireDate">Expire Date:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:contractPrice,field:'expireDate','errors')}">
                                    <richui:dateChooser class="date" name="expireDate" value="${contractPrice?.expireDate}" ></richui:dateChooser> mm/dd/yyyy
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="comments">Comments:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:contractPrice,field:'comments','errors')}">
                                    <input type="text" maxlength="15" id="comments" name="comments" value="${fieldValue(bean:contractPrice,field:'comments')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="qtyUnitMeasCode">Qty Unit Meas Code:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:contractPrice,field:'qtyUnitMeasCode','errors')}">
                                    <input type="text" maxlength="1" id="qtyUnitMeasCode" name="qtyUnitMeasCode" value="${fieldValue(bean:contractPrice,field:'qtyUnitMeasCode')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="thruQty1">Thru Qty1:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:contractPrice,field:'thruQty1','errors')}">
                                    <input type="text" id="thruQty1" name="thruQty1" value="${fieldValue(bean:contractPrice,field:'thruQty1')}" />
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="thruQty2">Thru Qty2:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:contractPrice,field:'thruQty2','errors')}">
                                    <input type="text" id="thruQty2" name="thruQty2" value="${fieldValue(bean:contractPrice,field:'thruQty2')}" />
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="thruQty3">Thru Qty3:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:contractPrice,field:'thruQty3','errors')}">
                                    <input type="text" id="thruQty3" name="thruQty3" value="${fieldValue(bean:contractPrice,field:'thruQty3')}" />
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="thruQty4">Thru Qty4:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:contractPrice,field:'thruQty4','errors')}">
                                    <input type="text" id="thruQty4" name="thruQty4" value="${fieldValue(bean:contractPrice,field:'thruQty4')}" />
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="thruQty5">Thru Qty5:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:contractPrice,field:'thruQty5','errors')}">
                                    <input type="text" id="thruQty5" name="thruQty5" value="${fieldValue(bean:contractPrice,field:'thruQty5')}" />
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="thruQty6">Thru Qty6:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:contractPrice,field:'thruQty6','errors')}">
                                    <input type="text" id="thruQty6" name="thruQty6" value="${fieldValue(bean:contractPrice,field:'thruQty6')}" />
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="thruQty7">Thru Qty7:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:contractPrice,field:'thruQty7','errors')}">
                                    <input type="text" id="thruQty7" name="thruQty7" value="${fieldValue(bean:contractPrice,field:'thruQty7')}" />
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="unitPrice1">Unit Price1:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:contractPrice,field:'unitPrice1','errors')}">
                                    <input type="text" id="unitPrice1" name="unitPrice1" value="${fieldValue(bean:contractPrice,field:'unitPrice1')}" />
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="unitPrice2">Unit Price2:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:contractPrice,field:'unitPrice2','errors')}">
                                    <input type="text" id="unitPrice2" name="unitPrice2" value="${fieldValue(bean:contractPrice,field:'unitPrice2')}" />
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="unitPrice3">Unit Price3:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:contractPrice,field:'unitPrice3','errors')}">
                                    <input type="text" id="unitPrice3" name="unitPrice3" value="${fieldValue(bean:contractPrice,field:'unitPrice3')}" />
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="unitPrice4">Unit Price4:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:contractPrice,field:'unitPrice4','errors')}">
                                    <input type="text" id="unitPrice4" name="unitPrice4" value="${fieldValue(bean:contractPrice,field:'unitPrice4')}" />
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="unitPrice5">Unit Price5:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:contractPrice,field:'unitPrice5','errors')}">
                                    <input type="text" id="unitPrice5" name="unitPrice5" value="${fieldValue(bean:contractPrice,field:'unitPrice5')}" />
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="unitPrice6">Unit Price6:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:contractPrice,field:'unitPrice6','errors')}">
                                    <input type="text" id="unitPrice6" name="unitPrice6" value="${fieldValue(bean:contractPrice,field:'unitPrice6')}" />
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="unitPrice7">Unit Price7:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:contractPrice,field:'unitPrice7','errors')}">
                                    <input type="text" id="unitPrice7" name="unitPrice7" value="${fieldValue(bean:contractPrice,field:'unitPrice7')}" />
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="newEntity">New Entity:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:contractPrice,field:'newEntity','errors')}">
                                    <input type="hidden" name="newEntity" value="${contractPrice?.newEntity}"/>
                                </td>
                            </tr> 
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <span class="button"><g:actionSubmit class="save" value="Update" /></span>
                    <span class="button"><g:actionSubmit class="delete" onclick="return confirm('Are you sure?');" value="Delete" /></span>
                </div>
            </g:form>
        </div>
    </body>
</html>
