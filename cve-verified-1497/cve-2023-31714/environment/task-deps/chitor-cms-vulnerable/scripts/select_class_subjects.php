<?php
require_once '../sand_box.php';
require_once '../db_connection.php';
$link=$LINK;

$class_name=$_GET['class'];
$class_name=Validate_input($class_name);

$school_name=$_GET['school'];
$school_name=Validate_input($school_name);

$school_id=Convert_School_Name_To_id($school_name);
$class_id=Convert_Class_Name_To_id($class_name);
$q="SELECT Subject_Id from class_subjects WHERE 
School_Id=$school_id AND Class_Id=$class_id";
$exe=mysqli_query($link, $q) or die('error in  class selection');
while ($exer=mysqli_fetch_assoc($exe)) {
    $subject_id=$exer['Subject_Id'];
    $q2="Select Name from Subjects WHERE Id=$subject_id";
    $exe2=mysqli_query($link, $q2);
    while ($exer2=mysqli_fetch_assoc($exe2)) {
        $subject_name=$exer2['Name'];
        echo "<option value'$subject_name'>$subject_name</option>";
    }
}

?>    