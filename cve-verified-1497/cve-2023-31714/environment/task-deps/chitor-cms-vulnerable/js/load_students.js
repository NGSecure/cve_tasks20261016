function load_students(){
  var xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
     document.getElementById('show_selected_class_students').innerHTML = this.responseText;
    }
  };

  xhttp.open("GET", "scripts/load_students.php", true);
   xhttp.send();
}

load_students();