eventsourced
==============

`eventsourced` streams stdin to a TCP/IP port as `text/event-source`.

On the server:

```
$ ping example.com | eventsourced --port 1337
```

In the browser:

```
new EventSource("http://0.0.0.0:1337/").onmessage = e => console.log(e.data)
```

Inspiration
-----------

This is similar in spirit to [joewalnes/websocketd](https://github.com/joewalnes/websocketd/), but instead of duplex communication it is boradcast only.

It was inspired by this post https://medium.com/@joewalnes/tail-f-to-the-web-browser-b933d9056cc

> Ever wanted to pipe “tail -f” to a web-page? Here’s a one liner…
> 
> ```
> $ (echo -e ‘HTTP/1.1 200 OK\nAccess-Control-Allow-Origin: *\nContent-type: text/event-stream\n’ && tail -f /path/to/some/file | sed -u -e ‘s/^/data: /;s/$/\n/’) | nc -l 1234
> ```

Which is super clever, but has some caveats:

> Should you use this?
Uhhh no, not really [...]
* it’ll only allow a single connection
* it starts tailing before the connection is received so if you’re not expecting a connection for a while it’ll eat memory
* there’s absolutely no authentication there

`eventsourced` attempts to address these issues.
