<?php
/**
 * Created by PhpStorm.
 * User: Nick
 * Date: 3/6/2017
 * Time: 12:34 PM
 */
include ("dbconnect.php");
$prefix = $_POST['prefix'];
$fname = $_POST['fname'];
$lname = $_POST['lname'];
$username = $_POST['username'];
$password1 = $_POST['password1'];
$password2 = $_POST['password2'];

if(strlen($password1) < 8 || strcmp($password1, $password2) != 0 || preg_match('/^(?=[a-z])(?=[A-Z])[a-zA-Z]{8,}$/', $password)){
    $creationstatus = create_user($username, $password1, $fname, $lname);
    if($creationstatus){
        //TODO: success alert
    }else{
        //TODO: failure alert
    }
}
