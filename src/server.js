const http = require('http')

const port = process.env.PORT // access port from environment variable from Dockerfile
const fake_db = "fake db. just go with it"

http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain' })
  res.end('Docker example\n')
}).listen(port, () => {
  console.log(`Listening on port ${port}`)
})
