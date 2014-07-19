<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta name="layout" content="main" />
    <title>Dealer Image Download</title>
    <link rel="stylesheet" href="${createLinkTo(dir:'css',file:'jquery.treeview.css')}" />
    <g:javascript src="jquery/jquery-1.4.2.min.js"/>     
    <g:javascript src="jquery/jquery.cookie.js"/>     
    <g:javascript src="jquery/jquery.treeview.js"/>   
</head>
<html>
<body>
    <br/>
    <h1 id="banner">Dealer Image Download</h1>
    <div class="treeview">
	    <ul id="browser" class="filetree treeview-famfamfam">
		    <g:each in="${divisions}" var="division">
		        <li class="closed" id="division_${division.id}">
		           <span class="folder">${division.name}</span>
		           <ul>
		               <g:each in="${division.categories.sort{it.name}}" var="category">
			               <li class="closed expandable" id="category_${category.id}"><span class="folder">${category.name}</span>
			                  <ul id="category_${category.id}UL">
		                           <li class="closed">building item list...</li>
		                      </ul>
			               </li>
			           </g:each>
		           </ul>
		        </li>
		    </g:each>
	    </ul>
    </div>
</div>
 
<g:javascript>
	$("#browser").treeview({
		toggle: function() {
			var eleId = $(this).attr('id');
            if (window.console) console.log('update #'+eleId+'UL');
            if (eleId.match(/^division_\d*$/)) return;
			$.ajax({
				type:'POST', 
				url: "${createLink(action:'expand')}",
				data: '&divCatOrItem='+$(this).attr('id'),
				success:function(data,textStatus){$('#'+eleId+'UL').html(data);},
				error:function(XMLHttpRequest,textStatus,errorThrown){}
			});
		}
	}); 
	function getItems(itemId) {
       $.ajax({
           type:'POST', 
           url: "${createLink(action:'showImages')}",
           data: '&id='+itemId,
           success:function(data,textStatus){$('#item'+itemId).html(data);},
           error:function(XMLHttpRequest,textStatus,errorThrown){}
       });
       
		$('#item_'+itemId+'LI > span, #item_'+itemId+'LI > div.hitarea').unbind('click');
			
		$('#item_'+itemId+'LI > span, #item_'+itemId+'LI > div.hitarea').click(function() {
			$('#item'+itemId).html('');
			$(this).parent().addClass('expandable');
			$('#item_'+itemId+'LI > span, #item_'+itemId+'LI > div.hitarea').unbind('click');
			$('#item_'+itemId+'LI.expandable > span, #item_'+itemId+'LI.expandable > div.hitarea').click(function() {
			      getItems(itemId); $(this).parent().removeClass('expandable');
			});
		});
	}
</g:javascript>
</body>
</html>

