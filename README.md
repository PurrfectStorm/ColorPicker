 A simple app allowing user to save individual colors from any given photo, which can be added from clipboard as URL or raw data, picked from phone gallery or shot on camera. Loaded photo can be zoomed for convenience and user can pick color just by tapping at desired location. Picked colors are saved permanently on device and persists between app launches. Any number of colors can be grouped together as a color set, binding it with the image they were extracted from, which is also cached in device memory. Individual colors and color sets can be renamed or deleted if no longer needed, and hexadecimal color code can be copied by tapping on it. It is possible to add more colors to previously saved set, in this case image associated with this particular color set will reappear on screen, restored from cache, and after it regular color saving process can be continued. There is also a menu option to erase all previously saved colors, sets and cached photos at once.

  Stack used:
- Appearance: UIKit, programmatic Autolayout
- Data flow: delegation, closures, KVO
- Serialization: Codable
- Data persistence: UserDefaults, FileManager
