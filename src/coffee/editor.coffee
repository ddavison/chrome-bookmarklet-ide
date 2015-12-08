$(document).ready ->

  props = Ide.get_property('editor_props')
  bookmarklet_id = Ide.get_param('id')
  if bookmarklet_id
    chrome.bookmarks.get(bookmarklet_id, (b) ->
      bookmark = b[0]
      $('#ide-editor-file-name').val(bookmark.title)
      chrome.bookmarks.get(bookmark.parentId, (parent_folder) ->
        $('#ide-editor-file-location').text(parent_folder[0].title)
      )
      props.value = Ide.from_bookmarklet bookmark.url

      Ide.prepare_editor(props)
    )
  else
    Ide.prepare_editor(props)

