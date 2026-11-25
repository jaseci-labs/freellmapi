// imp.mts <server-dir>: import the server's app module graph, print the ms it took, exit.
const t0 = performance.now();
await import(process.argv[2] + '/src/app.ts');
console.log((performance.now() - t0).toFixed(0));
process.exit(0);
