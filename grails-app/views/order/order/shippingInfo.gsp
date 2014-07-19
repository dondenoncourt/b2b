<%@ page import="com.kettler.domain.orderentry.share.OrderHeader" %>
<%@ page import="com.kettler.domain.orderentry.share.ShipTo" %>
<%@ page import="com.kettler.domain.orderentry.ContractPrice" %>
<%@ page import="com.kettler.domain.orderentry.share.SalesPerson" %>
<%@ page import="com.kettler.domain.orderentry.share.Carrier" %>
<%@ page import="com.kettler.domain.orderentry.share.Role" %>
<%@ page import="com.kettler.domain.orderentry.FOBCode" %>
<%@ page import="com.kettler.domain.orderentry.Terms" %>
<%@ page import="com.kettler.domain.orderentry.PackListCode" %>
<%@ page import="com.kettler.domain.orderentry.share.SalesTax" %>
<%@ page import="com.kettler.domain.orderentry.SalesTermsTier" %>
<%@ page import="com.kettler.domain.orderentry.share.ShipVia" %>
<%@ page import="com.kettler.domain.orderentry.share.WebUser" %>
<%@ page import="com.kettler.domain.orderentry.ReferenceCode" %>

<%@ page import="com.kettler.domain.item.Warehouse" %>

<%@ page import="com.kettler.domain.actrcv.share.Customer" %>
<%@ page import="com.kettler.domain.actrcv.share.TableCode" %>

<%@ page import="com.kettler.domain.varsity.ShippingInstructions" %>

<%@ page import="com.kettler.domain.work.DateUtils" %>

<html>
  <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
      <meta name="layout" content="main" />
      <title>Shipping Information</title>
      <resource:dateChooser />
      <gui:resources components="['dataTable']"/>
      <g:javascript src="application" />
      <g:javascript library="prototype" />      
	  <g:javascript library="log4js" />		
  </head>
<body>
<% 
	def cust = Customer.findByCompCodeAndCustNo(ord.compCode, ord.custNo)
    def termsCodeByTier = orderService.getTermsCodeByTier(ord, cust.salesDivision, cust.salesGroup)?.trim()
%>
<%-- WebUser user = WebUser.findByEmail(SecurityUtils.getSubject()?.getPrincipal()?:'') --%>

