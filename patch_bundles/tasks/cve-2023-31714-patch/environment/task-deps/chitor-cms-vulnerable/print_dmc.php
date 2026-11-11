<?php
/**
 * Print DMC.
 * php version 8.1
 *
 * @category Student
 *
 * @package None
 *
 * @author Waqas Ahmad <waqas@waqaskanju.com>
 *
 * @license http://www.waqaskanju.com/license MIT
 *
 * @link http://www.waqaskanju.com/
 **/

require_once 'sand_box.php';
Page_header('Print DMC');
?>
</head>
<body class="background">
  <?php require_once 'nav.html';?>
  <div class="container-fluid">
    <div class="text-center bg-warning">
      <h4>Print DMC </h4>
      <p> Type Your Roll No To Print Single DMC  </p>
    </div>
    <form class="mt-3 p-3" action="dmc.php" target="_blank" method="GET">
      <div class="row bg-white p-3">
        <div class="col-sm-2">
          <label for="name" class="form-label">Type Roll No:</label>
      </div>
      <div class="col-sm-2 ">  
      <input type="number" class="form-control" id="rollno"
               name="rollno" placeholder="type Roll No" min="1" autofocus required>
      </div>
      <div class="col-sm-8 ">
      <button type="submit" name="submit" 
      class="btn btn-primary mt-4 mt-md-0" data-toggle="popover" 
      title="Popover title" data-content="And  some">
          Show DMC </button>
      </div>
    </div> <!-- End of Row-->
  </form>
</div>
<?php
Page_close();
?>


