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

## Testing Strategy

There are 2 types of classes that need a testing strategy: commands and
resources. Take my book reading list as an example. In that case I have both
`Mli::Cli::BookCommand` and `Mli::Book` classes. The command class takes
arguments and options and sends them into the resource class and then prints the
output. I think of these things as outer and inner loops. Tests at the command
level are integration tests while tests at the resource level are unit tests.

Given that framing then my typical strategy is for integration tests to mostly
cover the happy path and for unit tests to be more exhaustive. How does this
play out?

```
RSpec.describe Mli::Cli::BookCommand do
  describe "create" do
    context "with no options" do
      it "does not send the api call and prints an error message"
    end
    context "with required options" do
      it "sends the api call and prints the created data"
    end
    context "with all options" do
      it "sends the api call with all options and prints the created data"
    end
  end

  describe "update" do
    context "with no argument" do
      it "does not send the api call and prints an error message"
    end
    context "with no options" do
      it "does not send the api call and prints an error message"
    end
    context "with an option" do
      it "sends the api call and prints the updated data"
    end
    context "with all options" do
      it "sends the api call with all options and prints the updated data"
    end
  end
end

RSpec.describe Mli::Book do
  describe ".create" do
    context "with nil attrs" do
      it "returns an error message"
    end

    context "with empty attrs" do
      it "returns an error message"
    end

    context "with required attrs" do
      it "returns created data"
    end

    context "with extra attrs" do
    end
  end
end
```
