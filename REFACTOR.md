# Refactoring Checklist

This file lists all violations of the *Five Lines of Code* rules found in the codebase,
organized by priority (most impactful first).

---

## High Priority

These are severe violations that significantly impact readability and maintainability.

### Rule 1: Five Lines Rule - Severely Long Methods

- [ ] `lib/morf/experiments/neat/experiment.rb:37` - `run` method is 114 lines; orchestrates
      entire experiment lifecycle with multiple responsibilities
- [ ] `lib/morf/neat/reproduction/crossover.rb:19` - `reproduce` method is 45 lines; complex
      multi-step gene alignment and crossover logic
- [ ] `lib/morf/neat/speciation.rb:25` - `distance` method is 43 lines; calculates genetic
      distance with complex gene matching logic
- [ ] `lib/morf/neat/mutation/add_connection.rb:15` - `call` method is 27 lines; contains loop
      with multiple guard clauses for connection validation
- [ ] `lib/morf/neat/mutation/add_node.rb:18` - `call` method is 24 lines; handles node
      insertion with connection splitting logic
- [ ] `lib/morf/neat/initial_population_factory.rb:10` - `create` method is 24 lines; builds
      initial genomes with nested loops
- [ ] `lib/morf/grid_view.rb:18` - `show` method is 23 lines; mixes GTK setup with rendering
      logic

### Rule 2: Either Call or Pass

- [ ] `lib/morf/experiments/neat/experiment.rb:37` - `run` method both calls methods on
      `@population` and passes it to multiple processing functions
- [ ] `lib/morf/neat/speciation.rb:25` - `distance` method both calls methods on genomes and
      passes their properties to external calculations
- [ ] `lib/morf/neat/mutation/add_node.rb:18` - `call` method both calls methods on
      `connection_to_split` and passes it to constructors
- [ ] `lib/morf/neat/initial_population_factory.rb:49` - `create_connection_genes` both calls
      methods on nodes and passes them to ConnectionGene constructor

---

## Medium Priority

These violations affect code clarity but are more localized.

### Rule 1: Five Lines Rule - Moderately Long Methods

- [ ] `lib/morf/neat/initial_population_factory.rb:49` - `create_connection_genes` is 21 lines;
      iterates over node combinations
- [ ] `lib/morf/grid_view.rb:48` - `initialize_cell_views` is 17 lines; creates nested cell
      view structure
- [ ] `lib/morf/sensors/moore_sensor.rb:12` - `sense` method is 14 lines; iterates over
      neighbor offsets
- [ ] `lib/morf/neat/mutation/mutator.rb:34` - `mutate_add_node` is 13 lines; delegates to
      mutation strategy with setup
- [ ] `lib/morf/experiments/neat/genome_developmental_trial.rb:36` - `run_trial` is 13 lines;
      runs development steps with fitness calculation
- [ ] `lib/morf/experiments/neat/offspring_allocator.rb:32` - `allocate_proportionally` is 12
      lines; calculates species offspring counts
- [ ] `lib/morf/neat/mutation/mutator.rb:48` - `mutate_add_connection` is 11 lines; delegates
      to mutation strategy
- [ ] `lib/morf/neat/speciation.rb:69` - `speciate` is 9 lines; assigns genomes to species
- [ ] `lib/morf/neat/network_builder.rb:22` - `build_nodes` is 9 lines; creates node objects
      from genes
- [ ] `lib/morf/cppn/activation_functions.rb:73` - `process_output` is 9 lines; handles output
      clamping and rounding
- [ ] `lib/morf/cppn/brain.rb:10` - `next_state` is 7 lines; processes network for next cell
      state

### Rule 4: Never Use If with Else

- [ ] `lib/morf/experiments/game_of_life/brain.rb:5` - `next_state` uses if-else instead of
      guard clauses with early returns
- [ ] `lib/morf/neat/reproduction/duel.rb:27` - `reproduce` uses if-else for parent selection;
      should use early return
- [ ] `lib/morf/experiments/neat/offspring_allocator.rb:11` - `allocate` uses if-else; should
      use early returns

### Rule 3: If Only at the Start

