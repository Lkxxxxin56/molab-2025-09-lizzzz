# Inspiration

I wanted to turn ordinary library photos into hypnotic, symmetric patterns by riffing on Instafilter with Core Image’s kaleidoscope-style tile filters.

# Process

## Phase 1 — Scaffold from Instafilter

* **Did:** Reused the PhotosPicker → CIImage → CIFilter → CIContext render pipeline, swapping in a kaleidoscope/tile filter.
* **Worked:** The overall app structure and state mirrored cleanly.
* **Didn’t:** Initial output showed nothing (later traced to infinite extents).

## Phase 2 — Loading the Image

* **Did:** Loaded `PhotosPickerItem` data into `UIImage` then `CIImage`, storing the original for reprocessing.
* **Worked:** Async loading was reliable and kept UI responsive.
* **Didn’t:** N/A here, but I added a quick raw-image preview to verify the load path.

## Phase 3 — Parameter Controls

* **Did:** Added sliders for tile width, rotation, and normalized center X/Y, mapping 0–1 to image space.
* **Worked:** Live updates via `.onChange` felt immediate and intuitive.
* **Didn’t:** Mixing `CGFloat`/`Double` was noisy, so I standardized on `Double`.

## Phase 4 — Infinite-Extent Bug

* **Did:** Cropped the filter’s `outputImage` to a finite rect (input extent / centered square) before rasterizing.
* **Worked:** Cropping made `createCGImage(_:from:)` succeed and the preview render correctly.
* **Didn’t:** Rendering with `output.extent` failed because the filter’s extent was effectively unbounded.

## Phase 5 — Symmetry & Randomize

* **Did:** Added a segmented control to switch 4/6/8/12-fold filters and a “Randomize” for parameters.
* **Worked:** Produced instant variety while reusing the same parameter plumbing.
* **Didn’t:** Some filters use `inputWidth` vs `inputScale`, so I guarded by checking `inputKeys`.

## Phase 8 — Fidelity & Performance

* **Did:** Reused a single `CIContext` and opted into sRGB for consistent color.
* **Worked:** Interaction stayed smooth and exports looked as expected.
* **Didn’t:** High-res offline export is still a future improvement.

# Reflection

This project sharpened my Core Image instincts—especially around infinite extents—and taught me to pair normalized UI controls with robust rendering (crop first, then draw); next time I’ll add drag-to-center, tweened symmetry transitions, and a high-res export.

