function changeEqual()
{
    const tableLength = document.getElementsByTagName('table');
    for(let k=0;k<tableLength.length;k++){ 
        let t=document.getElementsByTagName('table')[k];
        for(let j=1; j<=8; j++){
            for(let i=5; i>0; i--){
                let upper=t.tBodies[0].rows[i].cells[j].innerHTML;
                let lower=t.tBodies[0].rows[i-1].cells[j].innerHTML;
                if(upper==lower && lower!="X") {
                      console.log(`Upper ${upper} = lower ${upper}`);
                      t.tBodies[0].rows[i].cells[j].innerHTML="&#8220";
                }
                else {

                }
            }
        }
    } 
}
setTimeout(
    function () {
        changeEqual(); }, 2000
);

