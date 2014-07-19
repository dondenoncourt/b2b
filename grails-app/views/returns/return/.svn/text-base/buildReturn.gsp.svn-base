<%@ page import="com.kettler.domain.actrcv.share.Customer" %>
<%@ page import="com.kettler.domain.actrcv.share.Return" %>
<%@ page import="com.kettler.domain.actrcv.share.ReturnItem" %>
<%@ page import="com.kettler.domain.actrcv.share.ReturnItemDetail" %>
<%@ page import="com.kettler.domain.actrcv.share.ReturnFreightDenial" %>
<%@ page import="com.kettler.domain.actrcv.share.ReturnReason" %>
<%@ page import="com.kettler.domain.actrcv.share.ReturnStatus" %>
<%@ page import="com.kettler.domain.actrcv.share.ReturnNote" %>
<%@ page import="com.kettler.domain.actrcv.share.ReturnCondition" %>
<%@ page import="com.kettler.domain.actrcv.share.ReturnDisposition" %>
<%@ page import="com.kettler.domain.actrcv.share.ReturnFreightDesc" %>
<%@ page import="com.kettler.domain.actrcv.share.TableCode" %>

<%@ page import="com.kettler.domain.orderentry.CanadianProvinceCode" %>
<%@ page import="com.kettler.domain.orderentry.share.Carrier" %>
<%@ page import="com.kettler.domain.orderentry.share.Role" %>
<%@ page import="com.kettler.domain.orderentry.share.ShipVia" %>
<%@ page import="com.kettler.domain.orderentry.StateCode" %>
<%@ page import="com.kettler.domain.orderentry.share.WebUser" %>

<%@ page import="com.kettler.domain.item.Warehouse" %>

<%@ page import="com.kettler.domain.varsity.Country" %>

<%@ page import="org.jsecurity.SecurityUtils" %>

<html>
  <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
      <meta name="layout" content="main" />
      <title>Return Maintenance</title>
      <resource:dateChooser />
      <resource:autoComplete skin="default" />
      <gui:resources components="['tabView']"/>
      <g:javascript library="prototype" />
      <g:javascript src="jquery/jquery-1.4.2.min.js"/>     
  </head>
