ImagesCorrector = (images)->
  if !$(images).hasClass(".skip-image-corrector") and $(images).parents(".skip-image-corrector").length is 0
    $(images).on "error", (ev) ->
      img = $ ev.currentTarget
      defaultSrc = img.data "default-src"
      if defaultSrc
        img.attr("src", defaultSrc)
      else
        img.remove()

app.initializers.ImagesCorrector = (el)->
  targets = $("img", el).not(".img-corrector-initialized")
  ImagesCorrector targets
  targets.addClass "img-corrector-initialized"
