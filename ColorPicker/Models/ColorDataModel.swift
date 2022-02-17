//
//  ColorDataModel.swift
//  ColorPicker
//
//  Created by Holy Light on 18.02.2022.
//

import Foundation

struct Color {
    let description: String
    let rValue: Double
    let gValue: Double
    let bValue: Double
    let aValue: Double
    let dateTaken: Date
}

struct ColorSet {
    let title: String
    var colors: [Color]
    let source: Data
    let dateCreated: Date
}
