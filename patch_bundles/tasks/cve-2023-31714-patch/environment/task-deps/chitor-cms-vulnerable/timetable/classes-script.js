function dayNum(day)
{
    if(day=="Mon") { return 0;}
    else if(day=="Tue") { return 1;}
    else if(day=="Wed") { return 2;}
    else if(day=="Thu") { return 3;}
    else if(day=="Fri") { return 4;}
    else if(day=="Sat") { return 5;}
    else{ return "wrong input";}
}
const  days=["Mon","Tue","Wed","Thu","Fri","Sat"];
const  classes=["6th","7th","8th","9thA","9thB","10thA","10thB"]
function blank_timeTable(all_days,class_id)
{
    const body = document.getElementsByTagName("body")[0];
    const table = document.createElement("table");
    table.style.width = "50%";
    table.setAttribute("border", "1");
    table.setAttribute("id", class_id);
    table.classList.add("same-page");
    const tableHead = document.createElement("thead");
    const headFirstRow = document.createElement("tr");
    const th = document.createElement("th");
    th.setAttribute("colspan", 9);
    th.innerText = class_id;
    headFirstRow.append(th);
    tableHead.append(headFirstRow);
    table.append(tableHead);
    const row2 = document.createElement("tr");
    const DayforwardSlahPeriod = document.createElement("th");
    DayforwardSlahPeriod.innerText = "Day/Period";
    row2.append(DayforwardSlahPeriod);
    // create period header 1 to 8
    for (let i=1; i<=8; i++) {
        const theNumbers = document.createElement("th");
        theNumbers.innerText = i;
        row2.append(theNumbers);
    }
    tableHead.append(row2);
    const tableBody = document.createElement("tbody");
    for (day of all_days) {
        const dailySechdule = document.createElement("tr");
        const currentDay = document.createElement("td");
        currentDay.innerText = day;
        dailySechdule.append(currentDay);
        for(let i=0;i<=7;i++){
            const currentClass = document.createElement("td");
            dailySechdule.append(currentClass);
            tableBody.append(dailySechdule);
        }
    }

    table.append(tableBody);
    body.append(table);
}
// Populate function here.
async function getData()
{
    let data = await fetch('http://localhost/chitor-cms/timetable/timetable_data.json');
    let timeTable = await data.json();
    for(teacher in timeTable){
        for(day in timeTable[teacher]) {
            for (period in timeTable[teacher][day]) {
                let d=dayNum(day)
                //populate the tables
                if (timeTable[teacher][day][period].hasOwnProperty('Class')) {
                    let cls=timeTable[teacher][day][period]["Class"];
                    let sec=timeTable[teacher][day][period]["Section"];
                    let combine= cls+"th"+sec;
                    // console.log (combine);
                    let selectedTable=document.getElementById(combine);
                    // console.log(teacher);
                    // console.log(day);
                    // console.log(selectedTable);
                    let selectedTBody=selectedTable.tBodies[0];
                    // console.log(selectedTBody);
                    let TRow=selectedTBody.getElementsByTagName('tr')[d]
                    let TColumn=TRow.getElementsByTagName('td')[period];
                    TColumn.innerHTML=timeTable[teacher][day][period]["Subject"]+ "<br>" +teacher;
                }
                else{
                    console.log('Empty');
                }
            }// end of period loop.
        }//end of day loop
    }// end of teacherLoop
}
getData();
for(c of classes){
    blank_timeTable(days,c);
}
