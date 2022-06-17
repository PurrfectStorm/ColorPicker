//
//  ColorManipulator.swift
//  ColorPicker
//
//  Created by Holy Light on 18.02.2022.
//

import Foundation
//MARK: - An entity to store, change and delete colors and sets

enum OperatingMode: Equatable {
    case regularPicking
    case setEditing (setIndex: Int)
}

struct ColorManipulator {
    
    static var operatingMode: OperatingMode = .regularPicking
    
    var savedColors: [Color] {
        get {
            //TODO: - why is this getter being called repeatedly so many times while accessing this var?
            return restoreColorsFromUD()
        }
        set {
            synchronizeColorsWithUD(colors: newValue)
        }
    }
    
    var savedColorSets: [ColorSet] {
        get {
            return restoreColorSetsFromUD()
        }
        set {
            synchronizeColorSetsWithUD(sets: newValue)
        }
    }
    //MARK: - Color operations
    mutating func saveColor(color: Color) {
        switch ColorManipulator.operatingMode {
        case .regularPicking: savedColors.append(color)
        case .setEditing(let index):
            savedColorSets[index].colors.append(color)
        }
    }
    
    mutating func deleteColor(position: Int) {
        switch ColorManipulator.operatingMode {
        case .regularPicking:
            if savedColors.count > 0 && position < savedColors.count {
                savedColors.remove(at: position)
            }
        case .setEditing(let index):
            if savedColorSets[index].colors.count > 0 && position < savedColorSets[index].colors.count {
                savedColorSets[index].colors.remove(at: position)
            }
        }
    }
    
    mutating func renameColor(name: String, position: Int) {
        switch ColorManipulator.operatingMode {
        case .regularPicking:
            if savedColors.count > 0 && position < savedColors.count {
                savedColors[position].title = name
            }
        case .setEditing(let index):
            if savedColorSets[index].colors.count > 0 && position < savedColorSets[index].colors.count {
                savedColorSets[index].colors[position].title = name
            }
        }
    }
    
    //MARK: - Color sets operations
    mutating func saveColorSet(set: ColorSet) {
        savedColorSets.append(set)
    }
    
    mutating func deleteColorSet(position: Int) {
        if savedColorSets.count > 0 && position < savedColorSets.count {
            savedColorSets.remove(at: position)
        }
    }
    
    mutating func renameColorSet(name: String, position: Int) {
        if savedColorSets.count > 0 && position < savedColorSets.count {
            savedColorSets[position].title = name
        }
    }
    //MARK: - Storage management
    
    mutating func deleteAllData() {
        savedColors.removeAll()
        savedColorSets.removeAll()
    }
    
    private func synchronizeColorsWithUD(colors: [Color]) {
        let defaults = UserDefaults.standard
        let encodedColors = try? JSONEncoder().encode(colors)
        defaults.set(encodedColors, forKey: "SavedColors")
        defaults.synchronize()
    }
    
    private func restoreColorsFromUD() -> [Color] {
        let defaults = UserDefaults.standard
        if let decoded  = defaults.data(forKey: "SavedColors") {
            if let decodedData = try? JSONDecoder().decode([Color].self, from: decoded) {
                return decodedData
            } else {
                return []
            }
        } else {
            return []
        }
    }
    
    private func synchronizeColorSetsWithUD(sets: [ColorSet]) {
        let defaults = UserDefaults.standard
        let encodedColors = try? JSONEncoder().encode(sets)
        defaults.set(encodedColors, forKey: "SavedColorSets")
        defaults.synchronize()
    }
    
    private func restoreColorSetsFromUD() -> [ColorSet] {
        let defaults = UserDefaults.standard
        if let decoded  = defaults.data(forKey: "SavedColorSets") {
            if let decodedData = try? JSONDecoder().decode([ColorSet].self, from: decoded) {
                return decodedData
            } else {
                return []
            }
        } else {
            return []
        }
    }
}
