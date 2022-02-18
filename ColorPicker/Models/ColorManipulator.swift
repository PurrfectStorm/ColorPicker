//
//  ColorManipulator.swift
//  ColorPicker
//
//  Created by Holy Light on 18.02.2022.
//

import Foundation

struct ColorManipulator {
    
    var colors: [Color] = []
    var colorSets:[ColorSet] = []
    
    mutating func saveColor(color: Color) {
        colors.append(color)
        print (colors)
    }
    
    mutating func deleteColor(position: Int) {
        colors.remove(at: position)
    }
    
    mutating func addColorSet() {
        
    }
    
    mutating func updateColorSet() {
        
    }
    
    mutating func deleteColorSet() {
        
    }

}
