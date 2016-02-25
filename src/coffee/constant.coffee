###
  Bookmarklet IDE
  (c) 2015 Daniel Davison & Contributors

  This file in particular is a background script that adds context menus and anything else necessary
###

chrome.contextMenus.create({
  title: 'Add to Bookmarklet IDE',
  contexts: ['link'],
  onclick: (obj) ->
    bookmarklet_title = obj.selectionText
    bookmarklet_code  = obj.linkUrl
    chrome.storage.sync.get({
      project_dir: 'Bookmarklets'
    }, (items) ->
      chrome.bookmarks.search(items.project_dir, (bookmarklet_folder) ->
        chrome.bookmarks.create({
          title: bookmarklet_title,
          url: bookmarklet_code,
          parentId: bookmarklet_folder[0].id
        }, (n) ->
          window.open(chrome.runtime.getURL("edit.html?id=#{n.id}"))
        )
      )
    )
})
