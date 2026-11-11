<?php

/**
 * Data base connection
 * php version 8.1
 *
 * @category Adfsad
 *
 * @package Adf
 *
 * @author Khan <abc@examp.com>
 *
 * @license http://www.abc.com MIT
 *
 * @link Adfas
 **/

/**
 * Use to connect with database.
 *
 * @return int database connection.
 **/
function connect()
{
    $link=mysqli_connect('localhost', 'root', '', 'chitor_db');
    if ($link) {
    } else {
                echo 'error in connection';
    }

    return $link;
}

$LINK=connect();

?>
