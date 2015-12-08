###
  Bookmarklet IDE
  (c) 2015 Daniel Davison & Contributors

  Bookmarklet IDE for Chrome
###

class Ide
  props =
    bookmarks_folder_name: 'Bookmarklets'

    # default editor properties
    editor_props:
      value: "(function() {\n  // todo\n})();"
      mode: 'javascript'
      indentUnit: 2
      smartIndent: true
      tabSize: 2
      indentWithTabs: false
      lineNumbers: true

  constructor: ->
    @load_properties()
    @load_bookmarklets()

  # get a parameter from the url
  get_param: (which) ->
    result = 'Not found'
    tmp = []

    location.search
    .substr(1)
    .split("&")
    .forEach((item) ->
      tmp = item.split('=')
      result = decodeURIComponent(tmp[1]) if tmp[0] == which
    )

    result

  # Set a property to a specific value
  set_property: (prop, value) ->
    props[prop] = value

  # Get a property
  get_property: (prop, default_value = null) ->
    @set_property(prop, default_value) if !props[prop] and default_value
    props[prop]

  # Save all properties into storage
  save_properties: ->

  # Load all properties from storage
  load_properties: ->
    console.log 'loading properties'

  # load all bookmarklets from the folder (create the folder if not there)
  #  @get_property('bookmarklets') to fetch all
  load_bookmarklets: (callback) ->
    bookmarks_folder = @get_property('bookmarks_folder_name')
    chrome.bookmarks.search(bookmarks_folder, (bookmarks) =>
      if bookmarks.length > 1
        alert "Apparently there are more than one bookmark folders named #{bookmarks_folder}.\n\n" +
          'In order for the Bookmarklet IDE to work, it needs to know where to store the bookmarklets.\n' +
          'Please rectify this solution either by correcting your bookmarks for disambiguity, or by opening' +
          ' this extensions options page and changing the folder name.'
      else if bookmarks.length == 0
        chrome.bookmarks.create(
          title: bookmarks_folder
        , (b) ->
          bookmarks = b
        )

      @set_property('bookmarklets_dir', bookmarks[0])

      chrome.bookmarks.getSubTree(
        @get_property('bookmarklets_dir').id
      , (bookmarks) =>
        @set_property('bookmarklets', bookmarks[0].children)
        callback.call() if callback
      )
    )





window.Ide = new Ide()
