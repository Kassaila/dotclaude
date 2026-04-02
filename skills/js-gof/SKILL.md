---
name: js-gof
description:
  Apply Gang of Four and related design patterns in JavaScript/TypeScript. Use when implementing
  creational, structural, or behavioral patterns, or when the user mentions factory, builder,
  singleton, adapter, proxy, decorator, observer, strategy, command, state, mediator, iterator, or
  any other GoF pattern.
---

# GoF Patterns (JavaScript)

## Principles

- Use structural composition over inheritance
- Use multiparadigm code and contract-programming
- Use domain-specific languages (DSLs), prefer declarative way
- Separate and do not mix system and domain code
- Use GRASP and SOLID principles; especially reduce coupling
- Remember about referential transparency
- Prefer platform-agnostic code
- Implement isolation and layer borders with IoC & DI
- Use object/Map lookup for Strategy and polymorphic/dynamic dispatch
- Keep patterns simple — do not over-engineer for the sake of a pattern name

## Pattern references

Load the relevant reference when the user needs a specific pattern:

### Creational

- **Abstract Factory** — see `references/creational.md`. Creates related objects belonging to one
  family without specifying their concrete classes.
- **Builder** — see `references/creational.md`. Step-by-step assembly of a complex configurable
  object, often using chaining.
- **Factory / Factory Method** — see `references/creational.md`. Function or method that creates
  objects; Factory Method chooses the correct abstraction via dispatch.
- **Prototype** — see `references/creational.md`. Creates objects by cloning a prepared instance to
  save resources.
- **Flyweight** — see `references/creational.md`. Saves memory by sharing common state among
  multiple instances.
- **Singleton** — see `references/creational.md`. Global access to a single instance; often
  implemented via ESM/CJS module caching.
- **Object Pool** — see `references/creational.md`. Reuses pre-created objects to save resources
  during frequent creation and destruction.

### Structural

- **Adapter** — see `references/structural.md`. Converts an incompatible interface into a compatible
  one.
- **Wrapper** — see `references/structural.md`. Function wrapper that delegates calls and adds
  behavior; a specialized case of Adapter.
- **Boxing** — see `references/structural.md`. Wraps primitives into object types to add methods or
  unify interfaces (Value-Object).
- **Decorator** — see `references/structural.md`. Dynamically extends behavior without inheritance,
  typically via composition.
- **Proxy** — see `references/structural.md`. Controls access to an object by intercepting calls,
  reads, and writes.
- **Bridge** — see `references/structural.md`. Separates two or more abstraction hierarchies via
  composition, allowing them to evolve independently.
- **Composite** — see `references/structural.md`. Implements a common interface to uniformly handle
  individual objects and their tree structures.
- **Facade** — see `references/structural.md`. Simplifies access to a complex system, providing a
  unified interface.
- **Context** — see `references/structural.md`. Exchanges state and dependencies between components
  without tightly coupling them.

### Behavioral

- **Chain of Responsibility** — see `references/behavioral.md`. Passes a request along a chain of
  handlers until one processes it.
- **Command** — see `references/behavioral.md`. Encapsulates a request as an object, enabling
  undo/redo, queuing, and logging.
- **Iterator** — see `references/behavioral.md`. Provides sequential access to elements without
  exposing the underlying structure.
- **Mediator** — see `references/behavioral.md`. Centralizes communication between objects, reducing
  direct dependencies.
- **Memento** — see `references/behavioral.md`. Captures and restores an object's state without
  exposing its internals.
- **Observer** — see `references/behavioral.md`. Notifies dependents of state changes via
  EventEmitter/EventTarget.
- **State** — see `references/behavioral.md`. Alters behavior when internal state changes, avoiding
  conditional branching.
- **Strategy** — see `references/behavioral.md`. Defines interchangeable algorithms selected at
  runtime via object/Map lookup.
- **Template Method** — see `references/behavioral.md`. Defines an algorithm skeleton with
  customizable steps.
- **Visitor** — see `references/behavioral.md`. Adds operations to objects without modifying their
  classes.
- **Revealing Constructor** — see `references/behavioral.md`. Exposes privileged capabilities only
  during construction.

## Sources

- [HowProgrammingWorks](https://github.com/HowProgrammingWorks) — pattern repositories with
  JavaScript examples
