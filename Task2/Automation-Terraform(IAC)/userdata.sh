#!/bin/bash
yum update -y
yum install -y nodejs npm

cat <<EOF > app.js
const http = require('http');
const os = require('os');

const server = http.createServer((req, res) => {
  res.end("Hello from " + os.hostname());
});

server.listen(3000);
EOF

node app.js &