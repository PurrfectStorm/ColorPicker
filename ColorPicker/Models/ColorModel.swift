//
//  ColorModel.swift
//  ColorPicker
//
//  Created by Holy Light on 18.02.2022.
//

import Foundation

struct Color: Codable {
    let description: String
    let rValue: Float
    let gValue: Float
    let bValue: Float
    let aValue: Float
    let dateTaken: Date
}

struct ColorSet: Codable {
    let title: String
    var colors: [Color]
    let source: Data?
    let dateCreated: Date
}
