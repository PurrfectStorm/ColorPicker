//
//  SavedColorSets.swift
//  ColorPicker
//
//  Created by Holy Light on 13.06.2022.
//

import UIKit

class ColorSetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private lazy var manipulator = ColorManipulator()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manipulator.savedColorSets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SavedColorSetCell.identifier, for: indexPath) as? SavedColorSetCell else {
            return UITableViewCell()
        }
        return cell
    }
}
