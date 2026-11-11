<?php
session_start();

require_once '../sand_box.php';
require_once '../db_connection.php';
$link=$LINK;

$user=$_SESSION['user'];
$user=Validate_input($user);
$q="SELECT Selected_School_Id, Selected_Class_Id from setting WHERE User_Id=$user";
$exe=mysqli_query($link, $q);
$exer=mysqli_fetch_assoc($exe);
$school_id=$exer['Selected_School_Id'];
$class_id=$exer['Selected_Class_Id'];

$school_name=Convert_School_Id_To_name($school_id);
$class_name=Convert_Class_Id_To_name($class_id);

$q2="SELECT Roll_No,Name,FName,Status from students_info WHERE 
    Class='$class_name' AND School='$school_name'";

$exe2=mysqli_query($link, $q2);
echo '<table class="table table-stripped table-hover">';
echo "<legend class='text-center'> 
            Date of School Name $school_name AND Class Name $class_name
     </legend>";
echo "<tr><th>Roll No</th><th>Name</th><th>Father Name</th><th>Status</th>
<th>Operation</th>";
while ($exer2=mysqli_fetch_assoc($exe2)) {

    $roll_no=$exer2['Roll_No'];
    $student_name=$exer2['Name'];
    $father_name=$exer2['FName'];
    $status=$exer2['Status'];
    $status=change_status_to_word($status);
    echo "<tr>
        <td> $roll_no </td>
        <td> $student_name </td>
        <td> $father_name </td>
        <td> $status </td>
        <td> <a href='edit_student.php?roll_no=$roll_no&submit=Search'>Edit </a>
        <a href='delete_student.php?roll_no=$roll_no'>Delete </a>
        
        </td>
      </tr>";
}
