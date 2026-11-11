<?php
/**
 * Show the result of a class
 * php version 8.1
 *
 * @category Exam_Result
 * @package  None
 * @author   Waqas Ahmad <waqaskanju@gmail.com>
 *
 * @license http://www.abc.com MIT
 *
 * @link Adfas
 **/
  session_start();
  require_once 'sand_box.php';
  $link=$LINK;
  Page_header("Class Result")
?>
</head>
<body>
  <?php  require_once 'nav.html';?>
   <div class="bg-warning text-center no-print">
    <h4>Class Result</h4>
  </div>

<div class="container-fluid no-print">
    
  <form action="#" method="GET">
        <div class="row">
            <?php
            $class_name='6th';
            $school_name=$SCHOOL_NAME;
            Select_class($class_name);
            Select_school($school_name);?>
        </div>
        <button class="no-print btn btn-primary mt-2" type="submit"
        name="submit">
            Show Result
        </button>
  </form>
</div>
<?php
if (isset($_GET['submit'])) {
    $class_name=$_GET['class_exam'];
    $class_name=Validate_input($class_name);

    $school_name=$_GET['school'];
    $school_name=Validate_input($school_name);
    ?>
<!-- Page Header -->
<div class="container-fluid">
  <div class="row">
    <div class="col-sm-2">
      <img class="img-fluid" src="./images/khyber.png" alt="khyber">
    </div>
    <div class="text-center col-sm-8">
      <h3>GOVT. HIGHER SECONDARY SCHOOL </h3>
      <h3>  CHITOR, DISTRICT SWAT  </h3>
      <h5>
        Result of
          <?php
            // A message from config page.
            echo $class_result_header;
            ?>
      </h5>
             <h6>
            Date: <?php echo date('d-M-Y') ?>
            School Name: <?php echo $school_name ?>
            Class Name: <?php echo $class_name ?>
        </h6>
      </div>
      <div class="col-sm-2">
        <img class="img-fluid" src="./images/kpesed.png" alt="kpesed.png">
      </div>
    </div> <!--row end -->
  </div> <!--fluid end -->

<!-- Page Header End -->
      <?php
            // Initially Subject marks.
            $subject_total_marks=0;
            $all_subjects_total_marks=0;
            echo'
            <table class="table table-bordered">
            <thead>
            <tr>
            <th class="vertical"> S No </th>
            <th class="vertical"> Roll No </th>
            <th > Name </th>';

            $class_subjects=select_subjects_of_class($school_name, $class_name);
            // variable for marks selection query
            $subject_marks_selection_query="";
        for ($i=0;$i<count($class_subjects);$i++) {
            $subject=$class_subjects[$i]['Name'];
            $subject_total_marks=One_Subject_Total_marks(
                $school_name, $class_name, $subject
            );
            $all_subjects_total_marks=$all_subjects_total_marks
            +
            $subject_total_marks;
            echo "<th class='text-wrap'> $subject ($subject_total_marks)</th>";
            $subject_marks_selection_query = $subject_marks_selection_query.
            Change_Subject_To_Marks_col($subject).
            ',';
        }
            //echo $subject_marks_selection_query;
            echo'   <th class="text-wrap"> Total ('.$all_subjects_total_marks.')</th>
            <th> % </th>
            <th class="text-wrap"> Position </th>
            <th> Status </th>
        </tr></thead>';
            $qs="SELECT students_info.Roll_No, students_info.Name,
          $subject_marks_selection_query students_info.Class_Position
          FROM chitor_db.students_info JOIN chitor_db.marks
          ON chitor_db.students_info.Roll_No = chitor_db.marks.Roll_No
          WHERE students_info.Class='$class_name'
          AND students_info.School='$school_name' AND students_info.Status='1' 
          order by Roll_No ASC";
            $qr=mysqli_query($link, $qs) or die('error:'.mysqli_error($link));
            $sno=1;
            $fail=0;
            $pass=0;
        while ($qfa=mysqli_fetch_assoc($qr)) {
            echo  '<tbody><tr>
              <td>'.$sno. '</td>
                <td>'.$qfa['Roll_No']. '</td>
                <td>'.$qfa['Name']. '</td>';
            // Array to store all marks of a student
                $marks_array=[];
            for ($i=0;$i<count($class_subjects);$i++) {
                // Get the name of each subject
                    $subject=$class_subjects[$i]['Name'];
                // Change Subject Name to its corresponding Makrs Column in db
                    $marks_array[$i]=$qfa[Change_Subject_To_Marks_col($subject)];
                // Show Student Marks.
                // If marks=-1 show A (for absent)
                    echo  '<td>'.Show_absent($marks_array[$i]) .'</td>';
            }
            // initailly total=0 Its total marks of a student.
                $student_total=0;

            for ($j=0;$j<count($marks_array);$j++) {
                // As Absent are stored as -1 for total marks calculation ...
                // we need to convert -1 to 0
                $student_total=$student_total+Change_Absent_tozero(
                    $marks_array[$j]
                );
            }

            if ($all_subjects_total_marks==0) {
                echo "<div class='row'>";
                    echo "<div col-md-6 class='alert alert-danger' role='alert'>";
                        echo "Error Total Marks of Subjects=0, Add Total Marks";
                echo "</div>
                </div>";
                exit;
            }

            $percentage =($student_total*100)/$all_subjects_total_marks;
            $position=substr($qfa['Class_Position'], 0, 6);
            //find pass percentage of class.
            $pass_p_age=pass_percentage($class_name);
            $status=$percentage>=$pass_p_age ? "Pass" : "Fail";
            if ($status=="Fail") {
                $fail=$fail+1;
            } else {
                $pass=$pass+1;
            }
              echo  '<td>'. $student_total. '</td>
              <td>' . number_format($percentage, 1, '.', ' ') . '</td>
              <td>'. $position  .'</td>
              <td>'. $status  .'</td>
              </tr>';
                $sno++;
        
        }
        $total=$sno-1;
}
?>
    </table>
    <?php
    // To remove initail page load error. defaluts are given.
    if (!isset($fail)) {
          $fail=0;
          $pass=0;
          $total=1;
    }
    
    // without if($sno) condition.
    // when page load and it has no values of pass, fail etc.
    // so shown undefined error.
    if (isset($sno)) {
        if ($sno>1) {
            Exam_footer($class_name, $fail, $pass, $total);
        }
    }
    
    Page_close();
    ?>