counter = require '../lib/main'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "counter", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    activationPromise = atom.packages.activatePackage('atomCounter')

  describe "when the counter:activate event is triggered", ->
    it "attaches and then detaches the view", ->
      expect(atom.workspaceView.find('.counter')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.workspaceView.trigger 'counter:activate'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspaceView.find('.counter')).toExist()
        atom.workspaceView.trigger 'counter:activate'
        expect(atom.workspaceView.find('.counter')).not.toExist()
