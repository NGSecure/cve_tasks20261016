// Get data from timetable.json file
async function getData()
{
    const data = await fetch('./timetable_data.json');
    const timeTable = await data.json();
    // count: count the number of classes of a teacher.
    let count;
    // num: To give unique id to each teacher.
    let num = 1;
    // syntax of for in (key in object). key can be any variable.
    for (teacher in timeTable) {
        count = 0;
        // Create Table Element.
        const table = document.createElement('table');
        table.style.width = '50%';
        table.setAttribute('border', '1');
        table.classList.add("same-page");
        // Create Table Head.
        const tableHead = document.createElement('thead');
        const topRow = document.createElement('tr');
        const th = document.createElement('th');
        th.setAttribute('colspan', 9);
        th.setAttribute('id', num);
        th.innerText = teacher;
        topRow.append(th);
        tableHead.append(topRow);
        table.append(tableHead);
        // End of the Top Row of table.
        const row2 = document.createElement('tr');
        const row3 = document.createElement('tr');
        row3.innerHTML ="<td>     <td>09:05 <br> 09:45    <td> 09:45<br>10:20    <td>10:20<br>10:55         <td>10:55<br>11:30     <td>11:30<br>12:05      <td>12:05<br>12:40    <td>01:10<br>01:45   <td>01:45<br>02:20";
        const DayforwardSlahPeriod = document.createElement('th');
        DayforwardSlahPeriod.innerText = 'Day/Period';
        row2.append(DayforwardSlahPeriod);
        // create numbers of periods from 1 to 8
        for (let i = 1; i <= 8; i++) {
            const theNumbers = document.createElement('th');
            theNumbers.innerText = i;
            row2.append(theNumbers);
        }
        tableHead.append(row2);
        tableHead.append(row3);
        // End of Table header.
        const tableBody = document.createElement('tbody');
        for (day in timeTable[teacher]) {
            const dailySchedule = document.createElement('tr');
            const currentDay = document.createElement('td');
            currentDay.innerText = day;
            dailySchedule.append(currentDay);
            for (period in timeTable[teacher][day]) {
                const currentClass = document.createElement('td');
                if (timeTable[teacher][day][period].hasOwnProperty('Class')) {
                    count += 1;
                    currentClass.innerHTML = timeTable[teacher][day][period].Class;
                    currentClass.innerHTML += '<sup>th</sup> ';
                    currentClass.innerHTML
                      += timeTable[teacher][day][period].Section;
                    currentClass.innerHTML += '<br>';
                    currentClass.innerHTML
                      += timeTable[teacher][day][period].Subject;
                } else {
                    currentClass.innerText = 'X';
                }
                dailySchedule.append(currentClass);
            }
            tableBody.append(dailySchedule);
        }
        table.append(tableBody);
        const body = document.getElementsByTagName('body')[0];
        body.append(table);
        const teacherTopRow = document.getElementById(num);
        teacherTopRow.innerHTML += `&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;C=${count}`;
        num++;
    }
}
getData();

let e_tableCell1;
let e_tableCell2;
let e_previousValue;
const e_numberOfTables = document.getElementsByTagName('table').length;
for (let i = 0; i < e_numberOfTables; i++) {
    for (let valueOfOne = 1; valueOfOne <= 8; valueOfOne++) {
        const e_selectedTable = document.getElementsByTagName('table')[i];
        const e_tableBody = e_selectedTable.getElementsByTagName('tbody')[0];
        e_previousValue = e_tableBody;
        e_previousValue = e_tableBody.getElementsByTagName('tr')[0];
        e_previousValue = e_tableBody.getElementsByTagName('td')[valueOfOne].textContent;
        console.log(e_previousValue);
        for (let j = 0; j < 5; j++) {
            const e_tableRow = e_tableBody.getElementsByTagName('tr')[j];
            const e_tableRow2 = e_tableBody.getElementsByTagName('tr')[j + 1];
            console.log(j + 1);
            e_tableCell1 = e_tableRow.getElementsByTagName('td')[valueOfOne];
            e_tableCell2 = e_tableRow2.getElementsByTagName('td')[valueOfOne];
            console.log(`first cell = ${e_tableCell1.textContent}`);
            console.log(`2nd cell = ${e_tableCell2.textContent}`);
            console.log('___________________');
            if (e_tableCell1.textContent == e_tableCell2.textContent) {
                e_previousValue = e_tableCell2.textContent;
                if (e_previousValue != 'X') {
                    e_tableCell2.innerHTML = '<span>&#8220;</span>';
                }
            }
        }
    }
}
