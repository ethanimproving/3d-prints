# 3D Prints

A collection of 3D-printable models, each with its own parametric source
(`.scad`), exported geometry (`.stl`), render images and build instructions.

The goal is to keep every model fully editable: the OpenSCAD sources are
checked in alongside ready-to-print STLs, so you can tweak dimensions to fit
your own hardware without re-modeling from scratch.

## Projects

| Project | Description | Source |
|---|---|---|
| [Everyday Dose Frother Fridge Holder](everyday-dose-frother-fridge-holder/) | Magnetic fridge holder for a 33 mm milk-frother handle | OpenSCAD |

## Layout

Each project lives in its own folder and follows the same layout:

```
<project>/
  README.md     # build & print instructions
  <model>.scad  # parametric OpenSCAD source
  <model>.stl   # exported mesh, ready to slice
  images/       # rendered previews (hero.png + angle views)
```

## Using the projects

- **Quick print**: download the `.stl` and slice it with your slicer (Cura,
  PrusaSlicer, OrcaSlicer, ...). See each project's `README.md` for
  recommended settings.
- **Customize**: open the `.scad` in [OpenSCAD](https://openscad.org/), adjust
  the parameters at the top of the file, then hit F6 to rebuild and F7 to
  export a new STL. The parameters each have a comment explaining what they
  control.
- **Re-render previews**: `openscad -o images/out.png --camera ... model.scad`
  (see each project folder for the exact camera settings used).

## Intent

This repository is a personal archive of working, tested print files so they
can be reused, shared and rebuilt later. Every model is derived from
permissively-licensed community designs where applicable — see each project's
`README.md` for the original author and license attribution.