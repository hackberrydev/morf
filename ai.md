# AI Directive for Morphogenesis Ruby Project

This file contains the project description and guidelines that OpenAI Codex
should load on each session startup.

## Project Overview

Project Name: Morphogenesis
Language: Ruby
Goal: Explore morphogenesis with cellular automata in an object-oriented style.

Inspired by the following paper as a key inspiration:
> **CA-NEAT: Evolved Compositional Pattern Producing Networks for Cellular
> Automata Morphogenesis and Replication**
> (Amos et al., GECCO 2018)

## Core Principles

1. **Object-Oriented Design**
   - Modular classes for cells, grids, patterns, and evolutionary operators.
2. **Extensibility**
   - Easy to add new automaton rules, fitness metrics, and mutation strategies.
3. **BDD-style Testing**
   - Use Minitest with spec-style syntax for behavior-driven development.

## Directory Structure

```
.
├── lib/      # Ruby source files
├── test/     # Minitest BDD test files
├── ai.md     # Codex startup directives
└── README.md # Project overview and usage instructions
```

## Coding & Testing Guidelines

1. Use StandardRB for Ruby code formatting and style enforcement.
   Run style checks (`bundle exec standardrb`) and auto-fix issues
   (`bundle exec standardrb --fix`) before committing.
2. Write tests using Minitest/spec syntax:
   ```ruby
   describe Cell do
     it "initializes with a state" do
       ...
     end
   end
   ```
3. Run tests with `bundle exec rake test`.
4. Commit early and often with clear messages, ensuring style checks
   and tests pass before push.

## File Formatting Requirement

All Markdown and plain text files in this project **must** wrap lines at a maximum width of 100
characters.

---
*End of AI configuration. Do not modify without updating Codex context.*
