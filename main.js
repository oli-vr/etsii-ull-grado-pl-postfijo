$(document).ready(function () {
  $("button").click(function () {
    try {
      var result = calculator.parse($("textarea").val())
      $("span").html(result);
    } catch (e) {
      $("span").html(String(e));
    }
  });
});
