/////////////////// Plug-in file for CalendarXP 9.0 /////////////////
// This file is totally configurable. You may remove all the comments in this file to minimize the download size.
/////////////////////////////////////////////////////////////////////

///////////// Calendar Onchange Handler ////////////////////////////
// It's triggered whenever the calendar gets changed to y(ear),m(onth),d(ay)
// d = 0 means the calendar is about to switch to the month of (y,m); 
// d > 0 means a specific date [y,m,d] is about to be selected.
// e is a reference to the triggering event object
// Return a true value will cancel the change action.
// NOTE: DO NOT define this handler unless you really need to use it.
////////////////////////////////////////////////////////////////////
function fOnChange(y,m,d,e) {
	if (NN4) _pop_flag=0;
	return false;  // return true to cancel the change.
}


///////////// Calendar AfterSelected Handler ///////////////////////
// It's triggered whenever a date gets fully selected.
// The selected date is passed in as y(ear),m(onth),d(ay)
// e is a reference to the triggering event object
// NOTE: DO NOT define this handler unless you really need to use it.
////////////////////////////////////////////////////////////////////
function fAfterSelected(y,m,d,e) {
	fHideCal();
}


///////////// Calendar Cell OnDrag Handler ///////////////////////
// It triggered when you try to drag a calendar cell. (y,m,d) is the cell date. 
// aStat = 0 means a mousedown is detected (dragstart)
// aStat = 1 means a mouseover between dragstart and dragend is detected (dragover)
// aStat = 2 means a mouseup is detected (dragend)
// e is a reference to the triggering event object
// NOTE: DO NOT define this handler unless you really need to use it.
//       If you use fRepaint() here, fAfterSelected() will be ignored.
////////////////////////////////////////////////////////////////////

// function fOnDrag(y,m,d,aStat,e) {}



////////////////// Calendar OnResize Handler ///////////////////////
// It's triggered after the calendar panel has finished drawing.
// NOTE: DO NOT define this handler unless you really need to use it.
////////////////////////////////////////////////////////////////////
// function fOnResize() {}


////////////////// Calendar fOnWeekClick Handler ///////////////////////
// It's triggered when the week number is clicked.
// NOTE: DO NOT define this handler unless you really need to use it.
////////////////////////////////////////////////////////////////////
// function fOnWeekClick(year, weekNo) {}

////////////////// Calendar fOnDoWClick Handler ///////////////////////
// It's triggered when the week head (day of week) is clicked.
// dow ranged from 0-6 while 0 denotes Sunday, 6 denotes Saturday.
// NOTE: DO NOT define this handler unless you really need to use it.
////////////////////////////////////////////////////////////////////
// function fOnDoWClick(year, month, dow) {}


////////////////// Calendar fIsSelected Callback ///////////////////////
// It's triggered for every date passed in as y(ear) m(onth) d(ay). And if 
// the return value is true, that date will be rendered using the giMarkSelected,
// gcFGSelected, gcBGSelected and guSelectedBGImg theme options.
// NOTE: If NOT defined here, the engine will create one that checks the gdSelect only.
////////////////////////////////////////////////////////////////////
// function fIsSelected(y,m,d) {
//		return gdSelect[2]==d&&gdSelect[1]==m&&gdSelect[0]==y;
// }



////////////////// Calendar fParseInput Handler ///////////////////////
// Once defined, it'll be used to parse the input string stored in gdCtrl.value.
// It's expected to return an array of [y,m,d] to indicate the parsed date,
// or null if the input str can't be parsed as a date.
// NOTE: If NOT defined here, the engine will create one matching fParseDate().
////////////////////////////////////////////////////////////////////
// function fParseInput(str) {}


////////////////// Calendar fFormatInput Handler ///////////////////////
// Once defined, it'll be used to format the selected date - y(ear) m(onth) d(ay)
// into gdCtrl.value.
// It's expected to return a formated date string.
// NOTE: If NOT defined here, the engine will create one matching fFormatDate().
////////////////////////////////////////////////////////////////////
// function fFormatInput(y,m,d) {}

////////////////// Calendar fOnload Handler ///////////////////////
// It's triggered when the calendar engine is fully loaded by the browser.
// NOTE: DO NOT define this handler unless you really need to use it.
////////////////////////////////////////////////////////////////////
// function fOnload() {}


// ====== predefined utility functions for use with agendas. ========

// load an url in the window/frame designated by "framename".
function popup(url,framename) {	
	var w=parent.open(url,framename,"top=200,left=200,width=400,height=200,scrollbars=1,resizable=1");
	if (w&&url.split(":")[0]=="mailto") w.close();
	else if (w&&!framename) w.focus();
}

// ====== Following are self-defined and/or custom-built functions! =======



// ======= the following plugin is coded for the double internal dropdown seletors ========
// You may change the left,top in the fPopMenu() to adjust the popup position.
// Other Settings
var _highlite_background="#ffcc99";	// highlight background color
var _highlite_fontColor="black";	// highlight font color
var _yearPop_length=7;	// how many years to be shown
var _yearPop_width=38;	// pixels of the year popup width
var _monthPop_width=70;	// pixels of the month popup width



