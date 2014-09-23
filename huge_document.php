<?php
$path = "template/20_20_2500_template.pdf";
header("Content-Disposition: attachment; filename=template.pdf");
header("Content-type: application/pdf");
readfile($path);
?>