- [ ] `lib/morf/neat/mutation/add_connection.rb:19-34` - multiple guard clauses scattered
      throughout loop body instead of consolidated
- [ ] `lib/morf/sensors/moore_sensor.rb:16` - guard clause nested within iteration instead of
      at method start
- [ ] `lib/morf/cppn/activation_functions.rb:74-78` - nested if-else in middle of method for
      NaN/infinite check

### Rule 6: Only Inherit from Interfaces

- [ ] `lib/morf/neat/reproduction/crossover.rb:13` - `Crossover < Base` inherits implementation;
      consider composition
- [ ] `lib/morf/neat/reproduction/duel.rb:12` - `Duel < Base` inherits implementation; consider
      composition

---

## Low Priority

These are minor violations or cases where the rule may not strictly apply.

### Rule 1: Five Lines Rule - Borderline Methods

- [ ] `lib/morf/neat/genome.rb:45` - `path_exists?` is 22 lines; implements BFS algorithm which
      may be acceptable as a cohesive unit

### Rule 7: Never Have Common Affixes

- [ ] `lib/morf/experiments/*/cell_view.rb` - multiple `CellView` classes across experiments;
      indicates potential for shared abstraction
- [ ] `lib/morf/experiments/*/seed.rb` - multiple `Seed` classes across experiments; indicates
      potential for shared abstraction
- [ ] `lib/morf/experiments/*/brain.rb` - multiple `Brain` classes across experiments;
      indicates potential for shared abstraction
- [ ] `lib/morf/sensors/` - `MooreSensor` and `VonNeumannSensor` share `Sensor` suffix;
      consider extracting interface
- [ ] `lib/morf/neat/mutation/` - `AddConnection` and `AddNode` share `Add` prefix

### Rule 8: No Getters/Setters on Non-Data Classes

- [ ] `lib/morf/cppn/node.rb:26` - `input=` setter on computational class; consider pushing
      behavior to caller
- [ ] `lib/morf/neat/connection_gene.rb:7` - `attr_accessor :weight` allows direct mutation;
      consider adding behavior method
- [ ] `lib/morf/neat/genome.rb:6-7` - multiple accessors expose internal collections; consider
      encapsulating access
- [ ] `lib/morf/cppn/node.rb:8` - multiple readers expose internal structure
- [ ] `lib/morf/cppn/connection.rb:6` - multiple readers expose internal structure

### Rule 9: Use Primitives Only in Data Classes

- [ ] `lib/morf/experiments/neat/experiment.rb:19-35` - constructor accepts multiple primitive
      integers; consider `ExperimentConfiguration` object
- [ ] `lib/morf/neat/mutation/mutation_strategy.rb:15-31` - constructor accepts primitive
      floats for probabilities; consider `MutationParameters` object
- [ ] `lib/morf/neat/speciation.rb:17-23` - constructor accepts primitive floats; consider
      `SpeciationParameters` object
- [ ] `lib/morf/grid.rb:10-20` - constructor accepts primitive dimensions; consider
      `GridDimensions` object
- [ ] `lib/morf/grid_view.rb:5-16` - constructor accepts primitive view settings; consider
      `ViewConfiguration` object
- [ ] `lib/morf/neat/initial_population_factory.rb:10` - `create` accepts multiple primitive
      integers; consider parameter object

---

## Summary

| Rule | Violations | Priority Distribution |
|------|------------|----------------------|
| 1. Five Lines | 19 | 7 high, 11 medium, 1 low |
| 2. Either Call or Pass | 4 | 4 high |
| 3. If Only at the Start | 3 | 3 medium |
| 4. Never Use If with Else | 3 | 3 medium |
| 5. Never Use Switch/Case | 0 | - |
| 6. Only Inherit from Interfaces | 2 | 2 medium |
| 7. Never Have Common Affixes | 5 | 5 low |
| 8. No Getters/Setters | 5 | 5 low |
| 9. Primitives Only in Data Classes | 6 | 6 low |
| **Total** | **47** | |

---

*Generated by analyzing codebase against Five Lines of Code rules by Christian Clausen.*
