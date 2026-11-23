# SCAD Auto Preview

Opens `.scad` files in the [OpenSCAD.js Preview](https://marketplace.visualstudio.com/items?itemName=ouroborosproductions.openscad-js-preview) instead of the text editor, so you don't have to press F5.

OpenSCAD.js only shows `.scad` previews in a webview panel opened by a command. It does not register a custom editor for `.scad`, so `workbench.editorAssociations` cannot point `.scad` files at it. This extension runs `openscadJs.openPreview`, moves the panel into the code's editor group (OpenSCAD.js always opens it beside), and closes the code tab.

## Behavior

- Opening a `.scad` file with no preview open replaces the code tab with the preview.
- Opening a `.scad` file whose preview is already open shows the code normally. Use this to edit: open the file again (Ctrl+P), or click an error in the preview.
- A code tab with unsaved changes is never closed.

## Install

```powershell
cd tools/scad-auto-preview
powershell -ExecutionPolicy Bypass -File .\build-vsix.ps1
code-insiders --install-extension .\scad-auto-preview-0.2.0.vsix --force
```

`build-vsix.ps1` zips the extension into a VSIX directly, so it doesn't need `vsce` or npm. Reload the window after installing.

## Settings

- `scadAutoPreview.enabled` (default `true`): turn the behavior on or off.
