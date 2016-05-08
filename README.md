eventsourced
==============

`eventsourced` streams stdin to a TCP/IP port as `text/event-source`.

On the server:

```
$ ping example.com | eventsourced --port=1337 --allow-origin=localhost
```

In the browser:

```
> new EventSource('http://0.0.0.0:1337').onmessage = e => console.log(e.data)
  PING example.com (93.184.216.34): 56 data bytes
  64 bytes from 93.184.216.34: icmp_seq=0 ttl=50 time=86.586 ms
  64 bytes from 93.184.216.34: icmp_seq=1 ttl=50 time=89.107 ms
  64 bytes from 93.184.216.34: icmp_seq=2 ttl=50 time=88.805 ms
  64 bytes from 93.184.216.34: icmp_seq=3 ttl=50 time=88.843 ms
  64 bytes from 93.184.216.34: icmp_seq=4 ttl=50 time=89.181 ms
  64 bytes from 93.184.216.34: icmp_seq=5 ttl=50 time=89.159 ms
  64 bytes from 93.184.216.34: icmp_seq=6 ttl=50 time=87.214 ms
  ...
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