<g:javascript>
	//var log = new Log(Log.DEBUG, Log.popupLogger);
	
	// page-specific javascript seems to be required after the body tag for Grails 1.1.1
    function refreshSpecialChargesSelects() {
      var params = 'shipInstructions='+$('shipInstructions').value;
      new Ajax.Request('${resource(dir:'order')}/specialChargesSelectAsJSON', {
        method: 'get',
        parameters: params,
        onSuccess: function(transport) {
          var json = eval(transport.responseText);
          var select1 = $('specialChrgCd1');
          var select2 = $('specialChrgCd2');
          var select3 = $('specialChrgCd3');
          select1.innerHTML = '';
          select2.innerHTML = '';
          select3.innerHTML = '';
          $('specialChargesDL').hide();
          if (json.length > 0) {
	          select1.options.add(new Option('Select one',''));
	          select2.options.add(new Option('Select one',''));
	          select3.options.add(new Option('Select one',''));
	          for (i = 0; i < json.length; i++) {
	            select1.options.add(new Option(json[i].chargeDescr,json[i].chargeCode));
	            select2.options.add(new Option(json[i].chargeDescr,json[i].chargeCode));
	            select3.options.add(new Option(json[i].chargeDescr,json[i].chargeCode));
	          }
	          $('specialChargesDL').show();
          } 
        },
	      onFailure: function(transport) {
            $('specialChargesDL').hide();
        }
      });
    }
    function checkDupPo(compNo, custNo, poNo, orderNo) {
        var params = 'compNo='+compNo+'&custNo='+custNo+'&poNo='+poNo+'&orderNo='+orderNo;
        new Ajax.Request('${resource(dir:'order')}/checkDupPo', {
          method: 'get',
          parameters: params,
          onSuccess: function(transport) {
            if (transport.responseText == 'true') {
                alert("Purchase order "+poNo+" already exists");
                $('poNo').focus();
            } 
          }
        });
    }
	function showHideEarlyBuyDueDate() {
		if ($('termsCode').value == 0) { // early buy
			$('earlyBuyDueDateDT').show();
			$('earlyBuyDueDateDD').show();
		} else {
			$('earlyBuyDueDateDT').hide();
			$('earlyBuyDueDateDD').hide();
		}
	} 
	function onloadHandler() { // called in body of layout gsp
	    acknChanged($('acknCheckBox'));
		showHideEarlyBuyDueDate();
		<jsec:lacksRole name="${Role.KETTLER}">
			<% if (!termsCodeByTier || termsCodeByTier == '1') { %>  
			    var shipVia = $('shippingForm').shipViaSCACShipIns.value;
				if (shipVia != '') {
					$('shpTrmDT').show();$('shpTrmDD').show();
				} else {
					$('shpTrmDT').hide();$('shpTrmDD').hide();
				}
			<% } %>
			$('shipViaSCACShipIns').options.add(new Option('', 'ROUTINGS'));
		</jsec:lacksRole>
		if ($('shipInstructions') != null) { 
			refreshSpecialChargesSelects();
		}
		<% if (inquiry) { %>
			disableFormFields('shippingForm') ;
		<% } %>
		shipCompleteChanged();
		<% if (ordDate) { %>
			$('reqShipDT').show();$('reqShipDD').show();
            <jsec:hasRole name="${Role.KETTLER}">
			     $('pickDT').show();$('pickDD').show();
			</jsec:hasRole>
		<% } else { %>
			$('reqShipDT').hide();$('reqShipDD').hide();
            <jsec:hasRole name="${Role.KETTLER}">
    			$('pickDT').hide();$('pickDD').hide();
    		</jsec:hasRole>
		<% } %>
		<% if (ord.hasExtraShipInst) { %> 
			$('xtrShipInsDT').show();$('xtrShipInsDD').show();
		<% } else { %>
			$('xtrShipInsDT').hide();$('xtrShipInsDD').hide();
		<% } %> 
		<% if (!inquiry) { %>
			<jsec:lacksRole name="${Role.KETTLER}">
				<% if (!termsCodeByTier || termsCodeByTier == '1') { %>  
					hideShipViaCheckboxes();
					$('insDT').hide();$('insDD').hide();
					$('liftDT').hide();$('liftDD').hide();
					$('insDelDT').hide();$('insDelDD').hide();
					$('resiDelDT').hide();$('resiDelDD').hide();
				    var shipVia = $('shippingForm').shipViaSCACShipIns.value;
					if (shipVia.startsWith('UPS') ||  shipVia.startsWith('Fedex')) {
						$('sigReqDT').show();$('sigReqDD').show();
						$('insDT').show();$('insDD').show();
					} else if (shipVia.startsWith('COMMON CARRIER')) {
						$('liftDT').show();$('liftDD').show();
						$('insDelDT').show();$('insDelDD').show();
						<% if (ord.shipToNo == 9999) { %>
							$('resiDelDT').show();$('resiDelDD').show();
						<% } %>
					}
				<% } %>
			</jsec:lacksRole>
		<% } %>
		<% 
		if (user.role.name == Role.CUSTOMER || user.role.name == Role.CUST_ADMIN ||
		    user.role.name == Role.REP_PLUS || user.role.name == Role.REP        || user.role.name == Role.REP_ADMIN) {
		%>
		    $('scacDT').hide();$('scacDD').hide();
		    <% if (ord.fobCode == 'TP'  ) { %>
		    	$('scacDT').show();$('scacDD').show();
			<% } %>
		<% } %>
		
	}
	function hideShipViaCheckboxes() {
		<jsec:lacksRole name="${Role.KETTLER}">
			$('sigReqDT').hide();$('sigReqDD').hide();
			$('insDT').hide();$('insDD').hide();
			$('liftDT').hide();$('liftDD').hide();
			$('insDelDT').hide();$('insDelDD').hide();
			$('resiDelDT').hide();$('resiDelDD').hide();
		</jsec:lacksRole>
	}
	function shipViaChange(shipVia) {
		<jsec:lacksRole name="${Role.KETTLER}">
			hideShipViaCheckboxes();
			
			// if 3rd Party selected, reset carrier as well
			if ($('fobCode').value == 'TP') {
				setCarrierFromShipIns();
			}
		
			if (shipVia != '') {
				$('shpTrmDT').show();$('shpTrmDD').show();
			} else {
				$('shpTrmDT').hide();$('shpTrmDD').hide();
			}
	
			if (shipVia.startsWith('UPS') || shipVia.startsWith('Fedex')) {
				$('sigReqDT').show();$('sigReqDD').show();
				$('insDT').show();$('insDD').show();
				$('shippingForm').liftGate.checked = false;
				$('shippingForm').insideDelivery.checked = false;
				$('shippingForm').resiDelivery.checked = false;
			} else if (shipVia.startsWith('COMMON CARRIER')) {
				$('liftDT').show();$('liftDD').show();
				$('insDelDT').show();$('insDelDD').show();
				<% if (ord.shipToNo == 9999) { %>
					$('resiDelDT').show();$('resiDelDD').show();
				<% } %>
				$('shippingForm').signatureRequired.checked = false;
				$('shippingForm').insurance.checked = false;
			}
		</jsec:lacksRole>
	}
	function fobChange(fob) {
		if (fob == 'TP') { // Third Party
		    $('scacDT').show();$('scacDD').show();
			<jsec:lacksRole name="${Role.KETTLER}">
				//log.debug($('fobCode').value);
				setCarrierFromShipIns();
			</jsec:lacksRole>
		} else {
		    $('scacDT').hide();$('scacDD').hide();
			$('carrierCode').value = '';
		}
		<jsec:lacksRole name="${Role.KETTLER}">
			if (fob == 'PC') { // CHARGE TO CUSTOMER
				$('shipViaSCAC	ShipIns').value = 'COMMON CARRIER'
			}
		</jsec:lacksRole>
	}
	function setCarrierFromShipIns() {
		//log.debug('setCarrierFromShipIns()');
		var shipIns = $('shipViaSCACShipIns').value;
		var carrierCodeDropDown = $('carrierCode');
		if (shipIns == 'COMMON CARRIER') {
			carrierCodeDropDown.disabled = false;
		} else {
			carrierCodeDropDown.disabled = true;
			var scac = '';
			if (shipIns.startsWith('UPS')) {
				scac = 'UPSN';
			} else if (shipIns.startsWith('Fedex')) {
				scac = 'FDE ';
				if (shipIns.endsWith('Ground')) {
					scac = 'FDEG';
				}
			}
			var options = carrierCodeDropDown.options;
			for (var i = 0; i < options.length; i++) {
				options[i].selected = false;
				if (options[i].value == scac) {
					options[i].selected = true;
				} 
			}
		}
	}
	function shipCompleteChanged() {
		if ($('shipComplete').checked) {
			$('backOrder').checked = false
		}
	}
	function backOrderChanged() {
		if ($('backOrder').checked) {
			$('shipComplete').checked = false
		}
	}
	function acknChanged(ackCheckBox) {
        var checked = ackCheckBox.checked
	    if (checked) {
	    	$('acknowledgement').value = 'Y';
	    } else {
	    	$('acknowledgement').value = 'N';
		}	    
		if (checked) {
			$('emailDT').show();$('emailDD').show();
		} else {
			$('emailDT').hide();$('emailDD').hide();
		}
		return true;
	}
	function emailChanged() {
		var acknEmail = $('acknEmail');
		if (acknEmail.value == null || acknEmail.value.length == 0)  {
			return true;
		}
		acknEmail.value = acknEmail.value.strip()
		var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
		if (!filter.test(acknEmail.value)) {
			alert('Please provide a valid email address');
			acknEmail.focus();
			return false;
		}
		return true;
	}
	function reqShipChanged(reqShip) {
		if (reqShip.value == 'date') {
			$('reqShipDT').show();$('reqShipDD').show();
            <jsec:hasRole name="${Role.KETTLER}">
    			$('pickDT').show();$('pickDD').show();
    	    </jsec:hasRole>
		} else {
			$('reqShipDT').hide();$('reqShipDD').hide();
			<jsec:hasRole name="${Role.KETTLER}">
			   $('pickDT').hide();$('pickDD').hide();
			</jsec:hasRole>
		}
	}
	/* invoke setShipTo event unless shipToNo is 9999, then invoke createDropShip event */
	function shipToNoSelected(shipToNo) {
		<jsec:hasRole name="${Role.KETTLER}">
			if ($('sellToNo').value == '') {
				$('sellToNo').value = '0';
			}
		</jsec:hasRole> 
		var formValues = $('shippingForm').serialize();
		// strip off any g:submitButton event names as the is explicitly set by this function  
		formValues = formValues.substr(0, formValues.lastIndexOf('&_eventId'));
		var event = 'setShipTo';
		if (shipToNo == 9999) {
			event = '_createDropShip';
		} else {
            event = '_setShipTo';
		}
		window.location='/${meta(name:'app.name')}/order/order?execution='+$('execution').value+'&_eventId'+event+'='+event+'&'+formValues;
	}		
	function hasExtraShipInstChanged(checked) {
		if (checked) {
			$('xtrShipInsDT').show();$('xtrShipInsDD').show();
		} else {
			$('extraShipInst').value = ''
			$('xtrShipInsDT').hide();$('xtrShipInsDD').hide();
		}		
	}
	function submitHandler() {
		<jsec:hasRole name="${Role.KETTLER}">
			if ($('fobCode').value == '') {
				alert('Please set Shipping Terms');
				return false;
			}
		</jsec:hasRole>
        <jsec:lacksRole name="${Role.KETTLER}">
            <% if (!custRepSetShipTo) { %>
                alert('Please select a Ship-To before proceeding');
                return false;
            <% } %>
        </jsec:lacksRole>
	}			
	function carrierCodeChanged(carrierCode) {
		<jsec:hasRole name="${Role.KETTLER}">
	        new Ajax.Request('${resource(dir:'order')}/getShippingInstructionsForCarrier', {
	          method: 'get',
	          parameters: 'carrierCode='+carrierCode,
	          onSuccess: function(transport) {
					$('shipInstructionsDD').innerHTML = transport.responseText; 
	          }
	        });
		</jsec:hasRole>
		<jsec:lacksRole name="${Role.KETTLER}">
			var shipVia = $('shippingForm').shipViaSCACShipIns.value;
			if (shipVia.startsWith('COMMON CARRIER'))	 { 
			    if (carrierCode.startsWith('FDE')) {
			    	alert('Please change Ship Via to a Federal Express selection');
			    	$('shippingForm').shipViaSCACShipIns.focus();
			    } else if (carrierCode == 'UPSN') {
			    	alert('Please change Ship Via to a UPS selection');
			    	$('shippingForm').shipViaSCACShipIns.focus();
			    }
			}
		</jsec:lacksRole>
	}
    function cancel() {
        var confirmation = confirm('Are you sure?');
        if (confirmation) {
            submitHandler = function () {}
        }
        return confirmation;
    }
