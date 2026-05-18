# Product

## User

React Native developers and AI coding agents working together on runtime debugging. The human user needs a fast macOS desktop surface for seeing app connection state, recent logs, search results, and MCP availability while an agent reads the same runtime context through MCP.

## Product Purpose

ReactKit captures React Native runtime signals, keeps a bounded local event buffer, exposes that context through MCP, and gives the user a lightweight native viewer for app connections and logs.

## Brand Personality

Calm, precise, lightweight. The interface should feel native and quiet, with a more polished and modern desktop experience than the legacy reference app.

## Anti-references

Do not recreate the old Electron reference look: heavy monospaced labels everywhere, gray utility chrome, dense icon rail as the main visual identity, and low-contrast empty states. Do not chase full feature parity in v1.

## Design Principles

- Make runtime status immediately visible.
- Keep the first screen useful without setup ceremony.
- Use one polished visual system across connection, timeline, and MCP surfaces.
- Prefer scan-friendly log density over decorative dashboards.
- Let AI-facing features feel built in, not bolted on.

## Accessibility & Inclusion

Target WCAG AA contrast for text and controls. Use system typography, visible focus states, non-color status labels, and restrained motion that respects reduced-motion settings.
