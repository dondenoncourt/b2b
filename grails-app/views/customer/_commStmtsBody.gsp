<%@ page import="com.kettler.domain.orderentry.share.Role" %>
<%@ page import="com.kettler.domain.orderentry.share.SalesPerson" %>
<%@ page import="com.kettler.domain.orderentry.share.Role" %>
<%@ page import="com.kettler.domain.orderentry.share.WebUser" %>
<%@ page import="org.jsecurity.SecurityUtils" %>


<g:if test="${list?.size()}">
 <div class="full">
    <table class="wide">
        <thead>
            <tr>
                <th>Cust No</th>
                <th>Name</th>
                <th>Invoice No</th>
                <th>Invoice Date</th>
                <th>PO No</th>
                <th>Item No</th>
                <th>Sales</th>
                <th>Misc</th>
                <th>Net</th>
                <th>Rate</th>
                <th>Comm</th>
            </tr>
        </thead>
        <tbody>
        <% 
            def lastCustNo = ''
            def lastInvNo = ''
        %>
        <g:each in="${list}" status="i" var="dtl">
            <% def total = dtl.itemNo.contains('TOTALS') %>
            <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                <% if (total && i) { %>
                    <td colspan="6"/>
                <% } else { %>
                    <% if (dtl.custNo == lastCustNo && i) { %>
                        <td colspan="2"/>
                    <% } else { %>
                 <td>${dtl.custNo.replaceAll(/&/,'&#38;')}</td>
                 <td>${dtl.name.encodeAsHTML().replaceAll(/&amp;/,'&#38;')}</td>
                    <% } %>
                    <% if (dtl.invoiceNo == lastInvNo && i) { %>
                        <td colspan="3"/>
                    <% } else { %>
                  <td>${dtl.invoiceNo}</td>
                  <td>${dtl.invoiceDate}</td>
                  <td>${dtl.poNo.encodeAsHTML().replaceAll(/&amp;/,'&#38;')}</td>
                    <% } %>
                    <td>${dtl.itemNo.encodeAsHTML().replaceAll(/&amp;/,'&#38;')}</td>
                <% } %>
                <td class="number ${total?'total':''}">${dtl.salesAmt}</td>
                <td class="number ${total?'total':''}">${dtl.miscAmt}</td>
                <td class="number ${total?'total':''}">${dtl.netAmt}</td>
                <td class="number ${total?'total':''}">${total?'':dtl.commRate}</td>
                <td class="number ${total?'total':''}">${dtl.commAmt}</td>
            </tr>
            <% 
                lastCustNo = dtl.custNo
                lastInvNo = dtl.invoiceNo
            %>
        </g:each>
        <tr><td colspan="8"></td></tr>
        <tr> 
            <td colspan="6"  class="total">Grand Totals:</td>
            <td class="total"><g:formatNumber number="${totalRow.salesAmt}" format="\$###,###,##0.00" /></td>
            <td class="total"><g:formatNumber number="${totalRow.miscAmt}" format="\$###,###,##0.00" /></td>
               <td class="total"><g:formatNumber number="${totalRow.netAmt}" format="\$###,###,##0.00" /></td>
            <td/> 
            <td class="total"><g:formatNumber number="${totalRow.commAmt}" format="\$###,###,##0.00" /></td>
        </tr>
        </tbody>
    </table>
     <% if (!params.pdf) { %>
         <div class="paginateButtons full">
             <g:paginate total="${count?:0}" params="${params}"/>
         </div>
    <% } %>
</div>
</g:if>
