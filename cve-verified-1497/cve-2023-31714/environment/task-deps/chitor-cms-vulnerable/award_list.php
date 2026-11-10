<?php
/**
 * Add New Students to LMS
 * php version 8.1
 *
 * @category Exam
 *
 * @package None
 *
 * @author Waqas Ahmad <waqaskanju@gmail.com>
 *
 * @license http://www.abc.com MIT
 *
 * @link award_list.php
 **/
session_start();
require_once 'sand_box.php';
$link=$LINK;
Page_Header('Award List');
?>
    </style>
    
</head>
<!-- <body onload="Load_class_subject()"> -->
  <body>
  <div class="container-fluid">
    <form action="#" method="GET" id="award-list-form" 
    onsubmit='Save_class_subject()'>
      <div class="row no-print">
        <?php
            $selected_class='';
            Select_school($SCHOOL_NAME);
            
            $selected_class='';
            Select_class($selected_class);

            $selected_subject='';
            Select_subject($selected_subject);
        ?>
      </div>
        <button class="no-print btn btn-primary mt-2" type="submit" name="submit">
          Submit
        </button>
    </form>
</div> <!-- End of container-->
<?php
if (isset($_GET['submit'])) {
    $class_name=$_GET['class_exam'];
    $class_name=str_replace('\'', '', $class_name);
    $class_name=Validate_input($class_name);

    $school_name=$_GET['school'];
    $school_name=str_replace('\'', '', $school_name);
    $school_name=Validate_input($school_name);

    $subject_name=$_GET['subject'];
    $subject_name=str_replace('\'', '', $subject_name);
    $subject_name=Validate_input($subject_name);
} else {
    $school_name='';
    $subject_name='Urdu';
    $teacher_name='';
    $class_name='6th';
}
?>
<div class="container-fluid">
  <?php require_once 'nav.html';?>
  <div class="row">
    <div class="col-sm-2">
      <img class="img-fluid" src="./images/khyber.png" alt="khyber">
    </div>
    <div class="text-center col-sm-8">
      <h3>GOVT. HIGHER SECONDARY SCHOOL </h3>
      <h3>  CHITOR, DISTRICT SWAT  </h3>
      <h5>
          <?php
            // A message from config page.
            echo $award_list_msg;
            ?>
      </h5>
      <h6>
        <?php echo "Class:".$class_name;  ?>
              Teacher: Mr.
            <?php
            if ($school_name=="GHSS Chitor") {
                 echo Subject_teacher($class_name, $subject_name);
            } else {
                echo "__________";
            }
            ?>
             Subject:  <?php echo $subject_name; ?>
        </h6>
        <h6>
            Date: <?php echo date('d-M-Y') ?>
            School Name: <?php echo $school_name ?>
        </h6>
      </div>
      <div class="col-sm-2">
        <img class="img-fluid" src="./images/kpesed.png" alt="kpesed.png">
      </div>
    </div> <!--row end -->
  </div> <!--fluid end -->
  <div class="container-fluid">
    <table class="table border border-dark" id="award-list">
      <thead>
        <tr class="border border-dark">
          <th class="border border-dark fw-bolder">S #</th>
          <th class="border border-dark fw-bolder">Roll #</th>
          <th class="border border-dark fw-bolder">Name</th>
          <th class="border border-dark fw-bolder">Father Name</th>
          <th class="border border-dark fw-bolder">Student <br> Signature</th>
          <th class="border border-dark fw-bolder">Marks</th>
          <th class="border border-dark fw-bolder" colspan="2">Marks in words</th>
        </tr>
      </thead>
      <tbody>
        <?php
        $q="Select * from students_info WHERE
            Class='$class_name'
            AND
            School='$school_name'
            AND
            Status='1' order by Roll_No ASC";
        $qr=mysqli_query($link, $q) or die('Error in Q 1'.mysqli_error($link));
        $i=1;
        while ($qfa=mysqli_fetch_assoc($qr)) {
                echo  '<tr>
                            <td class="border border-dark fw-bolder">'.$i. '</td>
                            <td class="border border-dark 
                            fw-bolder">'.$qfa['Roll_No'].'</td>
                            
                            <td class="border border-dark 
                            fw-bolder">'.$qfa['Name'].'</td>

                            <td class="border border-dark 
                            fw-bolder">'.$qfa['FName'].'</td>

                            <td class="border border-dark fw-bolder"></td>
                            <td class="border border-dark fw-bolder"></td>
                            <td class="border border-dark fw-bolder"></td>
                        </tr>';
            $i++;
        }
        ?>
        </tbody>
    </table>
    <div class="row m-t-1">
        <div class="col-sm-6">
            <p class="text-left sign">Controller of  Examination Signature </p>
            <p class="text-left m-t-1">___________________ </p>
        </div>
        <div class="col-sm-6">
            <p class="text-center  sign">Examiner Signature </p>
            <p class="text-center m-t-1">___________________ </p>
        </div>
    </div>
</div>  <!-- End of container -->
<script type='text/javascript' src='js/award_list.js'></script>
<?php Page_close(); ?>
