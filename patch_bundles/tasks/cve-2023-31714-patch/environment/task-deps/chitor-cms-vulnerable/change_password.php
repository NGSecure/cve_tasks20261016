<?php
/**
 * Change Password
 * php version 8.1
 *
 * @category Management
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
$link=$LINK;
if (isset($_SESSION['user'])) {
    if (isset($_POST['submit'])) {

        $old_password=$_POST['old_password'];
        $old_password=Validate_input($old_password);
        $old_password=md5($old_password);

        $new_password=$_POST['new_password'];
        $new_password= Validate_input($new_password);
        $new_password= md5($new_password);

        $employee_id=$_SESSION['user'];
        $employee_id=Validate_input($employee_id);
        
        $q="SELECT  Password FROM login WHERE Employee_id='$employee_id'";
        $exe=mysqli_query($link, $q);
        $exer=mysqli_fetch_assoc($exe);
        $db_password=$exer['Password'];
        if ($old_password===$db_password) {

            $q2="Update Login SET Password='$new_password' WHERE
             Employee_Id='$employee_id'";
            $exe2=mysqli_query($link, $q2);
            if ($exe2) {
                echo "Password changed Successfully";
            }
        } else {
            echo "Invalid Old Password";
        }

    }

} else {

    header('refresh:1 ; url=login.php');
}
Page_header('Change Password');
?>

</head>
<body>
<div class="container">
  <form action="#" method="POST">

    <div>
      <label for="name">Old Password*</label>
      <input type="password"  id="old_password" name="old_password" 
      class="form-control"
             placeholder="Type Old Password" required>
    <div>
    <div>
      <label for="name">New Password*</label>
      <input type="password"  id="new_password" name="new_password" 
      class="form-control"
             placeholder="Type Password" required>
    <div>
      <input type="submit" name="submit" value="Change Password" 
      class="btn btn-primary mt-3">



</div>
  </form>
</div>

<?php
Page_close();

?>
