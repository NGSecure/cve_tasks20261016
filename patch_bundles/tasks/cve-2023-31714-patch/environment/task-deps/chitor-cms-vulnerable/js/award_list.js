// A seperate file is create because it only load with Award list.

function save_classname(){
  //let rollno= document.getElementById('rollno').value;
	localStorage.setItem('class_Name',class_name);
}

function save_subjectname(){
  //let rollno= document.getElementById('rollno').value;
	localStorage.setItem('subject_Name',subject_name);
}

function Save_class_subject(){
    let class_name=document.getElementById("class_name").value;
    let subject_name=document.getElementById("subject_name").value;
  
    localStorage.setItem('class_name',class_name);
    localStorage.setItem('subject_name',subject_name);
  }
  
  function Load_class_subject(){
    let storage_class_name=localStorage.getItem('class_name');
    let storage_subject_name=localStorage.getItem('subject_name');
    document.getElementById("class_name").value=storage_class_name;
    document.getElementById("subject_name").value=storage_subject_name;
    
  }

  
  function removeAll() {
    let selectBox=document.getElementById("class_exam");
    console.log(selectBox.options.length);
    while (selectBox.options.length > 0) {
        select.remove(0);
    }
}


function view_existing_school_classes(){
  var xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
       document.getElementById('class_name').innerHTML=this.responseText;
    }
  };

  let school_name=document.getElementById("school_name").value;
  xhttp.open("GET", "scripts/select_school_classes.php?tech=class_only&school="+school_name, true);
   xhttp.send();
}

function view_existing_subjects(){
  var xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
       document.getElementById('subject_name').innerHTML=this.responseText;
    }
  };

  let school_name=document.getElementById("school_name").value;
  let class_name=document.getElementById("class_name").value;
  xhttp.open("GET", "scripts/select_class_subjects.php?school="+school_name+"&class="+class_name, true);
   xhttp.send();
}

