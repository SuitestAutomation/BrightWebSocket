' This source file is the entry point for the application and is not required
' to use the library. See readme.md for more info.

' Entry point for the application
function main(args as dynamic) as void
    screen = createObject("roSGScreen")
    port = createObject("roMessagePort")
    screen.setMessagePort(port)
    scene = screen.createScene("Main")
    screen.show()
    scene.setFocus(true)
    scene.backExitsScene = false
    while true
        msg = wait(0, port)
        if type(msg) = "roSGScreenEvent" and msg.isScreenClosed()
            return
        end if
    end while
end function

' Entry point for the main scene
function init() as void
    m.ws = createObject("roSGNode", "WebSocketClient")
    m.ws.observeField("on_open", "on_open")
    m.ws.observeField("on_close", "on_close")
    m.ws.observeField("on_message", "on_message")
    m.ws.observeField("on_error", "on_error")
    m.ws.protocols = []
    m.ws.headers = []
    m.ws.log_level = "INFO"
    m.SERVER = "ws://echo.websocket.org/"
    m.ws.open = m.SERVER
    m.reinitialize = false
end function

' Key events
function onKeyEvent(key as string, press as boolean) as boolean
    if key = "back" and press
        print "Closing websocket"
        m.ws.close = [1000, "optional"]
    else if key = "OK" and press
        print "Reinitializing websocket"
        if m.ws.ready_state <> m.ws.STATE_CLOSED
            m.ws.close = []
            m.reinitialize = true
        else
            m.ws.open = m.SERVER
        end if
    end if
end function

' Socket open event
function on_open(event as object) as void
    print "WebSocket opened"
    print tab(2)"Protocol: " + event.getData().protocol
    send_test_data()
end function

' Send test data to the websocket
function send_test_data() as void
    print "Sending string: test string"
    m.ws.send = ["test string"]
    test_binary = []
    for bin = 0 to 3
        test_binary.push(bin)
    end for
    print "Sending data: 00010203"
    m.ws.send = [test_binary]
end function

' Socket close event
function on_close(event as object) as void
    print "WebSocket closed"
    if m.reinitialize
        m.ws.open = m.SERVER
        m.reinitialize = false
    end if
end function

' Socket message event
function on_message(event as object) as void
    message = event.getData().message
    if type(message) = "roString"
        print "WebSocket text message: " + message
    else
        ba = createObject("roByteArray")
        for each byte in message
            ba.push(byte)
        end for
        print "WebSocket binary message: " + ba.toHexString()
    end if
end function

' Socket Error event
function on_error(event as object) as void
    print "WebSocket error"
    print event.getData()
end function
