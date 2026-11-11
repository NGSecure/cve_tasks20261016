# Versionn

> Change Version information across multiple files

Changes Version information in

* package.json
* component.json
* bower.json
* any other file of choice containing a `VERSION` variable

Offering a module with support for npm, bower, component, ... requires to update the version information in the various files.
`versionn` helps here to keep all the version numbers within the files in sync.

You can either use a file called `VERSION` in the root folder of your project which just contains the [semver][] version, or just use the information contained in `package.json`, `bower.json` or `component.json`.

By default the version information is being extracted from the files in the following order.

1. VERSION
2. package.json
3. bower.json
4. component.json

Additionally any file can be used which contains the pattern

```
VERSION = "<semver>"
```

To increment the version information you can choose one of the commands:

    premajor|preminor|prepatch|prerelease|major|minor|patch|pre|same

## Installation

```
npm install -g versionn
```

## Usage

```
versionn [premajor|preminor|prepatch|prerelease|major|minor|patch|pre|same|set] [-e <file>] [-d <dir>] [-t] [-u] [filenames]

premajor|preminor|prepatch|prerelease|major|minor|patch|pre
    Increase Version by ...

same
    Update all version tags to the first version found

set <version>
    Sets all version tags to <version>

-e, --extract <file>
    extract version information from <file>

-d, --dir <dir>
    apply versionn in directory <dir>

-t, --tag
    Set Git version tag

-u, --untag
    Delete Git version tag

-c, --commit
   Git commit with version tag

-i, --info
    Display version information of inspected project.

-h, --help
    Display help information.

--version
    Display version.
```

**Examples:**

Applies the same version to all files `VERSION`, `package.json`, `bower.json`, `component.json`:

    versionn

Increment the `minor` version of `package.json` only:

    versionn minor package.json

Extract the version from `VERSION` and increase `bower.json` and `component.json` by `premajor` version. Note: `VERSION` will *NOT* be increased!

    versionn premajor -e VERSION bower.json component.json

Choose a different directory other that the current-working-directory:

    versionn -d <otherdir>

Git-tag the version

    versionn -t

Remove the Git-tag with:

    versionn -u

## Contribution

If you contribute code to this project, you are implicitly allowing your code
to be distributed under the MIT license. You are also implicitly verifying that
all code is your original work.

## License

Copyright (c) 2016 commenthol
Software is released under [MIT][license].

[license]: ./LICENSE
[semver]: http://semver.org
