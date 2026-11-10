<?php
/**
 * Add Subject Marks script file consumed by ajax
 * called from add_subject_marks.php file.
 *  * php version 8.1
 *
 * @category Exam
 *
 * @package None
 *
 * @author Waqas <waqaskanju@gmail.com>
 *
 * @license http://www.waqaskanju.com/license MIT
 *
 * @link http://www.waqaskanju.com
 **/
session_start();
require_once '../sand_box.php';
$link=$LINK;

/* Roll No */
$roll_no=$_GET['roll_no'];
$roll_no=Validate_input($roll_no);
/* Subject  Name Marks Column */
$class_name=$_GET['class_name'];
$class_name=Validate_input($class_name);


$q="UPDATE students_info SET Class='$class_name' WHERE Roll_No=$roll_no";

if ($STUDENT_CHANGES==1) {
    $exe=mysqli_query($link, $q) or die('error'.mysqli_error($link));
    if ($exe) {
        echo "<span class='alert alert-success' role='alert'> Class Name Updated.
                </span>";
    } else {
        echo "<span class='alert alert-danger' role='alert'>
            Error in query
        </span>";
    } 
} else {
    echo "
            <span class='alert alert-danger' role='alert'>
                No Permission For Changing in Student Module.
        </span>";
}
?>