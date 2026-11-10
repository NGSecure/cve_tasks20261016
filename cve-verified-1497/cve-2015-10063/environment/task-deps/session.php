<?php
session_start();
require('_sessioninfo.php');

/* 
* Use require('session.php')) if a page requires authentication.
*/

// If session is expired, go to login page
if (!isset($_SESSION['_user_session'])) {
    unset($_SESSION['err_message']);
    header("Location: login.php");
    exit();
    
} else if (isExpired()) {
    $_SESSION['err_message'] = "Session expired.";
    header("Location: login.php");
    unset($user_session);
    exit();
}

// Session is definitely valid if we're here. Refresh its expiry time.
updateActiveTime();

// Expose some useful functions for fellow programmers
function getUserName() {
	return $_SESSION['user_name'];
}
function getUserClass() {
	return $_SESSION['class'];
}
function getUserPersonID() {
	return $_SESSION['person_id'];
}

/**
 * Checks if the class is of the required type. If it isn't,
 * the requested page is not displayed.
 * 
 * $type is a string. If multiple user types are allowed to
 * view a page, just use multiple characters in the string
 * 
 * ex. requireUserClass('a');
 *     requireUserClass('adr');
 */
function requireUserClass($type) {
	if (strpos($type, getUserClass()) === FALSE) {
		header('HTTP/1.0 403 Forbidden');
		include('forbidden.html');
		exit;
	}
}

?>
