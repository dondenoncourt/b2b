//used to hide select boxes before a div tag popups up to fix an IE bug of bleeding controls
function hideSelects(){
	
    if (navigator.appName != 'Microsoft Internet Explorer') return
	var oSelects=document.getElementsByTagName("select");
	for(var i=0;i<oSelects.length;i++) {
		oSelects[i].className+=" ieSelectBleedFixHide";
	}
}	
//used to unhide select boxes after a div tag popups up to fix an IE bug of bleeding controls
function showSelects(){
    if (navigator.appName != 'Microsoft Internet Explorer') return
	var oSelects=document.getElementsByTagName("select");
	for(var i=0;i<oSelects.length;i++) {
		oSelects[i].className=oSelects[i].className.replace(" ieSelectBleedFixHide","");
	}
}			

var Ajax;
if (Ajax && (Ajax != null)) {
	Ajax.Responders.register({
	  onCreate: function() {
        if($('spinner') && Ajax.activeRequestCount>0)
          Effect.Appear('spinner',{duration:0.5,queue:'end'});
	  },
	  onComplete: function() {
        if($('spinner') && Ajax.activeRequestCount==0)
          Effect.Fade('spinner',{duration:0.5,queue:'end'});
	  }
	});
}

function disableFormFields(formName) {
	var elements=$(formName).elements;
	for (var i=0; i <elements.length;i++) {
		var element = elements.item(i); 
		if (element.type != 'submit') {
			element.disabled = true;
		}
	}
}
function checkNumeric(e) {   
	var key  
	var shiftKey   
	if (window.event) {     
		key = event.keyCode   
	} else {     
		key = e.which
	}
	// Was key that was pressed a numeric character (0-9) or backspace (8)?   
	if ((key > 47 && key < 58) || key == 8 || key == 9 || key == 18 || key == 0 || key == 13) {     
		return; // if so, do nothing   
	} else {// otherwise, discard character  
		alert('Please key numerics only for this field.');   
		if (window.event) { //IE       
			window.event.returnValue = null;     
		} else {//Firefox       
			e.preventDefault();
		}
	} 
} 	

function ignorEnter(formField,e) {
	var keycode;
	if (window.event) keycode = window.event.keyCode;
	else if (e) keycode = e.which;
	else return true;
	if (keycode == 13) {
	   return false;
	} else {
	   return true;
	}
}
