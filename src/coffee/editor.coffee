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

        @beautify(bookmark.url, (beautified_code) =>
          props.value = beautified_code
          @refresh(props)
        )
      )
    else
      @refresh(props)

  # Get / Set the code
  code: (new_code) ->


  # Beautify code (will be called called from the code in the bookmarklet)
  beautify: (code, callback) ->
    callback.call(code) if callback

  # Minify code (will be called when saving the bookmarklet)
  minify: (code, callback) ->
    $.post('http://codebeautify.org/service/jsmin', {data: code}, (response) ->
      callback.call(response)
    )

$(document).ready ->
  window.Editor = new Editor()
