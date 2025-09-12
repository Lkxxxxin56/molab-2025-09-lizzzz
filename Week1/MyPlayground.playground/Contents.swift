import Foundation

// The borders of WSP
let street1 = "WaverlyPlace_"
let street2 = "West4thStreet"
let repeats = 3
let rows = 10
let top = String(repeating: street1, count: repeats)
let bottom = String(repeating: street2, count: repeats)
let width = max(top.count, bottom.count)
let topLine = top + String(repeating: " ", count: width - top.count)
let bottomLine = bottom + String(repeating: " ", count: width - bottom.count)
print(topLine)

// --- Drawing area setup (between the side borders) ---
let innerW = width - 2
let centerX = innerW/2 //center relative to inner area
let centerY = rows/2
let radius = 6
let stretch = 2

let fountain = "⛲️"
let fountainX = centerX
let fountainY = centerY

let arch = "⛩️"
let archX = centerX
let archY = rows/8

let gate = "🚧"
let gateX = centerX
let gateY = rows*7/8

// Draw ring + fountain together
for y in 0..<rows {
    var line = "|"
    for x in 0..<innerW {
        // distance-squared with horizontal stretch
        let dx = (x - centerX)
        let dy = (y - centerY) * stretch
        let dist2 = dx*dx + dy*dy
        let onRing = dist2 >= (radius-1)*(radius-1) && dist2 <= (radius+1)*(radius+1)

        if x == fountainX && y == fountainY {
            line += fountain // draw fountain at center
            line += ""
        } else if x == archX && y == archY {
            line += arch
            line += ""
        } else if x == gateX && y == gateY {
            line += gate
            line += ""
        } else if onRing {
            line += "O" // ring
        } else {
            line += " " // empty
        }
    }
    line += "|"
    print(line)
}

// Draw the arch

print(bottomLine)
