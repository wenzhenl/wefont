<?php
$json = file_get_contents('php://input');
$obj = json_decode($json);

if($obj->image->content_type == "image/jpeg"){
  $filename = $obj->id . time() . ".jpg";
  $base = basename($filename, ".jpg");
  $base = "userImages/$base";
  $target_file = "userImages/$filename";
  $data = str_replace(' ', '+', $obj->image->file_data);
  $data = base64_decode($data);
  if(file_put_contents($target_file, $data)){
    $return_data = array("success"=>true, "message"=>"The photo has been uploaded.","url"=>"http://52.10.206.187/$base.pdf");
    exec("/usr/bin/convert $target_file $base.bmp");
    exec("/usr/bin/potrace -b pdf $base.bmp");
    echo json_encode($return_data);
  } else {
    $return_data = array("success"=>false, "message"=>"Sorry, there was an error uploading your photo.");
    echo json_encode($return_data);
  }
} else {
  $return_data = array("success"=>false,"message"=>"Not a JPEG image");
  echo json_encode($return_data);
} 

?>
