```bash
 _     _____ ___  _   _ _____
| |   | ____/ _ \| \ | |__  /
| |   |  _|| | | |  \| | / / 
| |___| |__| |_| | |\  |/ /_ 
|_____|_____\___/|_| \_/____|
                             
```

# darktable - JPEG workflow
_Updated February 2026_
Description: Quick workflow for legacy / archive JPEGs, adapted and tested on Darktable 5.4

## 🟦 The "SOOC Refresh" Workflow

### 1. Initial Setup
* **Disable sigmoid/AgX:** Ensure the scene-referred filmic/sigmoid modules are OFF.
* **Input Color Profile:** Confirm it is set to `sRGB`.

### ⚙️ 2. Apply preset Registry: JPEG_polish
To maintain consistency, the following modules are saved as auto-applying presets (to non-raw) named `JPEG_polish`:

* **color balance rgb:** Vibrance +15, Saturation +10.
* **denoise (profiled):** Non-local means, 50% Opacity.
* **diffuse or sharpen:** Preset `local contrast - normal`.
* **tone equalizer:** Preset `compress shadows/highlights (GF, medium)`.

### 🎨 3. Creative & Corrective Steps (Manual)

### White Balance & Color Calibration
* **Legacy JPEGs:** Usually have baked-in WB. If the color is off, use the `color calibration` module, but avoid aggressive shifts. 
* **Tip:** If the image is too "warm" or "cool," use the `color balance rgb` **4-way tab** (Global Offset) for a gentler correction than traditional WB sliders.

### LUT 3D (The "Film" Look)
* **Usage:** Apply for stylistic color grading (e.g., Kodak/Fuji simulations).
* **Workflow:** Place LUTs early in the pipe. 
* **Precaution:** Drop `opacity` to 30-50%. JPEGs lack the bit-depth for heavy LUT application; 100% opacity often causes "banding" in skies.

### Lens & Optical Corrections (Legacy Specific)
* **chromatic aberration:** Highly recommended for older "Rebel" era JPEGs. Modern modules can easily strip away purple/green fringing that 2006-era cameras ignored.
* **lens correction:** * **Use only if needed:** Legacy cameras did NOT correct distortion in-camera. 
  > Note: Turning this on will "re-sample" the 8-bit pixels. Only use if barrel/pincushion distortion is visually distracting.
* **haze removal:** Useful for old landscape shots to cut through atmospheric "muck" and improve contrast. Keep the strength low, around 0.1 to 0.2

### Geometry & Framing
* **Rotate and Perspective:** Fix horizons and keystoning.
* **Framing / Watermark:** Use when exporting