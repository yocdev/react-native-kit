const assert = require("node:assert/strict")
const test = require("node:test")

const { appendCommand, config, state } = require("../src/index")

test("log buffer evicts oldest commands when the byte budget is exceeded", () => {
  const originalByteLimit = config.bufferByteLimit
  const originalLimit = config.bufferLimit

  try {
    state.commands = []
    state.commandBytes = 0
    config.bufferLimit = 10
    config.bufferByteLimit = Number.MAX_SAFE_INTEGER

    appendCommand({ messageId: 1, type: "log", payload: { message: "first" } })
    config.bufferByteLimit = state.commandBytes + 10
    appendCommand({ messageId: 2, type: "log", payload: { message: "second" } })

    assert.deepEqual(state.commands.map((command) => command.messageId), [2])
    assert.ok(state.commandBytes <= config.bufferByteLimit)
  } finally {
    state.commands = []
    state.commandBytes = 0
    config.bufferLimit = originalLimit
    config.bufferByteLimit = originalByteLimit
  }
})
