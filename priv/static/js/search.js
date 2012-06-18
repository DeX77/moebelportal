// global variables
var sListTotal   =  0;
var sListCurrent = -1;
var sDelay		  = 10000;
var sURL		  = null;
var sSearchId	  = null;
var sResultsId	  = null;
var sSearchField = null;
var sResultsDiv  = null;

var type_url_mapping = new Array();
type_url_mapping["p"] = "/products/";
type_url_mapping["m"] = "/manuals/";
type_url_mapping["s"] = "/steps/";
type_url_mapping["t"] = "/tools/";
type_url_mapping["e"] = "/materials/";

function setSearchAutoComplete(field_id, results_id, get_url){

	// initialize vars
	sSearchId  = "#" + field_id;
	sResultsId = "#" + results_id;
	sURL 		= get_url;

	// create the results div
    var div = document.createElement("div");
    div.id = results_id;
    document.body.appendChild(div);
	//$("body").append('<div id="' + results_id + '"></div>');

	// register mostly used vars
	sSearchField	= $(sSearchId);
	sResultsDiv	= $(sResultsId);

	// reposition div
	searchRepositionResultsDiv();
	
	// on blur listener
	sSearchField.blur(function(){ setTimeout("searchClearAutoComplete()", 200) });

	// on key up listener
	sSearchField.keyup(function (e) {

		// get keyCode (window.event is for IE)
		var keyCode = e.keyCode || window.event.keyCode;
		var lastVal = sSearchField.val();

		// check an treat up and down arrows
		if(searchUpdownArrow(keyCode)){
			return;
		}

		// check for an ENTER or ESC
		if(keyCode == 13 || keyCode == 27){
			searchClearAutoComplete();
			return;
		}

		// if is text, call with delay
		setTimeout(function () {searchAutoComplete()}, sDelay);
	});
}

// treat the auto-complete action (delayed function)
function searchAutoComplete()
{
	// get the field value
	var part = sSearchField.val();

	// if it's empty clear the resuts box and return
	if(part == ''){
		searchClearAutoComplete();
		return;
	}

	// get remote data as JSON
	$.getJSON(sURL + part, function(json){

		// get the total of results
		var ansLength = sListTotal = json.length;

		// if there are results populate the results div
		if(ansLength > 0){

			var newData = '';
      

			// create a div for each result
			for(i=0; i < ansLength; i++) {
                /*var split = json[i].split(":");
                var div = document.createElement("div");
                div.className = "unselected";
                var onclick ="document.location.href=\'" + type_url_mapping[split[0]] + split[1] + "\';";
                div.onclick = onclick;
                div.innerHTML = split[2].replace(part,"<u>" + part + "</u>");
                document.getElementById(sResultsId.substring(1)).appendChild(div);
                */
                var split = json[i].split(":");
                newData += '<div onclick="document.location.href=\'';
                newData += type_url_mapping[split[0]];
                newData += split[1] + '\';" class="unselected"  >';
                var str = split[2].replace(part,"<u>" + part + "</u>");
                newData += str + '</div>';
                
			}

			// update the results div
			sResultsDiv.html(newData);
			sResultsDiv.css("display","block");
			
			// for all divs in results
			var divs = $(sResultsId + " > div");
		
			// on mouse over clean previous selected and set a new one
			divs.mouseover( function() {
				divs.each(function(){ this.className = "unselected"; });
				this.className = "selected";
			})			

		} else {
			searchClearAutoComplete();
		}
	});
}

// clear auto complete box
function searchClearAutoComplete()
{
	sResultsDiv.html('');
	sResultsDiv.css("display","none");
}

// reposition the results div accordingly to the search field
function searchRepositionResultsDiv()
{
	// get the field position
	var sf_pos    = sSearchField.offset();
	var sf_top    = sf_pos.top;
	var sf_left   = sf_pos.left;

	// get the field size
	var sf_height = sSearchField.height();
	var sf_width  = sSearchField.width();

	// apply the css styles - optimized for Firefox
	sResultsDiv.css("position","absolute");
	sResultsDiv.css("left", sf_left - 2);
	sResultsDiv.css("top", sf_top + sf_height + 5);
	sResultsDiv.css("width", sf_width - 2);
}


// treat up and down key strokes defining the next selected element
function searchUpdownArrow(keyCode) {
	if(keyCode == 40 || keyCode == 38){

		if(keyCode == 38){ // keyUp
			if(sListCurrent == 0 || sListCurrent == -1){
				sListCurrent = sListTotal-1;
			}else{
				sListCurrent--;
			}
		} else { // keyDown
			if(sListCurrent == sListTotal-1){
				sListCurrent = 0;
			}else {
				sListCurrent++;
			}
		}

		// loop through each result div applying the correct style
		sResultsDiv.children().each(function(i){
			if(i == sListCurrent){
				sSearchField.val(this.childNodes[0].nodeValue);
				this.className = "selected";
			} else {
				this.className = "unselected";
			}
		});

		return true;
	} else {
		// reset
		sListCurrent = -1;
		return false;
	}
}