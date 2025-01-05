$(document).ready(function() {
  // Initially hide the image container and add the 'off' class
  $('.image-container').hide();
  $('#reset-button').prop("disabled", true)
  $('#alcolize-button').prop("disabled", true)
  $('.image-container').addClass('off');

  window.addEventListener('message', function(event) {
    const data = event.data;

    // If Esc clicked close NUI
    $(document).on('keyup', function(e) {
      let keyPressed = e.which;
      if (keyPressed === 27) {
        axios.post(`https://${GetParentResourceName()}/resetalcolizer`, {})
        $('.image-container').toggleClass('off'); 
      }
    })

    // Show the UI when showui is heard
    if (data.type === "opennui") {
      $('.image-container').show();
    }

    // Hide the UI when closenui is heard
    if (data.type === "closenui") {
      $('.image-container').hide();
    }

    // Button handling
    $("#power-button").click(function(event) {

      // Enable Other Buttons
      $('#reset-button').prop("disabled", false)
      $('#alcolize-button').prop("disabled", false)


      // Toggle the 'off' class, turning the screen on or off
      $('.image-container').toggleClass('off'); 
    });

    $("#reset-button").click(function() {
      axios.post(`https://${GetParentResourceName()}/resetalcolizer`, {})
      $('#bactext').text(".000")
      $('.image-container').toggleClass('off'); 
    });

    $("#alcolize-button").click(function() {
      axios.post(`https://${GetParentResourceName()}/alcolizeped`, {})
      .then((response) => {
        let bacResult = response.data;
         
        // change h1 text
        $('#bactext').text(bacResult)
      })
    });
  });
});
