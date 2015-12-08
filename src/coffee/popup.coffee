$(document).ready ->
  $content = $('#ide-popup-content')
  Ide.load_bookmarklets ->
    for bookmarklet in Ide.get_property('bookmarklets')
      $content.append(
        "<a class=\"ide-bookmarklet\" target=\"_blank\" href=\"edit.html?id=#{bookmarklet.id}\">#{bookmarklet.title}</a>"
      )
