$( function() {
  // Stuff to do on the modal Edit / Add screen.
  $("#modal-background").click( function() {
    modalFadeOut();
  });
});

function modalFadeOut() {
  $("#modal").fadeOut('fast', function() {
    $("#modal-content").empty();
  });
}
