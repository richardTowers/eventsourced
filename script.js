(function () {
var outputElem = document.getElementById('output'),
  exampleLines = [
    { delay: 0,    text: 'PING example.com (93.184.216.34): 56 data bytes' },
    { delay: 1000, text: '64 bytes from 93.184.216.34: icmp_seq=0 ttl=50 time=87.191 ms' },
    { delay: 1000, text: '64 bytes from 93.184.216.34: icmp_seq=1 ttl=50 time=85.325 ms' },
    { delay: 1000, text: '64 bytes from 93.184.216.34: icmp_seq=2 ttl=50 time=87.945 ms' },
    { delay: 1000, text: '64 bytes from 93.184.216.34: icmp_seq=3 ttl=50 time=87.716 ms' },
    { delay: 1000, text: '64 bytes from 93.184.216.34: icmp_seq=4 ttl=50 time=85.036 ms' },
    { delay: 1000, text: '64 bytes from 93.184.216.34: icmp_seq=5 ttl=50 time=85.414 ms' },
    { delay: 1000, text: '64 bytes from 93.184.216.34: icmp_seq=6 ttl=50 time=87.364 ms' },
    { delay: 1000, text: '64 bytes from 93.184.216.34: icmp_seq=7 ttl=50 time=87.773 ms' },
    { delay: 1000, text: '64 bytes from 93.184.216.34: icmp_seq=8 ttl=50 time=88.323 ms' },
    { delay: 1000, text: '64 bytes from 93.184.216.34: icmp_seq=9 ttl=50 time=87.699 ms' },
    { delay: 0,    text: '' },
    { delay: 0,    text: '--- example.com ping statistics ---' },
    { delay: 0,    text: '10 packets transmitted, 10 packets received, 0.0% packet loss' },
    { delay: 0,    text: 'round-trip min/avg/max/stddev = 85.036/86.979/88.323/1.166 ms' },
  ],
  lineNumber = 0

function writeExampleLines () {
  var line = exampleLines[lineNumber++]
  if (line != null) {
    outputElem.appendChild(document.createTextNode(line.text + '\n'))
	setTimeout(writeExampleLines, line.delay)
  }
}
writeExampleLines()
}())

