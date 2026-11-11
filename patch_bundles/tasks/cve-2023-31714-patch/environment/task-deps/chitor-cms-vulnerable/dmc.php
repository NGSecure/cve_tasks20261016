<?php

/**
 * Print DMC.
 * php version 8.1
 *
 * @category DMC
 *
 * @package None
 *
 * @author Waqas Ahmad <waqas@waqaskanju.com>
 *
 * @license http://www.waqaskanju.com/license MIT
 *
 * @link http://www.waqaskanju.com/
 **/
session_start();
require_once 'sand_box.php';
$link=$LINK;


if (isset($_GET['rollno'])) {
    // Get Roll No from print_dmc.php page.
    $rollno=$_GET['rollno'];
    $rollno=Validate_input($rollno);
    // Select detail of Student based on Roll No.
    $q="SELECT Roll_No,Name,FName,Class,School,Class_Position FROM students_info
    WHERE Roll_No=".$rollno;
    $qr=mysqli_query($link, $q) or die('Error:'. mysqli_error($link));
    $qra=mysqli_fetch_assoc($qr);

    $Roll_No = $qra['Roll_No'];
    $Name = $qra['Name'];
    $Father_Name = $qra['FName'];
    $Class_Name = $qra['Class'];
    $current_class = $Class_Name;
    $School_Name = $qra['School'];
    $Class_Position = $qra['Class_Position'];
    $Serial_No= Select_Column_data("marks", "Serial_No", "Roll_No", $Roll_No);
} else {
    echo "Please Enter Roll No";
    exit;
}
?>

<?php  Page_header('DMC of '. $Roll_No .' '.$Name); ?>
</head>
<body>
<?php require_once 'nav.html'; ?>
<div class="container border border-primary">
  <div class="container  m-t-1">
    <div class="row">
      <div class="col-2 ">
        <img src="images/khyber.png"
              class="img img-fluid"
              alt="khyberlogo"
              height="auto" >
      </div>
      <div class="col-8">
        <h3 class="text-center text-uppercase">
          Government Higher Secondary School
        </h3>
        <h3 class="text-center text-uppercase">Chitor Swat </h3>
        <h4 class="text-center">Detailed Marks Sheet</h4>
      </div>
      <div class="col-2">
        <img src="images/kpesed.png"
             alt="booklogo"
             height="auto"
             class="img img-fluid"
             >
      </div>
    </div>
  </div>


  <div class="container mt-5">
    <div class="row">
      <div class="col-8">
      </div>
      <div class="col-3 text-right">
        <p class="font-weight-bold text-danger">
            Serial No
          <?php echo $Serial_No['Serial_No']; ?>
        </p>
      </div>
      <div class="col-md-1">
        <!-- Empty -->
      </div>
    </div>
  </div>

    <div class="container">
      <div class="row">
        <div class="col-8">
          <table class="table">
            <tr class="row-height">
              <td>
                <span class="font-weight-bold"> Name </span> </td>
              <td> <?php echo $Name;  ?> </td>
            </tr>
            <tr class="row-height">
              <td>
                <span class="font-weight-bold"> Father's Name </span>
              </td>
                <td> <?php echo $Father_Name;  ?></td>
            </tr>
            <tr class="row-height">
              <td>
                <span class="font-weight-bold"> School </span> </td>
                <td><?php echo $School_Name;?> </td>
            </tr>
        </table>
        </div>
        <div class="col-4">
            <center class="float-center">
              <img src="pictures/<?php echo $rollno ?>.png"
                  class="img-fluid; max-width:50%; height: auto; img-thumbnail"
                  width="200"
                  height="200">
            </center>
        </div>
      </div> <!-- Row of Naming and Picture -->
    </div> <!-- Naming information-->

<center>
  <div class="container" style="margin-top:50px">
    <div class="row">
      <div class="col-md-12">
        <table class="table table-bordered print-center">
          <tr> <th>Roll No</th> <td> <?php echo $Roll_No;  ?>  </td>
               <th>Class</th> <td> <?php echo $Class_Name;  ?>  </td>
               <th>Session</th> <td><?php echo  date('Y')-1 . "-" ;
                echo date('Y');?>  </td>
        </tr>
        </table>
    </div>
  </div> 
