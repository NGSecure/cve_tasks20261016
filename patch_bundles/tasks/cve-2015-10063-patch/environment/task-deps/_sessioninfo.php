<?php
function isExpired() {
     return time() > getSessionExpiry();
}

function getSessionExpiry() {
    // Expire after 30 minutes inactivity, or 24 hours of activity.
    return min( $_SESSION['us_last_activity'] + 1800, $_SESSION['us_created_time'] + 86400 );
}
function updateActiveTime() {
    $_SESSION['us_last_activity'] = time();
}
?>