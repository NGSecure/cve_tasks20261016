function countdown(timestamp) {
    timetarget = new Date(timestamp);
    
    var Today = new Date();

    Todays_Year = Today.getFullYear() - 2000;
    Todays_Month = Today.getMonth();

    //Convert both today's date and the target date into miliseconds.
    Todays_Date = (new Date(Todays_Year, Todays_Month, Today.getDate(), Today.getHours(), Today.getMinutes(), Today.getSeconds())).getTime();

    Target_Date = timetarget.getTime();

    //Find their difference, and convert that into seconds.
    Time_Left = Math.round((Target_Date - Todays_Date) / 1000);

    if (Time_Left < 0) Time_Left = 0;

    //More datailed.
    days = Math.floor(Time_Left / (60 * 60 * 24));
    Time_Left %= (60 * 60 * 24);
    hours = Math.floor(Time_Left / (60 * 60));
    Time_Left %= (60 * 60);
    minutes = Math.floor(Time_Left / 60);
    Time_Left %= 60;
    seconds = Time_Left;

    if (seconds < 10) {
        seconds = '0' + seconds;
    }
    if (minutes < 10) {
        minutes = '0' + minutes;
    }

    html = hours + ':' + minutes + ':' + seconds + ' secs';

    document.getElementById('countdown').innerHTML = html;

    //Recursive call, keeps the clock ticking.
    setTimeout(function() { countdown(timestamp); }, 1000);
}

countdown(1303189200 * 1000); // i made up a timestamp here, you can just use whatever you want, including using php to inject the value