function view_existing_school_classes(){
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
      if (this.readyState == 4 && this.status == 200) {
       document.getElementById('exiting-school-classes').innerHTML = this.responseText;
      }
    };
  
    let school_name=document.getElementById("school_name").value;
    xhttp.open("GET", "scripts/select_school_classes.php?school_name="+school_name, true);
     xhttp.send();
  }
  
  view_existing_school_classes();