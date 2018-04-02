<?php
/**
 * Created by PhpStorm.
 * User: Nick
 * Date: 3/4/2017
 * Time: 9:39 AM
 */
include ("/utilities/dbconnect.php");
$username = $_POST['username'];
$password = $_POST['password'];

$loginstatus = verify_web_login($username, $password);
if($loginstatus){
    $_SESSION['username'] = $username;
    header("Location: ../home.php");
}else{
    echo '<script> parent.badLogin(); </script>';
}
