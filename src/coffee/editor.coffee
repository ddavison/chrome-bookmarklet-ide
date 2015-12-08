class Editor
  objects =
    $CODE: '#ide-editor-code'
    CODE: 'ide-editor-code'
    $FILE_NAME: '#ide-editor-file-name'
    $FILE_LOCATION: '#ide-editor-file-location'

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
        chrome.bookmarks.get(bookmark.parentId, (parent_folder) ->
          $(objects.$FILE_LOCATION).text(parent_folder[0].title)
        )

        @beautify(bookmark.url, (resp) =>
          props.value = resp
          @refresh(props)
        )
      )
    else
      @refresh(props)

  # Get / Set the code
  code: (new_code = null) ->
    code_editor = $('.CodeMirror')[0].CodeMirror
    if new_code
      code_editor.options.value = new_code
      return new_code
    else
      code_editor.options.value

  # Beautify code (will be called called from the code in the bookmarklet)
  beautify: (code, callback) ->
    code = @code unless code
    code = code.replace('javascript:', '')
    callback(code)


  # Minify code (will be called when saving the bookmarklet)
  minify: (code, callback) ->
    code = @code unless code
    $.get('http://marijnhaverbeke.nl/uglifyjs', {js_code: code}, (response) ->
      callback(code)
    )

$(document).ready ->
  window.Editor = new Editor()
