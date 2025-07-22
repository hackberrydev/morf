# Minitest to RSpec Migration Plan

This document outlines the steps to migrate the project's test suite from Minitest to RSpec.

## Phase 1: Setup RSpec

- [ ] Add `rspec` to `morf.gemspec` as a development dependency.
- [ ] Add `rspec` to `Gemfile`.
- [ ] Install gems with `bundle install`.
- [ ] Initialize RSpec with `bundle exec rspec --init`.
- [ ] Configure RSpec `spec_helper.rb` to require `morf`.

## Phase 2: Migrate Test Files

- [ ] `test/morf/null_cell_test.rb` -> `spec/morf/null_cell_spec.rb`
- [ ] `test/morf/cell_test.rb` -> `spec/morf/cell_spec.rb`
- [ ] `test/morf/clock_test.rb` -> `spec/morf/clock_spec.rb`
- [ ] `test/morf/grid_test.rb` -> `spec/morf/grid_spec.rb`
- [ ] `test/morf/experiments/game_of_life/brain_test.rb` -> `spec/morf/experiments/game_of_life/brain_spec.rb`
- [ ] `test/morf/experiments/game_of_life/seed_test.rb` -> `spec/morf/experiments/game_of_life/seed_spec.rb`
- [ ] `test/morf/experiments/game_of_life/sensor_test.rb` -> `spec/morf/experiments/game_of_life/sensor_spec.rb`

## Phase 3: Finalize Migration

- [ ] Remove the `test` directory.
- [ ] Remove `minitest` from `morf.gemspec`.
- [ ] Update `Rakefile` to use the RSpec test task.
- [ ] Run `bundle install` to remove `minitest`.
- [ ] Ensure all tests pass with `bundle exec rspec`.
