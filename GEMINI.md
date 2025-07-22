# Gemini Directive for Morphogenesis Ruby Project

This file contains the project description and guidelines that Gemini
should load on each session startup.

## Project Overview

Project Name: Morphogenesis
Language: Ruby
Goal: Explore morphogenesis with cellular automata in an object-oriented style.

The project is inspired by the following papers:

> **CA-NEAT: Evolved Compositional Pattern Producing Networks for Cellular
> Automata Morphogenesis and Replication**
> (Amos et al., GECCO 2018)

> **ARC-NCA: Towards Developmental Solutions to the Abstraction and Reasoning Corpus**
> (TBD et al., May 2025)

A key concept to explore is the **French Flag Problem**.

## Core Principles

1. **Object-Oriented Design**
   - Modular classes for cells, grids, patterns, and evolutionary operators.
2. **Extensibility**
   - Easy to add new automaton rules, fitness metrics, and mutation strategies.
3. **TDD/BDD-style Testing**
   - Use RSpec for behavior-driven development.

## Directory Structure

```
.
├── lib/      # Ruby source files
├── spec/     # RSpec test files
├── GEMINI.md # Gemini startup directives
└── README.md # Project overview and usage instructions
```

## Coding & Testing Guidelines

1.  Use StandardRB for Ruby code formatting and style enforcement.
    Run style checks (`bundle exec standardrb`) and auto-fix issues
    (`bundle exec standardrb --fix`) before committing.
2.  Write tests using RSpec.
    - Use `RSpec.describe` for top-level example groups.
    - Use `let` and `let!` to define test data and memoize it across examples.
    - Use the `expect(...).to` syntax for assertions.
3.  Run tests with `bundle exec rspec`.
4.  Commit early and often with clear messages, ensuring style checks
    and tests pass before push.

## File Formatting Requirement

All Markdown and plain text files in this project **must** wrap lines at a maximum width of 100
characters.

---
*End of Gemini configuration. Do not modify without updating Gemini context.*
