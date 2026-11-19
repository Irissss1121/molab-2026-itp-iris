# Week 11 – Memory Map

Memory Map lets me save a mood or a short note at my current location and read it later by tapping the pin.

## AI Use

I used ChatGPT to plan the first prototype and Codex to generate and revise the SwiftUI code. Codex implemented the MapKit map, location permissions, and local storage with SwiftData. When the Add Memory button stayed disabled, Codex checked the running iPhone simulator and found that it needed a simulated location.

After trying the first version, I wanted to do more than drop a pin. Codex added a form for writing and editing memories, tested that saved notes could be reopened after restarting the app, and added English comments to help me follow the code.

### Prompt

> Help me build Memory Map in my existing SwiftUI project at `week10/MemoryMap`. Use MapKit to show the map and Core Location to request my location while the app is open. When I tap **Add Memory**, capture where I am at that moment and let me choose a mood, write a short note, or both. When I tap **Save**, store the coordinates, date, mood, and note on my device and place a pin there. I want to tap that pin later to read or edit the memory.
>
> Keep the Swift code simple enough for me to explain in class. Add short English `//` comments where the app gets my location and saves a memory. Test it in the iPhone simulator and show me how to set a simulated location, save a memory, and check that it is still there after I close and reopen the app.
