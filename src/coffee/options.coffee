###
  Bookmarklet IDE
  (c) 2015 Daniel Davison & Contributors

  Bookmarklet IDE for Chrome
###

# Load default settings (and set them if they are not set already
window.Settings.get({
  project_dir: 'Bookmarklets',
  indentUnit: 2,
  smartIndent: true,
  tabSize: 2,
  indentWithTabs: false,
  lineNumbers: true
}, (items) ->
  document.querySelector('#ide-options-txt-projectdir').value = items.project_dir
  document.querySelector('#ide-options-txt-indentsize').value = items.tabSize
  document.querySelector('#ide-options-chk-usetabs').checked = 'checked' if items.indentWithTabs
  document.querySelector('#ide-options-chk-showlinenumbers').checked = 'checked' if items.lineNumbers
)


# Save
document.querySelector('#ide-options-btn-save').addEventListener('click', ->
  project_dir = document.querySelector('#ide-options-txt-projectdir').value
  indentUnit = document.querySelector('#ide-options-txt-indentsize').value
  tabSize = document.querySelector('#ide-options-txt-indentsize').value
  indentWithTabs = document.querySelector('#ide-options-chk-usetabs').checked
  lineNumbers =  document.querySelector('#ide-options-chk-showlinenumbers').checked

  window.Settings.save({
    project_dir: project_dir,
    indentUnit: indentUnit,
    tabSize: tabSize,
    indentWithTabs: indentWithTabs,
    lineNumbers: lineNumbers
  }, ->
    document.getElementById('ide-options-status').innerHTML = 'Saved.'
  )
)
