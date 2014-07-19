<%@ page import="com.kettler.domain.orderentry.share.Role" %>
<%@ page import="com.kettler.domain.orderentry.share.SalesPerson" %>
<%@ page import="com.kettler.domain.orderentry.share.UserControl" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
		<g:javascript library="prototype" />
        <title>Create WebUser</title>         
    </head>
    <body>

<g:javascript>
    // 1: CUST_ADMIN, 2: CUSTOMER, 3: REP, 4: KETTLER, 5: SUPER_ADMIN, 6: REP_ADMIN
	function roleChanged(role) {
        <jsec:hasRole name="${Role.SUPER_ADMIN}">
			$('salespersonDT').show();$('salespersonDD').show();
		</jsec:hasRole>
        <jsec:lacksRole name="${Role.SUPER_ADMIN}">
			$('user400DT').hide();$('user400DD').hide();
		</jsec:lacksRole>
		switch (role) {
		case '1': // cust admin
		case '2': // cust
	        <jsec:hasRole name="${Role.SUPER_ADMIN}">
				$('salespersonDT').hide();$('salespersonDD').hide();
			</jsec:hasRole>
			$('custNoDT').show();$('custNoDD').show();
			$('user400DT').hide();$('user400DD').hide();
			break;
		case '3': // rep
		case '6': // rep admin
		case '11': // rep admin
			$('custNoDT').hide();$('custNoDD').hide();
	        <jsec:hasRole name="${Role.SUPER_ADMIN}">
				$('salespersonDT').show();$('salespersonDD').show();
			</jsec:hasRole>
			$('user400DT').hide();$('user400DD').hide();
			break;
		case '4': // kettler
		case '7': // store employee
		case '8': // store manager
		case '12': // store deliveries manager
		case '9': // inventory manager
		case '10': // assistant controller
				$('user400DT').show();$('user400DD').show();
				// no break, drop-through....
		case '5': // super admin
	        <jsec:hasRole name="${Role.SUPER_ADMIN}">
				$('custNoDT').hide();$('custNoDD').hide();
				$('salespersonDT').hide();$('salespersonDD').hide();
			</jsec:hasRole>
			break;
		}
	}
   	function onloadHandler() {
   		roleChanged($('role').value);
	}
</g:javascript>
<%--
	don't prompt for compCode for any Role
		adding Customer or Cust Admin: fill compCode from custmast
		adding Rep or Rep Admin: fill compCode from custmast

--%>
	
 
        <div class="body">
            <h1>Create WebUser</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${webUser}">
            <div class="errors">
                <g:renderErrors bean="${webUser}" as="list"	 />
            </div>
            </g:hasErrors>
   	  	     <g:form action="save" method="post" >
                <div class="dialog">
                	<dl> 
						<dt id="roleDT">Role:</dt>
							<dd id="roleDD" class="value ${hasErrors(bean:webUser,field:'role','errors')}">
								<jsec:hasRole name="${Role.SUPER_ADMIN}">          
									<g:select name="role" from="${['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10','11', '12']}" valueMessagePrefix="webuser.role" value="${webUser?.role?.role}" onChange="roleChanged(this.value);"/>
								</jsec:hasRole>
								<jsec:hasRole name="${Role.CUST_ADMIN}">          
									<g:select name="role" from="${['0', '1', '2']}" valueMessagePrefix="webuser.role" value="${webUser?.role?.role}" onChange="roleChanged(this.value);"/>
								</jsec:hasRole>
								<jsec:hasRole name="${Role.REP_ADMIN}">          
									<g:select name="role" from="${['0', '1', '2', '3', '6']}" valueMessagePrefix="webuser.role" value="${webUser?.role?.role}" onChange="roleChanged(this.value);"/>
								</jsec:hasRole>
							</dd> 
						<dt id="eMailDT" >eMail:</dt>
							<dd id="eMailDD" class="value ${hasErrors(bean:webUser,field:'email','errors')}">
								<input type="text" size="40" maxlength="40" id="email" name="email" value="${fieldValue(bean:webUser,field:'email')}"/>
						    </dd> 
						<dt id="passwordDT">Password:</dt>
							<dd id="passwordDD" class="value ${hasErrors(bean:webUser,field:'password','errors')}">
								<input type="password" size="20" maxlength="100" id="password" name="password" value="${fieldValue(bean:webUser,field:'password')}"/>
							</dd> 
                        <jsec:hasRole name="${Role.SUPER_ADMIN}">
							<dt id="salespersonDT">Salesperson:</dt>
								<dd  id="salespersonDD">
									<g:select optionKey="id" from="${SalesPerson.list([sort:'id'])}" name="salesperson.id" value="${webUser?.salesperson?.id}" noSelection="['':'Select One']"></g:select>
								</dd>
						</jsec:hasRole>
                        <jsec:hasAnyRole in="${[Role.SUPER_ADMIN,Role.REP_ADMIN]}">
							<dt id="custNoDT" >Customer No:</dt>
							<dd  id="custNoDD" class="value ${hasErrors(bean:webUser,field:'custNo','errors')}">
		                        <jsec:hasRole name="${Role.SUPER_ADMIN}">
									<input type="text" size="7" maxlength="7" id="custNo" name="custNo" value="${fieldValue(bean:webUser,field:'custNo')}"/>
								</jsec:hasRole>
		                        <jsec:hasRole name="${Role.REP_ADMIN}">
	    	                    	<g:select name="custNo" from="${customers}" optionKey="custNo" value="${webUser.custNo}" noSelection="${['':'Select a customer...']}"/>
								</jsec:hasRole>	                        
							</dd>
						</jsec:hasAnyRole>
						<dt id="firstnameDT">Firstname:</dt>
							<dd  id="firstnameDT" class="value ${hasErrors(bean:webUser,field:'firstname','errors')}">
								<input type="text" maxlength="20" id="firstname" name="firstname" value="${fieldValue(bean:webUser,field:'firstname')}"/>
							</dd>	
						<dt id="lastnameDT">Lastname:</dt>
							<dd  id="lastnameDD" class="value ${hasErrors(bean:webUser,field:'lastname','errors')}">
								<input type="text" maxlength="25" id="lastname" name="lastname" value="${fieldValue(bean:webUser,field:'lastname')}"/>
							</dd> 
						<dt id="user400DT">400 Username:</dt>
							<dd  id="user400DD" class="value ${hasErrors(bean:webUser,field:'user400','errors')}">
                                <g:select name="user400.id" from="${UserControl.list()}" optionKey="id" optionValue="username" noSelection="${['':'Select a user name...']}"/>
							</dd> 
                    </dl>
                </div>
                <div class="buttons">
                    <input class="save" type="submit" value="Create" />
                    <g:actionSubmit class="save" action="list" value="Cancel" /> 
                </div>
            </g:form>
        </div>
    </body>
</html>
