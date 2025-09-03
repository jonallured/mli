# mli

This gem wraps the [Monolithium][] API and provides CLI and classes to make
working with that API nice.

## Installation

For now I'm just installing it locally. To do that first clone the repo and then
have rake install it:

```bash
rake install
```

And that's it! Upgrading is the same.

> [!NOTE]
> This will install to the current Ruby so keep in mind that other Rubies could
> have an older version or no version at all.

## Releasing

This gem is not published to RubyGems.org but I'm still tagging releases so to
cut a new version do this:

```bash
./bin/release
```

This will:

* bump the patch level version
* make a commit
* tag that commit
* push the new commit
* push the tag

## License

The gem is available as open source under the terms of the [MIT License][MIT].

[Monolithium]: https://github.com/jonallured/monolithium
[MIT]: https://opensource.org/licenses/MIT
