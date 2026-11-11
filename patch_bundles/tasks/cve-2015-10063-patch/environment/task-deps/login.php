<?php
// Note: This page redirects back to /search.php if the
//       user has already logged in.

require('_login.php');

?>

<!DOCTYPE html>
<html>
    <head>
        <title>System Login</title>
        <link rel="stylesheet" href="loginpage.css">
    </head>
    <body>
        <div id="container">
            <form id="login" action="login.php" method="post">
                <div>   
                    <p class="header">System Login</p>
                    <?php echo "<p id=\"message\" class=\"$msg_class\">$message</p>"?>
                </div>
                <table>
                    <tr>
                        <td class="prompt_field">Username:</td>
                        <td class="field"><input type="text" name="user" /></td>
                    </tr>
                    <tr>
                        <td class="prompt_field">Password:</td>
                        <td class="field"><input type="password" name="pass" /></td>
                    </tr>
                    <div id="submit">
					<tr>
						<td/>
						<td>
							<input type="submit" name="login" value="Login"/>
						</td>
					</tr></div>
				</table>
            </form>
        </div>
    </body>
</html>
