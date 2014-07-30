class ImageCroppedPreview
  constructor: (el)->
    @el = $ el
    @noImageSrc = @el.data "no-image"
    @w = @el.data "format-params-w"
    @h = @el.data "format-params-h"
    @name = @el.data "format-name"
    @img = $ "img", @el
    @coordsFormat =  ["x", "y", "w", "h"]
    if @el.hasClass "dependent-cropper"
      @masterCropper = $ ".image-cropper .image-cropper-preview[data-ident=\"#{@el.data('master')}\"]"
      @masterInputs = $ "input[type=\"hidden\"]", @masterCropper
      @masterInputs.bind "change", @syncCoordsFromMaster
    else
      @fillNoImage()
      @img.bind "load", @fillSize

  syncCoordsFromMaster: (ev)=>
    target = $ ev.currentTarget
    @field(target.data 'attribute').val target.val()

  fillNoImage: =>
    @noImage = @noImageSrc is @img.attr "src"

  crop: (w)=>
    field = @field w
    parseFloat(field.val() || 0) / @scale

  toggleImg: (b = !@img.data("src")?)=>
    @noImage = b
    if b
      @img.data "src", @img.attr("src") #backup
      @img.attr "src", @noImageSrc
    else
      backup = @img.data "src"
      @img.attr "src", backup
      @img.data "src", null

  field: (w)=>
    $ "input.#{@name}_#{w}", @el

  fillSize: =>
    img = new Image()
    self = @
    img.onload = ->
      self.true_h = this.height
      self.true_w = this.width
      self.scale = parseFloat(self.true_h) / self.img.height()
      self.img.data("Jcrop")?.destroy?()
      self.updateCrop() unless self.noImage
    img.src = @img.attr "src"

  updateCrop: =>
    @img.removeAttr "style"


    setTimeout =>
      coords = {}
      for coord in @coordsFormat
        coords[coord] = @crop coord
      trueSize = [@true_w/@scale,@true_h/@scale]
      minSize =  [@w/@scale, @h/@scale]

      IQ300.Plugin.use 'jquery-jcrop', =>
        @img.Jcrop
          aspectRatio: parseFloat(@w)/@h
          trueSize: trueSize
          setSelect: [coords.x, coords.y, coords.x + coords.w, coords.y + coords.h]
          allowResize: true
          minSize: minSize
          allowSelect: true
          onSelect: @updateFields
          onChange: @updateFields
    , 0

  updateFields: (coords) =>
    for coord in @coordsFormat
      val = Math.round(coords[coord] * @scale)
      val = 0 if val < 0
      field = @field(coord)
      field.val val
      field.trigger "change"

  updateSrc: (data = @img.attr "src")=>
    @img.attr "src", data
    @fillNoImage()

class ImageCropper
  constructor:(el) ->
    @el = $ el
    @fileInput = $ "input[type=file]", @el
    @previewsElements = $ ".image-cropper-preview", @el
    @previews = []
    for previewEl in @previewsElements
      @previews.push new ImageCroppedPreview(previewEl)

    @fileInput.bind "change", @addImage
    @updatePreviews()
    @remove = $ ".remove-picture", @el
    @remove.bind "change", @toggleImages

  toggleImages: =>
    value = @remove.is ":checked"
    for preview in @previews
      preview.toggleImg value

  addImage: (event) =>
    if event.target.files != undefined
      file = event.target.files[0]
    return unless file
    if (file.type? && typeof FileReader != "undefined")
      reader = new FileReader()
      reader.onload = @updatePreviews
      reader.readAsDataURL file


  updatePreviews: (e)=>
    result = e.target.result if e && e.target
    for preview in @previews
      preview.updateSrc result


app.initializer.addComponent ImageCropper
