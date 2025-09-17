# CPPN-NEAT Experiment

- Each experiment consists of 100 generation runs.
- All experiments have a population size of 200 individuals. and elitism degree of 1.
- Each generation-population is segregated into species by NEAT, with selection and reproduction
  happening within these groups.
- Sigma scaled selection is used to select pairs for reproduction.
- The morphogenisis problem is defined as the development of a complex pattern (French flag) from a
  simple "seed" pattern.
- The grid size is 6x6 cells.
- The seed pattern is a single cell that's not dead in (2, 2) coordinates.
- The seed pattern should be developed for 30 iterations.
- For each iteration, the fitness should be calculated.
- Then, the max value from all iterations should be used in the following function, to calculate the
  final fitness of the organism. If x is the max value, f(x)=x*(e**(5*x))/(e**5).
- The most fit organism at the end of the experiment should be saved so that it can be used in a
  visualization.
- Independent runs should not use a graphical visualization. Instead, use a simple logging, just so
  we know how the whole experiment is progressing.

---

## Experiment Parameters (Conclusions)

Based on our discussion, the following parameters have been defined for the initial implementation:

- **Run Configuration:**
  - **Independent Runs:** 1
  - **Generations per Run:** 100

- **Grid and Patterns:**
  - **Grid Size:** 6x6
  - **Color Mapping:** `{ 0: :black, 1: :blue, 2: :white, 3: :red }`
  - **Target Pattern (French Flag):** Two vertical columns of each color (blue, white, red).
    ```ruby
    [
      [1, 1, 2, 2, 3, 3],
      [1, 1, 2, 2, 3, 3],
      [1, 1, 2, 2, 3, 3],
      [1, 1, 2, 2, 3, 3],
      [1, 1, 2, 2, 3, 3],
      [1, 1, 2, 2, 3, 3]
    ]
    ```
  - **Seed Pattern:** A grid of dead cells (0) with a single white cell (2) at `(2, 2)`.

- **CPPN Configuration:**
  - **Inputs:** The integer state of each of the 8 neighboring cells (Moore neighborhood) and the
    cell's own last state.
  - **Outputs:** 4 nodes (one for each state: dead, blue, white, red), using a "winner-take-all"
    mechanism to determine the cell's state.

- **Logging (per generation):**
  - Generation number
  - Best fitness
  - Average fitness
  - Number of species

- **Artifacts:**
  - The single most fit `Morf::NEAT::Genome` from the run will be serialized to a timestamped file in
    the project's root directory (e.g., `fittest_genome_20250916120000.dump`).
