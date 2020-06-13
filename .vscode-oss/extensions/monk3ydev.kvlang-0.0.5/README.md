# kvlang README

A Visual Studio Code extension with small support for the KvLang language of Kivy: Cross-platform Python Framework for NUI Development

- Key words highlighting
- Kivy language snippets
- Basic snippets of the uix widget inside class rule
- Linter syntax parser with error detection using language server for KvLang
- KvLang as Embedded language in files with python extension

![Kivy Snippets](https://github.com/Monk3yDev/kvlang-vscode/raw/master/images/snippets_kvlang.gif)

![Kivy basic widget Snippets](https://github.com/Monk3yDev/kvlang-vscode/raw/master/images/highlighting.gif)

![Kivy kivy words highlighting](https://github.com/Monk3yDev/kvlang-vscode/raw/master/images/snippets_basic_widget.gif)

![Syntax parser](https://github.com/Monk3yDev/kvlang-vscode/raw/master/images/syntax_parser.gif)

## Quick Start

- Install the extension
- Install Python
- Install Kivy
- Server run with default Python path: "python". Value can be changed in settings kvlang.pythonPath

## Requirements

- Visual Studio Code 1.34.0 or newer
- Python 3.x or 2.7 for the language server
- Kivy open source Python library

## Testing was performed in

- Windows 10 with Python 3.7.0
- Ubuntu 18.10 with Python 2.7.15

## TODO

- Add code formatting
- Add IntelliSense support
- Improve Kvlang Language Server

## Known Issues

- Language server is implemented in Python. Lack of it will cause problems with extension
- Kivy module is also mandatory. KvLint will show only basic lint information when module is missing from used python path
- When lint messages are not cleared or updated, restart of Visual Code is required

## Embedded language

- To activate new functionality special keyword must be used for language detection
- Two snippets can be used in the extension to create current keyword "kveb" and "kvev"

```python
#<KvLang>
#</KvLang>
```

![KvLang as Embedded language](https://github.com/Monk3yDev/kvlang-vscode/raw/master/images/kivy_embedded_language.png)

![KvLang snippets for Embedded language](https://github.com/Monk3yDev/kvlang-vscode/raw/master/images/kivy_embedded_language.gif)
