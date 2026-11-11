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
// not allow to use this file when mode=read in config file.
$school=$SCHOOL_NAME;
/* Roll No */
$roll_no=$_GET['roll_no'];
$roll_no=Validate_input($roll_no);
/* Subject  Name Marks Column */
$subject = $_GET['subject_name'];
$subject=Validate_input($subject);
/* Actual Subject  Name */
$actual_subject=$_GET['actual_subject'];
$actual_subject=Validate_input($actual_subject);
/* Subject Marks */
$marks=$_GET['marks'];
$marks=Validate_input($marks);
/* Class Name */
$class=$_GET['class_name'];
$class=Validate_input($class);
$update_Status=Check_Subject_Update_Lock_status($school, $class, $actual_subject);
if ($marks>100) {
    echo "Max Marks error";
    exit;
}
$q="UPDATE marks SET $subject = $marks WHERE Roll_No=$roll_no";
// Do this if lock=off, that means lock=0
// Singel Marks changes=allow means 1.
if ($SINGLE_MARKS_CHANGES==1 && $update_Status==0) {
    $exe=mysqli_query($link, $q) or die('error'.mysqli_error($link));
    if ($exe) {
        echo "<span class='alert alert-success' role='alert'> Marks Saved.
                </span>";
    } else {
        echo "<span class='alert alert-danger' role='alert'>
            Error in query
        </span>";
    } 
} else {
    echo "<span class='alert alert-danger' role='alert'>
        Marks are finalized.
        Changes Not allowed. OR No Permission</span>";
}

?>
