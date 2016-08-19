flashMessagesFunctions = () ->

  clearFlashMessages = () ->
    setTimeout( ()->
      $('.flash-messages').addClass('fadeOut')
    , 1000)
    setTimeout( ()->
      $('#flash-messages-container').html("")
    , 5000)

  if $('.flash-messages').length > 0
    clearFlashMessages()

$(document).on 'turbolinks:load', flashMessagesFunctions
