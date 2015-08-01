{View} = require 'atom-space-pen-views'

module.exports =
class CounterView extends View
  CSS_SELECTED_CLASS: 'counter-select'

  @content: ->
    @div class: 'counter inline-block'

  update_count: (editor) ->
    text = @getCurrentText editor
    [lineCount, wordCount, charCount] = @count text
    @text("#{lineCount || 0} L | #{wordCount || 0} W | #{charCount || 0} C")

  getCurrentText: (editor) =>
    selection = editor.getSelectedText()
    if selection
      @addClass @CSS_SELECTED_CLASS
    else
      @removeClass @CSS_SELECTED_CLASS
    text = editor.getText()
    selection || text

  count: (text) ->
    lines = text?.split('\n').length
    words = text?.match(/\S+/g)?.length
    chars = text?.length
    [lines, words, chars]
