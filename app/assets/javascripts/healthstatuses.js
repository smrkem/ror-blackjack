var health_status_data;
$( function() {
  // Stuff to do on the Status Reports section.
  if ($('#status_graph').length) {
    getHealthStatusData();

    $('#status_graph_legend input[name="dataset"]').change(drawGraph);
    $(window).resize(drawGraph);

    $('.range_button').click(function(){
      $(".range-selector .btn-success").removeClass("btn-success");
      getHealthStatusData($(this).data('range'));
      $(this).addClass("btn-success");
    });
  }

  // Stuff to do on the Status History section.
  if ($('.status-history-period').length) {
    $('.status-history-period h3').click( function() {
      var statuses = $(this).siblings('.status-history-statuses');
      if (statuses.hasClass('opened')) {
        $('.status-history-statuses.opened').removeClass('opened').css('height', '0px');
      }
      else {
        $('.status-history-statuses.opened').removeClass('opened').css('height', '0px');
        var height = statuses[0].scrollHeight;
        statuses.addClass('opened').css('height', height + 'px');
      }
    });
    var firstHistory = $('.status-history-statuses').first();
    firstHistory.addClass('opened').css('height', firstHistory[0].scrollHeight + 'px');
  }

  // Stuff to do on the modal Edit / Add screen.
  $("#modal-background").click( function() {
    $("#modal").fadeOut('fast', function() {
      $("#modal-content").empty();
    });
  });

});

function getHealthStatusData(start_date='1 month') {
  $.ajax({
    type: 'GET',
    url: 'health_statuses',
    dataType: 'json',
    data: { start_date: start_date },
    success: function(data) {
      health_status_data = data;
      drawGraph();
    },
    error: function() {
      return false;
    }
  });
}

function drawGraph() {
  var graph = $('#status_graph');
  var width = $('#status_graph_wr').width();
  var height = Math.round(width/3);
  graph.attr('width', width).attr('height', height);

  // graph.css('height', graph.width() / 3 + 'px');
  var xPadding = 30; var yPadding = 30;
  var graph = $('#status_graph');
  c = graph[0].getContext('2d');
  c.clearRect(0, 0, graph.width(), graph.height());
  var minX = health_status_data[0].created_at;
  var maxX = health_status_data[health_status_data.length - 1].created_at;

  c.lineWidth = 1;
  c.strokeStyle = '#999';
  c.font = 'italic 8pt sans-serif';
  c.fillStyle = '#eee';
  c.textAlign = 'center';

  // draw outline:
  c.beginPath();
  c.moveTo(xPadding, yPadding);
  c.lineTo(xPadding, graph.height() - yPadding);
  c.lineTo(graph.width() - xPadding, graph.height() - yPadding);
  c.stroke();

  // draw x axis:
  c.lineWidth = 2;
  c.strokeStyle = '#999';
  for (var i = 0; i < health_status_data.length; i++) {
    var date = new Date(health_status_data[i].created_at * 1000);
    c.beginPath();
    c.moveTo(getXPixel(health_status_data[i].created_at), graph.height() - yPadding + 5);
    c.lineTo(getXPixel(health_status_data[i].created_at), graph.height() - yPadding - 5);
    c.stroke();
    c.fillText((date.getMonth() + 1) + '/' + date.getDate(), getXPixel(health_status_data[i].created_at), graph.height() - yPadding + 20);
  }

  // draw y axis:
  for (var i = 0; i <= 10; i++) {
    c.beginPath();
    c.moveTo(xPadding - 5, getYPixel(i));
    c.lineTo(xPadding + 5, getYPixel(i));
    c.stroke();
    c.fillText(10 - i, xPadding - 20, yPadding + 3 + (i * (graph.height() - 2 * yPadding) / 10));
  }

  $('#status_graph_legend input[name="dataset"]:checked').each(function() {
    drawData($(this).val(),$(this).data('color'));
  });

  function drawData(key, color) {
    var oldX, oldY;
    c.lineWidth = 3;
    c.strokeStyle = color;
    c.beginPath();
    for (var i = 0; i < health_status_data.length; i++) {
      var newX = getXPixel(health_status_data[i].created_at);
      var newY = getYPixel(health_status_data[i][key]);
      // Draw data dot and line:
      c.beginPath();
      if (i > 0) {
        c.moveTo(oldX, oldY);
        c.lineTo(newX, newY);
        c.stroke();
      }
      c.arc(newX, newY, 2, 0, 2*Math.PI, false);
      c.stroke();
      oldX = newX;
      oldY = newY;
    }
  }

  function getXPixel(val) {
    var xRange = maxX - minX;
    var percent = (val - minX) / xRange;
    graphLeft = xPadding;
    graphRight = graph.width() - xPadding;
    graphWidth = graphRight - graphLeft;
    return graphLeft + (graphWidth * percent);
  }

  function getYPixel(val) {
    return graph.height() - yPadding - (val * (graph.height() - 2 * yPadding) / 10);
  }
}
