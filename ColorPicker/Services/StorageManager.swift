//
//  StorageManager.swift
//  ColorPicker
//
//  Created by Holy Light on 26.06.2022.
//

import Foundation

struct StorageManager {
    
    static let shared = StorageManager()
    
    //cache operations
    func cachePhoto(data: Data, name: String) {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = path.appendingPathComponent(name)
        do {
            try data.write(to: url)
        }
        catch {
            print("cache writing" + error.localizedDescription)
        }
    }
    
    func restoreFromCache(named: String) -> Data {
        var outputData = Data()
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let url = path.appendingPathComponent(named)
        do {
            outputData = try Data(contentsOf: url)
        }
        catch {
            print("cache reading" + error.localizedDescription)
        }
        return outputData
    }
    
    func deleteFromCache(fileName: String) {
        let cacheURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let directoryContents = try? FileManager.default.contentsOfDirectory( at: cacheURL, includingPropertiesForKeys: nil, options: [])
        if let contents = directoryContents, contents.count > 0 {
            for _file in contents {
                if String(describing: _file).contains(fileName) {
                    do {
                        try FileManager.default.removeItem(at: _file)
                    }
                    catch  {
                        print("cache deleting" + error.localizedDescription)
                    }
                }
            }
        }
    }
    
    //handle userdefaults business
    func synchronizeColorsWithUD(colors: [Color]) {
        let defaults = UserDefaults.standard
        let encodedColors = try? JSONEncoder().encode(colors)
        defaults.set(encodedColors, forKey: "SavedColors")
        defaults.synchronize()
    }
    
    func restoreColorsFromUD() -> [Color] {
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
    
    func synchronizeColorSetsWithUD(sets: [ColorSet]) {
        let defaults = UserDefaults.standard
        let encodedColors = try? JSONEncoder().encode(sets)
        defaults.set(encodedColors, forKey: "SavedColorSets")
        defaults.synchronize()
    }
    
    func restoreColorSetsFromUD() -> [ColorSet] {
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
    
    func deleteAllData() {
        //clear userdefaults
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: "SavedColors")
        defaults.set(nil, forKey: "SavedColorSets")
        //also delete cached photos
        let cacheURL =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let directoryContents = try? FileManager.default.contentsOfDirectory( at: cacheURL, includingPropertiesForKeys: nil, options: [])
        if let contents = directoryContents, contents.count > 0 {
            for file in contents {
                do {
                    try FileManager.default.removeItem(at: file)
                }
                catch  {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
