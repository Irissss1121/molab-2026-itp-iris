import Foundation

let skySymbols = ["*", ".", " ", " ", " "]

func makeSky(width: Int, lines: Int) {
    for _ in 0..<lines {
        var line = ""

        for _ in 0..<width {
            let symbol = skySymbols.randomElement() ?? " "
            line += symbol
        }

        print(line)
    }
}

let city = """
    ____      ______
   | [] |    | [] []|
   | [] |____| [] []|
   |    | [] |      |
___|____|____|______|___
"""

func showCity() {
    print("Hiii")
    makeSky(width: 25, lines: 3)
    print(city)
}

showCity()
