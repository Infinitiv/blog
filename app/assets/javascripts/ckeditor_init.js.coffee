$(document).ready ->
  if $("textarea").length > 0
    data = $("textarea")
    $.each data, (i) ->
      CKEDITOR.replace data[i].id