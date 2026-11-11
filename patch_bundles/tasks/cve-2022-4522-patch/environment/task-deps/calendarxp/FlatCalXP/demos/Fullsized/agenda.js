//////////////////// Agenda file for CalendarXP 9.0 /////////////////
// This file is totally configurable. You may remove all the comments in this file to minimize the download size.
/////////////////////////////////////////////////////////////////////

var sNewYear="<div align='center'><IMG src='newyear.gif' width='60' height='50' border='0' alt=''></div>";
var sXmas="<div align='center' ><IMG src='xmas.gif' width='39' height='50' border='0' alt='' title='Christmas Day is disabled and cannot be selected.'></div>";

// fAppendEvent is defined in the plugins.js

//////////////////// Define agenda events ///////////////////////////
// Usage -- fAddEvent(year, month, day, message, action, bgcolor, fgcolor, bgimg, boxit, html, etc);
// Note:
// 1. the (year,month,day) identifies the date of the agenda event.
// 2. the message param will be shown as tooltip and in the status bar.
// 3. setting the action param to null will disable that date with a line-through effect.
// 4. bgcolor is the background color.
// 5. fgcolor is the font color. Setting it to ""(empty string) will hide the date.
// 6. bgimg is the url of the background image file in use with the specific date.
// 7. if boxit is set other than false or null value, the date will be drawn in a box using boxit value as the color, or bgcolor if boxit is true.
// 8. html is the HTML string to be injected into the agenda cell, e.g. an <img> tag.
// 9. etc is any object you would like to associate with the date, so that you can retrieve it later via the fGetEvent().
// ** REMEMBER to unlock corresponding bits of the gAgendaMask option in the theme.
/////////////////////////////////////////////////////////////////////

// fAppendEvent() is defined in the plugins.js
fAppendEvent(2002,12,22," Click the sub events for details... ","","skyblue",null,null,false,"<div align=left class='MsgBoard'><a href='javascript:void(0)' onmousedown=\"alert('Shopping for whatever she likes.');return false;\"><U>14:00 shopping</U></a></div>");
fAppendEvent(2002,12,22,"","","skyblue",null,null,false,"<div align=left class='MsgBoard'><a href='javascript:void(0)' onmousedown=\"alert('Dining for whatever I like.');return false;\"><U>18:00 dinner</U></a></div>");
fAppendEvent(2002,12,22,"","","skyblue",null,null,false,"<div align=left class='MsgBoard'><a href='javascript:void(0)' onmousedown=\"alert('Party for whatever we like.');return false;\"><U>20:00 party</U></a></div>");
fAppendEvent(2002,12,22,"","","skyblue",null,null,false,"<div align=left class='MsgBoard'>23:00 ... ;-)</div>");

fAppendEvent(2002,12,15,"Let's google","","skyblue",null,null,false,"<div align=left class='MsgBoard'><a href='http://www.google.com' target='_top'>Google</a></div>");


///////////// Recurring Events /////////////////////////
// fHoliday() provides you a flexible way to create recurring events easily.
// Once defined, it'll be used by the calendar engine to render each date cell.
// An agenda array [message, action, bgcolor, fgcolor, bgimg, boxit, html, etc] 
// is expected as return value, which are similar to the params of fAddEvent().
// Returning null value will result in default style as defined in the theme.
// ** REMEMBER to unlock corresponding bits of the gAgendaMask option in the theme.
////////////////////////////////////////////////////////
function fHoliday(y,m,d) {
	var rE=fGetEvent(y,m,d), r=null;

	// you may have sophisticated holiday calculation set here, following are only simple examples.
	if (m==1&&d==1)
		r=[" Jan 1, "+y+" \n Happy New Year! ", "", "#4682b4", "white", null, false, sNewYear];
	else if (m==12&&d==25)
		r=[" Dec 25, "+y+" \n Merry X'mas! ", null, "#4682b4", "white", null, false, sXmas];	// show a line-through effect
	else if (m==5&&d>20) {
		var date=fGetDateByDOW(y,5,5,1);	// Memorial day is the last Monday of May
		if (d==date) r=["May "+d+", "+y+" \n Memorial Day ", gsAction, "#4682b4", "white"];
	}

	
	return rE?rE:r;	// favor events over holidays
}


