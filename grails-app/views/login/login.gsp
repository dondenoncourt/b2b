<%@ page import="com.kettler.domain.orderentry.share.Role" %>
<%@ defaultCodec="html" %>

<html>
  <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
      <meta name="layout" content="main" />
      <title>Login</title>
      <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.4.2/jquery.min.js" type="text/javascript"></script>
  <style>
  #accessKETTLERUSADiv {
    FONT-STYLE: italic; 
    WIDTH: 30%; 
    FONT-FAMILY: "Franklin Gothic Heavy",sans-serif; 
    FLOAT: left; 
    MARGIN-LEFT: 5px; 
    CLEAR: left; 
    clear: both;
    FONT-SIZE: 35px;
}
#loginFormDiv {
    WIDTH: 60%; 
    FLOAT: right;
    <!--[If IE 5]>
    clear:left;
    <![endif]-->
}
#requests {
    clear:left;
}
#requests p {
    margin-left: 10px;
}
#loginFormDiv p {
    font-size: small;
    font-style: italic;
}

#frontpage {
    margin-top: -22px;
}
.errors {
    position: absolute;
    left: 100px;
    top: 100px;
}
.message {
    position: absolute;
    left: 100px;
    top: 100px;
}
  </style>
  </head>
  
<body >
    <div style="width:910px;height: 100px;">
        <div id="accessKETTLERUSADiv">
            AccessKETTLERUSA
        </div>
	    <jsec:notAuthenticated>
			<div id="loginFormDiv">
		        <g:form name="loginForm" action="login" method="post" >
		            eMail:<g:textField name="email" size="30" value="${cmd?.email}"/>
		            Password:<g:passwordField name="password"  size="10" />  
		            <g:submitButton class="create" name="login" value="Login" />
		        </g:form>
		    </div>   
		    <div id="requests">
                 <p>If you are a current customer or rep, and do not yet have a login, click 
                     <g:link action="requestLogin">here</g:link>
                     to request access.
                 </p>
                 <p>
                    If you have forgotten your password, key your email above and click <a href="#" id="emailPasswordLink">here</a>
                    to have a temporary password emailed to you.
                 </p>
             </div>
	    </jsec:notAuthenticated>
	   <jsec:isLoggedIn>
			<div id="loginFormDiv">
		        <g:form name="loginForm" action="changePassword" method="post" >
		           <p>Welcome, ${user?.firstname} ${user?.lastname}. You are authenticated as a
				        <jsec:hasRole name="${Role.SUPER_ADMIN}">Super Admininistrator</jsec:hasRole>          
				        <jsec:hasRole name="${Role.CUST_ADMIN}">Customer Admininistrator</jsec:hasRole>          
				        <jsec:hasRole name="${Role.REP_PLUS}">Rep Plus</jsec:hasRole>          
				        <jsec:hasRole name="${Role.REP}">Customer Rep</jsec:hasRole>          
				        <jsec:hasRole name="${Role.REP_ADMIN}">Rep Admininistrator</jsec:hasRole>          
				        <jsec:hasRole name="${Role.CUSTOMER}">Customer</jsec:hasRole>         
				        <jsec:hasRole name="${Role.KETTLER}">KETTLER Employee</jsec:hasRole>
				   </p>
		            <g:submitButton class="create" name="changePassword" value="Change Password" title="Click to change your password" />
		        </g:form>
	        </div>
	    </jsec:isLoggedIn>
    </div>
	<img alt="KETTLER Inc." id="frontpage" src="${createLinkTo(dir:'images',file:'frontpage2.jpg')}">
    <div class="message">${flash.message}</div>
    <div class="errors"><g:renderErrors bean="${cmd}" as="list" /></div>
	<g:javascript>
	    $("#emailPasswordLink").click(function() {
	        $('.errors').html('');
            $('.message').html('');
	        $.ajax({
	            type:'POST', 
	            url: "${createLink(action:'emailPassword')}",
	            data: $('#loginForm').serialize(),
	            success:function(data,textStatus){
	               $('.message').html(data);
	               alert(data);
	               $('div.message').show();
	            },
	            error:function(XMLHttpRequest,textStatus,errorThrown){}
	         });
	         return false;
	    });
        $('div.message').hide();
        <g:if test="${flash.message}">
           $('.message').show();
        </g:if>
	</g:javascript>
</body>
</html>
