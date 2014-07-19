<%@ page import="com.kettler.domain.orderentry.SalesDivision" %>
<%@ page import="com.kettler.domain.orderentry.share.Role" %>
<%@ page import="com.kettler.domain.orderentry.share.SalesPerson" %>

<html>
  <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<% if (params.pdf) { %>
			<meta name="layout" content="pdf" />
		<% } else { %>
			<meta name="layout" content="main" />
		<% } %>
      <resource:dateChooser />
      <g:javascript library="prototype" />      
      <title>KETTLER Sales Analysis</title>
  </head>
<body>
<g:javascript>
	function onloadHandler() { // called in body of layout gsp
//		$('salesDivisionDT').hide();$('salesDivisionDD').hide();
//		$('unitsOrDollarsDT').hide();$('unitsOrDollarsDD').hide();
	}
	function reportTypeChanged(reportType) {
		$('salesDivisionDT').hide();$('salesDivisionDD').hide();
//		$('unitsOrDollarsDT').hide();$('unitsOrDollarsDD').hide();
		switch (reportType) {
		case '1':
			$('unitsOrDollarsDT').show();$('unitsOrDollarsDD').show();
		case '2':
		case '3':
			$('salesDivisionDT').show();$('salesDivisionDD').show();
			break;
		case '4':
//			$('unitsOrDollarsDT').show();$('unitsOrDollarsDD').show();
			break;
		}
	}
	// remove optional dates, if blank, so Grails command binding doesn't have an issue
	function checkOtherDates() {
		var ele;
		if ($('fromDate2_month').value == '') {
	    	ele = $('fromDate2'); 		ele.parentNode.removeChild(ele);
	    	ele = $('fromDate2_month'); ele.parentNode.removeChild(ele);
	    	ele = $('fromDate2_day');   ele.parentNode.removeChild(ele);
	    	ele = $('fromDate2_year');  ele.parentNode.removeChild(ele);
    	}
		if ($('fromDate3_month').value == '') {
	    	ele = $('fromDate3');       ele.parentNode.removeChild(ele);
	    	ele = $('fromDate3_month'); ele.parentNode.removeChild(ele);
	    	ele = $('fromDate3_day');   ele.parentNode.removeChild(ele);
	    	ele = $('fromDate3_year');  ele.parentNode.removeChild(ele);
    	}
		if ($('toDate2_month').value == '') {
	    	ele = $('toDate2'); 		ele.parentNode.removeChild(ele);
	    	ele = $('toDate2_month'); ele.parentNode.removeChild(ele);
	    	ele = $('toDate2_day');   ele.parentNode.removeChild(ele);
	    	ele = $('toDate2_year');  ele.parentNode.removeChild(ele);
    	}
		if ($('toDate3_month').value == '') {
	    	ele = $('toDate3');       ele.parentNode.removeChild(ele);
	    	ele = $('toDate3_month'); ele.parentNode.removeChild(ele);
	    	ele = $('toDate3_day');   ele.parentNode.removeChild(ele);
	    	ele = $('toDate3_year');  ele.parentNode.removeChild(ele);
	    }
    }

</g:javascript>
  	<div class="body">
		<h1>KETTLER Sales Analysis</h1>
		<g:if test="${message}"><div class="errors">${message}</div></g:if>
        <g:hasErrors bean="${cmd}">
	        <div class="errors">
	            <g:renderErrors bean="${cmd}" as="list" />
	        </div>
        </g:hasErrors>

		<g:form action="analyze" onsubmit="checkOtherDates();return true;">
			<dl>
				<jsec:hasRole name="${Role.KETTLER}">
					<dt>Comp Code:</dt>							<dd><input type="text" size="2" maxlength="2" id="compCode" value="${cmd?.compCode}" name="compCode" tabindex="1"/></dd>
					<dt>Report Type:</dt>						<dd><g:select name="reportType" value="${cmd?.reportType}" from="${['1','2','3','4','5','6' ]}" valueMessagePrefix="salesAnal.Rpt.Typ"  noSelection="${['':'Select One...']}" onchange="reportTypeChanged(this.value);" tabindex="2"/></dd>
				</jsec:hasRole>
				<jsec:hasAnyRole in="${[Role.CUSTOMER,Role.CUST_ADMIN]}">
					 											<input type="hidden"  name="compCode" value="${user.compCode}"/> 
					 											<input type="hidden"  name="reportType" value="4"/> 
				</jsec:hasAnyRole>
				<jsec:hasAnyRole in="${[Role.REP_PLUS, Role.REP,Role.REP_ADMIN]}">
					 											<input type="hidden"  name="compCode" value="${SalesPerson.get(user.salesperson.id).compCode}"/> 
					<dt>Report Type:</dt>						<dd><g:select name="reportType" value="${cmd?.reportType}" from="${['4', '5']}" valueMessagePrefix="salesAnal.Rpt.Typ"  noSelection="${['':'Select One...']}" onchange="reportTypeChanged(this.value);" tabindex="3"/></dd>
				</jsec:hasAnyRole>
				<dt>From/Thru:</dt> 							<dd><richui:dateChooser class="date" name="fromDate" format="MM/dd/yyyy"  value="${cmd?.fromDate}"   tabindex="4"/> <richui:dateChooser class="date" name="toDate" format="MM/dd/yyyy"  value="${cmd?.toDate}"    tabindex="5"/>mm/dd/yyyy </dd>
				<dt>&nbsp;</dt>		 							<dd><richui:dateChooser class="date" name="fromDate2" format="MM/dd/yyyy"  value="${cmd?.fromDate2}" tabindex="6" /> <richui:dateChooser class="date" name="toDate2" format="MM/dd/yyyy"  value="${cmd?.toDate2}" tabindex="7" />optional </dd>
				<dt>&nbsp;</dt> 								<dd><richui:dateChooser class="date" name="fromDate3" format="MM/dd/yyyy"  value="${cmd?.fromDate3}" tabindex="8"/> <richui:dateChooser class="date" name="toDate3" format="MM/dd/yyyy"  value="${cmd?.toDate3}"  tabindex="9"/>optional </dd>
				<dt>Number to Display:</dt>						<dd><g:select name="rowCount" from="${1..150}" value="${cmd?.rowCount?:'50'}" noSelection="['':'-Select one-']"/>	 
				<dt id="salesDivisionDT">Sales Division:</dt>	<dd id="salesDivisionDD">
				    <g:select name="salesDivision" 
				        from="${salesDivs}" 
				        optionKey="id" optionValue="desc" value="${cmd?.salesDivision}"  
				        noSelection="${['':'Select One...']}"
				         tabindex="10"
				    />
				</dd>
				<dt id="unitsOrDollarsDT">Units/Dollars:</dt>	<dd id="unitsOrDollarsDD"><g:select name="unitsOrDollars" from="${['U','D' ]}" valueMessagePrefix="unitsOrDollars"  value="${cmd?.unitsOrDollars?:'D'}"  noSelection="${['':'Select One...']}" tabindex="11"/></dd>	 
			</dl>
			<div class="buttons" >
				<g:submitButton class="search" name="analyze" value="Run Report" /> 
			</div>
		</g:form>
	</div>
</body>
</html>