<body>
	<g:javascript>
	    jQuery.noConflict();
		function onloadHandler() { // called in body of layout gsp
			<% if (!ra.freightClaim) { %>
				$('freightClaimSection').hide();
			<% } %>
	        <% if (inquiry) { %>
	            disableFormFields('raForm') ;
	        <% } %>

            /* hack IE bug with tabbed dialog where input tables were stepping on each other */
            var listItems = $('tabView').getElementsByTagName('li');
            for (var i = 0; i < listItems.length; i++) {
                var text = listItems.item(i).getElementsByTagName('a').item(0).getElementsByTagName('em').item(0).innerHTML;
                listItems.item(i).getElementsByTagName('a').item(0).onclick = tabClickedListener(text);
            } 

            toggleShipMethodCarrier();
            freightDescXChanged($('freightDescX').value);
	        $('topPriorCustCr').onblur = blankToZero;
			$('shipHandCustCr').onblur = blankToZero;
			$('topPriorCustCr').onblur = blankToZero;
			$('freightCustCr').onblur = blankToZero;
			$('refurbRestockCustDb').onblur = blankToZero;
			$('freightInCustDb').onblur = blankToZero;
			$('manufacturerDb').onblur = blankToZero;
			$('qty').onblur = blankToZero;
			$('unitPrice').onblur = blankToZero;
            $('invoiceDisc').onblur = blankToZero;
		}	
		var blankToZero = function() {
            if (this.getValue().trim().length == 0) {
               this.setValue('0');
            }
        }    
		// hack IE bug with tabbed dialog where input tables were stepping on each other
        var tabClickedListener = function(tabName) { 
            return function() {
                if (tabName == 'Notes') {
                    $('notesTable').show();
                    $('returnItems').hide();
                } else if (tabName == 'Items &amp; Freight Claim') {
                    $('returnItems').show();
                    $('notesTable').hide();
                } else if (tabName == 'Summary Info') {
                    $('returnItems').hide();
                    $('notesTable').hide();
                } else if (tabName == 'Pick-Up Address') {
                    $('returnItems').hide();
                    $('notesTable').hide();
                } else {
                    alert('developer did not code JavaScript tabClickedListener() for tab: '+tabName);            
                }
            };
        }
	    function showSpinner(visible) { $('spinner').style.display = visible ? "inline" : "none"; }
		function ajaxInvoicedItemLookup() {
			new Ajax.Updater('invoicedItemsDiv','${createLink(controller:'returns',action:'invoicedItemsByOrder')}',
					{asynchronous:true,evalScripts:true,  
					 parameters:'&orderNo='+$('ordNo').value+'&poNo='+$('poNo').value+'&freightTrackingNo='+$('fgtTrkNo').value+'&compCode=0'+${ra.customer.compCode}+'&custNo=${ra.customer.custNo.replaceAll(/&/,'%26')}'
					}
			);
			return false;
		}
		function ajaxInvoicedOrderSelect(poNo, freightTrackingNo) {
			new Ajax.Updater('invoicedOrderSelectDiv','${createLink(controller:'returns',action:'invoicedOrderSelect')}',
					{asynchronous:true,evalScripts:true,  
					 parameters:'&custNo='+'${ra.customer.custNo}'+'&poNo='+poNo+'&freightTrackingNo='+freightTrackingNo
					}
			);
			return false;
		}
		function qtyChangeOk(inpQty, shipQty) { 
		    if (parseInt(inpQty.value) > parseInt(shipQty)) {
				alert('Return quantity > shipped quantity of '+shipQty+'. Management review will be necessary.'); 
				inpQty.parentNode.addClassName('errors');
				return false;
			}
			inpQty.parentNode.removeClassName('errors');
			return true;
		}
	    var qtyChangedListener = function(inpQty, shipQty) { 
	    	return function() {return qtyChangeOk(inpQty, shipQty)};
		}
		function priceChangeOk(inpPrice, unitPrice) {
			if (isNaN(inpPrice.value)) {
				alert(inpPrice.value+' is not a valid dollar value.'); 
				inpPrice.parentNode.addClassName('errors');
				return false;
			}
			if (Number(inpPrice.value) > Number(unitPrice)) {
				alert('Return price > shipped price of '+unitPrice+'. Management review will be necessary.'); 
				inpPrice.parentNode.addClassName('errors');
				return false;
		 	}
			inpPrice.parentNode.removeClassName('errors');
			return true;
		}		
	    var priceChangedListener = function(inpPrice, unitPrice) { 
	    	return function() {return priceChangeOk(inpPrice, unitPrice)};
		}
		function getOrderItemListFromForm(raForm) {
			var ordItemList = [];
			var count = 0;
			for (var i = 0; i < raForm.elements.length; ++i ) {
				var ele = raForm.elements[i];
				if (ele.name == 'orderNo') {
					ordItemList[count++] = [ele.value]
				}
			}
			count = 0;
			for (var i = 0; i < raForm.elements.length; ++i ) {
				var ele = raForm.elements[i];
				if (ele.name == 'itemNo') {
					var itemOrder = ordItemList[count++]
					itemOrder[1] = ele.value
				}
			}
			return ordItemList;
		}

		function addNote() {
            if ($('transientNote').value.length == 0) {
                return;
            }
		    var table = document.getElementById('returnNotes');
		
		    var tr         		= document.createElement('TR');
		    var tdNote   		= document.createElement('TD');
            var tdPrint         = document.createElement('TD');
		    var inpNote    		= document.createElement('TEXTAREA');
            var inpPrint        = document.createElement('INPUT');
		    var hideId   		= document.createElement('INPUT');

		    inpNote.setAttribute("name", "aNote"); 
		    inpNote.value = $('transientNote').value;

            inpPrint.setAttribute("type", "checkbox"); 
            inpPrint.setAttribute("name", "aNotePdf"+(table.rows.length-1));
            inpPrint.setAttribute("title", "Check to print note on PDF");

			hideId.setAttribute('type', 'hidden');
			hideId.setAttribute('name', 'aNoteId');
			hideId.setAttribute('value', '0');

		    tdNote.appendChild(inpNote);
            tdPrint.appendChild(inpPrint);

		    tr.appendChild(tdNote);
            tr.appendChild(tdPrint);
		    tr.appendChild(hideId);
		    table.appendChild(tr);
		    /* IE honors the set of checked only after the row is appended */
            if ($('transientNotePdf').checked) {
                inpPrint.setAttribute('checked',  true);
            }            
		    $('transientNote').value = '';
		}
		var itemInputs = 0;
        function selectItem(selectRow, orderNo, shipNo, itemNo, desc, shipQty, unitPrice) {
			// first check to see if the item is already in the RA
			var ordItemList = getOrderItemListFromForm($('raForm'));
			var duplicate = false;
			ordItemList.each(function(ordItem) {
  				if (ordItem[0] == orderNo && ordItem[1] == itemNo) {
  					duplicate = true;
  				}
			});
			if (duplicate) {
				alert('Item '+itemNo+' from order no: '+' is already in the Return');
				return;
			}	
			
		    var table = document.getElementById('returnItems');
		
		    var tr         		= document.createElement('TR');
		    var tdDelete   		= document.createElement('TD');
		    var tdItemNo   		= document.createElement('TD');
            var tdOrderNo       = document.createElement('TD');
            var tdQty           = document.createElement('TD');
            var tdRcvQty        = document.createElement('TD');
		    var tdPrice    		= document.createElement('TD');
		    var tdDesc     		= document.createElement('TD');
            var tdReason        = document.createElement('TD');
		    var inpQty     		= document.createElement('INPUT');
		    var inpPrice   		= document.createElement('INPUT');
	        var imgDlt     		= document.createElement('IMG');
		    var hideOrdNo  		= document.createElement('INPUT');
		    var hideShpNo       = document.createElement('INPUT');
		    var hideItmNo  		= document.createElement('INPUT');
		    var hideDesc   		= document.createElement('INPUT');
		    var hideNewFlg 		= document.createElement('INPUT');
		    var hideDlt    		= document.createElement('INPUT');

			hideOrdNo.setAttribute('type', 'hidden');
			hideOrdNo.setAttribute('name', 'orderNo');
			hideOrdNo.setAttribute('value', orderNo);
			
            hideShpNo.setAttribute('type', 'hidden');
            hideShpNo.setAttribute('name', 'shipNo');
            hideShpNo.setAttribute('value', shipNo);
			
			hideItmNo.setAttribute('type', 'hidden');
			hideItmNo.setAttribute('name', 'itemNo');
			hideItmNo.setAttribute('value', itemNo);
			
			hideDesc.setAttribute('name', 'desc');
			hideDesc.setAttribute('value', desc);
			hideDesc.setAttribute('type', 'hidden');
			
			hideNewFlg.setAttribute('name', 'newYorN');
			hideNewFlg.setAttribute('value', 'Y');
			hideNewFlg.setAttribute('type', 'hidden');
			
			hideDlt.setAttribute('name', 'delete');
			hideDlt.setAttribute('value', 'N');
			hideDlt.setAttribute('type', 'hidden');
			
	        imgDlt.setAttribute('src', '${resource(dir:'images',file:'delete.gif')}');
	        imgDlt.setAttribute('title', 'Click to remove this item');
	        imgDlt.onclick = function(){ removeItem(tr); }
	        tdDelete.appendChild(imgDlt);
		
		    inpQty.setAttribute('name', 'qty'); 
            inpQty.setAttribute('value', '1');
            inpQty.setAttribute('type', 'text');
			inpQty.setAttribute('size', 5);
			inpQty.setAttribute('class', 'number');
	        inpQty.onchange = qtyChangedListener(inpQty, shipQty);
		    tdQty.appendChild(inpQty);

		    inpPrice.setAttribute('name', 'unitPrice'); 
		    inpPrice.setAttribute('value', unitPrice); 
            inpPrice.setAttribute('type', 'text');
			inpPrice.setAttribute('size', 9);
			inpPrice.setAttribute('class', 'number');
	        inpPrice.onchange = priceChangedListener(inpPrice, unitPrice);  
		    tdPrice.appendChild(inpPrice);

			tdItemNo.innerHTML = itemNo;
			tdDesc.innerHTML = desc;
		    tdReason.innerHTML = '${select(name:"reasonId",from:ReturnReason.listOrderByCode(),optionKey:"id", optionValue:"code", noSelection:['':'Select a Return Reason...']).replaceAll(/\r/, '').replaceAll(/\n/, '')}';
		
		    table.appendChild(tr);
		    tr.appendChild(tdDelete);
		    tr.appendChild(tdItemNo);
            tr.appendChild(tdOrderNo);
		    tr.appendChild(tdQty);
//            tr.appendChild(tdRcvQty);
		    tr.appendChild(tdPrice);
		    tr.appendChild(tdDesc);
            tr.appendChild(tdReason);
		    tr.appendChild(hideOrdNo);
		    tr.appendChild(hideShpNo);
		    tr.appendChild(hideItmNo);
		    tr.appendChild(hideDesc);
		    tr.appendChild(hideNewFlg);
		    tr.appendChild(hideDlt);
		    
		    if (selectRow != null) {
		    	var parentOfRow = selectRow.parentNode
		    	selectRow.parentNode.removeChild(selectRow);
		    	/* if only the header row is left, close the popup */
		    	if (parentOfRow.rows.length == 1) { 
		    		$('orderItemDialog').hide();
		    		showSelects();
		    	}
		    }
		
		    itemInputs++;
		}
		function removeItem(tr){
		    tr.parentNode.removeChild(tr);
		    itemInputs--;
		}
		function addItem() {
		    var itemNo  = $('itemNoAdd').value;
		    var desc = itemSelect(itemNo);
		    var orderNoZero = 0;
		    var shipNoZero = 0;
		    var shipQtyZero = 0;
		    var unitPriceZero = 0;
		    var selectRowNull = null;
			selectItem(selectRowNull, orderNoZero, orderNoZero, itemNo, desc, shipQtyZero, unitPriceZero);
			$('itemNoAdd').value = ''; 
			$('addItemDialog').hide();
            $('returnItems').show();
			showSelects();
		}
		/* validate entry */
		function validate(raForm) {
		    <% if (ra.hold) { %>
		      return; // ra is on hold, don't bother validation
		    <% } %>
		    if (raForm._eventId_hold) {
              return; // ra is going to be put hold, don't bother validation
		    }
            for (var i = 0; i < raForm.elements.length; ++i ) {
                var ele = raForm.elements[i];
                if (ele.name == 'reasonId' && ele.value == '') {
                    alert('Please select a return reason for all items');
                    return false;
                }
                <% if (warehouse) { %>
                    if ($('fieldDestroy').value != 'on') {
		                if (ele.name == 'qty' && parseInt(ele.value ) == 0) {
		                    alert('Please enter a quantity for all items');
		                    return false;
		                }
		                if (/itemNo.*cond_idx\d*/.test(ele.id) && ele.value == '') {
		                    alert('Please select a condition for all items');
		                    return false;
		                }
		                if (/itemNo.*disp_idx\d*/.test(ele.id) && ele.value == '') {
		                    alert('Please select a disposition for all items');
		                    return false;
		                }
	                }
             <% } %>
            }
		    if ($('returnItems').rows.length < 2) {
		      alert('Please enter an item before pressing update');
		      return false
		    } 
            addNote();      
            /* if not freight claim, remove all date structures:
             * freightClaimPaid, carrierNotifiedDate, and freightClaimSubmit
             * and their _day, _month, _year sub fields
             * could just set div.innerhtml to blank?
             */ 
            if ($('freightClaim') == null || $('freightClaim').checked != true) {
                $('freightClaimSection').innerHTML = '';
            }      
			return true;
		}
		// Get all textareas that have a "maxlength" property. 
	    jQuery('textarea[maxlength]').live('keyup blur', function() {
	        // Store the maxlength and value of the field.
	        var maxlength = jQuery(this).attr('maxlength');
	        var val = jQuery(this).val();
	
	        // Trim the field if it has content over the maxlength.
	        if (val.length > maxlength) {
	            alert('Note cannot be greater than '+maxlength+' characters, value truncated.');
	            jQuery(this).val(val.slice(0, maxlength));
	        }
	    });	
		function freigthClaimChanged() {
			if ($('freightClaim').checked == true) {
				$('freightClaimSection').show();
				// the mouseovers are a hack to force IE to paint input boxes
                $('returnsMenuLI').onmouseover();				
                $('returnsMenuLI').onmouseout();               
			} else {
				$('freightClaimSection').hide();
			}
		}
        function setCarrierFromShipVia(viaText, scac) {
            var carrierCodeDropDown = $('carrier.id');
            if (viaText == 'COMMON CARRIER') {
                carrierCodeDropDown.disabled = false;
            } else {
                var options = carrierCodeDropDown.options;
                for (var i = 0; i < options.length; i++) {
                    options[i].selected = false;
                    if (options[i].value == scac) {
                        options[i].selected = true;
                    } 
                }
            }
        }
	    function setCarrier() {
            var viaText = $('shipVia.id').value;
	        var params = 'viaText='+viaText;
	        new Ajax.Request('${resource(dir:'returns')}/getScac', {
	          method: 'get',
	          parameters: params,
	          onSuccess: function(transport) {
	            if (transport.responseText != 'not found') {
	                setCarrierFromShipVia(viaText, transport.responseText)
	            } 
	          }
	        });
	    }
	    function itemSelect(itemNo) {
	        var desc;
	        var params = 'compCode=${ra.customer.compCode}&itemNo='+itemNo;
	        new Ajax.Request('${resource(dir:'itemMaster')}/getDesc', {
	          method: 'get',
	          parameters: params, 
	          asynchronous: false,
	          onSuccess: function(transport) {
                desc = transport.responseText;
	          }
	        });
	        return desc;
	    }
        function toggleShipMethodCarrier() {
            if ($('shippingTerms').value == 'PREPAID') {
                $('carrierDT').hide(); $('carrierDD').hide(); $('shpMtdDD').hide(); $('shpMtdDT').hide();
            } else {
                $('carrierDT').show(); $('carrierDD').show(); $('shpMtdDD').show(); $('shpMtdDT').show();
            }
        }    
        function freightDescXChanged(freightDescX) {
            if (freightDescX == '3') {
                $('freightCustCrDistrCode').value = 'IHC';
                $('freightCustCrDistrCode').hide();
            } else {
                $('freightCustCrDistrCode').show();
            }
        }
        function reasonIdChanged(reasonId) {
            if (reasonId == '12') {
                alert('be sure to add a note describing the "Other" reason');
            }
        }
        function deleteItem(deleteButton, index, itemNo) {
            $('delete'+index).value='Y';
            deleteButton.hide();
            alert('Item '+itemNo+' will be deleted when you click Update. Click Exit or Cancel to abort updates if you do not wish to have this item deleted');
            return true;
        }
                
	</g:javascript>
    <% WebUser user = WebUser.findByEmail(SecurityUtils.getSubject()?.getPrincipal()?:'') %>
    <div class="body">
    	<h1>Order Return ${inquiry?'Inquiry':'Maintenance'}</h1>
        <br/>
		<div >
			<g:if test="${message}"><div class="message">${message}</div></g:if>
			<g:hasErrors bean="${ra}"><div class="errors"><g:renderErrors bean="${ra}" as="list" /></div></g:hasErrors>
			<g:form action="return" method="post" name="raForm" onsubmit="return validate(this);"  enctype="multipart/form-data">
				<gui:tabView id="tabView">
				        
			        <gui:tab label="Summary Info" active="${ra.id?'false':'true'}"  >
						<div id="sumInfoCol1">
							<dl>
								<% if (ra.status) { %>
									<dt>Status:</dt>				        <dd>
									${ra.status.id}:${(ReturnStatus.get(ra.status.id)?.desc)}</dd>
								<% } %>
								<jsec:hasRole name="${Role.KETTLER}">
									<dt>Handling Credit:</dt>              <dd>
									                                            <kettler:raColText	name="shipHandCustCr" 		status="${ra.status}" lockStatus="DENYD" value="${ra.shipHandCustCr}" class="money" title="Credit amount to Customer for shipping and handling" />
									                                            <g:select name="shipHandDescX" from="${ReturnFreightDesc.findAllByIdNotEqual(3)}" optionKey="id" optionValue="descr" value="${ra.shipHandDesc?.id}"
									                                               disabled="${(ra?.status?.colLockLevel >= ReturnStatus.get('DENYD').colLockLevel?'true':'false')}" 
									                                            />
									                                        </dd>
                                    <dt>Top Priority Credit:</dt>           <dd><kettler:raColText  name="topPriorCustCr"       status="${ra.status}" lockStatus="DENYD" value="${ra.topPriorCustCr}" class="money" title="Credit amount to Customer for shipping and handling" /></dd>
									<dt>Freight Cust Credit:</dt>			<dd>
									                                            <kettler:raColText 	name="freightCustCr"		status="${ra.status}" lockStatus="DENYD" value="${ra.freightCustCr}" class="money" title="Credit amount to customer for freight" status="${ra.status}" lockStatus="DENYD"/>
                                                                                <g:select name="freightDescX" from="${ReturnFreightDesc.findAllByIdInList([2l,3l], [sort:'id', order:'desc'])}" optionKey="id" optionValue="descr" value="${ra.freightDesc?.id}" onchange="freightDescXChanged(this.value);"
                                                                                    disabled="${(ra?.status?.colLockLevel >= ReturnStatus.get('DENYD').colLockLevel?'true':'false')}" /> 
                                                                                <select name="freightCustCrDistrCode" id="freightCustCrDistrCode" title="Set UPS and FDEX to UPS, all others set to FRT. IHC is for Inbound Handling Charge only." 
                                                                                        ${(ra?.status?.colLockLevel >= ReturnStatus.get('DENYD').colLockLevel?'disabled=disabled':'')}>
                                                                                    <g:each in="${['UPS', 'FRT']}">
	                                                                                    <option value="${it}" ${((it == ra?.freightCustCrDistrCode)?'selected="selected"':'')}>${it}</option>
                                                                                    </g:each> 
                                                                                </select>
									                                        </dd>
									<dt>Refurb/Restock Debit:</dt>     	    <dd><kettler:raColText 	name="refurbRestockCustDb" 	status="${ra.status}" lockStatus="DENYD" value="${ra.refurbRestockCustDb}" class="number" size="2" title="Debit percentage of items dollar value to customer for refurbishing and stock"/>(Percent)</dd>
									<dt>Freight In Debit:</dt>			    <dd><kettler:raColText 	name="freightInCustDb" 		status="${ra.status}" lockStatus="DENYD" value="${ra.freightInCustDb}" class="money" title="Debit amount to customer for freight in"/></dd>
                                    <dt>Field Destroy:</dt>                 <dd><kettler:raColChk   name="fieldDestroy"         status="${ra.status}" lockStatus="CMQUE" value="${ra.fieldDestroy}" /></dd>
                                    <dt>Warehouse:</dt>                     <dd><kettler:raSelect   name="warehouse"            status="${ra.status}" lockStatus="NORA"  value="${ra?.warehouse}"   from="${Warehouse.findAllByCompCode(ra.customer.compCode)}"  optionKey="code" optionValue="name" noSelection="${['':'Select One...']}" /></dd>
                                    <dt>Invoice Discount:</dt>              <dd>
                                                                                Amount: <kettler:raColText  name="invoiceDisc"    status="${ra.status}" lockStatus="DENYD" value="${ra.invoiceDisc}"    class="money" title="Invoice Discount Amount"   size="5" status="${ra.status}" lockStatus="DENYD"/>
                                                                                or Percent:    <kettler:raSelect   name="invoiceDiscPct"           status="${ra.status}" lockStatus="DENYD"  value="${ra.invoiceDiscPct}" from="${2..9}"   noSelection="${['0':'0']}" />
                                                                            </dd>
                                    <dt>RA Shipping Terms:</dt>             <dd><kettler:raSelect   name="shippingTerms"        status="${ra.status}" lockStatus="NORA"  value="${ra?.shippingTerms}" keys="${Return.SHIPPING_TERMS_MAP.keySet().toArray()}" optionValue="value" from="${Return.SHIPPING_TERMS_MAP}"  onchange="toggleShipMethodCarrier();"/></dd>
	                                <dt id="shpMtdDT">Ship Method:</dt>     <dd id="shpMtdDD">
	                                                                            <kettler:raSelect   name="shipVia.id"           status="${ra.status}" lockStatus="NORA"  value="${ra?.shipVia?.id}" from="${ShipVia.list()}"  optionKey="id" optionValue="id" noSelection="${['':'Select One...']}" onchange="setCarrier();"/> 
	                                                                        </dd>
	                                <dt id="carrierDT">Carrier:</dt>        <dd id="carrierDD">
	                                                                            <kettler:raSelect   name="carrier.id"           status="${ra.status}" lockStatus="NORA"  value="${ra?.carrier?.id}" from="${Carrier.listOrderByDesc()}"  optionKey="id" optionValue="desc" noSelection="${['':'Select One...']}"/>
	                                                                        </dd> 
								</jsec:hasRole>
								<% if (ra.returnDate) { %>								 
									<dt>Return Date:</dt>					<dd><g:formatDate date="${ra.returnDate}" format="MM/dd/yy"/></dd>
								<% } %>
								<dt>Carrier Notified Date:</dt>				<dd> 
																				<% if ((ra.status?.colLockLevel?:0) >= ReturnStatus.get('NORA').colLockLevel) { %>
																					<g:formatDate date="${ra.carrierNotifiedDate}" format="MM/dd/yy"/>&nbsp;
																				<% } else { %>
                                                                                    <richui:dateChooser name="carrierNotifiedDate"  disabled="${ra.status?:0 >= ReturnStatus.get('NORA').colLockLevel}" value="${ra.carrierNotifiedDate}" class="date" format="MM/dd/yyyy" /> mm/dd/yyyy
																				<% } %>
																			</dd>
								
								<dt>Tracking No:</dt>						<dd>
								                                                <kettler:raColText 	name="freightTrackingNo" 	status="${ra.status}" lockStatus="CMDIF" value="${ra.freightTrackingNo}"  title="Pro Number or Freight Tracking Number" 
								                                                     disabled="${(ra?.status?.colLockLevel >= ReturnStatus.get('CMDIF').colLockLevel?'true':'false')}"
								                                                />
								                                            </dd>
                                <dt>Freight Claim:</dt>                     <dd class="value">
							                                                        <g:if test="${ra.freightClaim}">
							                                                            <img src="${createLinkTo(dir:'images/skin',file:'checkmark.gif')}" alt="Yes">
							                                                        </g:if>
							                                                        <g:else>No</g:else>
							                                                        &#160;
							                                                </dd>
                                <g:if test="${ra.freightClaim}">
                                    <dt>Claim Amount:</dt>                  <dd id="totalClaimAmount">&nbsp;${fgtClmAmtTtl}</dd>
                                </g:if>
                                <dt>Debit manufacturer:</dt>            <dd><kettler:raColChk   name="manufacturerDb"       status="${ra.status}" lockStatus="DENYD" value="${ra.manufacturerDb}" /></dd>
                            </dl>
						</div>
						<div id="sumInfoCol2"> 
                            <dl><dt/><dd/></dl>
                            <dl>
                                <dt>Customer:</dt><dd>${ra.customer.name}</dd>
                                <dt>Cust No:</dt><dd>${ra.customer.custNo}</dd>
                            </dl>
                            <dl>
                                <% if (ra.id) { %>
	                                <dt>RA No:</dt>
	                                <dd>${ra.id}</dd>
                                <% } %>
                            </dl>
                            <dl>
                                <dt>Created:</dt><dd><g:formatDate date="${ra?.createDate}" format="MM/dd/yy"/>&nbsp;</dd>
                                <dt>By:</dt><dd>${ra?.createUser}</dd>
                            </dl>
                            <dl>
                                <% if (ra.returnDate) { %>
	                                <dt>Returned:</dt><dd><g:formatDate date="${ra?.returnDate}" format="MM/dd/yy"/>&nbsp;</dd>
	                                <dt>By:</dt><dd>${ra?.receivedBy}</dd>
	                            <% } %>
                            </dl>
                            <dl>
                                <% if (ra.changeDate) { %>
                                    <dt>Changed:</dt><dd><g:formatDate date="${ra?.changeDate}" format="MM/dd/yy"/>&nbsp;</dd>
                                    <dt>By:</dt><dd>${ra?.changeUser}</dd>
                                <% } %>
                            </dl>
                            <dl>
                                <% if (ra.confirmDate) { %>
                                    <dt>Changed:</dt><dd><g:formatDate date="${ra?.confirmDate}" format="MM/dd/yy"/>&nbsp;</dd>
                                    <dt>By:</dt><dd>${ra?.confirmedBy}</dd>
                                <% } %>
                            </dl>
                            <dl>
                                <% if (ra.carrierNotifiedDate) { %>
                                    <dt>Carr Called:</dt><dd><g:formatDate date="${ra?.carrierNotifiedDate}" format="MM/dd/yy"/>&nbsp;</dd>
                                <% } %>
                                
                                <% if (ra.freightClaimSubmit) { %>
                                    <dt>Fgt Claim Submit:</dt><dd><g:formatDate date="${ra?.freightClaimSubmit}" format="MM/dd/yy"/>&nbsp;</dd>
                                <% } %>
                                
                                <% if (ra.freightClaimPaid) { %>
                                    <dt>Fgt Claim Paid:</dt><dd><g:formatDate date="${ra?.freightClaimPaid}" format="MM/dd/yy"/>&nbsp;</dd>
                                <% } %>
                                <dt>Total:</dt><dd>${raTotal}&nbsp;</dd>
                                <br/>
                                <% if (ra.id) { %>
	                                <dl><dt>Images Upload:</dt><dd id="uploadPrompt">Click Browse... to upload</dd></dl>
	                                <input type="file" name="image"/>       
	                                <br/>
	                                <% if (images?.size()) { %>
		                                <dl><dt>Images View:</dt><dd></dd>Click image file name to view</dl>
		                                <g:each var="image" status="i" in="${images}">
		                                    <a href="#" onclick="window.open('${g.createLinkTo(dir:'/')}returns/showImage/${image}')" 
		                                        title="click to view the image in a new window">${image}</a>
		                                </g:each>
	                                <% } %>
                                <% } %>
                            </dl>
                            <% if (cart?.consumer?.billTos && user?.user400?.returnAR) { %>
	                            <dl>
	                            	<dt>Credit Card No:</dt>
	                            	<dd>
	                            		<a onclick="$('cardNo').show();this.hide();" class="button">Show</a>
	                            		<span id="cardNo">
	                            			<% def billTo = cart?.consumer?.billTos?.toArray()[0] %>
	                            			${billTo.cardNo} Expire: ${billTo.expMonth}/${billTo.expYear}
	                            		</span>
	                            	</dd>
	                            </dl>
	                            <g:javascript>
	                            	$('cardNo').hide();
	                            </g:javascript>
                            <% } %>
                        </div>
					</gui:tab>
	
			        <gui:tab label="Items & Freight Claim" active="${ra.id?'true':'false'}" > 
                        <% if (ra.status || warehouse) { %>
                            <jsec:hasRole name="${Role.KETTLER}">
                                <dl>
                                <dt>Freight Claim:</dt>             <dd><kettler:raColChk   name="freightClaim"         status="${ra.status}" lockStatus="RAREJ" value="${ra.freightClaim}"  onclick="freigthClaimChanged();"/></dd>
                                </dl>
                            </jsec:hasRole>
                        <% } %>
                        <span id="freightClaimSection">
                            <fieldset><legend>Freight Claim Detail</legend>  
                                <dl>
                                    <dt>Carrier:</dt>                       <dd>${ra.carrier?.desc}&nbsp;</dd>
                                    <dt>Claim No:</dt>                      <dd><kettler:raColText  name="freightClaimNo"       status="${ra.status}" lockStatus="RAREJ" value="${ra.freightClaimNo}" title="claim number"/></dd>
                                    <dt>Submit Date:</dt>                   <dd>
                                                                                <% if ((ra.status?.colLockLevel?:0) >= ReturnStatus.get('RAREJ').colLockLevel) { %>
                                                                                    <g:formatDate date="${ra.freightClaimSubmit}" format="MM/dd/yy"/>&nbsp;
                                                                                <% } else { %>
                                                                                    <richui:dateChooser name="freightClaimSubmit" value="${ra.freightClaimSubmit}" class="date" format="MM/dd/yyyy" /> mm/dd/yyyy</dd>
                                                                                <% } %>
                                                                            </dd>
                                    <dt>Claim Amount:</dt>                  <dd id="totalClaimAmount">&nbsp;${fgtClmAmtTtl}</dd>
                              <%--      <dt>GL Code:</dt>                   <dd>${ra.freightClaimGLCode} <kettler:raSelect  name="freightClaimGLCode"   status="${ra.status}" lockStatus="RAREJ" from="${TableCode.findAllByCompCodeAndType(ra.customer.compCode,'S')}" optionKey="debitAcctNo" optionValue="desc"  noSelection="${['':'Select One...']}"/> </dd> --%>
                                    <dt>Check No:</dt>                      <dd><kettler:raColText  name="freightClaimCheckNo"  status="${ra.status}" lockStatus="RAREJ" value="${ra.freightClaimCheckNo}"  title="Freight claim check number"/></dd>
                                    <dt>Paid Amount:</dt>                   <dd><kettler:raColText  name="freightClaimAmountPaid"  status="${ra.status}" lockStatus="RAREJ" value="${ra.freightClaimAmountPaid}"  title="Freight claim amount paid"/></dd>
                                    <dt>Paid Date:</dt>                     <dd>
                                                                                <% if ((ra.status?.colLockLevel?:0) >= ReturnStatus.get('RAREJ').colLockLevel) { %>
                                                                                    <g:formatDate date="${ra.freightClaimPaid}" format="MM/dd/yy"/>&nbsp;
                                                                                <% } else { %>
                                                                                    <richui:dateChooser name="freightClaimPaid" value="${ra.freightClaimPaid}" class="date" format="MM/dd/yyyy" /> mm/dd/yyyy
                                                                                <% } %>
                                                                            </dd>
                                <dt>Denied:</dt>                            <dd><g:checkBox name="freightClaimDenied" value="${ra.freightClaimDenied}" /></dd>
                                </dl>
                            </fieldset>
                        </span>
						<table style="width:100%">
						   <tbody id="returnItems">
								<tr>
								   <th></th>
								   <th>Item</th>
                                   <% if (!['RAREQ', 'NEWRA', 'NORA'].find{it == ra.status?.id}) { %>
                                        <th>Order</th>
                                   <% } %>
								   <% if (warehouse) { %>	
								   		<th>Received Qty</th>
								   <% } else { %>
								   		<th>Auth Qty</th>
	                                   <% if (ra.status?.id && !['RAREQ', 'NEWRA', 'NORA'].find{it == ra.status?.id}) { %>
	                                        <th>Rcv Qty</th>
	                                   <% } %>
								   <% } %>
								   <th>Unit Price</th>
								   <th>Description</th>
                                   <th>Return Reason</th>
								</tr>
								<g:each var="item" status="i" in="${ra.items?.sort{it.itemNo}}">
									<tr class="${(i % 2) == 0 ? 'odd' : 'even'} " id="raRow${i}">
										<td>
										 	<img  src="${resource(dir:'images',file:'delete.gif')}"
										 			title="Click to remove this item"
										 			onclick="if (confirm('Are you sure?')) {deleteItem(this, ${i}, 'delete${i}', '${item?.itemNo}')};"
										 			/>
										 	<input  name="delete" id="delete${i}"  value="N" type="hidden" />
										</td>
										<td class="${(item.validate()?'':'errors')}" title="From invoiced order no: ${item.orderNo}">${item.itemNo}</td>
                                        <% if (ra.status?.id && !['RAREQ', 'NEWRA', 'NORA'].find{it == ra.status?.id}) { %>
                                             <td>${item.orderNo}</td>
                                        <% } %>
										<% if (warehouse) { %>	
											<td> 
												<kettler:raColText class="number" size="4" name="qty"   value="${item.receivedQty}" title="Note authorized quantity is ${item.authQty}"
													status="${ra.status}" lockStatus="CMDIF" 
													onchange="if (this.value != ${item.authQty}) alert('Note: received qty of '+this.value+' not equal to authorized qty of: ${item.authQty}');"
													onkeypress="checkNumeric(event);"
												/> 
											</td>
										<% } else { %>
											<td>
											     <kettler:raColText class="number" size="4" name="qty" status="${ra.status}" lockStatus="CMDIF" value="${item.authQty}"
											         title="${((ra.status?.id == 'NORA')?'Received quantity was '+item.receivedQty:'')}"
											     />
											</td>
                                           <% if (ra.status?.id && !['RAREQ', 'NEWRA', 'NORA'].find{it == ra.status?.id}) { %>
                                            <td class="number">${item.receivedQty}</td>
	                                       <% } %>
										<% } %>
										<td><kettler:raColText class="number" size="8" name="unitPrice"    value="${item.unitPrice}" status="${ra.status}" lockStatus="DENYD"/></td>
										<td>${item.desc}</td>
                                        <td><kettler:raSelect name="reasonId" status="${ra.status}" lockStatus="DENYD" value="${item.reason?.id}" from="${ReturnReason.listOrderByCode()}" optionKey="id" optionValue="code" noSelection="${['':'Select One...']}" onchange="reasonIdChanged(this.value);"/></td>
										
										
										<input value="${item.orderNo}" name="orderNo" type="hidden"/>
                                        <input value="${item.shipNo}"  name="shipNo"  type="hidden"/>
										<input value="${item.itemNo}"  name="itemNo"  type="hidden"/>
										<input value="${item.desc}"    name="desc"    type="hidden"/>
										<input value="N"               name="newYorN" type="hidden"/>
									</tr>
									<%  // 64-bit Windows didn't like in="${item.details?.sort{it.id}?:0..<(item.authQty)}">
									    if (ra.status?.id != 'NEWRA' || warehouse) { 
											def dtlList
											if (item.details) {
												dtlList = item.details.sort{it.id}
											} else {
												dtlList = (0..<(item.receivedQty))
											}
									%>	
										<g:each var="detail" status="j" in="${dtlList}">



											<tr> 
												<td/><td/>
												<td colspan="6">
													<% 
														def cond = ''
														def disp = ''
														def dtlWarehouse =''
														def dtlLocation = ''
														if (detail.class == com.kettler.domain.actrcv.share.ReturnItemDetail) { 
															cond = detail.condition?.id?:''
															disp = detail.disposition?.id?:''
															dtlWarehouse = detail.dtlWarehouse?:''
															dtlLocation = detail.dtlLocation?:''
														}
													%>
	                                               <% if (ra.status?.id && !['RAREQ', 'NEWRA', 'NORA'].find{it == ra.status?.id}) { %>
			      										Condition:
			      								   <% } /* otherwise don't have space */ %>
													<kettler:raSelect name="itemNo${item.itemNo}cond_idx${j}" value="${cond}" status="${ra.status}" lockStatus="CMQUE" 
													   from="${ReturnCondition.listOrderByCode()}"   optionKey="id" optionValue="code"   noSelection="['':'-Choose Condition-']"/>
	                                               <% if (ra.status?.id && !['RAREQ', 'NEWRA', 'NORA'].find{it == ra.status?.id}) { %>
	                                                  Disposition:
	                                               <% } /* otherwise don't have space */ %>
													<kettler:raSelect name="itemNo${item.itemNo}disp_idx${j}" value="${disp}" status="${ra.status}" lockStatus="CMQUE" 
													   from="${ReturnDisposition.listOrderByCode()}" optionKey="id" optionValue="code"   noSelection="['':'-Choose Disposition-']"/>
													
											<% if (warehouse) { %>
  												<kettler:raSelect   name="itemNo${item.itemNo}dtlWar${j}"  status="${ra.status}" lockStatus="NORA"  value="${dtlWarehouse}"   from="${Warehouse.findAllByCompCode(ra.customer.compCode)}"  optionKey="code" optionValue="name" noSelection="${['':'Select Warehouse...']}" />
												
	                                    		<kettler:raColText  name="itemNo${item.itemNo}dtlLoc${j}"   size="6"    	status="${ra.status}" lockStatus="NORA" value="${dtlLocation}"  title="Parts warehouse location" />
											<% } %> 

													<% if (j == 0 && dtlList.size() > 2 && 'NEWRA' == ra.status?.id) { %>
													   <a href="#" onclick="autoSetCondDisp_${i}(${dtlList.size()});" 
													       title="Click to set subsequent cond &amp; disp to be the same as the first one">
													       Auto-set
													   </a>
													   <g:javascript>
													       function autoSetCondDisp_${i}(count) {
                                                               var cond = $('itemNo${item.itemNo}cond_idx0').value
                                                               var disp = $('itemNo${item.itemNo}disp_idx0').value
                                                               var dtlWarehouse = $('itemNo${item.itemNo}dtlWar0').value
                                                               var dtlLocation = $('itemNo${item.itemNo}dtlLoc0').value
                                                               var condIdx = $('itemNo${item.itemNo}cond_idx0').selectedIndex
                                                               var dispIdx = $('itemNo${item.itemNo}disp_idx0').selectedIndex
                                                               var dtlWarehouseIdx = $('itemNo${item.itemNo}dtlWar0').selectedIndex
                                                               var dtlLocationIdx = $('itemNo${item.itemNo}dtlLoc0').selectedIndex
													           for (i = 1; i < count; i++) {
													               $('itemNo${item.itemNo}cond_idx'+i).options[condIdx].selected = true;
                                                                   $('itemNo${item.itemNo}disp_idx'+i).options[dispIdx].selected = true;
													               $('itemNo${item.itemNo}dtlWar'+i).options[dtlWarehouseIdx].selected = true;
													               $('itemNo${item.itemNo}dtlLoc'+i).value = dtlLocation;
 													           }
													       }
													   </g:javascript>
													<% } %>
													
													
												</td>
											</tr>
                                            <% if (ra.freightClaim) { 
                                                def freightClaimAmount = ''
                                                def freightClaimGLCode = ''
                                                def denial = ''
                                                if (detail.class == com.kettler.domain.actrcv.share.ReturnItemDetail) { 
                                                	freightClaimAmount = detail.freightClaimAmount?:''
                                                	freightClaimGLCode = detail.freightClaimGLCode?:''
                                                    denial = detail.freightDenial?.id?:''
                                                }
                                            %>
                                                <tr>
                                                    <td/>
                                                    <td colspan="2">Claim Amt:
	                                                   <kettler:raColText name="itemNo${item.itemNo}FreightClaimAmount_idx${j}" value="${freightClaimAmount}" size="8" title="claim amount" class="number"/>
	                                                </td>
	                                                <td colspan="3">
	                                                    <kettler:raSelect  name="itemNo${item.itemNo}FreightClaimGLCode_idx${j}" value="${freightClaimGLCode}" from="${TableCode.findAllByCompCodeAndType(ra.customer.compCode,'S')}" optionKey="code" optionValue="desc"  noSelection="${['':'Choose GL Code...']}"/>
	                                                    <kettler:raSelect   name="itemNo${item.itemNo}freightDenial_idx${j}"         value="${denial}" status="${ra.status}" lockStatus="RAREJ" from="${ReturnFreightDenial.list()}" optionKey="id" optionValue="code" noSelection="${['':'Choose Denial...']}"/>
	                                               </td>
                                                </tr>
                                            <% } %>
	   									</g:each>
   									<% } %>
	       						</g:each>
						   </tbody>
						</table>
						<% if (!inquiry && (ra.status?.colLockLevel?:0) < ReturnStatus.get('NORA').colLockLevel) { %>
						    <div class="buttons">
								<input type="button" class="create" value="Order Item Search" onclick="$('orderItemDialog').show();hideSelects();" 
												title="Click to popup a panel to select items from shipped orders"/>
								<input type="button" class="create" value="Add Item with No Order" onclick="$('addItemDialog').show();hideSelects();" 
												title="Click to popup up a panel to enter an item not associated with an order"/>
							</div>
						<% } %>
					</gui:tab>
	
			        <gui:tab label="Notes" id="notesTab" >
						<fieldset><legend>Notes</legend> 
						<table id="notesTable">
						  <thead>
						  <tr>
						  <th>Note</th><th>Print</th><th>Author</th>
						  </tr>
						  </thead>
						   <tbody id="returnNotes"><%-- sort by date then id --%>
								<g:each var="note" status="i" in="${ra.notes?.sort {a, b -> if (a.createDate == b.createDate) return a.id <=> b.id else return a.createDate <=> b.createDate} }">
									<tr id="raNote${i}">
										<td>
										  <textArea name="aNote" id="aNote" maxlength="255" >${note.note}</textArea>
										</td>
                                        <td><g:checkBox name="aNotePdf${i}" value="${note.showOnPdf}" title="Check to print note on Customer PDF copy of credit memo" /></td>
                                        <td>${note.user}</td>
										<g:hiddenField name="aNoteId" value="${note.id?:0}"/>
									</tr>
								</g:each>
						    	<tr> 
						    		<td><textArea name="transientNote" id="transientNote" maxlength="255" ></textArea></td> 
                                    <td><g:checkBox name="transientNotePdf" value="${true}"  title="Check to print note on PDF" /></td>
									<td><input type="button" value="Add Note" onclick="addNote();"/></td>
								</tr>
							</tbody>
						</table>				
						</fieldset>
					</gui:tab>

					<% if (ra.items) { /* first order-item added sets address from the order's shipto or cust if no ship to */%>
						<gui:tab label="Pick-Up Address">
							<fieldset><legend>Pick-up Address</legend>
								<% if ((ra.status?.colLockLevel?:0) >= ReturnStatus.get('NORA').colLockLevel) { %>
									<dl>
										<dt>Name:</dt>				<dd>${ra?.name?.encodeAsHTML()}</dd>                                                            
										<dt>Address Line 1:</dt>	<dd>${ra?.addr1?.encodeAsHTML()}&nbsp;</dd>                                                           
										<dt>             2:</dt>	<dd>${ra?.addr2?.encodeAsHTML()}&nbsp;</dd>                                                      
										<dt>             3:</dt>	<dd>${ra?.addr3?.encodeAsHTML()}&nbsp;</dd>                                                      
									    <g:if test="${['USA', 'CAN'].find {it == ra?.countryCode}}">
											<dt>City/State/Zip:</dt><dd>${ra?.city}, ${ra?.state}  ${ra?.zipCode}</dd>                                
										</g:if>
										<g:else>	
											<dt>Country Name:</dt>	<dd>${Country.findByIsoCode(ra?.countryCode).desc}</dd>
										</g:else>
									</dl>
								<% } else { %>
									<g:render template="/common/address" model="['objWithAddr':ra]"/>
								<% } %>				
							</fieldset>
						</gui:tab>
					<% } %>				
				</gui:tabView> 
			    <div class="buttons">
                    <% def holdOrReleaseAuthorized = false 
                      if ((warehouse && ra.status?.id == 'NEWRA' && user?.user400?.returnWarehouse)          ||
                          (             ra.status?.id == 'NEWRA' && user?.user400?.returnSales)              || 
                          (             ra.status?.id == 'CMAPP' && user?.user400?.returnAR)                 ||
                          (             ra.status?.id == 'CMPEN' && user?.user400?.returnManagement)         || 
                          (['NORA', 'CMDIF', 'CMQUE'].find {it == ra.status?.id} && user?.user400?.returnSales) 
                         ) { 
                    	  holdOrReleaseAuthorized = true
                       } 
                    %>
			    
			        <% if (!inquiry) { %>
                        <jsec:hasRole name="${Role.SUPER_ADMIN}">
                            <g:submitButton class="delete" name="delete" value="Delete" title="Click to delete this return authorization request" />					
                        </jsec:hasRole>
                        <% if (!ra.hold) { %>
		                    <% if ((warehouse && ['NEWRA','CMDIF','CMPEN'].find{it == ra.status?.id}) || (!ra.items || !ra.id)) { %>
		                        <g:submitButton class="create" name="update"  value="Update" title="Click to validate the return authorization request" />
							<% } %>
		                    <%-- if (user?.user400?.returnSales || user?.user400?.returnWarehouse || user?.user400?.returnManagement || user?.user400?.returnAR) { --%>
							
		                    <% if (ra.status?.id == 'CMAPP' && user?.user400?.returnAR) { %>
		                        <g:submitButton class="create" name="generateCM"    value="Create Credit Memo"  title="Click to create a credit memo from the return authorization request" />
                                <g:submitButton class="create" name="backToPendApp" value="Back to Mgmt"        title="Click to put the RA back in the managers queue" 
                                      onclick="return confirm('Are you sure you wanted to select Back to Mgmt and did you add a Note describing why?');" />
		                    <% } %>
							<% if (ra.status?.id == 'CMPEN' && user?.user400?.returnManagement) { %>
								<g:submitButton class="create" name="approve"  value="Approve" 	title="Click to approve the return authorization request" />
								<g:submitButton class="create" name="deny"     value="Deny"    	title="Click to deny the return authorization request" />
								<g:submitButton class="create" name="queSales" value="Que Sales"	title="Click to question sales about the return authorization request" />
                                <g:submitButton class="create" name="queReceiving" value="Que Receiving" title="Click to question receiving about the return authorization request" />
							<% } else if (['NORA', 'CMDIF', 'CMQUE'].find {it == ra.status?.id} && user?.user400?.returnSales) { %>
								<g:submitButton class="create" name="pendApproval"  value="Approve Discrepancy" 	title="Click to send to management for approval" />
								<g:submitButton class="create" name="reject"  		value="Reject"		    	title="Click to reject--= the return authorization request" />
							<% } else if (ra.items && (user?.user400?.returnSales || user?.user400?.returnManagement || user?.user400?.returnAR || 
									                   (user?.user400?.returnWarehouse && ['NEWRA', 'NORA'].find{it == ra.status?.id})) ) { %>
								<g:submitButton class="create" name="complete" value="Complete" title="Click to complete changes to the return authorization request" />					
							<% } %>
                            <% if (warehouse) { %>
                                <% if (ra.status?.id == 'NEWRA') {  %>
	                                <g:submitButton class="create" name="forceDiff" value="Force Diff" title="Click to set status to CMDIF and complete changes to the return authorization request" 
	                                      onclick="return confirm('Are you sure you wanted to select ForceDiff and did you add a Note describing the issue for sales?');" /> 
                                <% } else if (ra.status?.id == 'CMQWH') {  %>
                                    <g:submitButton class="create" name="pendApproval"  value="Approve Discrepancy"  title="Click to send to management for approval" />
                                <% } %>
                            <% } %>
						<% } else if (ra.status?.id == 'NEWRA') { /* ra.hold */ %>
                                <g:submitButton class="create" name="update"  value="Update" title="Click to validate the return authorization request" />
                        <% } %>
						<% if (holdOrReleaseAuthorized) { %>
	                         <g:submitButton class="${ra.hold?'go':'error'}" name="${ra.hold?'release':'hold'}" value="${ra.hold?'Release':'Hold'}" title="Click to ${ra.hold?'release':'hold'} the return authorization request" />
	                    <% } %>
					<% } %>
                    <% if (ra.id) { %>
                        <span class="menuButton">
                            <a href="#" class="table" onclick="window.open ('${createLink(controller:'returns',action:'show', id:ra.id)}&popup=true', 'RAShow', 'location=1,status=1,scrollbars=1,width=900,height=690');" title="Open popup with summary detail and PDF print option">Summary</a>
                        </span>                     
                    <% } %>
		            <% if (!inquiry && ra.status?.id == 'NEWRA') { %>
                        <% if (user?.user400?.returnSales) { %>
                           <g:submitButton class="delete" name="delete" value="Delete" title="Click to delete this RA" />
                        <% } %>
					       <g:submitButton class="table" name="cancel" value="Exit" title="Click to exit" onclick="\$('raForm').onsubmit = null;"/>
					<% } else { %>
					       <g:submitButton class="table" name="cancel" value="${inquiry?'Exit Inquiry':'Cancel'}"	
					               title="Click to ${inquiry?'Exit Inquiry':'cancel changes to the return authorization request'}" 
					              onclick="\$('raForm').onsubmit = null;"/>
					<% } %>
				</div>
			</g:form>
		</div>

		<div id="addItemDialog" class="popup" style="display:none;"><%-- prototype show/hide can't handle display none in a css file --%>
			<h3>Add an Item without an Order</h3>
			<form action="javascript:addItem();">
			     <dl>
	                <dt> Item No:</dt>
	                <dd>
		                <richui:autoComplete name="itemNoAdd"  id="itemNoAdd" action="${createLinkTo('dir': 'itemMaster/searchAJAX')}" 
		                   size="15" maxLength="15"
		                   shadow="true" typeAhead="true" maxResultsDisplayed="25"   
		                />
	                </dd>
                </dl>
			    <div class="buttons">
					<input class="create" type="submit" value="Add"/>
					<input class="create"   type="button" value="Close" onclick="$('addItemDialog').hide();showSelects();"/>
				</div>
			</form>
		</div>
		<div id="orderItemDialog" class="popup" style="display:none;">
		    <dl>
		        <dt>Order No:</dt><dd><g:textField name="ordNo" size="6" maxlength="6"/></dd>
		        <dt>PO No:</dt><dd><g:textField name="poNo" size="25" maxlength="25"/></dd>
		        <dt>Freight Tracking No:</dt><dd><g:textField name="fgtTrkNo" size="25" maxlength="25"/></dd>
		    </dl>
            <div class="buttons">
                <input type="button" class="add" onclick="ajaxInvoicedItemLookup();return false;" value="Show"/>
                <input type="button" class="house" value="Close" onclick="$('orderItemDialog').hide();showSelects();$('invoicedItemsDiv').innerHTML='';"/>
            </div>    
			<div id="invoicedItemsDiv"/>
		</div>
	</div>
</body>
</html>
