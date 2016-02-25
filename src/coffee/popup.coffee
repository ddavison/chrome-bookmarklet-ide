$(document).ready ->
  $content = $('.ide-popup-content')
  Ide.get_properties((props) ->
    Ide.load_bookmarklets ->
      for bookmarklet in props.bookmarklets

        link = $(document.createElement('a'))
        .attr({
          class: 'ide-bookmarklet'
          target: '_blank'
          href: "edit.html?id=#{bookmarklet.id}"
        })
        .html(bookmarklet.title + '<span class="icon fa fa-arrow-right"></span>')

        $content.find('[data-popup-content]').append(link)
  )
