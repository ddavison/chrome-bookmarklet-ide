do ->
    CodeMirror.extendMode 'css',
        commentStart: '/*'
        commentEnd: '*/'
        newlineAfterToken: (type, content) ->
            /^[;{}]$/.test content
    CodeMirror.extendMode 'javascript',
        commentStart: '/*'
        commentEnd: '*/'
        newlineAfterToken: (type, content, textAfter, state) ->
            if @jsonMode
                /^[\[,{]$/.test(content) or /^}/.test(textAfter)
            else
                if content == ';' and state.lexical and state.lexical.type == ')'
                    return false
                /^[;{}]$/.test(content) and !/^;/.test(textAfter)
    CodeMirror.extendMode 'xml',
        commentStart: '<!--'
        commentEnd: '-->'
        newlineAfterToken: (type, content, textAfter) ->
            type == 'tag' and />$/.test(content) or /^</.test(textAfter)
    CodeMirror.defineExtension 'commentRange', (isComment, from, to) ->
        cm = this
        curMode = CodeMirror.innerMode(cm.getMode(), cm.getTokenAt(from).state).mode
        cm.operation ->
            if isComment
                cm.replaceRange curMode.commentEnd, to
                cm.replaceRange curMode.commentStart, from
                if from.line == to.line and from.ch == to.ch
                    cm.setCursor from.line, from.ch + curMode.commentStart.length
            else
                selText = cm.getRange(from, to)
                startIndex = selText.indexOf(curMode.commentStart)
                endIndex = selText.lastIndexOf(curMode.commentEnd)
                if startIndex > -1 and endIndex > -1 and endIndex > startIndex
                    selText = selText.substr(0, startIndex) + selText.substring(startIndex + curMode.commentStart.length, endIndex) + selText.substr(endIndex + curMode.commentEnd.length)
                cm.replaceRange selText, from, to
            return
        return
    # Applies automatic mode-aware indentation to the specified range
    CodeMirror.defineExtension 'autoIndentRange', (from, to) ->
        cmInstance = this
        @operation ->
            i = from.line
            while i <= to.line
                cmInstance.indentLine i, 'smart'
                i++
            return
        return
    # Applies automatic formatting to the specified range
    CodeMirror.defineExtension 'autoFormatRange', (from, to) ->
        cm = this
        outer = cm.getMode()
        text = cm.getRange(from, to).split('\n')
        state = CodeMirror.copyState(outer, cm.getTokenAt(from).state)
        tabSize = cm.getOption('tabSize')
        out = ''
        lines = 0
        atSol = from.ch == 0

        newline = ->
            out += '\n'
            atSol = true
            ++lines
            return

        i = 0
        while i < text.length
            stream = new (CodeMirror.StringStream)(text[i], tabSize)
            while !stream.eol()
                inner = CodeMirror.innerMode(outer, state)
                style = outer.token(stream, state)
                cur = stream.current()
                stream.start = stream.pos
                if !atSol or /\S/.test(cur)
                    out += cur
                    atSol = false
                if !atSol and inner.mode.newlineAfterToken and inner.mode.newlineAfterToken(style, cur, stream.string.slice(stream.pos) or text[i + 1] or '', inner.state)
                    newline()
            if !stream.pos and outer.blankLine
                outer.blankLine state
            if !atSol
                newline()
            ++i
        cm.operation ->
            `var cur`
            cm.replaceRange out, from, to
            cur = from.line + 1
            end = from.line + lines
            while cur <= end
                cm.indentLine cur, 'smart'
                ++cur
            cm.setSelection from, cm.getCursor(false)
            return
        return
    return
