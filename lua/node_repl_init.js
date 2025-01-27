const repl = require("repl");
const util = require("util");

// Better object inspection
const inspect = (obj) =>
  util.inspect(obj, {
    colors: true,
    depth: 6,
    maxArrayLength: 100,
    showHidden: false,
    showProxy: true,
  });

// Create REPL instance
const replServer = repl.start({
  prompt: "\x1b[33m→\x1b[0m ", // Yellow arrow prompt
  useColors: true,
  useGlobal: true,
  history: process.env.NODE_REPL_HISTORY,
  writer: (output) => {
    if (typeof output === "object" && output !== null) {
      return inspect(output);
    }
    return util.inspect(output, { colors: true });
  },
  ignoreUndefined: true, // Don't print undefined results
});

// Add some useful globals
replServer.context.inspect = inspect;

// Better error handling
replServer.on("error", (err) => {
  console.error("\x1b[31m%s\x1b[0m", err.message);
});

// Welcome message
console.log("\x1b[36m%s\x1b[0m", "🚀 Node.js REPL with enhanced formatting");
console.log("\x1b[90m%s\x1b[0m", `Node ${process.version}`);