var _pop_flag=0;
function fPopMenu(dc,dcId,e) {
	var lyr=NN4?document.freeDiv0:fGetById(document,"freeDiv0");
	if (_pop_flag==dcId) { fToggleLayer(0,false); return; }
	_pop_flag=dcId;
	if (dcId==1) fSetYPop(gCurMonth[0]);
	else fSetMPop();
	var h=17,w=NN4?dcId==2?-gMonths[gCurMonth[1]-1].length*5-20:-30:0;
	if (NN4) with (lyr) {
		left=dc.x+w;
		top=dc.y+h;
	} else {
		var xy=fGetXY(dc);
		with (lyr.style) {
			left=xy[0]+w+"px";
			top=xy[1]+h+"px";
		}
	}
	fToggleLayer(0,true);
	fStopEvent(e);
}

function fStopEvent(e) {
	e.cancelBubble=true;
	if (e.stopPropagation) e.stopPropagation();
}

var _tmid=null;
function fSetYPop(y) {
	var mi=_yearPop_length;
	var wd=_yearPop_width;
	var sME=NN4||IE4?"":" onmouseover='fToggleColor(this,0)' onmouseout='fToggleColor(this,1)' ";
	var padstr="&nbsp;&nbsp;&nbsp;";
	var a=[NN4||IE4||IE&&MAC?"<table border=1 cellspacing=0 cellpadding=0><tr><td>":"","<div onmouseover='clearTimeout(_tmid)' onmouseout='_tmid=setTimeout(\"fToggleLayer(0,false)\",100)'><table class='PopMenu' border=0 cellspacing=0 cellpadding=0>"];
	var hmi=Math.floor(mi/2),yy;
	if(!fBfRange(y-hmi,1))a.push("<tr><td align='center' class='PopMenuItem' nowrap width=",wd,sME,"><a class='PopMenuItem' href='javascript:void(0)' onclick='fStopEvent(event);fSetYPop(",y-mi,");return false;'>",padstr,"-",padstr,"</a></td></tr>");
	for (var i=0;i<mi;i++) {
		yy=y-hmi+i;
		if (gdBegin.getFullYear()<=yy&&yy<=gdEnd.getFullYear())
			a.push("<tr><td align='center' class='PopMenuItem' nowrap width=",wd,sME," onclick='fStopEvent(event)'><a class='PopMenuItem' href='javascript:void(0)' onclick='fToggleLayer(0,false);fSetCal(",yy,",gCurMonth[1],0,true,event);return false;'>",yy,"</a></td></tr>");
	}
	if(!fAfRange(yy,12))a.push("<tr><td align='center' class='PopMenuItem' nowrap width=",wd,sME,"><a class='PopMenuItem' href='javascript:void(0)' onclick='fStopEvent(event);fSetYPop(",y+mi,");return false;'>",padstr,"+",padstr,"</a></td></tr>");
	a.push("</table></div>",NN4||IE4||IE&&MAC?"</td></tr></table>":"");
	fDrawLayer(0,a.join(''));
}

function fSetMPop() {
	var wd=_monthPop_width;
	var sME=NN4||IE4?"":" onmouseover='fToggleColor(this,0)' onmouseout='fToggleColor(this,1)' ";

	var a=[NN4||IE4||IE&&MAC?"<table border=1 cellspacing=0 cellpadding=0><tr><td>":"","<div onmouseover='clearTimeout(_tmid)' onmouseout='_tmid=setTimeout(\"fToggleLayer(0,false)\",100)'><table class='PopMenu' border=0 cellspacing=0 cellpadding=0>"];
	var al=a.length;
	for (var i=1;i<=12;i++)
		if (!fIsOutRange(gCurMonth[0],i))
				a.push("<tr><td align='center' width=",wd,sME," onclick='fStopEvent(event);fToggleLayer(0,false);fSetCal(gCurMonth[0],",i,",0,true,event)'><a class='PopMenuItem' href='javascript:void(0)' onclick='if(NN4)fSetCal(gCurMonth[0],",i,",0,true,event);return false;'>",gMonths[i-1],"</a></td></tr>");
	if (a.length==al) {
		if (gsOutOfRange) alert(gsOutOfRange);
		return; // No change since none of them is in valid range
	}
	a.push("</table></div>",NN4||IE4||IE&&MAC?"</td></tr></table>":"");
	fDrawLayer(0,a.join(''));
}

var _cPair=[];
function fToggleColor(obj,n) {
	if (NN4||IE4) return;
	if (n==0) { // mouseover
		_cPair[0]=obj.style.backgroundColor;
		obj.style.backgroundColor=_highlite_background;
		_cPair[1]=obj.firstChild.style.color;
		obj.firstChild.style.color=_highlite_fontColor;
	} else {
		obj.style.backgroundColor=_cPair[0];
		obj.firstChild.style.color=_cPair[1];
	}
}

function fToggleLayer(id,bShow) {
	var lyr=NN4?eval("document.freeDiv"+id):fGetById(document,"freeDiv"+id);
	if (NN4) lyr.visibility=bShow?"show":"hide";
	else lyr.style.visibility=bShow?"visible":"hidden";
	if (!bShow) _pop_flag=0; 
}

function fDrawLayer(id,html) {
	var lyr=NN4?eval("document.freeDiv"+id):fGetById(document,"freeDiv"+id);
	if (IE4||IE&&MAC) lyr.style.border="0px";
	if (NN4) with (lyr.document) {
		clear(); open();
		write(html);
		close();
	} else {
		lyr.innerHTML=html+"\n";
	}
}

document.onclick=function(){	// Hide the pop menu when clicking elsewhere
	fToggleLayer(0,false);
}

// ======= end of double dropdown plugin ========
