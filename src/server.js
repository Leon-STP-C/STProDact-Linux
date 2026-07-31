const http = require('http')

const port = process.env.PORT || 9000
const fake_db = "fake db. jost go with it"

http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain' })
  res.end('Terrible Docker example\n')
}).listen(port, () => {
  console.log(`Unfortunately listening on port ${port}`)
})
