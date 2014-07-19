<%@ page import="com.kettler.domain.orderentry.share.Role" %>

<%@ page import="com.kettler.domain.orderentry.share.WebUser" %>
<%@ page import="org.jsecurity.SecurityUtils" %>
<%@ page import="com.kettler.domain.item.share.Dealer" %>
<%@ page import="com.kettler.domain.actrcv.share.Customer" %>
<html>
 <head>
     <title><g:layoutTitle default="Grails" /></title>
     <link rel="stylesheet" href="${createLinkTo(dir:'css',file:'main.css')}" />
     <link rel="shortcut icon" href="${createLinkTo(dir:'images',file:'favicon.ico')}" type="image/x-icon" />
     <nav:resources/>
     <g:layoutHead />
     <g:javascript library="application" />	
     <script type="text/javascript">
     	function onloadHandler() {
         	/*stub, override in pages that use this layout*/
     	}

		var _gaq = _gaq || [];
		_gaq.push(['_setAccount', 'UA-17400793-1']);
		_gaq.push(['_trackPageview']);
		
		(function() {
		  var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
		  ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
		  var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
		})();
     </script>
<script type="text/javascript"><!--//--><![CDATA[//><!--
	/* http://www.htmldog.com/articles/suckerfish/dropdowns/ */
	sfHover = function()  {
		if (document.getElementById("nav")) {
			var sfEls = document.getElementById("nav").getElementsByTagName("LI");
			for (var i=0; i<sfEls.length; i++) {
				sfEls[i].onmouseover=function() {
					this.className+=" sfhover";
					hideSelects();
				}
				sfEls[i].onmouseout=function() {
					this.className=this.className.replace(new RegExp(" sfhover\\b"), "");
                    showSelects();
				}
			}
		}
	}
	if (window.attachEvent) window.attachEvent("onload", sfHover);

//--><!]]></script>

 </head>
<% WebUser user = WebUser.findByEmail(SecurityUtils.getSubject()?.getPrincipal()?:'') %>
  <body onload="onloadHandler();" class="yui-skin-sam">
      <div id="spinner" class="spinner" style="display:none;">
          <img src="${createLinkTo(dir:'images',file:'spinner.gif')}" alt="Spinner" />
      </div>
      <g:if test="${(!ord || ord.class == 'com.kettler.domain.orderentry.QuoteHeader')}"
    <div class="menu">
        <jsec:isLoggedIn>
			<ul id="nav">
        </li>
<jsec:hasRole name="${Role.KETTLER}">       
	    <li><a href="#"  title="Select one of options below for www.kettlerusa.com maintenance" >KettlerUSA</a>
	        <ul>
	            <% if (user?.user400?.itemMaint) { %>
	                <li><g:link action="index" controller="itemMasterExt" title="Click to update retail item master" >Item Mast Ext</g:link></li>
	            <% } %>
	            <% if (user?.user400?.custMaint || user?.user400?.setupNewCust ) { %>
	                <li><g:link action="index" controller="dealer" title="Click to update dealers" >Dealers</g:link></li>
	            <% } %>
               <% if (user?.user400?.returnSales) { %>
                    <li><g:link action="list" controller="itemMasterExt" title="Click to update retail item master keywords" params="[keywordMaint:true]" >Item Keyword Maint</g:link></li>
                <% } %>
                <li><g:link action="list" controller="images" title="Click to download full resolution item images" >Item Image Download</g:link></li>
	        </ul>
	    </li>	    
</jsec:hasRole>
<jsec:hasRole name="${Role.SUPER_ADMIN}">       
       <li><a href="#"  title="Select one of options below" >KETTLER USA Maint</a>
           <ul>
                <li><g:link action="search" controller="inventoryMaintenance" title="Click to update your web inventory" >Upd Web Inv</g:link></li>
                <li><g:link action="index" controller="itemMasterExt" title="Click to update retail item master" >Item Mast Ext</g:link></li>
                <li><g:link action="list" controller="itemMasterExt" title="Click to update retail item master keywords" params="[keywordMaint:true]" >Item Keyword Maint</g:link></li>
                <li><g:link action="index" controller="dealer" title="Click to update dealers" >Dealers</g:link></li>
                <li><g:link action="list" controller="images" title="Click to download full resolution item images" >Item Image Download</g:link></li>
                <li><g:link action="list" controller="coupon" title="Click to update coupons" >Coupons</g:link></li>
                <li><g:link action="list" controller="returns" title="Click to display receiving maintenance list">Receiving Maintenance</g:link></li>
                <li><g:link action="promptMassRetailEmail" controller="marketing" title="Click to send a mass email" >Mass Email</g:link></li>
                <li><g:link action="listRetailShiptoBillto" controller="customer" title="Click to list ship-to bill-to" >Ship-to Bill-to</g:link></li>
            </ul>
        </li>       
