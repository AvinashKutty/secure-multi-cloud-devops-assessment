const http = require("http");

const server = http.createServer((req, res) => {
  res.writeHead(200, { "Content-Type": "application/json" });
  res.end(JSON.stringify({ prediction: "dummy-value" }));
});

server.listen(5000, "0.0.0.0", () => {
  console.log("ML API running on port 5000");
});
