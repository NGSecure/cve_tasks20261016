//////////////////// Agenda file for CalendarXP 9.0 /////////////////
// This file is totally configurable. You may remove all the comments in this file to minimize the download size.
/////////////////////////////////////////////////////////////////////

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
fAppendEvent(2002,12,14," Click the sub events for details... ","",null,null,"OS13.jpg",false,"<div align=left class='MsgBoard' title=' 6:00pm-7:30pm Dinner @ Green Wood \n Delicious food with drink unlimited. ' onmousedown='alert(\"Dining for what I like!\")'>18:00 dinner</div>");
fAppendEvent(2002,12,14,"",null,null,null,null,null,"<div align=left class='MsgBoard' title=' 8:00pm - 11:30pm Party @ Central Park. \n Have fun and enjoy yourself. ' onmousedown='alert(\"Party for what we like!\")'>20:00 party</div>");
fAppendEvent(2002,12,16,"","",null,null,null,null,"<div align=left class='MsgBoard'><a href='http://www.google.com' target='_top'>Google</a></div>");


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
		r=[" Jan 1, "+y+" \n Happy New Year! ", "alert('Happy New Year!')", null, null, "Holiday.jpg", false, "<div align=left class='MsgBoard'>Happy New Year!</div>"];
	else if (m==12&&d==25)
		r=[" Dec 25, "+y+" \n Merry X'mas! ", null, null, null, "Holiday.jpg"];	// show a line-through effect
	else if (m==5&&d>20) {
		var date=fGetDateByDOW(y,5,5,1);	// Memorial day is the last Monday of May
		if (d==date) r=["May "+d+", "+y+" \n Memorial Day ", gsAction, "#4682b4", "white"];
	}

	
	return rE?rE:r;	// favor events over holidays
}


