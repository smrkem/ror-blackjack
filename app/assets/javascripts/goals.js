$( function() {
  $('.complete_now_button').click( addGoalCompletion );

  $('.goal_active_toggle input').change( setGoalActive );
});

function setGoalActive() {
  var toggle = $(this).parent(".goal_active_toggle");
  var url = toggle.data('url');
  var status_class = $(this).is(":checked") ? "toggle_on" : "toggle_off";
  $.ajax({
    type: 'PATCH',
    url: url,
    dataType: 'json',
    data: {
      active: $(this).is(":checked")
    },
    success: function(goal) {
      // Remove active goal from listing
      $('li#goal_' + goal.id + '.inactive_goal > a').css('background','#337ab7');
      $('li#goal_' + goal.id + '.inactive_goal').fadeOut('slow', function() {
        $(this).remove();
      });
    },
    error: function() {
      return false;
    }
  });
  toggle.removeClass("toggle_on toggle_off").addClass(status_class);
}

function addGoalCompletion() {
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
}
