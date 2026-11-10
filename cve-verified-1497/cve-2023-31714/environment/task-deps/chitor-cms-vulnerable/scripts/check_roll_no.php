<?php
/**
 * Check If Roll No Already Exists.
 * php version 8.1
 *
 * @category Exam
 * @package  Adf
 *
 * @author Waqas Ahmad <waqaskanju@gmail.com>
 *
 * @license http://www.abc.com MIT
 *
 * @link None
 **/
session_start();
require_once '../db_connection.php';
require_once '../functions.php';
$link=$LINK;


if (isset($_GET['roll_no'])) {
    $roll_no=$_GET['roll_no'];
    $roll_no=Validate_input($roll_no);

    if ($_GET['table']=='student') {
        $q="SELECT * from students_info WHERE Roll_No=".$roll_no;
        $qr=mysqli_query($link, $q) or die('Error'.mysqli_error($link));
        $total_rows=mysqli_num_rows($qr);
        if ($total_rows>0) {
            echo "Data already exists.";
        }
    }


    if ($_GET['table']=='marks') {
        if ($roll_no=="") {
            echo 'Type Roll No.';
            $roll_no=1;
        }
        $q="SELECT * from marks WHERE Roll_No=".$roll_no;
        $qr=mysqli_query($link, $q) or die('Error'.mysqli_error($link));
        $total_rows=mysqli_num_rows($qr);
        if ($total_rows>0) {
            echo "Data already exists.Try Editing.";
        }
    }
}
if (isset($_GET['admission_no'])) {
        $admission_no=$_GET['admission_no'];
        $admission_no=Validate_input($admission_no);
    $q="SELECT admission_no from students_info WHERE admission_no=$admission_no";
    $qr=mysqli_query($link, $q) or die('Error'.mysqli_error($link));
    $total_rows=mysqli_num_rows($qr);
    if ($total_rows>0) {
        echo "Duplicate Admission No";
    } else {
        echo "Looks Good";
    }
}
?>
