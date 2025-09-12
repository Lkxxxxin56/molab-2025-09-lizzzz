# Week 01 — Washington Square Park Text Art

## Description
This project is a text-art sketch of **Washington Square Park**, drawn entirely in Swift (for the 1st time YAH) using loops, variables, and functions. 

## Inspiration
I wanted to turn my first coding exercise into something meaningful and place-based. 
Washington Square Park is at the heart of NYU life, so I used the park’s layout — the arch, the central fountain, the paths, and the surrounding streets — as a guide. 
Instead of random characters, I used descriptive words and emojis to capture the park’s identity.
The drawn park recreated the actual layout of WSP, but only important features are shown, street names, an arch emoji at the top, and a fountain emoji in the middle, and the circular plaza.

## Steps
1. **Built the frame**  
   - Repeated street names across the top and bottom.  
   - Added "|" borders to the left and right.  

2. **Created the circular space**  
   - Used a for-loop to calculate distance from a center point.  
   - Plotted `"O"` characters only where `(dx² + dy²)` was close to the radius squared.
   - Problem: the plaza looked like an oval instead of a perfect circle.
     - Reason: Each character's length is larger than its width, stretching the plaza vertically.
     - Result: Fixed! Added a stretch factor on the y-axis to make the circle look rounder in the console.  

3. **Placed elements inside**  
   - Added the fountain emoji (`⛲️`) at the exact center (`centerX, centerY`).  
   - Added the arch emoji (`🏛️`) at the top quarter of the space to represent the real arch at the north side of the park.
   - Problem: On each emoji line, the "|" border on the very right is being pushed to one unit further right.
     - Reason: Once an emoji is added, it is rendered as 2-character wide instead of one, 
     - Result: Not fixed! Fixing this error will cause me to rebuild the text art drawing system.

4. **Experimented and refined**  
   - Tried different radius sizes until the circle looked balanced.  
   - Adjusted spacing to keep borders aligned despite emoji width issues.  

## Reflection
This small sketch taught me how powerful even simple loops and conditions can be for creating visuals. 
At first the code only printed repeated street names, but step by step it became a recognizable park map with personality. 
I also learned about console quirks in  Swift — like why circles look oval and why emojis can misalign borders. 
Going forward, I want to explore ways of layering more descriptive language (trees, pigeons, paths) and maybe even animate parts of the sketch. 
It feels rewarding to see a familiar place emerge from nothing but text and logic.
