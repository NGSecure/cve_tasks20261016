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
	if (d==0) return false; // nothing needs to be done for month change
	
	if (m!=gCurMonth[1]&&[y,m,d]+''!=gToday+'') { // cancel the auto month switching
		fRepaint();
		return true;
	}
	
	return false;  // return true to cancel the change.
}


///////////// Calendar AfterSelected Handler ///////////////////////
// It's triggered whenever a date gets fully selected.
// The selected date is passed in as y(ear),m(onth),d(ay)
// e is a reference to the triggering event object
// NOTE: DO NOT define this handler unless you really need to use it.
////////////////////////////////////////////////////////////////////
// function fAfterSelected(y,m,d,e) {}


///////////// Calendar Cell OnDrag Handler ///////////////////////
// It triggered when you try to drag a calendar cell. (y,m,d) is the cell date. 
// aStat = 0 means a mousedown is detected (dragstart)
// aStat = 1 means a mouseover between dragstart and dragend is detected (dragover)
// aStat = 2 means a mouseup is detected (dragend)
// e is a reference to the triggering event object
// NOTE: DO NOT define this handler unless you really need to use it.
//       If you use fRepaint() here, fAfterSelected() will be ignored.
////////////////////////////////////////////////////////////////////
function fOnDrag(y,m,d,aStat,e) {
	if (aStat==2) return;	// discard dragover
	var bRangeClick=true;
	if (aStat==0) {
		bRangeClick=e?fCheckKeyPressed(1+2+4,e):false;	// use ctrl, shift or alt to select range end
	} else {
		var ag=fGetAgenda(y,m,d,true);
		if (ag==null||ag[1]==null) return;	// only allow dragging on selectable date
	}

	if (bRangeClick) {
		var dt=Date.UTC(y,m-1,d),sd,ed,hdEvent;
		if (dt>_pds[2]) {
			sd=_pds[2];
			ed=dt;
		} else {
			sd=dt;
			ed=_pds[2];
		}
		
		for (var i=sd; i<=ed; i+=MILLIDAY) {
			var day=new Date(i);
			hdEvent=fHoliday(day.getUTCFullYear(),day.getUTCMonth()+1,day.getUTCDate());
			if (hdEvent&&hdEvent[2]==HolidayBGC)
				break;
		}
		if (i<=ed) return;	// not allow selecting range across holiday
	}
	fAddRange(y,m,d,bRangeClick);
	if (gContainer.fOnRange) gContainer.fOnRange(_pds);	// pass in selected range
	fRepaint();
	return;
}



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
	if (_pds.length==0) return false;
	var dt=Date.UTC(y,m-1,d);
	return (_pds[0]<=dt&&dt<=_pds[1]);
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

var HolidayBGC="skyblue";	// define a way to identify holiday from other events, this time we use bgcolor
	
// ======= the following plugin is coded for the range-pick plugin ========

var _pds=[]; // will contain 3 items: [startdate, enddate, firstClicked].

function fCheckKeyPressed(key,e) {
	var ALT=1, CTRL=2, SHIFT=4, pr=false;
	if (key&&ALT) pr=NN4?e.modifiers&1:e.altKey;
	if (!pr&&key&&CTRL) pr=NN4?e.modifiers&2:e.ctrlKey;
	if (!pr&&key&&SHIFT) pr=NN4?e.modifiers&4:e.shiftKey;
	return pr;
}

function fClearAll() {
	_pds.length=0;
}

function fAddRange(y,m,d,bBatch) {
	var dt=Date.UTC(y,m-1,d);
	if (bBatch&&_pds.length>0) {
		if (dt<_pds[2]) {_pds[0]=dt; _pds[1]=_pds[2];}
		else if (_pds[2]<dt) {_pds[0]=_pds[2]; _pds[1]=dt;}
	} else _pds[0]=_pds[1]=_pds[2]=dt;
}
// ======= end of range-pick plugin ========

