# AI Agent Directives for Morphogenesis Ruby Project

This file contains project guidelines and context that AI coding agents should follow when working
on this codebase.

## Project Overview

**Project Name:** Morphogenesis  
**Language:** Ruby  
**Goal:** Explore morphogenesis through cellular automata using object-oriented design principles.

The project is inspired by the following research papers:

> **CA-NEAT: Evolved Compositional Pattern Producing Networks for Cellular Automata
> Morphogenesis and Replication**  
> (Amos et al., GECCO 2018)

> **ARC-NCA: Towards Developmental Solutions to the Abstraction and Reasoning Corpus**  
> (TBD et al., May 2025)

A key concept explored in this project is the **French Flag Problem**.

## Core Principles

1. **Object-Oriented Design**  
   Use modular classes for cells, grids, patterns, and evolutionary operators.

2. **Extensibility**  
   Make it easy to add new automaton rules, fitness metrics, and mutation strategies.

3. **Test-Driven Development**  
   Write comprehensive tests using RSpec following BDD principles.

## Directory Structure

```
.
├── lib/       # Ruby source files
├── spec/      # RSpec test files
├── AGENTS.md  # AI agent directives (this file)
└── README.md  # Project overview and usage instructions
```

## Coding Standards

### Style and Formatting

- Use StandardRB for code formatting and style enforcement.
- Run `bundle exec standardrb` to check for style issues.
- Run `bundle exec standardrb --fix` to auto-fix issues before committing.
- Always use double quotes for strings in Ruby code.
- Add an empty line at the end of each file.
- Wrap lines in Markdown and plain text files at a maximum width of 100 characters.

### Testing with RSpec

- Use `RSpec.describe` for top-level example groups.
- Use `let` and `let!` to define test data and memoize it across examples.
- Use the `expect(...).to` syntax for assertions.
- Always use parentheses with `eq`: `expect(...).to eq(value)`.
- Use `aggregate_failures` when grouping multiple related expectations in one example.
- Run tests with `bundle exec rspec`.

### Git Workflow

- Commit early and often with clear, descriptive messages.
- Ensure all style checks and tests pass before committing.

## Working with This Codebase

When making changes to this project:

1. **Understand the context** by reading relevant tests and implementation files.
2. **Make minimal changes** - only modify what's necessary to accomplish the task.
3. **Write tests first** or ensure existing tests cover your changes.
4. **Run tests frequently** to catch issues early.
5. **Follow the existing code style** and patterns used in the project.
6. **Update documentation** if your changes affect the public API or behavior.

---
*This file provides guidance for AI coding agents. Keep it updated as project conventions evolve.*
