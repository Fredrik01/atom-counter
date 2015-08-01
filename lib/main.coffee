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
    delimiter:
      title: 'Delimiter'
      description: 'Denfines what will separate the counters'
      type: 'string'
      default: ' | '

  activate: (state) ->
    view = new CounterView()

    atom.workspace.observeTextEditors (editor) ->
      editor.onDidChange -> view.update_count editor
      editor.onDidChangeSelectionRange -> view.update_count editor

    atom.workspace.onDidChangeActivePaneItem @show_or_hide_for_item

    @show_or_hide_for_item atom.workspace.getActivePaneItem()

  show_or_hide_for_item: (item) ->
    extensions = (atom.config.get('counter.extensions') || [])
      .map (extension) -> extension.toLowerCase()
    current_file_extension = item?.buffer?.file?.path.split('.').pop()
      .toLowerCase()

    if current_file_extension in extensions
      view.css("display", "none")
    else
      view.css("display", "inline-block")

  consumeStatusBar: (statusBar) ->
    tile = statusBar.addRightTile(item: view, priority: 100)

  deactivate: ->
    tile?.destroy()
    tile = null
