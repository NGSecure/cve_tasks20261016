<?php
require 'sql/connect.php';
include 'layout/guest/header.htm';
echo "<div id='content'>";

if(isset($_GET['email']) && !empty($_GET['email']) AND isset($_GET['reghash']) && !empty($_GET['reghash'])){
    // Verify dataq
    $email = $_GET['email']; // Set email variable
    $hash = $_GET['reghash']; // Set hash variable
    
    $sql = "SELECT id from accounts WHERE email = '$email' AND reghash = '$hash' AND active = '0'";
    $result = $conn->query($sql);
    $num_rows = mysqli_num_rows($result);
    while($row = $result->fetch_assoc()) {
    	$userid = $row["id"];
    };
    
    
    if ($num_rows > 0) {
    	$sql = "UPDATE accounts SET active='1' WHERE email = '$email' AND reghash = '$hash' AND active='0'";
    	$result = $conn->query($sql);
    	echo "<br>";
    	echo '<h4>Your account has been activated, you can now login</h4>';
    }
	else{
        // No match -> invalid url or account has already been activated.
        echo "<br>";
        echo '<h4>The url is either invalid or you already have activated your account.</h4>';
    }
                 
}else{
    // Invalid approach
    echo '<div class="statusmsg">Invalid approach, please use the link that has been send to your email.</div>';
}
echo "</div>";
include "layout/guest/footer.htm";


?>