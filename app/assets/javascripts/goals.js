$( function() {
  $('.complete_now_button').click( function() {
    var url = $(this).data('url');
    $.ajax({
      type: 'POST',
      url: url,
      dataType: 'json',
      data: {
        msg: "complete"
      },
      success: function(data) {
        console.log(data);
      },
      error: function() {
        return false;
      }
    });
  });
});
