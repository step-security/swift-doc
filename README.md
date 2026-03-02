[![StepSecurity Maintained Action](https://raw.githubusercontent.com/step-security/maintained-actions-assets/main/assets/maintained-action-banner.png)](https://docs.stepsecurity.io/actions/stepsecurity-maintained-actions)
# swift-doc

![CI][ci badge] 

A GitHub Action for generating documentation for Swift projects.

Given a directory of Swift files,
`swift-doc` generates HTML or CommonMark (Markdown) files
for each class, structure, enumeration, and protocol
as well as top-level type aliases, functions, and variables.

**Example Output**

- [HTML][swiftsemantics html]
- [CommonMark / GitHub Wiki][alamofire wiki]

## GitHub Action

### Inputs

- `inputs`:
  A path to a directory containing Swift (`.swift`) files in your workspace.
  (Default: `"./Sources"`)
- `format`:
  The output format (`"commonmark"` or `"html"`)
  (Default: `"commonmark"`)
- `module-name`:
  The name of the module.
- `base-url`:
  The base URL for all relative URLs generated in documents.
  (Default: `"/"`)
- `output`:
  The path for generated output.
  (Default: `"./.build/documentation"`)
- `minimum-access-level`:
  The minimum access level of the symbols which should be included.
  (Default: `"public"`)

### Example Workflow

```yml
# .github/workflows/documentation.yml
name: Documentation

on: [push]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v6
      - name: Generate Documentation
        uses: step-security/swift-doc@v1
        with:
          inputs: "Sources"
          module-name: MyLibrary
          output: "Documentation"
      - name: Upload Documentation to Wiki
        uses: SwiftDocOrg/github-wiki-publish-action@v1
        with:
          path: "Documentation"
        env:
          GH_PERSONAL_ACCESS_TOKEN: ${{ secrets.GH_PERSONAL_ACCESS_TOKEN }}
```

## License

MIT

[ci badge]: https://github.com/SwiftDocOrg/swift-doc/workflows/CI/badge.svg
[alamofire wiki]: https://github.com/SwiftDocOrg/Alamofire/wiki
[swiftsemantics html]: https://swift-doc-preview.netlify.app
[github wiki]: https://help.github.com/en/github/building-a-strong-community/about-wikis
[github actions]: https://github.com/features/actions
[swiftsyntax]: https://github.com/apple/swift-syntax
[swiftsemantics]: https://github.com/SwiftDocOrg/SwiftSemantics
[swiftmarkup]: https://github.com/SwiftDocOrg/SwiftMarkup
[commonmark]: https://github.com/SwiftDocOrg/CommonMark
[github-wiki-publish-action]: https://github.com/SwiftDocOrg/github-wiki-publish-action
[open an issue]: https://github.com/SwiftDocOrg/swift-doc/issues/new
[jazzy]: https://github.com/realm/jazzy
[swift number protocols diagram]: https://nshipster.com/propertywrapper/#swift-number-protocols
[protocol-oriented programming]: https://asciiwwdc.com/2015/sessions/408
[apple documentation]: https://developer.apple.com/documentation
[se-0195]: https://github.com/apple/swift-evolution/blob/master/proposals/0195-dynamic-member-lookup.md
[se-o258]: https://github.com/apple/swift-evolution/blob/master/proposals/0258-property-wrappers.md
[se-xxxx]: https://github.com/apple/swift-evolution/blob/9992cf3c11c2d5e0ea20bee98657d93902d5b174/proposals/XXXX-function-builders.md
[swiftdoc.org]: https://swiftdoc.org
[jazzy swiftsemantics]: https://swift-semantics-jazzy.netlify.com
[swift-doc swiftsemantics]: https://github.com/SwiftDocOrg/SwiftSemantics/wiki
[@natecook1000]: https://github.com/natecook1000
[nshipster]: https://nshipster.com
[dependency hell]: https://github.com/apple/swift-package-manager/tree/master/Documentation#dependency-hell
[pcre]: https://en.wikipedia.org/wiki/Perl_Compatible_Regular_Expressions
[dot]: https://en.wikipedia.org/wiki/DOT_(graph_description_language)
[graphviz]: https://www.graphviz.org
[libxml2]: https://en.wikipedia.org/wiki/Libxml2
[docker]: https://www.docker.com
[semver]: https://semver.org