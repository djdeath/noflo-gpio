noflo = require 'noflo'
gpio = require 'gpio'

class Out extends noflo.Component
  description: 'A GPIO output'
  icon: 'sign-out'
  constructor: ->
    @inPorts =
      port: new noflo.Port 'number'
      value: new noflo.Port 'number'

    @inPorts.port.on 'data', (portNumber) =>
      @stopGpio()
      @portNumber = portNumber
      @startGpio()

    @inPorts.value.on 'data', (value) =>
      @setValue(value)

  setValue: (value) ->
    return unless @gpio
    @gpio.set(value)

  stopGpio: () ->
    return unless @gpio
    @gpio.unexport()
    delete @gpio

  startGpio: () ->
    return unless @portNumber
    @gpio = gpio.export(@portNumber, { direction: 'out' })

  shutdown: () ->
    @stopGpio()

exports.getComponent = -> new Out