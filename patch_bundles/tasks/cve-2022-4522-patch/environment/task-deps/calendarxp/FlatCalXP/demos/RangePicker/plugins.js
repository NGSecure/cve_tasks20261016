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
	fSync(y,m,d);
	return false;
}


///////////// Calendar AfterSelected Handler ///////////////////////
// It's triggered whenever a date gets fully selected.
// The selected date is passed in as y(ear),m(onth),d(ay)
// e is a reference to the triggering event object
// NOTE: DO NOT define this handler unless you really need to use it.
////////////////////////////////////////////////////////////////////
function fAfterSelected(y,m,d,e) {
	fAddRange(y,m,d);
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
function fIsSelected(y,m,d) {
	if (gContainer._pds.length==0) return false;
	var dt=Date.UTC(y,m-1,d);
	return (gContainer._pds[0]<=dt&&dt<=gContainer._pds[1]);
}


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


// ======= the following plugin is coded for the range-pick plugin ========

gContainer._pds=[]; // will contain 3 items: [startdate, enddate, firstClicked].



function fClearAll() {
	gContainer._pds.length=0;
}

function fAddRange(y,m,d,bBatch) {
	var dt=Date.UTC(y,m-1,d);
	if (gContainer._pds.length>0) {
		if (dt<gContainer._pds[0]) gContainer._pds[0]=dt;
		else if (gContainer._pds[1]<dt) gContainer._pds[1]=dt;
		else gContainer._pds[0]=gContainer._pds[1]=gContainer._pds[2]=dt;
	} else gContainer._pds[0]=gContainer._pds[1]=gContainer._pds[2]=dt;
	
	gContainer.fOnRange(gContainer._pds);
	gContainer.gfFlat_1.fRepaint();
	gContainer.gfFlat_2.fRepaint();
	
}
// ======= end of range-pick plugin ========


// ======= the following plugin is coded for the artificial internal dropdown seletors ========
// You may change the left,top in the fPopMenu() to adjust the popup position.
// Other Settings
var _highlite_background="white";	// highlight background color
var _highlite_fontColor="black";	// highlight font color
var _pop_length=7;	// how many months to be shown
var _pop_width=100;	// pixels of the popup width

gbShareAgenda=true;
gbShrink2fit=false;
gbHideBottom=true;
giShowOther=(gTheme[3].split("_")[1]==1)?1+2+8:1+2+4; // hide the dates adjacent to the other panel


// Override the gsCalTitle option to popup a date-selector layer. Remember to keep it as an expression or a function returning a string.
gsCalTitle="\"<a class='PopAnchor' href='javascript:void(0);' onclick='if(this.blur)this.blur();fPopMenu(this,event);return false;'>\"+gMonths[gCurMonth[1]-1]+' '+gCurMonth[0]+\"</a>\"";

var _calendars4sync=2;	// MUST be specified to exact number of your calendars, or you will get errors.

function fSync(y,m,d) {
	var cn=gTheme[3].split("_");	// get current context id
	var no=parseInt(cn[1]),ctx;
	var r=fCalibrate(1,no+gdSelect[1]-m)[1]; // find the one needs refreshing
	for (var n=1; n<=_calendars4sync; n++)
		if (n!=no) {
			ctx=eval("gContainer."+cn[0]+"_"+n);
			if (!ctx) return;	// loading, not ready
			if (d>0) ctx.fUpdSelect(y,m,d);
			if (y!=gCurMonth[0]||m!=gCurMonth[1]||n==r&&gdSelect[1]!=0) ctx.fSetCal(y,m+n-no,0,false);
		}
}

function fPopMenu(dc,e) {
	var lyr=NN4?document.freeDiv0:fGetById(document,"freeDiv0");
	var bv=NN4?lyr.visibility=="show":lyr.style.visibility=="visible";
	if (bv) { fToggleLayer(0,false); return; }
	fSetDPop(gCurMonth[0],gCurMonth[1]);
	if (NN4) with (lyr) {
		left=35;
		top=4;
	} else with (lyr.style) {
		left=38+"px";
		top=4+"px";
	}
	fToggleLayer(0,true);
}

var _tmid=null;
function fSetDPop(y,m) {
	var mi=_pop_length;
	var wd=_pop_width;
	var sME=NN4||IE4?"":" onmouseover='fToggleColor(this,0)' onmouseout='fToggleColor(this,1)' ";	// menu-item focus background-color
	var padstr="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
	var cm=fCalibrate(y,m);
	var a=[NN4||IE4||IE&&MAC?"<table border=1 cellspacing=0 cellpadding=0><tr><td>":"","<div onmouseover='clearTimeout(_tmid)' onmouseout='_tmid=setTimeout(\"fToggleLayer(0,false)\",100)'><table class='PopMenu' border=0 cellspacing=0 cellpadding=0>"];
	if(!fBfRange(cm[0],cm[1]))a.push("<tr><td align='center' class='PopMenuItem' nowrap width=",wd,sME," onclick='fSetDPop(",cm[0],",",cm[1]-mi,")'><a class='PopMenuItem' href='javascript:void(0)' onclick='if(NN4)fSetDPop(",cm[0],",",cm[1]-mi,");return false;'>",padstr,"-",padstr,"</a></td></tr>");
	for (var i=0;i<mi;i++) {
		var lm=fCalibrate(cm[0],cm[1]+i);
		if (!fIsOutRange(lm[0],lm[1]))
			a.push("<tr><td align='center' class='PopMenuItem' nowrap width=",wd,sME," onclick='fToggleLayer(0,false);fSetCal(",lm[0],",",lm[1],",0,true,event);'><a class='PopMenuItem' href='javascript:void(0)' onclick='if(NN4)fSetCal(",lm[0],",",lm[1],",0,true,event);return false;'>",gMonths[lm[1]-1]," ",lm[0],"</a></td></tr>");
	}
	if(!fAfRange(lm[0],lm[1]))a.push("<tr><td align='center' class='PopMenuItem' nowrap width=",wd,sME," onclick='fSetDPop(",cm[0],",",cm[1]+mi,")'><a class='PopMenuItem' href='javascript:void(0)' onclick='if(NN4)fSetDPop(",cm[0],",",cm[1]+mi,");return false;'>",padstr,"+",padstr,"</a></td></tr>")
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

// ======= end of dropdown plugin ========
