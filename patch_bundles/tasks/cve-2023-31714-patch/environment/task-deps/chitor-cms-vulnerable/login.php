<?php
/**
 * Login Page.
 * php version 8.1
 *
 * @category Login
 *
 * @package None
 *
 * @author Waqas <waqas@waqaskanju.com>
 *
 * @license http://www.abc.com MIT
 *
 * @link Adfas
 **/

session_start();
require_once 'sand_box.php';
$link=$LINK;
Page_header('Search Students Detail');
?>

</head>
<body>
<div class="container-fluid">
<?php require_once 'nav.html';?>
  <div class="bg-warning text-center">
    <h4>Login Page</h4>
  </div>
</div>
<?php
if (isset($_POST['submit'])) {
    /* First letter of variable is in lower case */
    $username=$_POST['username'];
    $username=Validate_input($username);
    $password=$_POST['password'];
    $password= Validate_input($password);
    $password= md5($password);

    $q="SELECT  Employee_Id,User_Name,Password FROM login 
    WHERE User_Name='$username' AND Password='$password' AND
    Status='1'";

    $exe=mysqli_query($link, $q);

    if (mysqli_num_rows($exe)==1) {
        $exer=mysqli_fetch_assoc($exe);
        $employee_id=$exer['Employee_Id'];
        $_SESSION['user']=$employee_id;
        $msg="Login Successful";
        $msg_type="success";
        Show_alert($msg, $msg_type);
        echo "<a href='index.php'> Visit Index Page </a>";
    } else {
        echo "<p class='text-danger'>Incorrect User Name OR Password";
    }


}
?>
<div class="container">
  <form action="#" method="POST">

    <div>
      <label for="name">User Name*</label>
      <input type="text"  id="username" name="username" class="form-control"
             placeholder="Type User Name" required>
    <div>
    <div>
      <label for="name">Password*</label>
      <input type="password"  id="name" name="password" class="form-control"
             placeholder="Type Password" required>
    <div>
      <input type="submit" name="submit" value="Login" class="btn btn-primary mt-3">



</div>
  </form>
</div>

<?php
    Page_close();
?>
