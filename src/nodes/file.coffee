Path  = require 'path'
Class = require './class'

# The file class is a `fake` class that wraps the
# file body to capture top-level assigned methods.
#
module.exports = class File extends Class

  # Construct a File
  #
  # @param [Object] node the class node
  # @param [String] the filename
  # @param [Object] options the parser options
  #
  constructor: (@node, @fileName, @options) ->
    super @node, @fileName, @options

  # Get the full file name with path
  #
  # @return [String] the file name with path
  #
  getFullName: ->
    fullName = @fileName

    for input in @options.inputs
      input = input.replace(///^\.[\/]///, '')                        # Clean leading `./`
      input = input + Path.sep unless ///#{ Path.sep }$///.test input # Append trailling `/`
      input = input.replace(/([.?*+^$[\]\\(){}|-])/g, "\\$1")         # Escape String
      fullName = fullName.replace(new RegExp(input), '')

    fullName.replace(Path.sep, '/')

  # Returns the file class name
  #
  # @return [String] the file name without path
  #
  getFileName: ->
    Path.basename @getFullName()

  # Get the file path
  #
  # @return [String] the file path
  #
  getPath: ->
    path = Path.dirname @getFullName()
    path = '' if path is '.'
    path

  # Test if the file doesn't contain any top-level
  # methods and variables.
  #
  # @return [Boolean] true if empty
  #
  isEmpty: ->
    @getMethods().length is 0 and @getVariables.length is 0

  # Get a JSON representation of the object
  #
  # @return [Object] the JSON object
  #
  toJSON: ->
    json =
      file: @getFileName()
      path: @getPath()
      methods: []
      variables: []

    for method in @getMethods()
      json.methods.push method.toJSON()

    for variable in @getVariables()
      json.variables.push variable.toJSON()

    json
