class Editor
  objects =
    CODE: 'ide-editor-code'
    $FILE_NAME: '#ide-editor-file-name'
    $FILE_LOCATION: '#ide-editor-file-location'
    $BTN_SAVE: '#ide-editor-btn-save'
    $BTN_FORMAT: '#ide-editor-btn-formatfile'
    $BTN_RUN: '#ide-editor-btn-run'
    $BTN_EDITOROPTIONS: '#ide-editor-lnk-editoroptions'

  # Will be called when the page is loaded
  constructor: ->
    window.MonacoEnvironment = {
      baseUrl: "/assets/third-party/monaco-editor"
    }
    require.config({ paths: { 'vs': 'assets/third-party/vs' }});
    require(["vs/editor/editor.main"], ->

      Ide.get_properties((settings) ->
        window.Monaco = monaco.editor.create(document.getElementById(objects.CODE), {
          value: [
            "(() {",
            '\tconsole.log("Hello, world!");',
            "})();"
          ].join('\n'),

          language: "javascript",
          automaticLayout: true,
          theme: settings.theme,
          lineNumbers: settings.lineNumbers,
          fontSize: settings.fontSize
        })
      )
    )

    bookmarklet_id = Ide.get_param('id')

    return unless bookmarklet_id

    Ide.get_properties((props) =>
      chrome.bookmarks.get(bookmarklet_id, (b) =>
        bookmark = b[0]
        $(objects.$FILE_NAME).val(bookmark.title)
        document.title = "IDE :: #{bookmark.title}"

        props.value = bookmark.url.replace('javascript:', '')
        @beautify()
      )
    )

  # Get / Set the code in the editor
  code: (new_code = null) ->
    if new_code
      Monaco.setValue(new_code)
      return new_code
    else
      Monaco.getValue()

  # Beautify the code (will be called when loading the bookmarklet
  beautify: ->
    Monaco.getAction('editor.action.formatDocument').run()

  # Minify code (will be called when saving the bookmarklet)
  minify: (code, callback) ->
    code = code || @code
    if code.startsWith("javascript:")
      callback(code)
    else
      callback("javascript:#{code}")

  # Save the new / existing bookmarklet
  save: ->
    name = $(objects.$FILE_NAME).val()
    @minify(@code(), (minified_code) ->
      id = Ide.get_param('id')

      if id
        chrome.bookmarks.update(id, {
          title: name
          url: minified_code
        }, ->
          alert('saved')
        )
      else
        chrome.bookmarks.create({
          title: name,
          url: minified_code,
          parentId: Ide.get_property('bookmarklets_dir').id
        }, (bookmarklet) ->
          alert('saved')
          location.href += "?id=#{bookmarklet.id}"
        )
    )

  # Run the current bookmarklet
  run: ->
    @minify(@code(), (bookmarklet_script) ->
      chrome.tabs.create({ url: bookmarklet_script })
    )

  changed: ->
    alert('something changed')

  objects: ->
    objects


$(document).ready ->
  window.Editor = new Editor()

  # Save the bookmarklet
  $(window.Editor.objects().$BTN_SAVE)[0].addEventListener('click', ->
    window.Editor.save()
  )

  # Format the bookmarklet
  $(window.Editor.objects().$BTN_FORMAT)[0].addEventListener('click', ->
    window.Editor.beautify()
  )

  # Run the bookmarklet
  $(window.Editor.objects().$BTN_RUN)[0].addEventListener('click', ->
    window.Editor.run()
  )

  $(window.Editor.objects().$BTN_EDITOROPTIONS)[0].addEventListener('click', ->
    chrome.runtime.openOptionsPage()
  )