</center>


  <div class="container">
    <div class="row">
      <div class="col-md-12">
        <table class="table table-bordered print-center">
          <thead>
            <tr>
              <th>
                Subjects
              </th>
              <th>
                Total Marks
              </th>
              <th>
                Marks
              </th>

              <th>
                Remarks
              </th>
            </tr>
          </thead>
        <tbody>
          <tr>
      <?php
              // Initially Students marks are Zero.
              $student_obtain_marks=0;
              // Select all subjects of a class.
              $school_name=$School_Name;
              $subjects=Select_Subjects_Of_class($school_name, $Class_Name);
              // Loop throught all subjects.
        for ($i=0; $i<count($subjects); $i++) {
            $subject_name=$subjects[$i]['Name'];
            // Select total marks of a subject.
            $subject_total_marks=One_Subject_Total_marks(
                $school_name, $Class_Name, $subject_name
            );
            echo "<td>".$subject_name."</td>
                    <td>".$subject_total_marks."</td>";
            // As subject name and marks column of subject are
            // different coverversion required.
            $column_name=Change_Subject_To_Marks_col($subject_name);
            // Select Marks of a subject and a student.
            $subject_marks=Select_Column_data(
                "marks", $column_name, "Roll_No", $Roll_No
            );
            // Marks of a subjects of a student.
            $current_marks=$subject_marks[$column_name];
            // As -1 is stored for Absent for total marks -1 is change to 0.
            $student_obtain_marks=$student_obtain_marks+Change_Absent_tozero($current_marks);
            // -1 will be Shown As A=Absent.
            echo "<td>".Show_absent($current_marks)."</td>";
            $subject_percentage=(Change_Absent_tozero($current_marks)*100)/$subject_total_marks;
            $Remarks="";
            if ($subject_percentage<33) {
                $Remarks ="<span class=' text-danger fs-5'>Fail</span>";
            }
                  echo  "<td>".$Remarks."</td>
                      </tr>";
        }


                // Initiall value
        $All_Subjects_Total_Marks=-1;

        $All_Subjects_Total_Marks=Class_Total_marks($school_name, $Class_Name);
        if ($All_Subjects_Total_Marks==0) {
            echo "<div class='text-danger'>
                    All Subject Total Marks=0.. Add Subjects. 
                    <a href='add_class_subject.php'> Add Subject </a>
                  </div>";
            exit;
        }

        $Percentage=round(($student_obtain_marks*100)/$All_Subjects_Total_Marks, 2);

        ?>


                <!-- Total_Marks =  Class All Subjects Total Marks -->
                <tr>
                  <td>Total</td>
                  <td> <?php echo $All_Subjects_Total_Marks;  ?></td>
                  <td> <?php echo $student_obtain_marks  ?></td>
                  <td> 
                    <?php 
                    if ((($student_obtain_marks*100)/$All_Subjects_Total_Marks)<=pass_percentage($Class_Name)) {
                            echo "<span class=' text-danger fs-5'>Status Fail</span>";
                    } else {
                              echo "<span class=' text-success fs-5'>Status Pass</span>";
                    }
                    ?>
              </td>
              </tr>
            </tbody>
          </table>


          <table class="table table-bordered print-center mt-5">
            <tr>
                  <td>
                    <span class="font-weight-bold">Percentage </span>
                  </td>
                  <td> <?php echo $Percentage;  ?> </td>
                  <td>
                    <span class="font-weight-bold"> Class Position </span>
                  </td>
                  <td> <?php echo $Class_Position;  ?> </td>
            </tr>
          </table>
        </div>
</div>
</div>



<div class="container m-b-4">
<div class="row m-t-1 mb-5">
        <div class="col-sm-6">
            <p class="text-left sign">Controller of  Examination</p>
            <p class="text-left m-t-1">___________________ </p>
        </div>
        <div class="col-sm-6">
            <p class="text-center  sign">Checked By</p>
            <p class="text-center m-t-1">___________________ </p>
        </div>
    </div>   

  </div>

</div> <!--Overall container -->
<?php Page_close(); ?>
