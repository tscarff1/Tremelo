source = new EventSource('/notifications')

source.onmessage = (event) ->
    console.log event.data