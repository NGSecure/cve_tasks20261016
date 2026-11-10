function update_student_class(roll_no){
   let select_person=roll_no;
   let class_name=select_person+'_class_name';
   let class_name_value=document.getElementById(class_name).value;
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
      if (this.readyState == 4 && this.status == 200) {
        let response_place=select_person+'_response';
       document.getElementById(response_place).innerHTML = this.responseText;
      }
    };
  
    xhttp.open("GET", "scripts/update_student_class_script.php?roll_no="+roll_no+"&class_name="+class_name_value, true);
   xhttp.send();

}