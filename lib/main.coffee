CounterView = require './counter-view'
view = null
tile = null

module.exports =
  config:
    countLines:
      title: 'Count lines'
      type: 'boolean'
      default: true
      order: 1
    countWords:
      title: 'Count words'
      type: 'boolean'
      default: true
      order: 2
    countChars:
      title: 'Count characters'
      type: 'boolean'
      default: true
      order: 3
    includeWhitespace:
      title: 'Include whitespace'
      description: 'This affects the character count'
      type: 'boolean'
      default: true
      order: 4
    delimiter:
      title: 'Delimiter'
      description: 'Denfines what will separate the counters'
      type: 'string'
      default: ' | '
      order: 5
    extensions:
      title: 'Disabled file extensions'
      description: 'List of file extenstions which should not have this plugin
        enabled'
      type: 'array'
      default: []
      items:
        type: 'string'
      order: 6

  activate: (state) ->
    view = new CounterView()

    atom.workspace.observeTextEditors (editor) ->
      editor.onDidChange -> view.updateCount editor
      editor.onDidChangeSelectionRange -> view.updateCount editor

    atom.workspace.onDidChangeActivePaneItem @showOrHide
    console.log atom.config

    @showOrHide atom.workspace.getActivePaneItem()

  showOrHide: (item) ->
    extensions = (atom.config.get('counter.extensions') || [])
      .map (extension) -> extension.toLowerCase()
    currentFileExtension = item?.buffer?.file?.path.split('.').pop()
      .toLowerCase()

    isEditable =
      typeof item != 'undefined' and typeof item.displayBuffer != 'undefined'

    if currentFileExtension in extensions or not isEditable
      view.css("display", "none")
    else
      view.css("display", "inline-block")
      view.updateCount item

  consumeStatusBar: (statusBar) ->
    tile = statusBar.addRightTile(item: view, priority: 100)

  deactivate: ->
    tile?.destroy()
    tile = null
