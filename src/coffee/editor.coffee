class Editor
  objects =
    CODE: 'ide-editor-code'
    $FILE_NAME: '#ide-editor-file-name'
    $FILE_LOCATION: '#ide-editor-file-location'
    $BTN_SAVE: '#ide-editor-btn-save'

  refresh: (props) ->
    code_editor_element = document.getElementById(objects.CODE)
    CodeMirror((element) ->
      code_editor_element.parentNode.replaceChild(element, code_editor_element)
    ,
      props
    )

  constructor: ->
    props = Ide.get_property('editor_props')
    bookmarklet_id = Ide.get_param('id')
    if bookmarklet_id
      chrome.bookmarks.get(bookmarklet_id, (b) =>
        bookmark = b[0]
        $(objects.$FILE_NAME).val(bookmark.title)
        document.title = "IDE :: #{bookmark.title}"
        chrome.bookmarks.get(bookmark.parentId, (parent_folder) ->
          $(objects.$FILE_LOCATION).text(parent_folder[0].title)
          $(objects.$FILE_LOCATION).data('folder-id', parent_folder[0].id)
        )

        @beautify(bookmark.url, (resp) =>
          props.value = resp
          @refresh(props)
        )
      )
    else
      @refresh(props)

    $(objects.$BTN_SAVE).click(Editor.save)

  # Get / Set the code
  code: (new_code = null) ->
    code_editor = $('.CodeMirror')[0].CodeMirror
    if new_code
      code_editor.setValue(new_code)
      return new_code
    else
      code_editor.getValue()

  # Beautify code (will be called called from the code in the bookmarklet)
  beautify: (code, callback) ->
    code = @code unless code
    code = unescape(code.replace('javascript:', ''))
    callback(code)

  # Minify code (will be called when saving the bookmarklet)
  minify: (code, callback) ->
    code = @code unless code
    if code.startsWith("javascript:")
      callback(code)
    else
      callback("javascript:#{code}")

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


$(document).ready ->
  window.Editor = new Editor()
