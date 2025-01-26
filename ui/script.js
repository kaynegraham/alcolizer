$(document).ready(function() {
  $('.image-container').hide();
  $('#reset-button').prop("disabled", true)
  $('#alcolize-button').prop("disabled", true)
  $('.image-container').addClass('off');

  window.addEventListener('message', function(event) {
    const data = event.data;

    // Notification System
    if (event.data.type === "notification") {
      let notif = document.createElement("div");
      notif.className = "notif " + event.data.notifType;
      notif.innerText = event.data.text;
      document.body.appendChild(notif);

      setTimeout(() => notif.remove(), 4000);
  }

    // If Esc clicked close NUI
    $(document).on('keyup', function(e) {
      let keyPressed = e.which;
      if (keyPressed === 27) {
        axios.post(`https://${GetParentResourceName()}/resetalcolizer`, {})
        $('.image-container').hide();
        $('.image-container').toggleClass('off'); 
        $('#bactext').text(".000")
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

    // Update BAC 
    if (data.type === "showbac") {
      if (data.bac != "Invalid") {
        $('#bactext').text(data.bac); 
      }
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
    });
  });
});
