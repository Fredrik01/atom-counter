{View} = require 'atom-space-pen-views'

module.exports =
class CounterView extends View
  cssSelectedClass: 'counter-select'

  @content: ->
    @div class: 'counter inline-block'

  updateCount: (@editor) ->
    @addOrRemoveSelectionClass()
    delimiter = atom.config.get('counter.delimiter')
    @selections = @editor.getSelections()
    counts = [@countLines(), @countWords(), @countChars()]
    output = ''
    for type in counts
      if type[0]
        output = output + type[1] + ' ' + type[2] + delimiter
    @text output.substr(0, output.length - delimiter.length)

  addOrRemoveSelectionClass: ->
    if @isSelection()
      @addClass @cssSelectedClass
    else
      @removeClass @cssSelectedClass

  isSelection: ->
    if @editor.getSelectedText() then true else false

  getCurrentText: (delimiter = '') ->
    if @isSelection()
      @getTextInSelections(delimiter)
    else
      @getTextInDocument()

  getTextInSelections: (delimiter) ->
    text = ''
    for selection in @selections
      text += selection.getText() + delimiter
    text

  getTextInDocument: ->
    @editor.getText()

  countLinesInSelections: ->
    numberOfLines = 0
    for selection in @selections
      range = selection.getScreenRange()
      numberOfLines += range.getRowCount()
    numberOfLines

  countLinesInDocument: ->
    @editor.getLineCount()

  countLinesInDocumentOrSelections: ->
    if @isSelection()
      @countLinesInSelections()
    else
      @countLinesInDocument()

  countLines: ->
    if atom.config.get('counter.countLines')
      [true, @countLinesInDocumentOrSelections() || 0, 'L']
    else
      [false, false, false]

  countWords: ->
    if atom.config.get('counter.countWords')
      text = @getCurrentText(' ')
      [true, text?.match(/\S+/g)?.length || 0, 'W']
    else
      [false, false, false]

  countChars: ->
    if atom.config.get('counter.countChars')
      text = @getCurrentText()
      [true, text?.length || 0, 'C']
    else
      [false, false, false]
