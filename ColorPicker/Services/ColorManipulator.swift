//
//  ColorManipulator.swift
//  ColorPicker
//
//  Created by Holy Light on 18.02.2022.
//

import Foundation
//MARK: - An entity to edit colors and sets

enum OperatingMode: Equatable {
    case regularPicking
    case setEditing (setIndex: Int)
}

struct ColorManipulator {
    
    static var operatingMode: OperatingMode = .regularPicking {
        didSet {
            NotificationCenter.default.post(name: Notification.Name("ColorPicker.StateChange"), object: nil)
        }
    }
    
    var savedColors: [Color] {
        get {
            return StorageManager.shared.restoreColorsFromUD()
        }
        set {
            StorageManager.shared.synchronizeColorsWithUD(colors: newValue)
        }
    }
    
    var savedColorSets: [ColorSet] {
        get {
            return StorageManager.shared.restoreColorSetsFromUD()
        }
        set {
            StorageManager.shared.synchronizeColorSetsWithUD(sets: newValue)
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
    
    func deleteAllData() {
        StorageManager.shared.deleteAllData()
    }
}
