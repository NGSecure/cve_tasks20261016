Event.observe(window, 'load', init, false);

var hackdiet_old_value;

function init() {

	var weights = document.getElementsByClassName("weightedit");
	weights.each( function(cell){
		makeEditable(cell.id);
	});
}

function makeEditable(id) {
	Event.observe(id, 'click', function(){edit($(id))}, false);
	Event.observe(id, 'mouseover', function(){showAsEditable($(id))}, false);
	Event.observe(id, 'mouseout', function(){showAsEditable($(id), true)}, false);
}

function showAsEditable(obj, clear) {
	if (!clear){
		Element.addClassName(obj, 'editable');
	}else{
		Element.removeClassName(obj, 'editable');
	}
}

function edit(obj) {
	Element.hide(obj);

	hackdiet_old_value = obj.innerHTML;

	var text = '<div id="' + obj.id + '_editor"><input class="hackdiet_edit_text" type="text" id="' + obj.id + '_edit" name="' + obj.id + '" value="'
	if (hackdiet_old_value == "click here to add a weight")
	{
		text = text + "";
	}
	else if (hackdiet_old_value.indexOf('<') != -1)
	{
		text = text + hackdiet_old_value.substr(0, hackdiet_old_value.indexOf('<'));
	}
	else
	{
		text = text + hackdiet_old_value;
	}
	var text = text + '">';

	var button = '<input class="hackdiet_edit_button" id="' + obj.id + '_save" type="button" value="SAVE" /> OR <input class="hackdiet_cancel_button" id="' + obj.id + '_cancel" type="button" value="CANCEL" /></div>';

	new Insertion.After(obj, text + button);

	$(obj.id + '_edit').focus();

	Event.observe(obj.id+'_save', 'click', function(){saveChanges(obj)}, false);
	Event.observe(obj.id+'_cancel', 'click', function(){cleanUp(obj)}, false);

}

function cleanUp(obj, keepEditable){
	Element.remove(obj.id+'_editor');
	Element.show(obj);
	if (!keepEditable) showAsEditable(obj, true);
}

function saveChanges(obj){
	var new_content = escape($F(obj.id+'_edit'));
	
	if (new_content != obj.innerHTML)
	{
		obj.innerHTML = "Saving...";
		cleanUp(obj, true);

		var success = function(t){editComplete(t, obj);}
		var failure = function(t){editFailed(t, obj);}

		var url = $('file_path').innerHTML + 'weight_save.php';
		var pars = 'id=' + obj.id + '&user=' + $F('user_id') + '&content=' + new_content;
		var myAjax = new Ajax.Request(url, {method:'post', postBody:pars, onSuccess:success, onFailure:failure});
	} else {
		obj.innerHTML = new_content;
		cleanUp(obj, true);
		showAsEditable(obj, true);
	}
}

function editComplete(t, obj){
	obj.innerHTML = t.responseText;
	Element.removeClassName(obj, 'blankedit');
	showAsEditable(obj, true);
	var image_url = $('main_graph').src + "&random=" + (Math.random());
	$('main_graph').src = image_url;

	var blurb_success = function(t){blurbComplete(t, $('blurb'));}
	var blurb_failure = function(t){blurbFailed(t, $('blurb'));}

	var url = $('file_path').innerHTML + 'ajax_blurb.php';
	var pars = 'user=' + $F('user_id');
	var myAjax = new Ajax.Request(url, {method:'post', postBody:pars, onSuccess:blurb_success, onFailure:blurb_failure});

	var togo_success = function(t){togoComplete(t, $('togo'));}
	var togo_failure = function(t){togoFailed(t, $('togo'));}

	var togo_url = $('file_path').innerHTML + 'ajax_togo.php';
	var togo_pars = 'user=' + $F('user_id');
	var togo_myAjax = new Ajax.Request(togo_url, {method:'post', postBody:togo_pars, onSuccess:togo_success, onFailure:togo_failure});
}

function editFailed(t, obj){
	// TODO: dont just do this for errors, reset the value to the old weight and think of a better way to show failure
	obj.innerHTML = 'Sorry, the update failed.';
	cleanUp(obj);
}

function blurbComplete(t, obj){
	obj.innerHTML = t.responseText;	
}

function blurbFailed(t, obj){
	obj.innerHTML = '';
}

function togoComplete(t, obj){
	obj.innerHTML = t.responseText;	
}

function togoFailed(t, obj){
	obj.innerHTML = '';
}