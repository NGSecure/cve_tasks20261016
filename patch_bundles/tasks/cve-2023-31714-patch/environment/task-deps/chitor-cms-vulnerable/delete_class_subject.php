<?php
/**
 * Delete Subject From Class
 * php version 8.1
 *
 * @category Student
 *
 * @package None
 *
 * @author Waqas Ahmad <waqaskanju@gmail.com>
 *
 * @license http://www.waqaskanju.com/license MIT
 *
 * @link http://www.waqaskanju.com
 **/
session_start();
require_once 'sand_box.php';
$link=connect();

if ($SUBJECT_CHANGES!=1) {
    echo '<div class="bg-danger text-center"> Not allowed!! </div>';
     exit;
}
?>
<?php Page_header('Delete Class Subject'); ?>
</head>
<body> 
  <?php  require_once 'nav.html';?> 
  <div class="bg-warning text-center">
    <h4>Delete Subjects From Class</h4>
  </div>
  <div id="delete_result">
    </div>
    
    <aside class="float-end mt-3 p-3">
      <p>
        <a href="add_class_subject.php" class="btn btn-primary"> Add Subject</a>
      </p>
      <p>
      <a href="edit_class_subject.php" class="btn btn-warning"> Edit Subject</a>
      </p>
    </aside>
 
  <div class="container">
    <form action="#" method="GET" class="border border-primary p-3">
      <div class="row no-print">
        <?php
          $selected_class='';
          $selected_subject='';
          Select_class($selected_class);
          Select_subject($selected_subject);
        ?>
      </div>
      <div class="col-md-3">
        <button  class="btn btn-danger no-print mt-4" type="submit" name="submit">
          Delete
        </button>
    </form>
  </div>
  <div class="container mt-3">
  <h2 class="text-danger">
    Click on a subject and it will be deleted or use the above form
  </h2>
    <div class="row">
      
<?php
$school=$SCHOOL_NAME;
$classes_array=School_classes();
foreach ($classes_array as $class) {
    echo "<div class='col-4'>
        <h5> Class $class Subjects </h5>";
    $subjects=Select_Subjects_Of_class($school, $class);
    echo '<ul class="list-unstyled">';
    for ($i=0; $i<count($subjects); $i++) {
        echo "<li>";
        $subject_name=$subjects[$i]['Name'];
        $subject_name_with_quotes ="'$subject_name'";
        $class_name_with_quotes ="'$class'";
        $school_name_with_quotes="'$school'";
        $id="$subject_name$class";
        echo "<a href='javascript:void(0)' id='$id'
    onclick=\"delete_subject(
      $subject_name_with_quotes,$class_name_with_quotes,$school_name_with_quotes
      )\">
                $subject_name
              </a>";
        echo "</li>";

        
    }
    echo "</ul>";
    echo "</div>";
}
?>
  </div>
 </div> <!-- End of main container -->
 <script type="text/javascript" src="js/delete_subject.js"> </script>
<?php Page_close(); ?>

