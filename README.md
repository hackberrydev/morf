# morf

An experiment in morphogenesis.

## Development

Install the following packages on Debian and related Linux distributions:

```bash
sudo apt install libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-ttf-dev
```

After checking out the repo, run `bundle install` to install dependencies.

To enable the repository’s bundled Git hooks (e.g. style checks):

```shell
git config core.hooksPath .githooks
```

You can check style guide compliance with StandardRB:

```shell
bundle exec standardrb
```

To automatically fix style issues:

```shell
bundle exec standardrb --fix
```

Standard is also integrated into the default Rake task.

Finally, run the test suite:

```shell
bundle exec rspec
```
