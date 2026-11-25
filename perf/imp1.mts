// imp1.mts <server-dir> <module>: ms to import one server module (and all it drags in).
const t0 = performance.now();
await import(process.argv[2] + '/src/' + process.argv[3]);
const ms = performance.now() - t0;
console.log(ms.toFixed(0));
process.exit(0);
