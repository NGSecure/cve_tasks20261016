function select_settings(){
    var xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function() {
      if (this.readyState == 4 && this.status == 200) {
       document.getElementById('existing_employees').innerHTML = this.responseText;
      }
    };
  
    xhttp.open("GET", "scripts/select_settings.php", true);
     xhttp.send();
  }
  
  select_settings();