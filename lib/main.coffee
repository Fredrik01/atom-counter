CounterView = require './counter-view'
view = null
tile = null

module.exports =
  # Config options
  config:
    extensions:
      title: 'Disabled file extensions'
      description: 'List of file extenstions which should not have this plugin
        enabled'
      type: 'array'
      default: []
      items:
        type: 'string'
    countLines:
      title: 'Count lines'
      type: 'boolean'
      default: true
    countWords:
      title: 'Count words'
      type: 'boolean'
      default: true
    countChars:
      title: 'Count characters'
      type: 'boolean'
      default: true
    includeWhitespace:
      title: 'Include whitespace'
      description: 'This affects the character count'
      type: 'boolean'
      default: true
    delimiter:
      title: 'Delimiter'
      description: 'Denfines what will separate the counters'
      type: 'string'
      default: ' | '

  activate: (state) ->
    view = new CounterView()

    atom.workspace.observeTextEditors (editor) ->
      editor.onDidChange -> view.updateCount editor
      editor.onDidChangeSelectionRange -> view.updateCount editor

    atom.workspace.onDidChangeActivePaneItem @showOrHide

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
