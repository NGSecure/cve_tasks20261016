function view_existing_schools(){
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
      if (this.readyState == 4 && this.status == 200) {
       document.getElementById('existing_schools').innerHTML = this.responseText;
      }
    };

    xhttp.open("GET", "scripts/select_schools.php", true);
     xhttp.send();
  }
  
  view_existing_schools();