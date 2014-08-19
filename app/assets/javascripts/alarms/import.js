$(document)
  .on('change', '.btn-file :file', function() {
    var input = $(this),
    numFiles = input.get(0).files ? input.get(0).files.length : 1,
    label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
    input.trigger('fileselect', [numFiles, label]);
    
  $("form").submit(function(event){
    $(".has-error").removeClass("has-error");     
  });
  
});
    
$(document).ready( function() {
  $('.btn-file :file').on('fileselect', function(event, numFiles, label) {
    
    var input = $(this).parents('.input-group').find(':text'),
      log = numFiles > 1 ? numFiles + ' files selected' : label;
    
    if( input.length ) {
      input.val(log);
    } else {
      if( log ) alert(log);
    }
    
  });
  
  $("input[type='radio']").on("click", function(){
    var input = $(this);
    $("#import_value").prop("disabled", input.val() == "file");
    $("#import_file").prop("disabled", input.val() != "file"); 
    $(".has-error").removeClass("has-error");  
  });
  
  $("#import_value").prop("disabled", true);
});