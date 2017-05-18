$( function() {
  var offset = getGMTOffset();
  var selectedValue = $("#user_time_zone option:contains('" + offset + "')").first().val();
  $("#user_time_zone").val(selectedValue);

  var offset = -5;
  var d = new Date();
  var utc = d.getTime() + (d.getTimezoneOffset() * 60000);
   // create new Date object for different city
   // using supplied offset
  var nd = new Date(utc + (3600000 * offset));
  console.log(nd.toString());
});

function getGMTOffset() {
  var offset = new Date().getTimezoneOffset()/-60;
  var absoluteOffset = Math.abs(offset);
  var matchText = "(GMT";
  matchText += offset < 0 ? "-" : "+";
  matchText += absoluteOffset < 10 ? "0" + absoluteOffset : absoluteOffset;
  matchText += ':00)';
  return matchText;
}
