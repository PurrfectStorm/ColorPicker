//
//  ColorManipulator.swift
//  ColorPicker
//
//  Created by Holy Light on 18.02.2022.
//

import Foundation
//MARK: - An entity to store, change and delete colors and sets
struct ColorManipulator {
    
    var savedColors: [Color] {
        get {
            //TODO: - why is this setter being called repeatedly so many times while accessing this var?
            return restoreColorsFromUD()
        }
        set {
            synchronizeColorsWithUD(colors: newValue)
        }
    }

    mutating func saveColor(color: Color) {
        savedColors.append(color)
    }
    
    mutating func deleteColor(position: Int) {
        if savedColors.count > 0 && position < savedColors.count {
            savedColors.remove(at: position)
        }
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
}
