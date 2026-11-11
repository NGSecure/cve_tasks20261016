<?php
/**
 * Add New Students to LMS
 * php version 8.1
 *
 * @category Student
 *
 * @package Adf
 *
 * @author Waqas Ahmad <waqaskanju@gmail.com>
 *
 * @license http://www.abc.com MIT
 *
 * @link Adfas
 **/
session_start();
require_once 'sand_box.php';
$link=$LINK;
?>
<form action="#" method="GET">
<div class="form-row no-print">
<?php
  $selected_class='';
  Select_class($selected_class);
  Select_school($SCHOOL_NAME);?>
</div>
<button class="no-print" type="submit" name="submit" class="btn btn-primary">
  Submit
</button>

</form>
<?php
if (isset($_GET['submit'])) {
    $class_name=$_GET['class_exam'];
    $class_name=Validate_input($class_name);
    $class_name=str_replace('\'', '', $class_name);
} else {
    $class_name="6th";
}
Page_Header('Class wise age '.$class_name);
?>
</style>
</head>
<body>
<?php
if (isset($_GET['school'])) {
    $school_name=$_GET['school'];
    $school_name=Validate_input($school_name);
    $school_name=str_replace('\'', '', $school_name);
} else {
    $school_name ='GHSS CHITOR';
}

?>
<div class="container">
    <div class="row m-t-1">
        <div class="log col-sm-2">
            <img src="./images/khyber.png" alt="khyber">
        </div>
        <div class="header text-center col-sm-8">
        <h2>GOVT. HIGHER SECONDARY SCHOOL </h2>
        <h2 >  CHITOR, DISTRICT SWAT  </h2>
        <h5>
           Class Wise Age
            <?php echo $class_name;  ?>
        </h5>
        <!-- <h5> School Name:  <?php // echo $school_name; ?>  </h5>
        <h5>  Class: <?php // echo $class_name;  ?> </h5>-->
                     Date: <?php echo date('d-M-Y') ?>
       <!-- <h4>
        Final Examination Session 2021-2022 Class
        </h4>  -->
        </div>
        <div class="logo2 col-sm-2">
        <img src="./images/kpesed.png" alt="kpesed.png">
        </div>
    </div>
</div>

<div class="container">
    <table class="table table-bordered" id="award-list">
        <thead>
    <tr>
        <th>Serial No</th>
        <th>Admission No </th>
        <th>Roll No </th>
        <th>Name </th>
        <th>Father Name</th>
        <th>DoB</th>
        <th>Age</th>

    </tr>
    <thead>
        <?php
        $q="Select * from students_info WHERE
              Class='$class_name'
              AND
              School='$school_name'
              AND
              Status='1' order by Roll_No ASC";
        $qr=mysqli_query($link, $q) or die('Error in Q 1'.mysqli_error($link));
        $i=1;
        $student_ages=[];
        while ($qfa=mysqli_fetch_assoc($qr)) {
            $age = calculate_age($qfa['Dob']);
            $student_ages[$i]=$age;
                echo  '<tr>
                            <td>'.$i. '</td>
                            <td>'.$qfa['Admission_No'].'</td>
                            <td>'.$qfa['Roll_No'].'</td>
                            <td>'.$qfa['Name'].'</td>
                            <td>'.$qfa['FName'].'</td>
                            <td>'.$qfa['Dob'].'</td>
                            <td>'.$age.'</td>

                        </tr>';
            $i++;
        }

        ?>
    </table>
    <div class="row">
        <div class="col-sm-6">
    <p class="text-left  sign"> </p>
    <p class="text-left">

<table border="1" class="same-page">
    <tr> <th>  age </th> <th> No of Student </th> </tr>
<?php
$countvalue=array_count_values($student_ages);
foreach ($countvalue as $key => $value) {
      echo  '<tr> <td>'.$key."+</td><td> " . $value . "</td><tr>";
}
?>
</table>
 </p>
    </div>
    <div class="col-sm-6">
        <br><br><br><br><br>
        <p class="text-right  sign">Principal GHSS CHITOR </p>
        <p class="text-right">___________________ </p>
    </div>
    </div>
</div>


<?php Page_close(); ?>
