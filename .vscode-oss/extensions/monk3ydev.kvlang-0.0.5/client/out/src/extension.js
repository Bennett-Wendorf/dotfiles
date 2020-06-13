/* --------------------------------------------------------------------------------------------
 * Copyright (c) Microsoft Corporation. All rights reserved.
 * Licensed under the MIT License. See License.txt in the project root for license information.
 * ------------------------------------------------------------------------------------------ */
'use strict';
Object.defineProperty(exports, "__esModule", { value: true });
const path = require("path");
const vscode_1 = require("vscode");
const vscode_languageclient_1 = require("vscode-languageclient");
let serverPath;
let languageClient;
let kvLangStatusBar;
let kvLangPythonPath; // Last path which was used to activate Language server
function createLanguageClient(command, serverArgs) {
    const serverOptions = {
        run: { command: command, args: serverArgs },
        debug: { command: command, args: serverArgs }
    };
    const clientOptions = {
        documentSelector: [{ scheme: 'file', language: 'kv' },
            { scheme: 'file', language: 'python' }]
    };
    return new vscode_languageclient_1.LanguageClient('kvls', 'KvLang Server', serverOptions, clientOptions, false);
}
function activate(context) {
    serverPath = context.asAbsolutePath(path.join('server', 'server.py'));
    kvLangPythonPath = getPythonPath();
    languageClient = createLanguageClient(kvLangPythonPath, [serverPath]);
    languageClient.start();
    const myCommandId = 'KvLang.showPythonPathSelection';
    kvLangStatusBar = vscode_1.window.createStatusBarItem(vscode_1.StatusBarAlignment.Left, 0);
    kvLangStatusBar.text = 'KvLang Python';
    kvLangStatusBar.tooltip = kvLangPythonPath;
    kvLangStatusBar.command = myCommandId;
    kvLangStatusBar.show();
    vscode_1.workspace.onDidChangeConfiguration(restartLanguageServer);
    vscode_1.commands.registerCommand(myCommandId, updatePythonPath);
    console.log('KvLang: Activating of extension is finished with success');
}
exports.activate = activate;
function deactivate() {
    if (!languageClient) {
        console.log('KvLang: Deactivation of extension is finished. Language Client is undefined');
        return undefined;
    }
    console.log('KvLang: Deactivation of extension is finished with success');
    return languageClient.stop();
}
exports.deactivate = deactivate;
function restartLanguageServer() {
    let pythonPath = getPythonPath();
    if (kvLangPythonPath != pythonPath) {
        console.log('KvLang: Restart of language server ongoing. Python path has been changed');
        kvLangStatusBar.tooltip = pythonPath;
        // Deactivate language client
        if (languageClient) {
            languageClient.stop();
        }
        // Start new language client with new path
        kvLangPythonPath = pythonPath;
        languageClient = createLanguageClient(pythonPath, [serverPath]);
        languageClient.start();
    }
}
function updatePythonPath() {
    let options = { prompt: 'Change python path for the KvLang Language Server. \
	                        Empty input will clear current configuration.',
        placeHolder: 'current: ' + getPythonPath() };
    vscode_1.window.showInputBox(options).then(input => {
        input = input.trim();
        let pythonPath;
        if (input === '') {
            pythonPath = 'python';
            input = undefined;
        }
        else {
            pythonPath = input;
        }
        // Update configuration
        const configuration = vscode_1.workspace.getConfiguration('kvlang', null);
        let folder = vscode_1.workspace.getWorkspaceFolder(vscode_1.window.activeTextEditor.document.uri);
        if (folder === undefined && vscode_1.workspace.workspaceFolders === undefined) {
            console.log('KvLang: Updating global configuration: input=%s, pythonPath=%s', input, pythonPath);
            configuration.update('pythonPath', input, vscode_1.ConfigurationTarget.Global);
        }
        else {
            console.log('KvLang: Updating workspace configuration: input=%s, pythonPath=%s', input, pythonPath);
            configuration.update('pythonPath', input, vscode_1.ConfigurationTarget.Workspace);
        }
    });
}
function getPythonPath() {
    const configuration = vscode_1.workspace.getConfiguration('kvlang', null);
    let pythonPath = configuration.get('pythonPath', undefined);
    if (pythonPath === undefined) {
        console.error('KvLang: PythonPath is undefined. Assigned default value of python path');
        pythonPath = 'python';
    }
    return pythonPath;
}
//# sourceMappingURL=extension.js.map