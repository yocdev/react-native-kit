const assert = require("node:assert/strict")
const test = require("node:test")

const {
  connectionTargetKey,
  state,
  upsertConnection,
  visibleConnections,
} = require("../src/index")

function resetConnections() {
  state.connections.clear()
}

test("connectionTargetKey ignores volatile socket address changes", () => {
  const baseConnection = {
    name: "HugoAivApp",
    platform: "ios",
    platformVersion: "18.7.9",
    osRelease: "18.7.9",
    systemName: "iOS",
    model: "iPhone",
    screenWidth: 393,
    screenHeight: 852,
    screenScale: 3,
    userAgent: null,
  }

  assert.equal(
    connectionTargetKey({ ...baseConnection, address: "::ffff:127.0.0.1:61234" }),
    connectionTargetKey({ ...baseConnection, address: "::ffff:127.0.0.1:61235" })
  )
})

test("upsertConnection replaces stale entries for the same device target", () => {
  resetConnections()

  upsertConnection({
    id: 1,
    clientId: "old-client",
    name: "HugoAivApp",
    platform: "ios",
    platformVersion: "18.7.9",
    osRelease: "18.7.9",
    systemName: "iOS",
    model: "iPhone",
    screenWidth: 393,
    screenHeight: 852,
    screenScale: 3,
    address: "::ffff:127.0.0.1:61234",
  }, false)

  upsertConnection({
    id: 2,
    clientId: "new-client",
    name: "HugoAivApp",
    platform: "ios",
    platformVersion: "18.7.9",
    osRelease: "18.7.9",
    systemName: "iOS",
    model: "iPhone",
    screenWidth: 393,
    screenHeight: 852,
    screenScale: 3,
    address: "::ffff:127.0.0.1:61235",
  }, true)

  const connections = visibleConnections()

  assert.equal(connections.length, 1)
  assert.equal(connections[0].clientId, "new-client")
  assert.equal(connections[0].connected, true)
})

test("visibleConnections hides disconnected entries until they reconnect", () => {
  resetConnections()

  upsertConnection({
    id: 1,
    clientId: "offline-client",
    name: "HugoAivApp",
    platform: "ios",
    platformVersion: "18.7.9",
  }, false)

  assert.deepEqual(visibleConnections(), [])
  assert.equal(state.connections.size, 0)

  upsertConnection({
    id: 2,
    clientId: "android-client",
    name: "HugoAivApp",
    platform: "android",
    platformVersion: "34",
  }, true)

  const connections = visibleConnections()
  assert.equal(connections.length, 1)
  assert.equal(connections[0].clientId, "android-client")
})
