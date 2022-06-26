//
//  SavedColorSets.swift
//  ColorPicker
//
//  Created by Holy Light on 13.06.2022.
//

import UIKit

final class ColorSetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private lazy var manipulator = ColorManipulator()
    
    private var cellPositionForRenaming: Int?
    
    private lazy var colorSetsTV: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SavedColorSetCell.self, forCellReuseIdentifier: SavedColorSetCell.identifier)
        return tableView
    }()
    
    private var alert: UIAlertController {
        let alert = UIAlertController(title: "Rename color set", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self] _ in
            guard let fields = alert.textFields else {
                return
            }
            let nameField = fields[0]
            guard let newName = nameField.text, !newName.isEmpty else {
                return
            }
            if let newPosition = self?.cellPositionForRenaming {
                self?.manipulator.renameColorSet(name: newName, position: newPosition)
                self?.colorSetsTV.reloadData()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addTextField()
        return alert
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(colorSetsTV)
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressToRename(sender:)))
        colorSetsTV.addGestureRecognizer(longPressRecognizer)
        colorSetsTV.delegate = self
        colorSetsTV.dataSource = self
        NSLayoutConstraint.activate([
            colorSetsTV.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            colorSetsTV.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            colorSetsTV.heightAnchor.constraint(equalTo: view.heightAnchor),
            colorSetsTV.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manipulator.savedColorSets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SavedColorSetCell.identifier, for: indexPath) as? SavedColorSetCell else {
            return UITableViewCell()
        }
        cell.addToSetButtonTapHandler = { [weak self] in
            //enable set editing mode
            ColorManipulator.operatingMode = .setEditing(setIndex: indexPath.row)
            //tell main VC to put cached photo on main screen
            if let vc = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController as? MainScreenViewController {
                vc.showCachedPhoto(named: (self?.manipulator.savedColorSets[indexPath.row].source)!)
            }
            //dismiss menu
            self?.navigationController?.dismiss(animated: true)
        }
        cell.configure(cSet: manipulator.savedColorSets[indexPath.row])
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            StorageManager.shared.deleteFromCache(fileName: manipulator.savedColorSets[indexPath.row].source)
            manipulator.deleteColorSet(position: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
    
    @objc private func longPressToRename (sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: colorSetsTV)
            if let indexPath = colorSetsTV.indexPathForRow(at: touchPoint) {
                cellPositionForRenaming = indexPath.row
                present(alert, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        ColorManipulator.operatingMode = .setEditing(setIndex:indexPath.row)
        navigationController?.pushViewController(ColorsViewController(), animated: true)
    }
}