</g:javascript>
<div class="body">
   	<h1>Order Shipping <%= inquiry?'Inquiry':'Maintenance' %></h1>
	<g:if test="${message}"><div class="errors">${message}</div></g:if>
	<g:hasErrors bean="${ord}"><div class="errors"><g:renderErrors bean="${ord}" as="list" /></div></g:hasErrors>
	<% 
		SalesTermsTier curTier 
		SalesTermsTier nextTier 
	 	if (!ContractPrice.inEffectForCust(ord.compCode, ord.custNo) && ord.termsCode.trim() != Terms.CREDIT_CARD ) {
        	curTier = SalesTermsTier.getTier(ord.compCode, cust.salesDivision, cust.salesGroup, orderTotalInfo.netAmount)
        	nextTier = SalesTermsTier.getNextTier(ord.compCode, cust.salesDivision, cust.salesGroup, orderTotalInfo.netAmount)
	 	}
		if (nextTier?.tier) {
	%>
		<div class="message">
			Increase your order by <g:formatNumber number="${(curTier.amount - orderTotalInfo.netAmount)}" format="\$###,##0"/> to receive payment terms of <%= Terms.get(nextTier.termsCode).desc %></dd>
		</div>
	<% } %>

	<g:form action="order" name="shippingForm" method="post" onsubmit="return submitHandler();">

		<div id="custDiv" class="col1">
			<dl>
				<dt>Customer No:</dt>		<dd>${ord.custNo}</dd>
				<dt>Phone No:<dt>			<dd>${(cust?.phoneNo)?:'&nbsp;'}&nbsp;</dd>
				<dt>Address:<dt>			<dd>${cust?.name}</dd>     
				<dt>&nbsp;</dt>				<dd>${cust?.addr1?.encodeAsHTML()}<br/>
				<g:if test="${cust?.addr2}">
					<dt>&nbsp;</dt>			<dd>${cust?.addr2?.encodeAsHTML()}</dd>
				</g:if>
				<g:if test="${cust?.addr3}">
					<dt>&nbsp;</dt>			<dd>${cust?.addr3?.encodeAsHTML()}</dd>
				</g:if>
				<dt>&nbsp;</dt>				<dd>${cust?.city}, ${cust?.state} &nbsp;&nbsp;&nbsp;${cust?.zipCode}</dd>
			    <g:if test="${!(['USA', 'CAN'].find {it == cust?.countryCode})}">
					<dt>&nbsp;</dt>			<dd>${cust?.countryName}</dd>
				</g:if>
			</dl>
		</div>

		<div id="shipToDiv" class="col2">
			<g:if test="${shipTo}">
				<dl>
					<dt>Ship-To No:</dt>		<dd>${(ord.shipToNo?:'&nbsp;')}</dd>
					<g:if test="${(ord.shipToNo < 9999)}">
						<dt>Phone No:<dt>		<dd><input type="text" maxlength="10" id="shippingPhoneNo" name="shippingPhoneNo" value="${ord.shippingPhoneNo}"/></dd>
					<%--<dt>Location type:</dt> <dd><g:select name="residentialCommercial" from="${ShipTo.constraints.residentialCommercial.inList}" valueMessagePrefix="shipTo.resi.comm" value="${ord.residentialCommercial}" /></dd>--%>
					</g:if>
					<g:else>
						<dt>Phone No:<dt>		<dd>${(shipTo?.phoneNo)?:'&nbsp;'}&nbsp;</dd>
					</g:else>
					<% if (shipTo?.residentialCommercial == 'R') { %>
						<span class="resicomm">Residential</span><br/>
					<% } %>
					<dt>Ship-To Address:</dt>		<dd>&nbsp;</dd>
				</dl>
				${shipTo?.name}<br/>
				${shipTo?.addr1.encodeAsHTML()}<br/>
				<g:if test="${shipTo?.addr2}">
					${shipTo?.addr2.encodeAsHTML()}<br/>
				</g:if>
				<g:if test="${shipTo?.addr3}">
					${shipTo?.addr3.encodeAsHTML()}<br/>
				</g:if>
				<g:if test="${['USA', 'CAN'].find {it == shipTo?.countryCode}}">
					${shipTo?.city}, ${shipTo?.state} ${shipTo?.zipCode}
				</g:if>
				<br/>
			</g:if>
			<g:else>
				<dl>
				    <dt>Ship-To Address:</dt>
				    <dd>
				        <% if (user.role.name == Role.KETTLER || custRepSetShipTo) {%>
				        <span id="same">Same</span><br/>
				        <% } %>
				    </dd>
				</dl>
			</g:else>
			<g:if test="${!inquiry}">
				<% 
					def shipToList = [new ShipTo(name:'Click to add a Ship-To Address for this order only', shipToNo:9999, city:'', state:'',zipCode:'')] // dummy object
					if (ord.shipToNo) {
						shipToList << new ShipTo(name:'Click to reset Ship-To Address to the Customer address', shipToNo:0, city:'', state:'',zipCode:'') // dummy object
					} else if (user.role.name != Role.KETTLER && custRepSetShipTo == false) {
                        shipToList << new ShipTo(name:'Set Ship-To Address to your customer address', shipToNo:0, city:'', state:'',zipCode:'') // dummy object
					}
					shipToList += orderService.getShipToList(ord.compCode, ord.custNo, ord.orderNo) 
				 %>
				<g:select name="shipToNoPick" from="${shipToList}" optionKey="shipToNo" noSelection="${['0':'Pick a different Ship-To location: ...']}"
						onchange="shipToNoSelected(this.value);" />
			</g:if>
			<br/><br/>
		</div>
		<div style="clear:both;">
			<div class="col1">
				<dl>
					<dt>Ship Date:</dt> 			<dd class="value">
														ASAP: <g:radio name="reqShip" value="asap" checked="${(!ordDate)}" onclick="reqShipChanged(this);"/> 
					 									Prompt for date: <g:radio name="reqShip" value="date"  checked="${(ordDate)}" onclick="reqShipChanged(this);"/>
					 								</dd>
					<dt id="reqShipDT">Req Ship Date:</dt>
													<dd class="value" id="reqShipDD"><richui:dateChooser class="date" name="reqShipDate" value="${ordDate?.date}" format="MM/dd/yyyy" /> mm/dd/yyyy </dd>
                    <jsec:hasRole name="${Role.KETTLER}">
                        <dt id="pickDT">Pick Date:</dt>
                                                    <dd class="value" id="pickDD"><richui:dateChooser class="date" name="pickDate" value="${ord?.pickDate}" format="MM/dd/yyyy" /> mm/dd/yyyy </dd>
						<dt>Warehouse:</dt> 		<dd class="value"> <g:select name="warehouse" from="${Warehouse.list()}" optionKey="code" optionValue="name" value="${ord.warehouse}"/> </dd>
					</jsec:hasRole>
					<dt>Purchase Order No:</dt> 	<dd class="value"> <input type="text" maxlength="25" id="poNo" name="poNo" value="${fieldValue(bean:ord,field:'poNo')}" onChange="checkDupPo('${ord.compCode}', '${ord.custNo}', this.value, '${ord.compCode}');"/>  </dd>      		
					<jsec:lacksRole name="${Role.KETTLER}">
						<%-- if there is a payment term tier, 1 is the default, but for all others, don't show Ship Via or Shipping terms --%>
						<% if (!termsCodeByTier || termsCodeByTier == '1') { %>  
							<dt>Ship Via:</dt> 			<dd class="value">
															<g:select name="shipViaSCACShipIns" from="${shipViaCustViewable}" onchange="shipViaChange(this.value);" value="${ord.shipViaSCACShipIns}" noSelection="${['':'Best Way']}"/>
														</dd>
							<dt id="sigReqDT">	Signature Required:</dt>	<dd id="sigReqDD">	<g:checkBox name="signatureRequired" value="${ord.signatureRequired}"/></dd>
							<dt id="insDT">		Insurance:</dt>				<dd id="insDD">		<g:checkBox name="insurance" value="${ord.insurance}"/></dd>
							<dt id="liftDT">	Lift Gate:</dt>				<dd id="liftDD">	<g:checkBox name="liftGate" value="${ord.liftGate}"/></dd>
							<dt id="insDelDT">	Inside Delivery:</dt>		<dd id="insDelDD">	<g:checkBox name="insideDelivery" value="${ord.insideDelivery}"/></dd>
							<dt id="resiDelDT">	Residential Delivery:</dt>	<dd id="resiDelDD">	<g:checkBox name="resiDelivery" value="${ord.resiDelivery}"/></dd>
						<% } %>
					</jsec:lacksRole>
					<% if (!termsCodeByTier || termsCodeByTier == '1') { %>  
						<dt id="shpTrmDT">Shipping Terms:</dt> 		
													<dd class="value" id="shpTrmDD">
														<g:if test="${inquiry }">
															${(ord.fobCode?FOBCode.get(ord.fobCode)?.desc:'&nbsp;')}
														</g:if>
														<g:else>
															<jsec:lacksRole name="${Role.KETTLER}">
																<g:select name="fobCode" from="${FOBCode.findAllByIdNotEqual('PP')}" optionKey="id" optionValue="desc" onchange="fobChange(this.value);" value="${ord.fobCode}" noSelection="${['':'Select One...']}"/>
															</jsec:lacksRole>															
															<jsec:hasRole name="${Role.KETTLER}">
																<g:select name="fobCode" from="${FOBCode.list()}" optionKey="id" optionValue="desc" onchange="fobChange(this.value);" value="${ord.fobCode}" noSelection="${['':'Select One...']}"/>
															</jsec:hasRole>															
														</g:else>
													</dd>
					<% } %>
					<dt id="scacDT">Carrier:</dt>	<dd class="value" id="scacDD">
														<g:if test="${inquiry }">
															${(ord.carrierCode?Carrier.get(ord.carrierCode)?.desc:'&nbsp;')}
														</g:if>
														<g:else>
															<g:select name="carrierCode" from="${Carrier.list(sort:'desc')}" optionKey="id" optionValue="desc" value="${ord.carrierCode}" noSelection="${['':'Select One...']}"
																onChange="carrierCodeChanged(this.value);"/>
														</g:else>
													</dd>
					<jsec:hasRole name="${Role.KETTLER}">
						<dt>Ship Method:</dt> 		<dd class="value" id="shipInstructionsDD">
														<input type="text" maxlength="15" id="shipInstructions" name="shipInstructions" size="12" value="${fieldValue(bean:ord,field:'shipInstructions')}" disabled="disabled"/>
														<% if (!inquiry) { %>
															<a href="#" id="showShipInstrDataTableDialog" class="button" title="Click to search for shipping instructions" 
																onclick="$('shipInstrDataTableDialog').setStyle({left: '1em'});">Search</a>
														<% } %>  
														<g:render template="shipInstrDataTableDialog"/>
													</dd>
						</dl>
						<dl id="specialChargesDL">
							<dt>Special Charge 1:</dt> 		<dd class="value"> <select id="specialChrgCd1" name="specialChrgCd1"></select> </dd>
							<dt>               2:</dt> 		<dd class="value"> <select id="specialChrgCd2" name="specialChrgCd2"></select> </dd>
							<dt>               3:</dt> 		<dd class="value"> <select id="specialChrgCd3" name="specialChrgCd3"></select> </dd>
						</dl>
						<dl>
					</jsec:hasRole>
					<dt>Payment Terms:</dt> 		<dd class="value">
														<jsec:lacksRole name="${Role.KETTLER}">
															<g:hiddenField name="termsCode" value="${ord.termsCode}"/>
															${(Terms.get(ord.termsCode)?.desc)}
														</jsec:lacksRole>      
														<jsec:hasRole name="${Role.KETTLER}">
															<g:select name="termsCode" from="${Terms.list()}" optionKey="id" optionValue="desc" value="${ord.termsCode}" onChange="showHideEarlyBuyDueDate();" />
														</jsec:hasRole>
													</dd>
					<dt id="earlyBuyDueDateDT"> Early Buy Due Date: </dt> 
													<dd  id="earlyBuyDueDateDD" class="value"> 
														<richui:dateChooser class="date" name="dueDate" value="${ord?.dueDate}" format="MM/dd/yyyy" /> mm/dd/yyyy
													</dd>
					<% if (cust.refCode1) { %>						
						<dt>Cust Ref No:</dt> 		<dd class="value"> <input type="text" maxlength="25" id="custRef1" name="custRef1" value="${ord.custRef1}"/>  </dd>
					<% } %>       		
				</dl>
			</div>
			
			<div class="col2">
				<dl>
					<dt>Cancel Date:</dt> 			<dd class="value">
													<% 
														def cancelAfterDate =  ord.cancelAfterDate
														if (DateUtils.isEndOfTime(ord.cancelAfterDate)) { cancelAfterDate = null }
													%> 
														<richui:dateChooser class="date" name="cancelAfterDate" value="${cancelAfterDate}" format="MM/dd/yyyy" /> mm/dd/yyyy 
													</dd>
					<jsec:hasRole name="${Role.KETTLER}">
						<dt>Line Discounts:</dt> 	<dd class="value"> <g:checkBox name="lineDiscCode" value="${ord.lineDiscCode}" /> </dd>
					</jsec:hasRole>
					<dt>eMail Ackn:</dt> 			<dd class="value"> 
														<g:checkBox name="acknCheckBox" value="${(ord.acknowledgement == 'Y')}" onclick="acknChanged(this);" /> 
														<g:hiddenField name="acknowledgement" value="${ord.acknowledgement}"/>
													</dd>
					<dt id="emailDT">eMail:</dt>    <dd class="value" id="emailDD"><input type=text" name="acknEmail" id="acknEmail" value="${ord.acknEmail}" size="30" maxLength="50" onchange="emailChanged();"/></dd> 
					<dt>Extra Ship Notes:</dt> 		<dd class="value"><g:checkBox name="hasExtraShipInst" value="${(ord.extraShipInst?true:false)}" onclick="hasExtraShipInstChanged(this.checked);" /></dd>
					<dt id="xtrShipInsDT">Instructions:</dt> 
													<dd class="value" id="xtrShipInsDD"><input type="text" name="extraShipInst" id="extraShipInst" size="30" maxLength="30" value="${(ord.extraShipInst)}" /></dd>
					<jsec:hasRole name="${Role.KETTLER}">
						<dt>Tax Code 1:</dt> 		<dd class="value"> <g:select name="taxCode1" from="${SalesTax.list()}" optionKey="id" optionValue="desc"  value="${ord.taxCode1}" noSelection="${['':'Select One...']}"/> </dd>
						<dt>         2:</dt> 		<dd class="value"> <g:select name="taxCode2" from="${SalesTax.list()}" optionKey="id" optionValue="desc"  value="${ord.taxCode1}" noSelection="${['':'Select One...']}"/> </dd>
						<dt>         3:</dt> 		<dd class="value"> <g:select name="taxCode3" from="${SalesTax.list()}" optionKey="id" optionValue="desc"  value="${ord.taxCode1}" noSelection="${['':'Select One...']}"/> </dd>
					</jsec:hasRole>
					<dt>Ship Complete:</dt> 		<dd class="value"> <g:checkBox name="shipComplete" value="${ord.shipComplete}" onclick="shipCompleteChanged();" /> </dd>
					<dt>Allow Back Order:</dt> 		<dd class="value"> <g:checkBox name="backOrder" value="${ord.backOrder}" onclick="backOrderChanged();"/> </dd>
					<jsec:hasRole name="${Role.KETTLER}">
						<dt>Sales Person 1:</dt> 	<dd class="value"> <g:select name="salesperson1" from="${SalesPerson.list([sort:'id'])}" optionKey="id" value="${ord.salesperson1}" noSelection="${['':'Select One...']}"/> </dd>
						<dt>Discount Allow:</dt> 	<dd class="value">
														<g:if test="${ord.discAllowCode}">
															<img src="${createLinkTo(dir:'images/skin',file:'checkmark.gif')}" alt="Yes">
														</g:if>
														<g:else>No</g:else>
													</dd>
						<dt>Pack List:</dt> 		<dd class="value"> <g:select name="packingListCode" from="${PackListCode.list()}" optionKey="id" optionValue="desc" value="${ord.packingListCode}"/> </dd>
						<dt>Override AR Code:</dt><dd class="value"> <g:select name="overrideARCode" from="${TableCode.findAllByCompCodeAndType(ord.compCode,'S')}" optionKey="code" optionValue="desc"  value="${ord.overrideARCode}" noSelection="${['':'Select One...']}"/> </dd>
						<dt class="name"> Fullfill Sell-To No: </dt> 
													<dd class="value"> <input type="text" id="sellToNo" name="sellToNo" size="8" value="${fieldValue(bean:ord,field:'sellToNo')}" /> </dd>
					</jsec:hasRole>
					<jsec:lacksRole name="${Role.KETTLER}">
						<dt>Call Before Ship:</dt>  <dd class="value"> <g:checkBox name="callBeforeShipping" value="${orderService.callBeforeShippingExists(ordLines)}" /></dd>
					</jsec:lacksRole>      		
				</dl>
			</div>
		</div>
		<div class="buttons" >
			<g:submitButton class="table"   name="next" value="Next" title="Click to proceed to order summary"/>
			<jsec:hasRole name="${Role.KETTLER}">
				<g:if test="${!inquiry}">
					<g:submitButton class="add" name="custBillToAddr" value="Bill-To Addr" title="Click to add a Bill-To address"  />
				</g:if>
			</jsec:hasRole>
			<g:if test="${!inquiry}">
				<g:submitButton class="table"   name="back" value="Back" title="Click to return to the list of line items"  />
				<jsec:hasRole name="${Role.KETTLER}">
					<g:submitButton class="add" name="createShipTo" value="Add Ship-To"  title="Click to add a standard ship-to location"/>
				</jsec:hasRole>
                <g:submitButton class="house" name="cancel" value="Cancel Order" onclick="return cancel();" title="Click to cancel this order" />
	            <% if (ord.id) { %>
		            <g:submitButton class="house" name="abort" value="Cancel Update" onclick="return cancel();" title="Click to abort updates to this order" />
	            <% } %>
			</g:if>
			<g:if test="${inquiry}">
				<g:submitButton class="house" name="abort" value="Exit Inquiry" title="Click to end review of this order" />
			</g:if>
		</div>
	</g:form>
</div>
</body>
</html>
