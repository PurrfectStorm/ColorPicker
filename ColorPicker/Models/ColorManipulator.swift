//
//  ColorManipulator.swift
//  ColorPicker
//
//  Created by Holy Light on 18.02.2022.
//

import Foundation

struct ColorManipulator {
    
    static var colors: [Color] = [] //{
    //        willSet {
    //            let defaults = UserDefaults()
    //            defaults.set(newValue, forKey: "colors")
    //        }
    //    }
    //    var colorSets:[ColorSet] = []
    
    static func saveColor(color: Color) {
        colors.append(color)
    }
    
    static func deleteColor(position: Int) {
        if colors.count > 0 && position < colors.count {
            colors.remove(at: position)
        }
    }
    //
    //    mutating func addColorSet() {
    //
    //    }
    //
    //    mutating func updateColorSet() {
    //
    //    }
    //
    //    mutating func deleteColorSet() {
    //
    //    }
}
