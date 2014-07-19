<%@ page import="com.kettler.domain.orderentry.share.Role" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Change Password</title>
    </head>
    <body>
        <div class="body">
            <h1>Change Password</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${cmd}">
            <div class="errors">
                <g:renderErrors bean="${cmd}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="changePassword" method="post" >
            
                <div class="dialog">
	                    <table>
	                        <tbody>

                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="password">New Password:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:cmd,field:'password','errors')}">
                                    <input type="password" maxlength="50" id="password" name="password" />
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="password">Repeat Password:</label>
                                </td>
                                <td valign="top" class="value">
                                    <input type="password" maxlength="50" id="password2" name="password2" />
                                </td>
                            </tr> 
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <g:submitButton name="changePassword" class="save" value="Change"  title="Click to confirm your password change" />
                </div>
            </g:form>
        </div>
    </body>
</html>
