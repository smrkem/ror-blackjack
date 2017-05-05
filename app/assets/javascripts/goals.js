$( function() {
  $('.complete_now_button').click( function() {
    var goal = $(this).parents(".goal");
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
        goal.fadeOut('fast', function() {
          $(this).find(".goal_completes").text(data.goal_completes);
          $(this).fadeIn('fast', function() {
            if (data.goal_completed) {
              $(this).addClass("completed-goal");
            }
          });
        });
      },
      error: function() {
        return false;
      }
    });
  });
});
