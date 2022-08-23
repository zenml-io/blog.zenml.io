var args = process.argv.slice(2);

var json = JSON.stringify(args[0].replace(/\\n/g, "\n"));

console.log(json);
