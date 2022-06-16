//
//  Menu.swift
//  ColorPicker
//
//  Created by Holy Light on 19.02.2022.
//

import UIKit

//MARK: - root menu view controller
final class MenuViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var manipulator = ColorManipulator()
    
    private lazy var rootTV: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(rootTV)
        rootTV.delegate = self
        rootTV.dataSource = self
        NSLayoutConstraint.activate([
            rootTV.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rootTV.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            rootTV.heightAnchor.constraint(equalTo: view.heightAnchor),
            rootTV.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        switch indexPath.row {
        case 0 :
            cell.textLabel?.text = (ColorManipulator.operatingMode == .regularPicking ? "New color set from current photo" : "Stop adding colors to current set")
        case 1 :
            cell.textLabel?.text = "Colors"
            cell.accessoryType = .disclosureIndicator
        case 2 :
            cell.textLabel?.text = "Sets"
            cell.accessoryType = .disclosureIndicator
        case 3 :
            cell.textLabel?.text = "Delete all saved data"
            cell.textLabel?.textColor = .red
        default: break
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0: if ColorManipulator.operatingMode == .regularPicking {
            //create an empty color set
            manipulator.saveColorSet(set: ColorSet(title: "New set", colors: [], source: nil, dateCreated: Date()))
            //tell manipulator we are in set adding mode now
            ColorManipulator.operatingMode = .setEditing(setIndex: manipulator.savedColorSets.count - 1)
            self.dismiss(animated: true)
        } else {
            //we stopped editing set ang back to normal mode
            ColorManipulator.operatingMode = .regularPicking
            rootTV.reloadData()
        }
        case 1:
            ColorManipulator.operatingMode = .regularPicking
            navigationController?.pushViewController(ColorsViewController(), animated: true)
        case 2:
            ColorManipulator.operatingMode = .regularPicking
            navigationController?.pushViewController(ColorSetsViewController(), animated: true)
        case 3:
            ColorManipulator.operatingMode = .regularPicking
            manipulator.deleteAllData()
        default: break
        }
    }
}
