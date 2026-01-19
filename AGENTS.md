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

### Five Lines of Code Rules

This project follows principles from *Five Lines of Code* by Christian Clausen. These rules guide
refactoring decisions and help maintain clean, maintainable code.

#### 1. Five Lines Rule

Methods should be no longer than five lines of code (excluding braces/end keywords). This forces
extraction of smaller, focused methods.

```ruby
# Bad
def process_cell(cell)
  if cell.alive?
    neighbors = grid.neighbors_of(cell)
    live_count = neighbors.count(&:alive?)
    if live_count < 2 || live_count > 3
      cell.die
    end
  else
    neighbors = grid.neighbors_of(cell)
    if neighbors.count(&:alive?) == 3
      cell.revive
    end
  end
end

# Good
def process_cell(cell)
  cell.alive? ? apply_survival_rules(cell) : apply_birth_rules(cell)
end

def apply_survival_rules(cell)
  cell.die unless survives?(cell)
end

def apply_birth_rules(cell)
  cell.revive if born?(cell)
end
```

#### 2. Either Call or Pass

A function should either call methods on an object or pass it to other functions, not both. This
maintains consistent levels of abstraction.

```ruby
# Bad
def update_grid(grid)
  grid.each_cell do |cell|
    cell.update_state
  end
  renderer.draw(grid)
end

# Good
def update_grid(grid)
  update_all_cells(grid)
  render(grid)
end
```

#### 3. If Only at the Start

Put conditional checks at the beginning of functions as guard clauses.

```ruby
# Bad
def mutate(genome)
  result = genome.dup
  if should_mutate?
    result.genes.each { |g| g.randomize }
  end
  result
end

# Good
def mutate(genome)
  return genome.dup unless should_mutate?

  genome.dup.tap { |g| g.genes.each(&:randomize) }
end
```

#### 4. Never Use If with Else

Distinguish between **checks** and **decisions**:

- **Checks** (guards): Handle edge cases at the start and return early. These are acceptable.
- **Decisions**: Choose between two equally valid paths. These need careful consideration -
  simply converting to early returns doesn't address the underlying design issue.

```ruby
# Check (acceptable) - guard clause handles edge case
def mutate(genome)
  return genome.dup unless should_mutate?

  apply_mutations(genome)
end

# Decision (needs consideration) - choosing between two valid outcomes
def cell_symbol(cell)
  if cell.alive?
    "#"
  else
    "."
  end
end

# Note: Converting a decision to early return is only cosmetic:
def cell_symbol(cell)
  return "#" if cell.alive?

  "."
end
# This is still a decision. Consider whether the design could be improved
# (e.g., polymorphism, lookup tables, or other approaches).
```

#### 5. Never Use Switch/Case

Replace case statements with polymorphism. Each case branch often indicates a missing class.

```ruby
# Bad
def apply_rule(rule_type, cell)
  case rule_type
  when :conway then apply_conway(cell)
  when :highlife then apply_highlife(cell)
  when :seeds then apply_seeds(cell)
  end
end

# Good - use polymorphism
class ConwayRule
  def apply(cell) = # ...
end

class HighlifeRule
  def apply(cell) = # ...
end

rule.apply(cell)
```

#### 6. Only Inherit from Interfaces

Prefer composition over inheritance. When using inheritance, inherit from abstract classes or
modules that define interfaces.

```ruby
# Bad
class EnhancedGrid < Grid
  # Inherits implementation details
end

# Good
module Renderable
  def render
    raise NotImplementedError
  end
end

class Grid
  include Renderable

  def render = # ...
end
```

#### 7. Never Have Common Affixes

Don't prefix or suffix related classes with the same word. This often indicates a missing
abstraction.

```ruby
# Bad
class CellRenderer
class GridRenderer
class PatternRenderer

# Good - extract a Renderer abstraction
class Renderer
  def render(renderable) = # ...
end
```

#### 8. No Getters/Setters on Non-Data Classes

Push behavior to the class that owns the data. Data classes can have accessors; behavior classes
should not expose their internals.

```ruby
# Bad
class Cell
  attr_accessor :state

  # Caller does: cell.state = :alive if cell.state == :dead
end

# Good
class Cell
  def revive
    @state = :alive
  end

  def die
    @state = :dead
  end

  def alive?
    @state == :alive
  end
end
```

#### 9. Use Primitives Only in Data Classes

Wrap primitives in domain objects for non-data classes. This provides type safety and a place for
related behavior.

```ruby
# Bad
def set_position(x, y)
  @x = x
  @y = y
end

# Good
class Position
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def neighbors
    # Position knows how to find its neighbors
  end
end

def set_position(position)
  @position = position
end
```

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
