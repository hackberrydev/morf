# Morf Project TODO

This file tracks the development tasks for the Morf project.

## Guiding Principles & Design

This section summarizes the key architectural decisions for the Game of Life experiment.

- **State Representation**: A cell's state will be represented by an integer: `1` for alive, `0` for dead.
- **TDD Workflow**: All core logic components (Brain, Sensor, Seed) must be developed using a strict Test-Driven Development (TDD) cycle: Red, Green, Refactor.
- **Task Tracking**: This `TODO.md` file should be updated after each completed step.
- **Component Interfaces**:
  - `GameOfLife::Brain`
    - `next_state(current_state, live_neighbors_count)`: Returns the cell's next state (`0` or `1`).
  - `GameOfLife::Sensor`
    - `sense`: Returns the number of live neighbors (`0` to `8`).
  - `GameOfLife::Seed`
    - `state_for(row:, column:)`: Returns the initial state (`0` or `1`) for a given cell.
    - `default_state`: Returns the state for out-of-bounds cells.
- **Grid Design**: The `Grid` uses a `NullCell` for out-of-bounds access. The `NullCell`'s state is determined by the `Seed#default_state` method.

---

## Game of Life Experiment

- [ ] **Core Logic (TDD)**
    - [x] Create `test/morf/experiments/game_of_life/brain_test.rb`
    - [x] Create `lib/morf/experiments/game_of_life/brain.rb`
    - [x] Create `test/morf/experiments/game_of_life/sensor_test.rb`
    - [x] Create `lib/morf/experiments/game_of_life/sensor.rb`
    - [ ] Create `test/morf/experiments/game_of_life/seed_test.rb`
    - [ ] Create `lib/morf/experiments/game_of_life/seed.rb`

- [ ] **Visualization**
    - [ ] Create `lib/morf/experiments/game_of_life/cell_view.rb`

- [ ] **Experiment Setup**
    - [ ] Create `lib/morf/experiments/game_of_life/experiment.rb`

- [ ] **Integration**
    - [ ] Update `test/test_helper.rb` to include new Game of Life files.
    - [ ] Update `bin/console` to allow running the Game of Life experiment.
    - [ ] Run the full experiment and verify its correctness visually.

- [ ] **Cleanup**
    - [ ] Review and refactor the code.
    - [ ] Remove the `TODO.md` file.
