<?php
/**
 * Report of a class
 * php version 8.1
 *
 * @category Report
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
$school=$SCHOOL_NAME;
?>
<?php Page_header("Class Wise Report"); ?>
</head>
<body>
<div class="container-fluid no-print">
    <form action="#" method="GET" id="award-list-form">
      <div class="row">
        <?php
            $selected_class='';
            Select_class($selected_class);

            $selected_school=$SCHOOL_NAME;
            Select_school($selected_school);
        ?>
      </div>
        <button class="no-print btn btn-primary mt-2" type="submit" name="submit">
          Submit
        </button>
    </form>
</div> <!-- End of container-->
<h3 class="text-center"> <?php echo $class_wise_report_header;?> </h3>
<br>
<?php
if (isset($_GET['submit'])) {
     $school_name=$_GET['school'];
     $school_name=Validate_input($school_name);

     $class_name=$_GET['class_exam'];
     $class_name=Validate_input($class_name);
} else {
    $school_name=$SCHOOL_NAME;
    $class_name='6th';
}
$classes_array=School_classes();
//print_r($classes_array);
$class=$classes_array;

foreach ($classes_array as $class) {

    
    // Get Total Marks form Sandbox function.
    $total_marks=class_total_marks($school, $class);

    // Total Students
    $total_students=0;
    // NO of students appear in exam
    $present=0;
    // No of absent students
    $absent=0;
    // Sixty % and above
    $first_division=0;
    // from 50 till 59
    $second_division=0;
    // from 33% to 49%
    $third_division=0;
    // Pass studens;
    $pass=0;
    // Fail Studetns
    $fail=0;


    //query
    // Select all subject marks

    // check for -1 in all subject marks if -1 is more than 3 time increment absent.

    // change -1 to zero and add them.

    // find total marks and incrment division accordingly.
     $q="SELECT
          marks.English_Marks,
          marks.Urdu_Marks,
          marks.Maths_Marks,
          marks.Hpe_Marks,
          marks.Nazira_Marks,
          marks.Science_Marks,
          marks.Arabic_Marks,
          marks.Islamyat_Marks,
          marks.History_Marks,
          marks.Computer_Marks,
          marks.Mutalia_Marks,
          marks.Qirat_Marks,
          marks.Social_Marks,
          marks.Pashto_Marks,
          marks.Drawing_Marks,
          marks.Biology_Marks,
          marks.Chemistry_Marks,
          marks.Physics_Marks
		FROM chitor_db.students_info
		JOIN chitor_db.marks ON chitor_db.students_info.Roll_No = chitor_db.marks.Roll_No
        WHERE students_info.Class='$class_name'
        AND students_info.School='$school_name'";

    $exe=mysqli_query($link, $q) or die('error'.mysqli_error($link));
    $total_students=mysqli_num_rows($exe);
    while ($qfa=mysqli_fetch_assoc($exe)) {
        // for counting absent papers.
        $trails=0;
                  $english_marks = $qfa['English_Marks'];
                  $urdu_marks=$qfa['Urdu_Marks'];
                  $maths_marks=$qfa['Maths_Marks'];
                  $hpe_marks=$qfa['Hpe_Marks'];
                  $nazira_marks=$qfa['Nazira_Marks'];
                  $science_marks=$qfa['Science_Marks'];
                  $arabic_marks=$qfa['Arabic_Marks'];
                  $islamyat_marks=$qfa['Islamyat_Marks'];
                  $history_marks=$qfa['History_Marks'];
                  $computer_marks=$qfa['Computer_Marks'];
                  $mutalia_marks=$qfa['Mutalia_Marks'];
                  $qirat_marks=$qfa['Qirat_Marks'];
                  $social_marks=$qfa['Social_Marks'];
                  $pashto_marks=$qfa['Pashto_Marks'];
                  $drawing_marks=$qfa['Drawing_Marks'];
                  $biology_marks=$qfa['Biology_Marks'];
                  $chemistry_marks=$qfa['Chemistry_Marks'];
                  $physics_marks=$qfa['Physics_Marks'];

        if ($english_marks == -1) {
            $trails = $trails+1;
        }
        if ($urdu_marks == -1) {
            $trails = $trails+1;
        }
        if ($maths_marks == -1) {
            $trails = $trails+1;
        }
        if ($hpe_marks== -1) {
            $trails = $trails+1;
        }
        if ($nazira_marks == -1) {
            $trails = $trails+1;
        }
        if ($science_marks == -1) {
            $trails = $trails+1;
        }
        if ($arabic_marks == -1) {
            $trails = $trails+1;
        }
        if ($islamyat_marks == -1) {
            $trails = $trails+1;
        }
        if ($history_marks == -1) {
            $trails = $trails+1;
        }
        if ($computer_marks == -1) {
            $trails = $trails+1;
        }
        if ($mutalia_marks == -1) {
            $trails = $trails+1;
        }
        if ($qirat_marks == -1) {
            $trails = $trails+1;
        }
        if ($social_marks == -1) {
            $trails = $trails+1;
        }
        if ($pashto_marks == -1) {
            $trails = $trails+1;
        }
        if ($drawing_marks == -1) {
            $trails = $trails+1;
        }
        if ($biology_marks == -1) {
            $trails = $trails+1;
        }
        if ($chemistry_marks == -1) {
            $trails = $trails+1;
        }
        if ($physics_marks == -1) {
            $trails = $trails+1;
        }

        // for present absent

        if ($trails>3) {
            $absent = $absent+1;
        } else {
            $present = $present+1;
        }

        $student_total_marks = Change_Absent_tozero($english_marks) +
        Change_Absent_tozero($urdu_marks) +
        Change_Absent_tozero($maths_marks) +
        Change_Absent_tozero($hpe_marks) +
        Change_Absent_tozero($nazira_marks) +
        Change_Absent_tozero($science_marks) +
        Change_Absent_tozero($arabic_marks) +
        Change_Absent_tozero($islamyat_marks) +
        Change_Absent_tozero($history_marks) +
        Change_Absent_tozero($computer_marks) +
        Change_Absent_tozero($mutalia_marks) +
        Change_Absent_tozero($qirat_marks) +
        Change_Absent_tozero($social_marks) +
        Change_Absent_tozero($pashto_marks) +
        Change_Absent_tozero($drawing_marks) +
        Change_Absent_tozero($biology_marks) +
        Change_Absent_tozero($chemistry_marks) +
        Change_Absent_tozero($physics_marks);


        $percentage=$student_total_marks*100/$total_marks;
        if ($percentage>=60) {
            $first_division = $first_division+1;
        } else if ($percentage >=50 && $percentage<60) {
              $second_division = $second_division+1;
        } else if ($percentage>=30 && $percentage<50) {
              $third_division = $third_division+1;
        } else if ($percentage>=0 && $percentage<30) {
              $fail = $fail+1;
        }

    }
    ?>
<h3 class="text-center"> Report of Class 
    <?php echo $school_name; ?> 
    <?php echo $class; ?></h3>
    <table border="1">
        <tr>
            <td>Total Students</td>  <td> <?php echo $total_students; ?> </td>
            <td> Present</td> <td><?php echo $present;?></td>
            <td> Absent</td>  <td> <?php echo $absent; ?> </td>
        </tr>
        <tr>

            <td> Pass (30% and above)</td>  <td>
                <?php echo $first_division+$second_division+$third_division ?></td>
            <td> Fail (less then 30%)</td>  <td>
                <?php echo $fail ?> </td>
        </tr>
        <tr>
            <td>1st Division (60% - 100%)</td><td><?php echo $first_division ?></td>
            <td>2nd Division (50% - 59%)</td><td><?php echo $second_division ?></td>
            <td>3rd Division (30% - 49%)</td><td><?php echo $third_division ?></td>
        </tr>

    </table>
<br><br><br>
<?php } // end of for each?>

<?php Page_close(); ?>
