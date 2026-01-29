```bash
 _     _____ ___  _   _ _____
| |   | ____/ _ \| \ | |__  /
| |   |  _|| | | |  \| | / / 
| |___| |__| |_| | |\  |/ /_ 
|_____|_____\___/|_| \_/____|
                             
```

# darktable - panoramas
_Updated February 2026_

**Helpful Videos**
[Setup tips from Bruce from his Pano series](https://www.youtube.com/watch?v=LptFcD3rdhk&t=1498s)

**Prep in darktable**
- Before exporting, turn off lens correction module for all images (Paste in append mode). Verify color calibration/WB is the same
- Keep resolution dimensions during export from darktable and for Panorama (R6m2 is 6022x4024)

Export settings for Panorama TIFFs

![tiff-export.png](./assets/darktable_tiff_export.png)

**Hugin panorama stitcher tips**
> Darktable has a hugin lua script - need to try
> Basics on how to stitch using simple mode in [this video from darktable Landscapes](https://www.youtube.com/watch?v=pxuLCLpRPrs)
> Advanced mode stitching from [Bruce's Pano series](https://www.youtube.com/watch?v=QXQCeuSEq6I&t=601s)
> Multi-row sitching and manually seleccting control points from [Bruce's Pano series](https://www.youtube.com/watch?v=ArQQzIIOAkU&t=3s)
> Another helpful video that shows auto and semi-auto mode in Hugin for multi-row panos [here](https://www.youtube.com/watch?v=OaLNFKh82Dg)

- Use _straighten_ button on the Move/Drag tab
- Use  Projection tab to set type of pano:
	 Rectilinear: Good for narrow panoramas
    Cylindrical: Good for wide, horizontal panoramas. Preserves vertial lines
    Panini may work with architectural lines
- Save project files and pano TIFFs (tar them)

**AFTERWARDS (Stitched Panoramas)**
1. Import the final stitched TIFF/PNG back into darktable.
2. Select all the original RAW files used for the panorama plus the stitched file.
3. Group them using **Ctrl+G** (or the 'group' button in the 'selected image(s)' module).
    > Ensure the **stitched panorama** is the **group leader**.
4. Apply the 🔵 Rating (as you defined: "Part of Panorama stack while editing") to the source RAWs, and apply the final **Purple** color rating ("Editing done, finished") and 5-star quality rating to the group leader (stitched image).
5. Apply a tag _panorama source_ to the original RAWs and _panorama_stiched_ to the final image for filtering.
6. Use command `exiftool -TagsFromFile IMG_1234.TIF -all:all panorama_output.tif` to re-import EXIF info