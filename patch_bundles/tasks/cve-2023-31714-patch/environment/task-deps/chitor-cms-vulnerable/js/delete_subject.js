function delete_subject(subject,class_name,school){
    let to_hide=subject+class_name;
    let text = "Are your sure to delete Class " +class_name +"'s Subject "+subject;
    if (confirm(text) == true) {
        
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function() {
            if (this.readyState == 4 && this.status == 200) {
                document.getElementById("delete_result").innerHTML = this.responseText;
                document.getElementById(to_hide).style.display="none";
            }
        };
    xhttp.open("GET", "scripts/delete_class_subject_script.php?class_name="+class_name+"&subject="+subject+"&school="+school, true);
    xhttp.send();
        
      } 
}



