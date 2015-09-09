# jshint devel:true
DEBUG = true # set to false to disable console output

if (DEBUG is false) or (!window.console?)
  # if window.console? then window.console = {}
  window.console = {}
  # Protects against annoying blocking errors in IE
  for method in ['log', 'debug', 'info', 'warn', 'error', 'assert', 'clear', 'dir', 'dirxml', 'trace', 'group', 'groupCollapsed', 'groupEnd', 'time', 'timeEnd', 'timeStamp', 'profile', 'profileEnd', 'count', 'exception', 'table']
    window.console[method] = () ->

SITE =
  common:
    init: ->
      $('.nav-icon').on 'click',->
        $('.nav-icon').toggleClass 'open'
        $('.main-nav').toggleClass 'visible'
        $('body').toggleClass 'no-scroll'


      ## Initialize tweets carousel
      $('.tweet-carousel').jcarousel()

      ## Initialize and configure guests carousel
      jcarousel = $('.guests-carousel')
      jcarousel.on('jcarousel:reload jcarousel:create', ->
        carousel = $(this)
        width = carousel.innerWidth()
        if width >= 600
          width = width / 3
        else if width >= 350
          width = width / 2
        carousel.jcarousel('items').css 'width', Math.ceil(width) + 'px'
        return
      ).jcarousel wrap: 'circular'

      $('.jcarousel-control-prev').on('jcarouselcontrol:active', ->
        $(this).removeClass 'inactive'
        return
      ).on('jcarouselcontrol:inactive', ->
        $(this).addClass 'inactive'
        return
      ).jcarouselControl target: '-=1'
      $('.jcarousel-control-next').on('jcarouselcontrol:active', ->
        $(this).removeClass 'inactive'
        return
      ).on('jcarouselcontrol:inactive', ->
        $(this).addClass 'inactive'
        return
      ).jcarouselControl target: '+=1'


# DOM-based routing
# http://paulirish.com/2009/markup-based-unobtrusive-comprehensive-dom-ready-execution/
# Now ported to coffeescript by ar@manoderecha.mx, and using Underscore/Lo-dash _.each()
UTIL =
  fire: (func, funcname, args) ->

    namespace = SITE # indicate your obj literal namespace here

    funcname = if funcname is undefined then 'init' else funcname
    if (func isnt '' and namespace[func] and typeof namespace[func][funcname] is 'function')
      namespace[func][funcname] args

  loadEvents: ->
    bodyId = document.body.id

    # hit up common first.
    UTIL.fire 'common'

    # do all the classes too.
    _.each document.body.className.split(/\s+/), (classnm) ->
      UTIL.fire classnm
      UTIL.fire classnm, bodyId
      UTIL.fire classnm, 'finalize'

    UTIL.fire 'common', 'finalize'

# kick it all off here
jQuery(document).ready UTIL.loadEvents
