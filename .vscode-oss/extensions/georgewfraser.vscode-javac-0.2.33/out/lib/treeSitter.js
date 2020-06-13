'use strict';
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
const vscode_1 = require("vscode");
const path = require("path");
const Parser = require("web-tree-sitter");
const treeSitterColor_1 = require("./treeSitterColor");
const textMate_1 = require("./textMate");
function activateTreeSitter(context) {
    return __awaiter(this, void 0, void 0, function* () {
        let javaParser = null;
        // Parse of all visible documents
        const trees = {};
        function open(editor) {
            return __awaiter(this, void 0, void 0, function* () {
                if (editor.document.languageId != 'java')
                    return;
                if (javaParser == null) {
                    const absolute = path.join(context.extensionPath, 'lib', 'tree-sitter-java.wasm');
                    const wasm = path.relative(process.cwd(), absolute);
                    // @ts-ignore https://github.com/tree-sitter/tree-sitter/pull/471
                    const lang = yield Parser.Language.load(wasm);
                    javaParser = new Parser();
                    javaParser.setLanguage(lang);
                }
                const t = javaParser.parse(editor.document.getText()); // TODO don't use getText, use Parser.Input
                trees[editor.document.uri.toString()] = t;
                colorUri(editor.document.uri);
            });
        }
        // NOTE: if you make this an async function, it seems to cause edit anomalies
        function edit(edit) {
            if (edit.document.languageId != 'java')
                return;
            updateTree(javaParser, edit);
            colorUri(edit.document.uri);
        }
        function updateTree(parser, edit) {
            if (edit.contentChanges.length == 0)
                return;
            const old = trees[edit.document.uri.toString()];
            for (const e of edit.contentChanges) {
                const startIndex = e.rangeOffset;
                const oldEndIndex = e.rangeOffset + e.rangeLength;
                const newEndIndex = e.rangeOffset + e.text.length;
                const startPos = edit.document.positionAt(startIndex);
                const oldEndPos = edit.document.positionAt(oldEndIndex);
                const newEndPos = edit.document.positionAt(newEndIndex);
                const startPosition = asPoint(startPos);
                const oldEndPosition = asPoint(oldEndPos);
                const newEndPosition = asPoint(newEndPos);
                const delta = { startIndex, oldEndIndex, newEndIndex, startPosition, oldEndPosition, newEndPosition };
                old.edit(delta);
            }
            const t = parser.parse(edit.document.getText(), old); // TODO don't use getText, use Parser.Input
            trees[edit.document.uri.toString()] = t;
        }
        function asPoint(pos) {
            return { row: pos.line, column: pos.character };
        }
        function close(doc) {
            delete trees[doc.uri.toString()];
        }
        function colorUri(uri) {
            for (const editor of vscode_1.window.visibleTextEditors) {
                if (editor.document.uri == uri) {
                    colorEditor(editor);
                }
            }
        }
        const warnedScopes = new Set();
        function colorEditor(editor) {
            const t = trees[editor.document.uri.toString()];
            if (t == null)
                return;
            if (editor.document.languageId != 'java')
                return;
            const scopes = treeSitterColor_1.colorJava(t.rootNode, visibleLines(editor));
            for (const scope of scopes.keys()) {
                const dec = textMate_1.decoration(scope);
                if (dec) {
                    const ranges = scopes.get(scope).map(range);
                    editor.setDecorations(dec, ranges);
                }
                else if (!warnedScopes.has(scope)) {
                    console.warn(scope, 'was not found in the current theme');
                    warnedScopes.add(scope);
                }
            }
        }
        function colorAllOpen() {
            return __awaiter(this, void 0, void 0, function* () {
                for (const editor of vscode_1.window.visibleTextEditors) {
                    yield open(editor);
                }
            });
        }
        // Load active color theme
        function onChangeConfiguration(event) {
            return __awaiter(this, void 0, void 0, function* () {
                let colorizationNeedsReload = event.affectsConfiguration('workbench.colorTheme')
                    || event.affectsConfiguration('editor.tokenColorCustomizations');
                if (colorizationNeedsReload) {
                    yield textMate_1.loadStyles();
                    colorAllOpen();
                }
            });
        }
        context.subscriptions.push(vscode_1.workspace.onDidChangeConfiguration(onChangeConfiguration));
        context.subscriptions.push(vscode_1.window.onDidChangeVisibleTextEditors(colorAllOpen));
        context.subscriptions.push(vscode_1.workspace.onDidChangeTextDocument(edit));
        context.subscriptions.push(vscode_1.workspace.onDidCloseTextDocument(close));
        context.subscriptions.push(vscode_1.window.onDidChangeTextEditorVisibleRanges(change => colorEditor(change.textEditor)));
        yield textMate_1.loadStyles();
        yield Parser.init();
        yield colorAllOpen();
    });
}
exports.activateTreeSitter = activateTreeSitter;
function range(x) {
    return new vscode_1.Range(x.start.row, x.start.column, x.end.row, x.end.column);
}
function visibleLines(editor) {
    return editor.visibleRanges.map(range => {
        const start = range.start.line;
        const end = range.end.line;
        return { start, end };
    });
}
//# sourceMappingURL=treeSitter.js.map