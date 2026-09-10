import Foundation

// Symbols used to create the sky
let skySymbols = ["☁️", "⭐️", "  ", "  "]

let width = 8
let height = 5

// Generate one random line of sky
func generateSkyLine() {
    var line = ""

    for _ in 0..<width {
        let randomIndex = Int.random(in: 0..<skySymbols.count)
        line += skySymbols[randomIndex]
    }

    print(line)
}

// Draw several lines of sky
func drawSky() {
    for _ in 0..<height {
        generateSkyLine()
    }
}

// Draw the complete scene
func drawLandscape() {
    drawSky()

    print("🌳   🏠   🏢   🌳")
    print("━━━━━━━━━━━━━━━━")
}

drawLandscape()
