class Editor
  objects =
    CODE: 'ide-editor-code'
    $FILE_NAME: '#ide-editor-file-name'
    $FILE_LOCATION: '#ide-editor-file-location'
    $BTN_SAVE: '#ide-editor-btn-save'
    $BTN_FORMAT: '#ide-editor-btn-formatfile'
    $BTN_RUN: '#ide-editor-btn-run'

  # Will be called when the page is loaded
  constructor: ->
    bookmarklet_id = Ide.get_param('id')
    Ide.get_properties((props) =>
      if bookmarklet_id
        chrome.bookmarks.get(bookmarklet_id, (b) =>
          bookmark = b[0]
          $(objects.$FILE_NAME).val(bookmark.title)
          document.title = "IDE :: #{bookmark.title}"
          #chrome.bookmarks.get(bookmark.parentId, (parent_folder) ->
            #$(objects.$FILE_LOCATION).text(parent_folder[0].title)
            #$(objects.$FILE_LOCATION).data('folder-id', parent_folder[0].id)
          #)

          props.value = bookmark.url.replace('javascript:', '')
          @refresh(props)
          @selectAll()
          @beautify()
        )
      else
        @refresh(props)
    )

  # Fetches the actual CodeMirror object
  getEditor: ->
    $('.CodeMirror')[0].CodeMirror

  # Method that is called when the code mirror should be redrawn
  refresh: (props) ->
    code_editor_element = document.getElementById(objects.CODE)
    CodeMirror((element) ->
      code_editor_element.parentNode.replaceChild(element, code_editor_element)
    ,
      props
    )

# Get / Set the code in the editor
  code: (new_code = null) ->
    if new_code
      @getEditor().setValue(new_code)
      return new_code
    else
      @getEditor().getValue()

  # Utility method to fetch the range of characters that is currently selected
  getSelectedRange: ->
    {
      from: @getEditor().getCursor(true),
      to: @getEditor().getCursor(false)
    }

  # Select all the text within the code editor
  selectAll: ->
    @getEditor().execCommand('selectAll')

  # Beautify code (will be called called from the code in the bookmarklet)
  beautify: ->
    range = @getSelectedRange()
    @getEditor().autoFormatRange(range.from, range.to);

  # Minify code (will be called when saving the bookmarklet)
  minify: (code, callback) ->
    code = @code unless code
    if code.startsWith("javascript:")
      callback(code)
    else
      callback("javascript:#{code}")

  # Save the new / existing bookmarklet
  save: ->
    name = $(objects.$FILE_NAME).val()
    @minify(@code(), (minified_code) ->
      chrome.bookmarks.update(Ide.get_param('id'), {
        title: name
        url: minified_code
      }, ->
        alert('saved')
      )
    )

  # Run the current bookmarklet
  run: ->
    @minify(@code(), (bookmarklet_script) ->
      window.open(bookmarklet_script, "Bookmarklet: #{}")
    )

  changed: ->
    alert("something changed")

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
    window.Editor.selectAll()
    window.Editor.beautify()
  )

  # Run the bookmarklet
  $(window.Editor.objects().$BTN_RUN)[0].addEventListener('click', ->
    window.Editor.run()
  )
