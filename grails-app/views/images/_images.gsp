<li> 
	<div id="otherImages">  
	    <g:each in="${otherImages}" var="otherImage">
	     <a href="${createLink(action:'downloadImage')}?qualifiedImage=${item.division.name}/${item.category.name}/${otherImage}">
	        <img class="otherImage" id="${otherImage?.replaceAll(/.jpg/,'')}" 
	             src="https://www.kettlerusa.com/images/${item.division.name}/${item.category.name}/${otherImage}" 
	             alt="${item.desc} other image" title="Click to download the full sized image"/>
	     </a>
	    </g:each> 
	    <a href="${createLink(action:'downloadImage')}?qualifiedImage=${item.division.name}/${item.category.name}/${item.itemNo}_FULL.jpg">
	        <img class="otherImage" id="${otherImage?.replaceAll(/.jpg/,'')}" 
	             src="https://www.kettlerusa.com/images/${item.division.name}/${item.category.name}/${item.itemNo}.jpg" 
	             alt="${item.desc} other image" title="Click to download the full sized image"/>
	    </a>
	</div>
</li>