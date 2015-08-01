{View} = require 'atom-space-pen-views'

module.exports =
class CounterView extends View
  CSS_SELECTED_CLASS: 'counter-select'

  @content: ->
    @div class: 'counter inline-block'

  update_count: (editor) ->
    output = ''
    delimiter = ' | '
    text = @getCurrentText editor
    counts = @count text
    for type in counts
      if type[0]
        output = output + type[1] + ' ' + type[2] + delimiter
    @text output.substr(0, output.length - delimiter.length)

  getCurrentText: (editor) =>
    selection = editor.getSelectedText()
    if selection
      @addClass @CSS_SELECTED_CLASS
    else
      @removeClass @CSS_SELECTED_CLASS
    text = editor.getText()
    selection || text

  count: (text) ->
    lines = @countLines text
    words = @countWords text
    chars = @countChars text
    [lines, words, chars]

  countLines: (text) ->
    if atom.config.get('counter.countLines')
      [true, text?.split('\n').length || 0, 'L']
    else
      [false, false, false]

  countWords: (text) ->
    if atom.config.get('counter.countWords')
      [true, text?.match(/\S+/g)?.length || 0, 'W']
    else
      [false, false, false]

  countChars: (text) ->
    if atom.config.get('counter.countChars')
      [true, text?.length || 0, 'C']
    else
      [false, false, false]
