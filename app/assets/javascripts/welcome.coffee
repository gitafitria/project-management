ready = ->

  $("#navbar_visitor a").on 'click', (event) ->
    if @hash != ''
      event.preventDefault()
      hash = @hash
      $('#welcome_body').animate { scrollTop: $(hash).offset().top }, 800, ->
        window.location.hash = hash
        return

$(document).ready(ready);
$(document).on('page:change', ready);