# TODO: Switch from Moore to von Neumann Neighborhood

## Goal

Switch the NEAT experiment from using Moore neighborhood (8 neighbors) to von Neumann
neighborhood (4 neighbors: up, down, left, right) to align with the original CA-NEAT paper and
simplify the evolutionary search space.

## Benefits

- **Simpler search space:** Reduces CPPN inputs from 9 to 5 (4 neighbors + own state)
- **Clearer spatial patterns:** Better suited for French Flag's vertical structure
- **Easier gradient formation:** Orthogonal connectivity creates predictable gradients
- **Less overfitting:** Fewer inputs reduce overfitting risk
- **Paper alignment:** Matches the original CA-NEAT implementation

## Implementation Checklist

### Phase 1: Refactor Existing Sensor to Shared Location

- [ ] Create `/lib/morf/sensors/` directory

- [ ] Create `/lib/morf/sensors/moore_sensor.rb`
  - [ ] Move existing `Morf::CPPN::Sensor` code to new `Morf::Sensors::MooreSensor`
        class
  - [ ] Keep the same Moore neighborhood logic (8 neighbors)

- [ ] Create `/spec/morf/sensors/moore_sensor_spec.rb`
  - [ ] Move tests from `/spec/morf/cppn/sensor_spec.rb` to new location
  - [ ] Update test to use `Morf::Sensors::MooreSensor`
  - [ ] Ensure all tests still pass

- [ ] Update all references to `Morf::CPPN::Sensor`:
  - [ ] `/lib/morf/experiments/cppn/experiment.rb` - change to
        `Morf::Sensors::MooreSensor`
  - [ ] `/lib/morf/experiments/neat/genome_developmental_trial.rb` - change to
        `Morf::Sensors::MooreSensor`
  - [ ] `/spec/morf/experiments/neat/genome_developmental_trial_spec.rb` - change to
        `Morf::Sensors::MooreSensor`

- [ ] Delete old files:
  - [ ] `/lib/morf/cppn/sensor.rb`
  - [ ] `/spec/morf/cppn/sensor_spec.rb`

- [ ] Run tests: `bundle exec rspec`

### Phase 2: Create von Neumann Sensor

- [ ] Create `/lib/morf/sensors/von_neumann_sensor.rb`
  - [ ] Implement `Morf::Sensors::VonNeumannSensor` class
  - [ ] Return 4 orthogonal neighbors (top, right, bottom, left)
  - [ ] Ensure consistent ordering: top `(row-1, col)`, right `(row, col+1)`, bottom `(row+1,
        col)`, left `(row, col-1)`
  - [ ] Handle boundary conditions using grid's existing `cell` method (returns NullCell)

- [ ] Create `/spec/morf/sensors/von_neumann_sensor_spec.rb`
  - [ ] Test that exactly 4 neighbors are returned
  - [ ] Test the correct order of neighbors
  - [ ] Test boundary conditions
  - [ ] Test correct grid cell access

- [ ] Run tests: `bundle exec rspec spec/morf/sensors/von_neumann_sensor_spec.rb`

### Phase 3: Update Constants

- [ ] Update `/lib/morf/experiments/neat/constants.rb`
  - [ ] Change `CPPN_INPUTS = 9` to `CPPN_INPUTS = 5` (line 39)
  - [ ] Update comment from `# Moore neighborhood + self` to `# von Neumann neighborhood + self`

### Phase 4: Switch NEAT Experiment to von Neumann

- [ ] Update `/lib/morf/experiments/neat/genome_developmental_trial.rb`
  - [ ] Add `require "morf/sensors/von_neumann_sensor"` near top of file
  - [ ] Change `sensor_class: Morf::Sensors::MooreSensor` to `sensor_class:
        Morf::Sensors::VonNeumannSensor` (line 38)

- [ ] Update `/spec/morf/experiments/neat/genome_developmental_trial_spec.rb`
  - [ ] Add `require "morf/sensors/von_neumann_sensor"` near top of file
  - [ ] Change `sensor_class: Morf::Sensors::MooreSensor` to `sensor_class:
        Morf::Sensors::VonNeumannSensor` (line 50)

- [ ] Run full test suite: `bundle exec rspec`

### Phase 5: Code Quality

- [ ] Run linter: `bundle exec standardrb`
- [ ] Fix any style issues: `bundle exec standardrb --fix`

### Phase 6: Validation

- [ ] Run a small test experiment (10 generations, 20 population size)
  - [ ] Verify the experiment completes without errors
  - [ ] Check that genomes have correct number of input nodes (5 instead of 9)
  - [ ] Verify fitness calculations work correctly

### Phase 7: Documentation

- [ ] Update `/EXPERIMENT.md`
  - [ ] Change "Inputs: The integer state of each of the 8 neighboring cells (Moore
        neighborhood)" to "Inputs: The integer state of each of the 4 neighboring cells (von
        Neumann neighborhood)" (lines 48-49)
  - [ ] Update any other references to neighborhood size or structure

### Phase 8: Final Verification

- [ ] Run full test suite one more time: `bundle exec rspec`
- [ ] Commit changes with clear message
- [ ] Consider running a full experiment to baseline the new configuration

## Notes

- Both `Morf::Sensors::MooreSensor` and `Morf::Sensors::VonNeumannSensor` are shared
  components in `/lib/morf/sensors/` available for any experiment
- The CPPN experiment will continue using Moore neighborhood, while NEAT will use von Neumann
- Both sensors follow the same interface pattern (initialize with grid, row, column; call `sense`)
- Boundary handling is automatic via the grid's `cell` method which returns NullCell for
  out-of-bounds coordinates
