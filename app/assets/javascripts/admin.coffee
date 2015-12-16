$ ->
  console.log "hoge"
  $(".js-announcement-form").on "ajax:success", (xhr, data)->
    console.log xhr
    console.log data
