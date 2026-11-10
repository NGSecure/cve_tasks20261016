<?php
/**
 * Main Page of Subject Marks Page.
 * php version 8.1
 *
 * @category Management
 *
 * @package None
 *
 * @author Waqas <ahmad@waqaskanju.com>
 *
 * @license http://www.abc.com MIT
 *
 * @link Adfas
 **/
session_start();
 require_once 'sand_box.php';
 $link=$LINK;
 
 Page_header("Select Subject");
if ($SINGLE_MARKS_CHANGES=="0") {
    echo '<div class="bg-danger text-center"> Not allowed!! </div>';
    exit;
}
?>
</head>

  <body class="background">
  <?php require_once 'nav.html';?>
   <div class="container-fluid">
   <h3>Select a subject where you want to add marks. ( Current Selected School = 
        <?php echo $SCHOOL_NAME; ?> )
    </h3>
    <div class="row">
<?php
$school=$SCHOOL_NAME;
$classes_array=School_classes();
foreach ($classes_array as $class) {
    echo "<div class='col-3 bg-white m-2'>
        <h5 class='p-2'> Class $class Subjects </h5>";
    $subjects=Select_Subjects_Of_class($school, $class);
    for ($i=0; $i<count($subjects); $i++) {
         echo '<a href="update_one_subject_marks.php
         ?Class='.$class.'&Subject='.$subjects[$i]['Name'].'">'.
         $subjects[$i]['Name'].'</a> (';
        echo Subject_teacher($class, $subjects[$i]['Name']);
        echo " Sb) <br>";
    }
    echo "</div>";
}
?>

  </div>

 </div> <!-- End of main container -->
  <?php Page_close(); ?>