</jsec:hasRole>
<jsec:hasAnyRole in="${[Role.CUSTOMER,Role.CUST_ADMIN]}">          
<% def dealer = Dealer.findByCustomer(Customer.findByCompCodeAndCustNo(user.compCode, user.custNo)) %>
       <li><a href="#"  title="Select one of options below" >KettlerUSA</a>
           <ul>
            <% if (dealer?.trackInventory) { %>
			    <li><g:link action="search" controller="inventoryMaintenance" title="Click to Update Kettler web dealer location inventory" params="[custno:user.custNo]">
			                Update Inventory  
			        </g:link>
			    </li>
		    <% } %>
            <li><g:link action="list" controller="images" title="Click to download full resolution item images" >Item Image Download</g:link></li>
		  </ul>
       </li>
</jsec:hasAnyRole>
<jsec:hasAnyRole in="${[Role.REP_PLUS,Role.REP,Role.REP_ADMIN]}">          
       <li><a href="#"  title="Select one of options below" >KettlerUSA</a>
           <ul>
            <li><g:link action="list" controller="images" title="Click to download full resolution item images" >Item Image Download</g:link></li>
          </ul>
       </li>
</jsec:hasAnyRole>
	        <jsec:hasAnyRole in="${[Role.KETTLER,Role.CUSTOMER,Role.CUST_ADMIN,Role.REP_PLUS,Role.REP,Role.REP_ADMIN]}">          
					<li><a href="#"  title="Select one of options below" >Orders</a>
						<ul>
							<li><g:link action="order" controller="order" title="Click to add a new order">Place Order</g:link></li>
							<li><g:link action="listOrders" controller="order" title="Click to be prompted for an order number you wish to update" params="[statusCode:'N', search:'Search']">
							            Update Order
							    </g:link>
							</li>
							<li><g:link action="select" controller="quote" title="Click to review a quote">Review Quotes</g:link></li>
						</ul>
					</li>
				</jsec:hasAnyRole>
		        <jsec:hasAnyRole in="${[Role.SUPER_ADMIN,Role.CUST_ADMIN,Role.REP_ADMIN]}">          
					<li><a href="#">User Maint</a>
						<ul>
							<li><g:link action="create" controller="webUser" title="Click to create a new user profile" >Create user</g:link></li>
							<li><g:link action="list"   controller="webUser" title="Click to see a list of users, from which you can update or delete existing users" >List users</g:link></li>
						</ul>
					</li>
				</jsec:hasAnyRole>
		        <jsec:hasAnyRole in="${[Role.KETTLER,Role.CUSTOMER,Role.CUST_ADMIN,Role.REP_PLUS,Role.REP,Role.REP_ADMIN]}">          
					<li><a href="#"  title="Select one of options below" >Customer</a>
						<ul>
			        	    <jsec:hasRole name="${Role.KETTLER}">
								<li><g:link action="create" controller="customer" title="Click to create a new customer">New Customer</g:link></li>
                                <li><g:link action="list" controller="dealer" title="Click to list dealers">Dealer List</g:link></li>
							</jsec:hasRole>
		   	        	    <jsec:hasAnyRole in="${[Role.KETTLER,Role.REP_PLUS,Role.REP,Role.REP_ADMIN]}">
								<li><g:link action="list" controller="customer" title="Click to display customer information">Inquiry</g:link></li>
							</jsec:hasAnyRole>
		   	        	    <jsec:hasAnyRole in="${[Role.CUSTOMER,Role.CUST_ADMIN]}">
								<li><g:link action="show" controller="customer"  params="[compCode:user.compCode,custNo:user.custNo]" title="Click to display your customer information">Inquiry</g:link></li>
							</jsec:hasAnyRole>
						</ul>
					</li>								
					<li><a href="#"  title="Select one of options below" >Inquiry</a>
						<ul>
							<li><g:link action="list" controller="contractPrice" params="[rootLink:'true']" title="Click to view contract pricing" >Contract Pricing</g:link></li>
							<li><g:link action="item" controller="itemMaster" title="Click to view item information">Item Master</g:link></li>
		   	        	    <jsec:hasAnyRole in="${[Role.KETTLER,Role.REP_PLUS,Role.REP,Role.REP_ADMIN]}">
								<li><g:link action="list" controller="customer" title="Click to display customer information" params="[search:'Search']">Customer</g:link></li>
							</jsec:hasAnyRole>
		   	        	    <jsec:hasAnyRole in="${[Role.CUSTOMER,Role.CUST_ADMIN]}">
								<li><g:link action="show" controller="customer"  params="[compCode:user.compCode,custNo:user.custNo]" title="Click to display your customer information">Customer</g:link></li>
							</jsec:hasAnyRole>
							<li><g:link action="listOrders" controller="order" title="Click to be prompted for an order number you wish to review" params="[inquiry:'true',statusCode:' ', search:'Search']">
									Orders
								</g:link>
							</li>
							<li><g:link action="listOrders" controller="order" title="Click to be prompted for an order number you wish to review" params="[inquiry:'true',statusCode:'B', search:'Search']">
									Back Order
								</g:link>
							</li>
							<li><g:link action="listOrders" controller="order" title="Click to be prompted for an order number you wish to review" params="[inquiry:'true',statusCode:'F', search:'Search']">
									Future Ship
								</g:link>
							</li>
							<li><g:link action="listOrders" controller="order" title="Click to be prompted for an order number you wish to review" params="[inquiry:'true',statusCode:'H', search:'Search']">
									Credit Hold
								</g:link>
							</li>
		   	        	    <jsec:hasAnyRole in="${[Role.KETTLER]}">
								<li><g:link action="list"   controller="webUser" title="Click to see a list of users, from which you can enable image download" >List Users</g:link></li>
							</jsec:hasAnyRole>
						</ul>
					</li>
					<li><a href="#"  title="Select one of options below" >Reports</a>
						<ul>
			   	        	<jsec:hasAnyRole in="${[Role.CUSTOMER,Role.CUST_ADMIN]}">
								<li><a href="#" onclick="window.open ('${createLink(controller:'customer',action:'arStmts')}?compCode=${user.compCode}&custNo=${user.custNo}', 'ARStmt', 'location=1,status=1,scrollbars=1,width=900,height=690');">Statements</a></li>						
							    <li><g:link action="stockStatus" controller="inventoryMaintenance" title="Click to be display stock status">Stock Status</g:link></li>
							</jsec:hasAnyRole>
                            <jsec:hasAnyRole in="${[Role.KETTLER,Role.REP_PLUS,Role.REP_ADMIN,Role.REP]}">
								<li><g:link action="arStmtsPrompt" controller="customer" title="Click for A/R Statement printing">Statements</g:link></li>
                            </jsec:hasAnyRole>
							<li><g:link action="reportPrompt" controller="customer" params="[report:'printAckn']" title="Click to be prompted for an order number for which you wish to reprint Acknowlegdements">Acknowledge</g:link></li>
							<li><g:link action="invoicePrompt" controller="customer" title="Click to be prompted for an Invoice to reprint">Invoice</g:link></li>
							<li><g:link action="reportPrompt" controller="customer" params="[report:'printPackList']" title="Click to be prompted for Pack List Printing">Pack List</g:link></li>
							<li><g:link action="prompt" controller="salesAnalysis"  title="Click to be prompted for Sales Analysis">Sales Analysis</g:link></li>
                            <jsec:hasAnyRole in="${[Role.KETTLER,Role.REP_PLUS,Role.REP,Role.REP_ADMIN]}">
                                <li><g:link action="commStmts" controller="customer" title="Click to display Sales Commissions with option to generate PDF" >Commission Statments</g:link></li>
                            </jsec:hasAnyRole>
						</ul
					</li>
		        </jsec:hasAnyRole>           
                <jsec:hasRole name="${Role.KETTLER}">       
                    <li id="returnsMenuLI"><a href="#"  title="Select one of options below" >Returns</a>
                        <ul>
                            <% if (user?.user400?.returnSales || user?.user400?.returnWarehouse || user?.user400?.returnManagement || user?.user400?.returnAR) { %>
                               <% if (user?.user400?.returnWarehouse == false) { %>
   	                            <li><g:link action="list" controller="returns" params="[inquiry:'false']" title="Click to list Return Authorizations for update">Maintenance</g:link></li>
                               <% } %>
                               <% if (user?.user400?.returnWarehouse) { %>
   	                            <li><g:link action="list" controller="returns" params="[inquiry:'false']" title="Click to display receiving maintenance list">Receiving Maintenance</g:link></li>
                               <% } %>
                               <% if (user?.user400?.returnSales) { %>
                               <li><g:link action="return" controller="returns" params="[inquiry:'false']" title="Click to create a return"">Create RA</g:link></li>
                               <% } %>
                           <% } %>
                           <li><g:link action="list" controller="returns" params="[inquiry:'true']" title="Click to list RAs for inquiry">Inquiry</g:link></li>
                           <li><g:link action="report" controller="returns" title="Click to display the RA Report with PDF options">Report Generation</g:link></li>
                           <li><g:link action="freightClaimReport" controller="returns" title="Click to display the RA Freight Claims Report with PDF options">Claims Report</g:link></li>
                        </ul>
                    </li>    
                </jsec:hasRole>                           
				<li><g:link action="logoff" controller="login" title="Click to log off of the order entry application" >Logoff</g:link></li>
			</ul>
		</jsec:isLoggedIn>
    </div>
   </g:if>
      <g:layoutBody />		
 </body>	
</html>
