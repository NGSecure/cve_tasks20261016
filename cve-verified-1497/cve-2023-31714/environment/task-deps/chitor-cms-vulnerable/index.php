<?php
/**
 * Main Index page of CMS
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
Page_header("Home Page");
?>
</head>
<body class="background">
<div class="container-fluid">
  <section class="row">
      <h1 class="text-primary text-center">
        <strong class="col-sm-1">
          Welcome
          <?php echo $user_name ?>
          to
          <?php echo $SCHOOL_NAME?> Managment System
        </strong>
      </h1>
  </section>
  <section class="row">
    <div class="col-sm-4">
      <!-- Card 1 Started -->
      <div class="card mb-4">
        <div class="card-body">
          <h4 class="card-title"><i class="bi bi-person "></i> Student</h4>
          <p class="card-text">This section Contains Student Related Links</p>
          <aside class="row">
            <div class="col-3">
              <a href="add_student.php" class="btn btn-primary btn-lg mb-sm-0 mb-2">
               <i class="bi bi-person-plus"></i> Add
              </a>
            </div>
            <div class="col-3">
              <a href="edit_student.php"
              class="card-link btn btn-warning btn-lg mb-sm-0 mb-2">
              <i class="bi bi-pencil-square"></i> Edit
              </a>
            </div>
            <div class="col-3">
              <a href="delete_student.php"
              class="card-link btn btn-danger btn-lg mb-sm-0 mb-2">
               <i class="bi bi-trash"></i> Delete
              </a>
            </div>
            <div class="col-3">
              <a href="detail_student.php" class="card-link btn btn-success btn-lg
              mb-sm-0 mb-2">
              <i class="bi bi-search"></i> Search
              </a>
            </div>
          </aside>
        </div>
      </div>
      <!-- Card 1 Ended -->
      </div>
    <div class="col-sm-4 mb-4 mb-md-0">
      <!-- Card 2 Started -->
      <div class="card">
        <div class="card-body">
          <h4 class="card-title"><i class="bi bi-journal-text"></i> Examination</h4>
          <p class="card-text">This section Contains exam related links</p>
          <aside class="row">
            <div class="col-4">
              <a href="subject_link.php" class="btn btn-primary btn-lg mb-sm-0 mb-2">
              <i class="bi bi-file-plus"></i> Add Marks
              </a>
            </div>
            <div class="col-4">
              <a href="add_all_subjects_marks.php"
                  class="card-link btn btn-success btn-lg mb-sm-0 mb-2">
                  <i class="bi bi-plus-circle-dotted"></i> Batch Add
              </a>
            </div>
            <div class="col-4">
              <a href="update_all_subjects_marks.php"
                  class="card-link btn btn-warning btn-lg mb-sm-0 mb-2">
                  <i class="bi bi-credit-card"></i> Batch Edit
              </a>
            </div>
          </aside>  <!-- Card Button Placment Row -->
        </div> <!-- Card body -->
      </div> <!-- Card 2 End -->
    </div> <!-- col-sm-4 -->
    <div class="col-sm-4 mb-4 mb-md-0">
       <!-- Card 3 Started -->
      <div class="card">
        <div class="card-body">
          <h4 class="card-title"><i class="bi bi-lightning"></i> Result</h4>
          <p class="card-text">This section contains result related links</p>
          <aside class="row">
            <div class="col-4">
              <a href="class_result.php" class="btn btn-primary btn-lg mb-sm-0 mb-2">
              <i class="bi bi-people"></i> Class Result
              </a>
            </div>
            <div class="col-4">
              <a href="print_dmc.php"
                 class="card-link btn btn-warning btn-lg mb-sm-0 mb-2">
                 <i class="bi bi-printer"></i> Print DMC
              </a>
            </div>
            <div class="col-4">
              <a href="calculate_position.php"
                 class="card-link btn btn-danger btn-lg mb-sm-0 mb-2">
                 <i class="bi bi-signpost-split"></i> Add Position
              </a>
            </div>
          </aside>  <!-- Card Button Placment Row -->
        </div> <!-- Card body -->
      </div> <!-- Card 3 ended -->
    </div> <!-- col-sm-4 -->
  </section><!-- end of 1st row -->
  <!--2nd Row started -->
  <section class="row">
    <div class="col-sm-4 mb-4 mb-md-0">
      <!-- Card 4 Started -->
      <div class="card mb-4">
        <div class="card-body">
          <h4 class="card-title"><i class="bi bi-person-square"></i> User</h4>
          <p class="card-text">This section Contains User Related Links</p>
          <aside class="row">
            <div class="col-3">
              <a href="login.php" class="btn btn-primary btn-lg mb-sm-0 mb-2">
              <i class="bi bi-door-open"></i> Login
              </a>
            </div>
            <div class="col-3">
              <a href="logout.php" class="card-link btn btn-warning btn-lg
              mb-sm-0 mb-2">
              <i class="bi bi-door-closed"></i> Logout
              </a>
            </div>
            <div class="col-3">
              <a href="change_password.php" class="card-link btn btn-danger
              btn-lg mb-sm-0 mb-2">
              <i class="bi bi-shield-plus"> </i> Change
              </a>
            </div>
            <div class="col-3">
              <a href="setting.php" class="card-link btn btn-success btn-lg
              mb-sm-0 mb-2">
              <i class="bi bi-wrench"></i> Setting
              </a>
            </div>
          </aside>
        </div>
      </div>
      <!-- Card 4 Ended -->
      </div>
    <div class="col-sm-4 mb-4 mb-md-0">
      <!-- Card 2 Started -->
      <div class="card">
        <div class="card-body">
          <h4 class="card-title"><i class="bi bi-award"></i> Report</h4>
          <p class="card-text">This section Contains exam related Report</p>
          <aside class="row">
            <div class="col-4">
              <a href="subject_wise_report.php" class="btn btn-primary btn-lg
              mb-sm-0 mb-2">
              <i class="bi bi-pie-chart"></i> Subject wise
              </a>
            </div>
            <div class="col-4">
              <a href="class_wise_report.php"
                  class="card-link btn btn-success btn-lg mb-sm-0 mb-2">
                  <i class="bi bi-flag"></i> Class wise
              </a>
            </div>
            <div class="col-4">
              <a href="class_wise_age.php"
                  class="card-link btn btn-warning btn-lg mb-sm-0 mb-2">
                  <i class="bi bi-translate"></i> Age wise
              </a>
            </div>
          </aside>  <!-- Card Button Placment Row -->
        </div> <!-- Card body -->
      </div> <!-- Card 5 End -->
    </div> <!-- col-sm-4 -->
    <div class="col-sm-4 mb-4 mb-md-0">
       <!-- Card 6 Started -->
      <div class="card">
        <div class="card-body">
          <h4 class="card-title"><i class="bi bi-building"></i> Class's Subject</h4>
          <p class="card-text">This section contains subject related links</p>
          <aside class="row">
            <div class="col-3">
              <a href="add_class_subject.php" class="btn btn-primary btn-lg
              mb-sm-0 mb-2">
              <i class="bi bi-node-plus"></i> Add
              </a>
            </div>
            <div class="col-3">
              <a href="assign_subject.php"
                 class="card-link btn btn-warning btn-lg mb-sm-0 mb-2">
                 <i class="bi bi-emoji-sunglasses"></i> Assign
              </a>
            </div>
            <div class="col-3">
              <a href="view_lock_subjects.php"
                  class="card-link btn btn-success btn-lg mb-sm-0 mb-2">
                  <i class="bi bi-lock"></i> Lock
              </a>
            </div>
            <div class="col-3">
              <a href="delete_class_subject.php"
                 class="card-link btn btn-danger btn-lg mb-sm-0 mb-2">
                 <i class="bi bi-calendar-x"></i> Delete
              </a>
            </div>
          </aside>  <!-- Card Button Placment Row -->
        </div> <!-- Card body -->
      </div> <!-- Card 6 ended -->
    </div> <!-- col-sm-4 -->
  </section><!-- end of 2st row -->
  <!-- 2nd Row ended -->
  <!-- 3rd Row Started -->
  <section class="row">
    <div class="col-sm-4 mb-4 mb-md-0">
      <!-- Card 7 Started -->
      <div class="card mb-4">
        <div class="card-body">
          <h4 class="card-title"><i class="bi bi-card-checklist"></i> Lists</h4>
          <p class="card-text">This section Contains Student list links</p>
          <aside class="row">
            <div class="col-3">
              <a href="award_list.php" class="btn btn-primary btn-lg mb-sm-0 mb-2">
              <i class="bi bi-calendar2-range"></i> Award List
              </a>
            </div>
            <div class="col-3">
              <a href="book_list.php" class="card-link btn btn-warning btn-lg
              mb-sm-0 mb-2">
               <i class="bi bi-book"> </i> Book List
              </a>
            </div>
            <div class="col-3">
              <a href="class_test.php" class="card-link btn btn-danger btn-lg
              mb-sm-0 mb-2">
              <i class="bi bi-emoji-wink"></i> Test List
              </a>
            </div>
            <div class="col-3">
              <a href="roll_no_slip.php" class="card-link btn btn-success btn-lg
              mb-sm-0 mb-2">
              <i class="bi bi-clipboard-check"></i> RollNo Slip
              </a>
            </div>
          </aside>
        </div>
      </div>
      <!-- Card 7 Ended -->
      </div>
    <div class="col-sm-4 mb-4 mb-md-0">
      <!-- Card 8 Started -->
      <div class="card">
        <div class="card-body">
          <h4 class="card-title"><i class="bi bi-tablet"></i> Site</h4>
          <p class="card-text">This section Contains site related links</p>
          <aside class="row">
            <div class="col-4">
              <a href="site_map.php" class="btn btn-primary btn-lg mb-sm-0 mb-2">
              <i class="bi bi-map"></i> All website Links
              </a>
            </div>
            <div class="col-4">
              <a href="empty_position_column.php"
                  class="card-link btn btn-success btn-lg mb-sm-0 mb-2">
                  <i class="bi bi-funnel"></i> Empty Position Col
              </a>
            </div>
            <div class="col-4">
              <a href="update_student_class.php"
                  class="card-link btn btn-warning btn-lg mb-sm-0 mb-2">
                  <i class="bi bi-arrow-left-right"></i> Std Class Change
              </a>
            </div>

          </aside>  <!-- Card Button Placment Row -->
        </div> <!-- Card body -->
      </div> <!-- Card 8 End -->
    </div> <!-- col-sm-4 -->
    <div class="col-sm-4 mb-4 mb-md-0">
       <!-- Card 3 Started -->
      <div class="card">
        <div class="card-body">
          <h4 class="card-title"><i class="bi bi-diagram-2"></i> Seating</h4>
          <p class="card-text">This section contains Seating related links</p>
          <aside class="row">
            <div class="col-4">
              <a href="seating_plan.php" class="btn btn-primary btn-lg mb-sm-0 mb-2">
              <i class="bi bi-flower1"></i> Seating PlanA
              </a>
            </div>
            <div class="col-4">
              <a href="seating_plan_B.php"
                 class="card-link btn btn-warning btn-lg mb-sm-0 mb-2">
                 <i class="bi bi-flower2"></i> Seating PlanB
              </a>
            </div>
            <div class="col-4">
              <a href="test_pictures.php"
                 class="card-link btn btn-danger btn-lg mb-sm-0 mb-2">
                 <i class="bi bi-file-image"></i>Student Images
              </a>
            </div>
          </aside>  <!-- Card Button Placment Row -->
        </div> <!-- Card body -->
      </div> <!-- Card 3 ended -->
    </div> <!-- col-sm-4 -->
  </section><!-- end of 1st row -->
  <!-- 3rd Row ended -->
   <!-- 4rd Row Started -->
   <section class="row">
    <div class="col-sm-4 mb-4 mb-md-0">
      <!-- Card 10 Started -->
      <div class="card">
        <div class="card-body">
          <h4 class="card-title"><i class="bi bi-menu-button-wide"></i> School</h4>
          <p class="card-text">This section Contains School list links</p>
          <aside class="row">
            <div class="col-3">
              <a href="add_school.php" class="btn btn-primary btn-lg mb-sm-0 mb-2">
              <i class="bi bi-paint-bucket"></i> Add School
              </a>
            </div>
            <div class="col-3">
              <a href="add_school_class.php" class="card-link btn btn-warning btn-lg
              mb-sm-0 mb-2">
              <i class="bi bi-clipboard2-plus"></i> Add Class
              </a>
            </div>
            <div class="col-3">
              <a href="comming_soon.html" class="card-link btn btn-danger btn-lg
              mb-sm-0 mb-2">
              <i class="bi bi-plus-circle"></i> New Dev
              </a>
            </div>
            <div class="col-3">
            <?php  echo "<a href='./print' 
                            class='btn btn-success btn-lg mb-sm-0 mb-2'>"; ?>
              <i class="bi bi-file-earmark"></i> Print Doc
              </a>
            </div>
          </aside>
        </div>
      </div>
      <!-- Card 10 Ended -->
      </div>
    <div class="col-sm-4 mb-4 mb-md-0">
      <!-- Card 11 Started -->
      <div class="card">
        <div class="card-body">
          <h4 class="card-title"><i class="bi bi-bezier"></i> Student Data</h4>
          <p class="card-text">This section Contains student data related links</p>
          <aside class="row">
            <div class="col-4">
              <a href="show_students_data.php" 
                 class="btn btn-primary btn-lg mb-sm-0 mb-2">
              <i class="bi bi-bookshelf"></i> Show Class Data
              </a>
            </div>
            <div class="col-4">
              <a href="mass_roll_no_change.php"
                  class="card-link btn btn-success btn-lg mb-sm-0 mb-2">
                  <i class="bi bi-box-seam"></i> Update Mass Roll No
              </a>
            </div>
            <div class="col-4">
              <a href="add_roll_no_to_marks.php"
                  class="card-link btn btn-warning btn-lg mb-sm-0 mb-2">
                  <i class="bi bi-bricks"></i> RollNo To Marks
              </a>
            </div>

          </aside>  <!-- Card Button Placment Row -->
        </div> <!-- Card body -->
      </div> <!-- Card 11 End -->
    </div> <!-- col-sm-4 -->
    <div class="col-sm-4 mb-4 mb-md-0">
       <!-- Card 12 Started -->
      <div class="card">
        <div class="card-body">
          <h4 class="card-title"><i class="bi bi-alarm"></i> Time Table</h4>
          <p class="card-text">This section contains Time Table related links</p>
          <aside class="row">
            <div class="col-4">
            <?php  echo "<a href='./timetable/Time_Table_Teachers.html' 
                            class='btn btn-primary btn-lg mb-sm-0 mb-2'>"; ?>
              <i class="bi bi-calendar2-week"></i> Tutor Time Table
              </a>
            </div>
            <div class="col-4">
              <a href="./timetable/Time_Table_Classes.html"
                 class="card-link btn btn-warning btn-lg mb-sm-0 mb-2">
                 <i class="bi bi-hourglass"></i> Class Time Table
              </a>
            </div>
            <div class="col-4">
              <a href="./timetable/Time_Table_Vacant.html"
                 class="card-link btn btn-danger btn-lg mb-sm-0 mb-2">
                 <i class="bi bi-arrow-through-heart"></i> Vacant Time Table
              </a>
            </div>
          </aside>  <!-- Card Button Placment Row -->
        </div> <!-- Card body -->
      </div> <!-- Card 12 ended -->
    </div> <!-- col-sm-4 -->
  </section><!-- end of 4th row -->
  <!-- 4rd Row ended -->
      </div>  <!-- end container Fluid -->
<?php Page_close(); ?>







