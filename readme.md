# BrightWebSocket

A ScreneGraph websocket client library written in BrightScript. It is written to work in a separate task to not affect the main thread of the application.

Many thanks to [rolandoislas/BrightWebSocket](https://github.com/rolandoislas/BrightWebSocket) who originally developed this library.

# RFC 6455

Follows [RFC 6455](https://tools.ietf.org/html/rfc6455)

Notes:

- Uses ASCII instead of UTF-8 for string operations
- Does not support secure web sockets at this time

# Installation

The contents of the "src" folder in the repository's root should be placed
 in the "components" folder of a SceneGraph Roku app.
 
# Using the Library

The client follows the 
 [HTML WebSocket interface](https://html.spec.whatwg.org/multipage/web-sockets.html#the-websocket-interface), 
 modified to work with BrightScript conventions. Those familiar with browser
 (JavaScript) WebSocket implementations should find this client similar.

Example:

```brightscript
function init() as void
    m.ws = createObject("roSGNode", "WebSocketClient")
    m.ws.observeField("on_open", "on_open")
    m.ws.observeField("on_message", "on_message")
    m.ws.open = "ws://echo.websocket.org/"
end function

function on_open(event as object) as void
    m.ws.send = ["Hello World"]
end function

function on_message(event as object) as void
    print event.getData().message
end function
```

For a working sample app see the "test" folder. Its contents can be zipped for
 installation as a dev channel on a Roku.
 
# Additional information

## A differences between `roUrlTransfer` and `roStreamSocket`

The `roUrltransfer` is sending larger data faster, Roku replied to this with the following:
> Could be the difference between using curlLibrary and lower-level roStreamSocket implementation. The curl library is highly optimized as we use it for all the manifest handling in streaming.

The `roStreamSocket` is separated into standalone thread but still is serialized, devices handling a higher amount of data could overload a buffer for some situations and data could send for longer. 

We approximately measured _230KB/s_ on **4660X - Roku Ultra** and _15KB/s_ on **3500EU - Roku Stick**.

To send larger amount of data we suggest to use `roUrlTransfer` instead. Won't be improved/fixed in near future.

# License

The MIT License. See license.txt.
