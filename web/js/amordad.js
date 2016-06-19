function validate() {

  var files = document.getElementById("cv_load").files;

  // if no file has been selected, give warning
  if(files.length == 0) {
    $('#alert_placeholder').html ('<div class="alert alert-danger"><a href="#"'
                  + 'class="close" data-dismiss="alert">'
                  + '&times;</a><strong>Error!</strong>'
                  + ' No file has been selected!</div>');

    return;
  }

  var valid = 1;
  // check to make sure every query is cv file
  for(var i = 0; i < files.length; i++) {
    var extension = files[i].name.split('.').pop();
    // warning when the query is not cv file
    if(extension != "cv") {
      $('#alert_placeholder').html ('<div class="alert alert-danger">'
        + '<a href="#" class="close" data-dismiss="alert">&times;</a>'
        + '<strong>Error! <del>' + files[i].name + '</del></strong>'
        + ' is not allowed, please send <strong>cv</strong> files!</div>');
      valid = 0;
      break;
    }
  }

  // when all the queries are legal, congratulations
  if(valid == 1) {
    $('#alert_placeholder').html ('<div class="alert alert-success">'
    + '<a href="#" class="close" data-dismiss="alert">&times;</a>'
    + '<strong>Success!</strong>'
    + ' Your queries have been successfully submitted!</div>'); 
    var form = document.getElementById("uploadBox");
    form.submit();
  }
}

$("document").ready(function(){
  $('#cv_load').change(function() {
  var files = this.files;
  var files_table_html = '<table class="table table-striped table-bordered '
              + 'table-condensed"><thead><tr><th>selected file(s)'
              + '</th></tr></thead><tbody>';
  for(var i = 0; i < files.length; i++) {
   files_table_html += '<tr><td>' + files[i].name + '</td></tr>';
  }

  files_table_html += '</tbody></table>';
  $('#selected_files').html(files_table_html);
 });
});
