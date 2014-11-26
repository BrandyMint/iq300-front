gutil = require("gulp-util")
through = require("through2")

module.exports = (opts) ->
  "use strict"

  #rootRegEx = undefined
  
  throw new gutil.PluginError("gulp-assetpaths", "No parameters supplied")  unless opts
  throw new gutil.PluginError("gulp-assetpaths", "Missing parameter : filetypes")  if not opts.filetypes or (not opts.filetypes instanceof Array)
  #throw new gutil.PluginError("gulp-assetpaths", "Missing parameter : newDomain")  unless opts.newDomain
  #throw new gutil.PluginError("gulp-assetpaths", "Missing parameter : oldDomain")  unless opts.oldDomain
  #throw new gutil.PluginError("gulp-assetpaths", "Missing parameter : docRoot")  unless opts.docRoot
  filetypes = new RegExp("." + opts.filetypes.join("|."))

  #rootRegEx = setReplacementDomain(opts.oldDomain)

  opts.newDomain ||= ''

  attrsAndProps = [
    {
      exp: /(<\s*)(.*?)\bhref\s*=\s*((["{0,1}|'{0,1}]).*?\4)(.*?)>/g
      captureGroup: 3
      templateCheck: /((\bdownload)(?=(.*?)\bhref\s*=))|((\bhref\s*=)(?=(.*?)\bdownload))/
    }
    {
      exp: /((\bbackground|\bbackground-image)\s*:\s*?.*){0,1}\burl\s*((\(\s*[^\w]{0,1}(["{0,1}'{0,1}]{0,1})).*?\5\))/g
      captureGroup: 3
      templateCheck: /((\bbackground|\bbackground-image)\s*:\s*?.*)\burl\s*\(.*?\)/
    }
    {
      exp: /((\bsrc)\s*:\s*?.*){0,1}\burl\s*((\(\s*[^\w]{0,1}(["{0,1}'{0,1}]{0,1})).*?\5\))/g
      captureGroup: 3
      templateCheck: /((\bsrc)\s*:\s*?.*)\burl\s*\(.*?\)/
    }

    {
      exp: /((<\s*){0,1}\bscript)(.*?)\bsrc\s*=\s*((["{0,1}|'{0,1}]).*?\5)/g
      captureGroup: 4
      templateCheck: /(<\s*){0,1}(\bscript)(.*?)\bsrc\s*=\s*/
    }
    {
      exp: /((<\s*){0,1}\bimg)(.*?)\bsrc\s*=\s*((["{0,1}|'{0,1}]).*?\5)/g
      captureGroup: 4
      templateCheck: /(<\s*){0,1}(\bimg)(.*?)\bsrc\s*=\s*/
    }
    {
      exp: /(:\s*("(.*?)"))/g
      captureGroup: 2
      templateCheck: false
    }
  ]


  setReplacementDomain = (string) ->
    #if isRelative(opts.oldDomain)
    #  new RegExp("(((\\bhttp|\\bhttps):){0,1}\\/\\/" + string + ")")
    new RegExp(string)

  isRelative = (string, insertIndex) ->
    (if (string.indexOf("/") is -1 or string.indexOf("/") > insertIndex) then true else false)

  getInsertIndex = (string) ->
    if string.search(/^.{0,1}\s*("|')/) isnt -1
      
      #check to see if template not using interpolated strings
      nonInter = /["|']\s*[+|.][^.]/.exec(string)
      return (if string.search(/"|'/) is nonInter.index then nonInter.index else (nonInter.index - 1))  if nonInter
      return (string.search(/"|'/) + 1)
    1
  insertAtIndex = (string, fragment, index) ->
    ins = [
      string.slice(0, index)
      fragment
      string.slice(index)
    ].join ""
    ins
  ignoreUrl = (match) ->
    #regEx = /((\bhttp|\bhttps):){0,1}\/\//
    #return true  if (rootRegEx isnt null) and (not rootRegEx.test(match))  if regEx.test(match)
    false
  replacementCheck = (cGroup, match, regEx) ->
    return filetypes.test(cGroup)  unless opts.templates
    if regEx.templateCheck
      filetypes.test(cGroup) or regEx.templateCheck.test(match)
    else
      filetypes.test cGroup
  processLine = (line, regEx, file) ->
    line = line.replace(regEx.exp, (match) ->
      cGroup = arguments[regEx.captureGroup]
      if replacementCheck(cGroup, match, regEx)
        unless ignoreUrl(cGroup)
          return match.replace(cGroup, (match) ->
            #match = match.replace(rootRegEx, "").trim()
            insertPath match, file
          )
      match
    )
    
    #pass back line if noop
    line
  countRelativeDirs = (path) ->
    relDirs = path.filter((dir) ->
      (if dir.indexOf("..") isnt -1 then true else false)
    )
    relDirs.length
  anchorToRoot = (string, file) ->
    index = getInsertIndex(string)
    if isRelative(string, index)
      
      #if the path isn't being dynamically generated(i.e. server or in template)
      unless /^\s*[\(]{0,1}\s*["|']{0,1}\s*[<|{|.|+][^.]/.test(string)
        if opts.docRoot
          currentPath = string.split("/")
          relDirs = countRelativeDirs(currentPath)
          string = string.replace(/\.\.\//g, "")
          relDirs = (if relDirs > 0 then relDirs else relDirs + 1)
          fullPath = file.path.split("/").reverse().slice(relDirs)
          if fullPath.indexOf(opts.docRoot) isnt -1
            while fullPath[0] isnt opts.docRoot
              string = insertAtIndex(string, fullPath[0] + "/", index)
              fullPath = fullPath.slice(1)
    string

  insertPath = (string, file) ->
    string = anchorToRoot(string, file)
    index = getInsertIndex(string)
    if opts.newDomain && opts.newDomain?.length > 0 && string.match(opts.newDomain) == null
      string = insertAtIndex(string, "/", index) if isRelative(string, index)
      insertAtIndex string, opts.newDomain, index
    else
      string



  assetpaths = (file, enc, callback) ->
    
    # Do nothing if no contents
    if file.isNull()
      @push file
      return callback()
    return @emit("error", new gutil.PluginError("gulp-assetpaths", "Streaming not supported"))  if file.isStream()
    if file.isBuffer()
      outfileContents = ""
      contents = file.contents.toString("utf8")
      lineEnding = (if contents.search(/[\r\n]/) isnt -1 then "\r\n" else "\n")
      lines = contents.split(lineEnding)
      lines.forEach ((line) ->
        attrsAndProps.forEach ((regEx) ->
          line = processLine(line, regEx, file)
          return
        ), this
        outfileContents += line
        return
      ), this
      outfile = file.clone()
      outfile.contents = new Buffer(outfileContents)
    @push outfile
    callback()

  through.obj assetpaths
