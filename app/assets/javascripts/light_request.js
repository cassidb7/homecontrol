$(function () {
  $(".dial").knob({
     "min":0,
     "max":255,
     "displayInput":false,
     "thickness": 0.15,
       'release' : function (v) {
         lightIdx = this.$.attr('data-uniqueid')
         dimLights(lightIdx, v)
       }
   });


  $(".power-switch").change(function() {
   if ($(this).is(':checked')) {
     lightsOn($(this));


   }else{
     lightsOff($(this));
     disableDial();
   }
  });

  function disableDial(){
    console.log("diable knob")
    $('.dial').unwrap().attr("data-readOnly",true)
  }

  function dimLights(lightIdx, dim_value){
   $.ajax({
     url: '/lights/dim_settings.json',
     type: 'PATCH',
     data: { light_identifier: lightIdx, dimmer_value: dim_value }
     }).done(function(data) {
     });
   }

  function lightsOff(element){
   var thisLightID = $(element).closest('tr').find('td:first').text();

   $.ajax({
     url: '/lights/turn_off.json',
     type: 'PATCH',
     data: {
       uniqueid: thisLightID
       }
     }).done(function(data) {
       console.log("lights off")
     });
   }

   function lightsOn(element){
     var thisLightID = $(element).closest('tr').find('td:first').text();

     $.ajax({
       url: '/lights/turn_on.json',
       type: 'PATCH',
       data: {
         uniqueid: thisLightID
       }
     }).done(function(data) {
       console.log("lights on")
     });
   }
})
