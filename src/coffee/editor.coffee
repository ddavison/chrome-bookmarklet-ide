class Editor
  constructor: ->
    code_editor_element = document.getElementById('ide-code-editor')
    code_editor = CodeMirror((element) ->
      code_editor_element.parentNode.replaceChild(element, code_editor_element)
    ,
      Ide.get_property('editor_props')
    )


window.Editor = new Editor()
