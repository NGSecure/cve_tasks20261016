function view_existing_subjects(){
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
      if (this.readyState == 4 && this.status == 200) {
       document.getElementById('existing_subjects').innerHTML = this.responseText;
      }
    };

    xhttp.open("GET", "scripts/select_subjects.php", true);
     xhttp.send();
  }
  
  view_existing_subjects();