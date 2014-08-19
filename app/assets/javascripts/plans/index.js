$(document).ready(function(){
  $("div.thumbnail").each(function(){
    $(this).hover(function(){ $(this).addClass("plan"); }, function(){ $(this).removeClass("plan"); });
  });    
});