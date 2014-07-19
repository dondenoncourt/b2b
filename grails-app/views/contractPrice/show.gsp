
<%@ page import="com.kettler.domain.orderentry.ContractPrice" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Show ContractPrice</title>
    </head>
    <body>
        <div class="body">
            <h1>Show ContractPrice</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="dialog">
                <table>
                    <tbody>

                    
                        <tr class="prop">
                            <td valign="top" class="name">Id:</td>
                            
                            <td valign="top" class="value">${contractPriceInstance.id}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Company Code:</td>
                            
                            <td valign="top" class="value">${contractPriceInstance.compCode}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Customer No:</td>
                            
                            <td valign="top" class="value">${contractPriceInstance.custNo}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Item No:</td>
                            
                            <td valign="top" class="value">${contractPriceInstance.itemNo}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Begin Century:</td>
                            
                            <td valign="top" class="value">${contractPriceInstance.beginCentury}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Begin Date:</td>
                            
                            <td valign="top" class="value">${contractPriceInstance.beginDate}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Expire Century:</td>
                            
                            <td valign="top" class="value">${contractPriceInstance.expireCentury}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Expire Date:</td>
                            
                            <td valign="top" class="value">${contractPriceInstance.expireDate}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Comments:</td>
                            
                            <td valign="top" class="value">${contractPriceInstance.comments}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Qty Unit Meas Code:</td>
                            
                            <td valign="top" class="value">${contractPriceInstance.qtyUnitMeasCode}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Thru Qty1:</td>
                            
                            <td valign="top" class="value">${contractPriceInstance.thruQty1}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Thru Qty2:</td>
                            
                            <td valign="top" class="value">${contractPriceInstance.thruQty2}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Thru Qty3:</td>
                            
                            <td valign="top" class="value">${contractPriceInstance.thruQty3}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Thru Qty4:</td>
                            
                            <td valign="top" class="value">${contractPriceInstance.thruQty4}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Thru Qty5:</td>
                            
                            <td valign="top" class="value">${contractPriceInstance.thruQty5}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Thru Qty6:</td>
                            
                            <td valign="top" class="value">${contractPriceInstance.thruQty6}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Thru Qty7:</td>
                            
                            <td valign="top" class="value">${contractPriceInstance.thruQty7}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Unit Price1:</td>
                            
                            <td valign="top" class="value">${contractPriceInstance.unitPrice1}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Unit Price2:</td>
                            
                            <td valign="top" class="value">${contractPriceInstance.unitPrice2}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Unit Price3:</td>
                            
                            <td valign="top" class="value">${contractPriceInstance.unitPrice3}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Unit Price4:</td>
                            
                            <td valign="top" class="value">${contractPriceInstance.unitPrice4}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Unit Price5:</td>
                            
                            <td valign="top" class="value">${contractPriceInstance.unitPrice5}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Unit Price6:</td>
                            
                            <td valign="top" class="value">${contractPriceInstance.unitPrice6}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">Unit Price7:</td>
                            
                            <td valign="top" class="value">${contractPriceInstance.unitPrice7}</td>
                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name">New Entity:</td>
                            
                            <td valign="top" class="value">${contractPriceInstance.newEntity}</td>
                            
                        </tr>
                    
                    </tbody>
                </table>
            </div>
        </div>
    </body>
</html>
