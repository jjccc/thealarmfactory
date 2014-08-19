$(document).ready(function(){
  
  $("form").submit(function(event){
    error = validate_alarm();
    if (error != null){
      show_error(error);
      event.preventDefault();
      return false;  
    }      
  });
  
});

function validate_alarm(){
  result = null; 
  if ($("#alarm_name").val() == ""){
    result = {message: "La alarma debe tener un nombre.", control: $("#alarm_name")};
  }
  else {
    if ($("#alarm_name").val().length > 250){
      result = {message: "El nombre no puede tener más de 250} caracteres.", control: $("#alarm_name")};
    }
    else {
      if ($("#alarm_description").val() != "" && $("#alarm_description").val().length > 600){
        result = {message: "La descripción no puede tener más de 600 caracteres.", control: $("#alarm_description")};
      }
    }
  }
  return result;    
};

function show_error(error){
  error.control.parent().addClass("has-error");
  error.control.select().focus(); 
  error_container = error.control.next();  
  error_container.html(error.message);  
  error_container.removeClass("hidden");
}
