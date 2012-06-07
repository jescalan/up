$ ->
  $('.yes').on 'click', ->
    $('#screen1').fadeOut 500, ->
      $('#screen-yes').fadeIn 500
  
  $('.no').on 'click', ->
    $('#screen1').fadeOut 500, ->
      $('#screen-no').fadeIn 500
  
  $('.done.n1').on 'click', ->
    $('#screen-yes').fadeOut 500, ->
      $('#screen-done').fadeIn 500
  
  $('.done.n2').on 'click', ->
    $('#screen-no').fadeOut 500, ->
      $('#screen-done').fadeIn 500