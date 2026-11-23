const vscode = require('vscode');
const path = require('path');

const inFlight = new Set();

function isScad(document) {
  return document.uri.scheme === 'file' && document.uri.path.toLowerCase().endsWith('.scad');
}

function previewLabel(uri) {
  return `${path.basename(uri.fsPath)} Preview`;
}

function isPreviewTab(tab, label) {
  return tab.input instanceof vscode.TabInputWebview
    && tab.input.viewType.endsWith('openscadJs.preview')
    && tab.label === label;
}

function findPreviewTab(label) {
  for (const group of vscode.window.tabGroups.all) {
    const tab = group.tabs.find(t => isPreviewTab(t, label));
    if (tab) return tab;
  }
  return undefined;
}

// Opening a .scad file shows its OpenSCAD.js preview in place of the code. If the preview is
// already open, the code opens normally, so the preview's error links and Ctrl+P still reach it.
async function replaceWithPreview(editor) {
  if (!editor || !isScad(editor.document)) return;
  if (!vscode.workspace.getConfiguration('scadAutoPreview').get('enabled')) return;
  const uri = editor.document.uri;
  const key = uri.toString();
  const label = previewLabel(uri);
  if (inFlight.has(key) || findPreviewTab(label)) return;
  inFlight.add(key);
  try {
    const sourceColumn = vscode.window.tabGroups.activeTabGroup.viewColumn;
    await vscode.commands.executeCommand('openscadJs.openPreview', uri);

    // OpenSCAD.js always opens the panel in the group beside the code. Move it back.
    const previewTab = findPreviewTab(label);
    if (previewTab && previewTab.group.viewColumn !== sourceColumn && previewTab.group.isActive) {
      await vscode.commands.executeCommand('workbench.action.moveEditorToLeftGroup');
    }

    // Close the code tab, but never discard unsaved edits.
    if (!editor.document.isDirty) {
      const textTab = vscode.window.tabGroups.all
        .filter(g => g.viewColumn === sourceColumn)
        .flatMap(g => g.tabs)
        .find(t => t.input instanceof vscode.TabInputText && t.input.uri.toString() === key);
      if (textTab) await vscode.window.tabGroups.close(textTab);
    }
  } finally {
    inFlight.delete(key);
  }
}

function activate(context) {
  context.subscriptions.push(vscode.window.onDidChangeActiveTextEditor(replaceWithPreview));
  void replaceWithPreview(vscode.window.activeTextEditor);
}

function deactivate() {}

module.exports = { activate, deactivate };
