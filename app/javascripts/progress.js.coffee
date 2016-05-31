window.Progress ||= {}

((app) ->
  # https://github.com/kimmobrunfeldt/progressbar.js

  if $('#progressbar-circle').length > 0
    bar = new ProgressBar.Circle('#progressbar-circle', {
      strokeWidth: 6,
      easing: 'easeInOut',
      duration: 500,
      color: '#3C98B6',
      trailColor: '#eee',
      strokeWidth: 15,
      trailWidth: 15,
      svgStyle: null
    })

    val = 0
    duration = 5000
    steps = 20

    animateBar = (val) ->
      bar.animate(val)

    timer = setInterval(( ->
      animateBar(val)
      val = val + 1/steps
    ), duration/(steps + 1))

    setTimeout(( ->
      clearInterval(timer)
    ), duration + duration/steps)

    #bar.animate(0.7);  # Number from 0.0 to 1.0

)(window.Progress ||= {})
