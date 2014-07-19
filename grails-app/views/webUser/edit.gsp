<%@ page import="com.kettler.domain.orderentry.share.Role" %>
<%@ page import="com.kettler.domain.orderentry.share.SalesPerson" %>
<%@ page import="com.kettler.domain.orderentry.share.UserControl" %>

<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <meta name="layout" content="main" />
        <title>Edit WebUser</title>
    </head>
    <body>
        <div class="body">
            <h1>Edit WebUser</h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${webUser}">
            <div class="errors">
                <g:renderErrors bean="${webUser}" as="list" />
            </div>
            </g:hasErrors>
            <g:form method="post" >
                <input type="hidden" name="id" value="${webUser?.id}" />
                <input type="hidden" name="version" value="${webUser?.version}" />
                <div class="dialog">
                    <table>
                        <tbody>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="email">Email:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:webUser,field:'email','errors')}">
                                    <input type="text" maxlength="25" id="email" name="email" value="${fieldValue(bean:webUser,field:'email')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="password">Password:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:webUser,field:'password','errors')}">
                                    <input type="password" size="40" maxlength="50" id="password" name="password" />
                                </td>
                            </tr> 
                            <tr><td/><td class="comment">Leave password blank to keep current</td></tr>

                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="firstname">Firstname:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:webUser,field:'firstname','errors')}">
                                    <input type="text" maxlength="20" id="firstname" name="firstname" value="${fieldValue(bean:webUser,field:'firstname')}"/>
                                </td>
                            </tr> 
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="lastname">Lastname:</label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean:webUser,field:'lastname','errors')}">
                                    <input type="text" maxlength="25" id="lastname" name="lastname" value="${fieldValue(bean:webUser,field:'lastname')}"/>
                                </td>
                            </tr> 

							<g:if test="${webUser.role.name == Role.KETTLER}">                       
	                            <tr class="prop">
	                                <td valign="top" class="name">
	                                    <label for="lastname">400 Profile:</label>
	                                </td>
	                                <td valign="top" class="value ${hasErrors(bean:webUser,field:'user400','errors')}">
                                        <g:select name="user400.id" from="${UserControl.list()}" optionKey="id" optionValue="username" value="${webUser.user400?.id}" noSelection="${['':'Select a user name...']}"
                                        title="Note: if the user is not in this list, it will have to be added via green screen maintenance to the OEUCTL file."/>
	                                </td>
	                            </tr> 
                            </g:if>
                        
                        </tbody>
                    </table>
                </div>
                <div class="buttons">
                    <g:actionSubmit class="save" value="Update" /> 
                    <g:actionSubmit class="delete" onclick="return confirm('Are you sure?');" value="Delete" /> 
                    <g:actionSubmit class="save" action="list" value="Cancel" /> 
                </div>
            </g:form>
        </div>
    </body>
</html>
