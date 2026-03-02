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
        uses: step-security/swift-doc@master
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
