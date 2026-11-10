<?php
  /**
   * Show Class data of Students
   * php version 8.1
   *
   * @category Adfsad
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
Page_header('Show Class');
$show_class="6th";
$show_school="GHSS Chitor";
$status="1";

if (isset($_GET['submit'])) {
  
    $show_class=$_GET['class_exam'];
    $show_class=Validate_input($show_class);

    $show_school=$_GET['school'];
    $show_school=Validate_input($show_school);
    $status=0;
}

if (isset($_GET['active'])) {

    $show_class=$_GET['class_exam'];
    $show_class=Validate_input($show_class);

    $show_school=$_GET['school'];
    $show_school=Validate_input($show_school);

    $status=1;
}


?>
</head>
<body>
<?php require_once 'nav.html';?>
  <div class="bg-warning text-center">
    <h4>Show Class Information</h4>
  </div>
  <?php // require_once 'nav.html' ?>
<div class="container-fluid">
        <form class="" action="#" method="GET">
          <div class="row">
          <?php
            $selected_class=$CLASS_NAME;
            $selected_school=$SCHOOL_NAME;
            Select_class($selected_class);
            Select_school($selected_school);
            ?>

          </div>
          <button type="submit" name="submit" value="all" class="btn btn-primary">
            Show Inactive Students
          </button>
          <button type="submit" name="active" value="active" class="btn btn-primary">
            Show Active Students
          </button>
        </form>
</div>
<div class="container">
  <div class="row">
      <div class="col-md-12 ">
        <table class="table" border="1">
          <caption style="caption-side: top">
            <h4>
              <?php echo "Showing Data of Class:$show_class School: $show_school";?>
            </h4>
          </caption>
          <tr>
          <td> Pictures </td>
            <td> Admission No </td>
            <td> Admission Date </td>
            <td> Roll No </td>
            <td> Name </td>
            <td> Father Name </td>
            <td> Dob </td>
            <td> Mobile No </td>
            <td> Father CNIC </td>
            <td> Class </td>
            <td> School</td>
          </tr>
            <?php
              $qs="Select * from students_info WHERE
                  Class='".$show_class."' AND
                  school='".$show_school."' AND
                  status='".$status."'
                  order by Roll_No ASC";
              $qr=mysqli_query($link, $qs)or die('error:'.mysqli_error($link));
            while ($qfa=mysqli_fetch_assoc($qr)) {
                echo  '<tr>
                <td>
                  <img class="img img-fluid"  src="pictures/'.$qfa['Roll_No'].'">
                </td>
                          <td>'.$qfa['Admission_No']. '</td>
                          <td>'.$qfa['Admission_Date']. '</td>
                          <td>'.$qfa['Roll_No']. '</td>
                          <td>'.$qfa['Name']. '</td>
                          <td>'.$qfa['FName']. '</td>
                          <td>'.$qfa['Dob']. '</td>
                          <td>'.$qfa['Mobile_No']. '</td>
                          <td>'.$qfa['Father_Cnic']. '</td>
                          <td>'.$qfa['Class'].'</td>
                          <td>'.$qfa['School']. '</td>
                          </td>
                        </tr>';
            }
            ?>
          </table>
        </div>
      </div>
  </div>

  <?php Page_close(); ?>
