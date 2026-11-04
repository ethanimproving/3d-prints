# Engenesis modular illuminated divider sign

This package is a parametric first-pass design for the illuminated **ENGENESIS** divider sign discussed in the concept images.

## Included design

- Individual opaque letter shells
- Separately printed translucent letter diffusers
- Interlocking hollow bridges for a continuous LED strip and wiring
- Separate bridge diffusers
- 240 mm interlocking rail sections, sized below a 300 mm print bed
- Divider clamps that avoid permanent furniture modification
- A simplified snake-wrapped-I showpiece with separate shell and diffuser
- Full assembly preview

## Important measurements to verify

Before printing the full system, measure and update these variables near the top of `engenesis_sign.scad`:

- `divider_thickness`
- `clamp_depth`
- LED strip width and thickness
- Desired overall letter height
- Available sign length across the desk dividers

The default clamp assumes a 55 mm divider. Print only one short clamp/rail test first.

## Suggested materials

- Shells, bridges, rail and clamps: black or dark navy PLA/PETG
- Snake shell: dark green PLA/PETG
- Diffusers: natural/translucent white PLA or PETG
- Optional flame modules: blue shell plus white diffuser, using the same construction as a letter

Single-color printing is supported because shells and diffusers are separate parts.

## Exporting parts

Open `engenesis_sign.scad`, set `PART`, and export one STL at a time.

Examples:

```scad
PART = "letter_shell";
GLYPH = "E";
```

```scad
PART = "bridge_shell";
```

```scad
PART = "divider_clamp";
```

Press **F6**, then export as STL.

## Recommended prototype sequence

1. Print one bridge shell and one letter shell at reduced height or with a short test section.
2. Confirm the tongue/socket clearance. Adjust `connector_clearance` in 0.1 mm steps if needed.
3. Print one rail and clamp. Confirm divider fit using removable foam/felt pads.
4. Test the planned LED strip inside the bridge and letter cavity.
5. Only then print the complete wordmark.

## Electrical and facilities notes

- Keep the LED strip continuous through the bridges where bend radius allows.
- Where strip bending is too tight, use short soldered wire jumpers between modules.
- Size the power supply for the actual LED count and configured brightness.
- Use low-voltage, enclosed, strain-relieved wiring.
- Obtain Facilities approval before attaching or powering the installation in the office.

## Known limitations of this first pass

- The snake-I is a simplified parametric motif rather than an exact vector trace of the logo.
- Font rendering depends on the font installed on the computer running OpenSCAD.
- Divider dimensions and available sign width were not measured, so those parameters are provisional.
- Final LED routing, controller enclosure and power inlet should be adapted after selecting the exact strip/controller hardware.
