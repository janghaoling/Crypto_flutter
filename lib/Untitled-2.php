<?php
include("dbconnect.php");
if ($_SERVER["REQUEST_METHOD"] == "POST") {
  $otp = $_POST['otp'];
  $sql = "select * from customers where email = '$email' limit 1";
  $result = $con->query($sql);
  $data = $result->fetch_assoc();

  if ($data['otp_code'] == $otp) {
    // database update 
    $sql = "update customers set otp_verify = true where email = '$email'";
    $con->query($sql);
    $loginObj = new stdClass();
    $loginObj->error = false;
    $loginObj->message = 'OTP successfully verified!';
    echo json_encode($loginObj);
  } else {
    $loginObj = new stdClass();
    $loginObj->error = true;
    $loginObj->message = 'OTP not correct!';
    echo json_encode($loginObj);
  }
}
