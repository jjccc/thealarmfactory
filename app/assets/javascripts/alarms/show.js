$(document).ready(function(){
  $.pnotify.defaults.delay = 4000;
  $.pnotify.defaults.styling = "bootstrap";
  
  // Handler del link de la advertencia de que no hay receptores definidos
  $("#add-receiver-link").on("click", function(){    
    $("#alarm-tab-ul a:last").tab("show");
    $("#add-receiver-button").click();
    $("#receiver_name").focus();
  });
  
  // Handler de cada uno de los botones de los operadores en la pestaña de edición de la condición
  $("a[id^='operator-']").each(function(){
    $(this).on("click", function(){
      // Escribe en el edit box el símbolo seleccionado
      $("#alarm_condition").val($("#alarm_condition").val() + " " + htmlDecode($(this).html()));      
      $("#alarm_condition").focus();
      return false;
    });
  });
  
  // Si la alarma no tiene muestras se hace visible el formulario de nueva muestra
  if (gon.samples == 0){
    $("#add-sample-button").click();  
  }  
  
  // Si la alarma no tiene receptores se hace visible el formulario de nueva receptor
  if (gon.receivers == 0){
    $("#add-receiver-button").click();
  }
  
  bind_receivers_buttons();   
  bind_samples_buttons(); 
  bind_notifications_buttons();
  bind_import_button();  
});

function hide_add_receiver_form(){
  $("#new_receiver").remove();
  $("#add-receiver-form").addClass("hide");
  $("#add-receiver-container").html('<div id="new-receiver-placeholder"></div>');  
  $("#add-receiver-button-container").removeClass("hide");
} 

function hide_add_sample_form(){
  $("#new_sample").remove();
  $("#add-sample-form").addClass("hide");
  $("#add-sample-container").html('<div id="new-sample-placeholder"></div>');  
  $("#add-sample-button-container").removeClass("hide");
}

function restore_visibilities(){
  $(".receiver-row,.sample-row").each(function(){
    $(this).removeClass("hide");
  });
  $(".delete-receiver-message,.edit-receiver-row,.delete-sample-message,.edit-sample-row").each(function(){
    $(this).addClass("hide");
  }); 
  $("#add-receiver-button-container,#add-sample-button-container").removeClass("hide");
  hide_add_receiver_form();
  hide_add_sample_form();
}

function bind_receivers_buttons(){
  $("button[id^='delete-receiver-']").each(function(){
    $(this).on("click", function(){
      restore_visibilities();
      $(this).parents("tr").addClass("hide");
      $(this).parents("tr").next("tr").next("tr").removeClass("hide");
    });
  });
  
  $("button[id^='cancel-delete-receiver-']").each(function(){
    $(this).on("click", function(){
      restore_visibilities();
      $(this).parents("tr.delete-receiver-message").addClass("hide");
      $(this).parents("tr.delete-receiver-message").prev("tr.receiver-row").removeClass("hide");
    });
  });
}

function bind_samples_buttons(){
  $("button[id^='delete-sample-']").each(function(){
    $(this).on("click", function(){
      restore_visibilities();
      $(this).parents("tr").addClass("hide");
      $(this).parents("tr").next("tr").next("tr").removeClass("hide");
    });
  });
  
  $("button[id^='cancel-delete-sample-']").each(function(){
    $(this).on("click", function(){
      restore_visibilities();
      $(this).parents("tr.delete-sample-message").addClass("hide");
      $(this).parents("tr.delete-sample-message").prev("tr.sample-row").removeClass("hide");
    });
  });
}

function bind_notifications_buttons(){
  $("a[id^='view-sample-button-']").each(function(){
    $(this).on("click", function(){ 
      // Limpiamos el gráfico de la muestra para poder recargarlo.
      $("#samples-chart").removeData();
     
      restore_visibilities();
      $("#samples-chart").modal({
        show: true,
        remote: Routes.alarm_notification_path(gon.alarm_id, $(this).siblings("input").val(), {method: 'get'})
      });
    });
  });
}

function bind_import_button(){
  $("#import-sample-button").on("click", function(){
    // Limpiamos el formulario poder recargarlo.
    $("#import-dialog").removeData();
    $("#import-dialog").modal({
      show: true,
      remote: Routes.new_alarm_import_path(gon.alarm_id, {method: 'get', from_index: false})
    });
  });
}

function htmlDecode(value){ 
  return $('<div/>').html(value).text(); 
}
