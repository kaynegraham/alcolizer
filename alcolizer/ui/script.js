$(document).ready(function() {
  // Initially hide the image container and add the 'off' class
  $('.image-container').hide();
  $('.image-container').addClass('off');

  window.addEventListener('message', function(event) {
    const data = event.data;

    // If Esc clicked close NUI
    $(document).on('keyup', function(e) {
      let keyPressed = e.which;
      if (keyPressed === 27) {
        axios.post(`https://${GetParentResourceName()}/resetalcolizer`, {})
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

      // Toggle the 'off' class, turning the screen on or off
      $('.image-container').toggleClass('off'); 
    });

    $("#reset-button").click(function() {
      axios.post(`https://${GetParentResourceName()}/resetalcolizer`, {})
    });

    $("#alcolize-button").click(function() {
      axios.post(`https://${GetParentResourceName()}/alcolizeped`, {})
      .then((response) => {
        let bacResult = response.data;
        
        if (bacResult > 0.05) {
          console.log("Illegal")
        } else {
          console.log("Legal")
        }
    
      })
    });
  });
});
