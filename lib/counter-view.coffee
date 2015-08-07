{View} = require 'atom-space-pen-views'

module.exports =
class CounterView extends View
  cssSelectedClass: 'counter-select'

  @content: ->
    @div class: 'counter inline-block'

  updateCount: (@editor) ->
    @isSelection = @checkIfSelection()
    @addOrRemoveSelectionClass()
    @selections = @editor.getSelections()
    @output()

  output: (str = '') ->
    delimiter = atom.config.get('counter.delimiter')
    for type in [@countLines(), @countWords(), @countChars()]
      if type[0]
        str = str + type[1] + ' ' + type[2] + delimiter
    @text str.substr(0, str.length - delimiter.length)

  addOrRemoveSelectionClass: ->
    if @isSelection
      @addClass @cssSelectedClass
    else
      @removeClass @cssSelectedClass

  checkIfSelection: ->
    if @editor.getSelectedText() then true else false

  getCurrentText: (delimiter = '') ->
    if @isSelection
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

  removeWhitespace: (str) ->
    str.replace(/\s/g, '')

  countLinesInSelections: ->
    numberOfLines = 0
    for selection in @selections
      range = selection.getScreenRange()
      numberOfLines += range.getRowCount()
    numberOfLines

  countLinesInDocument: ->
    @editor.getLineCount()

  countLinesInDocumentOrSelections: ->
    if @isSelection
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
      if not atom.config.get 'counter.includeWhitespace'
        text = @removeWhitespace text
      [true, text?.length || 0, 'C']
    else
      [false, false, false]
