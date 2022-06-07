//
//  SavedColors.swift
//  ColorPicker
//
//  Created by Holy Light on 20.02.2022.
//

import UIKit

//MARK: - saved colors submenu list
class SavedColorsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private lazy var manipulator = ColorManipulator()
    private var cellPositionForRenaming: Int?
    
    private lazy var colorsTV: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SavedColorCell.self, forCellReuseIdentifier: SavedColorCell.identifier)
        return tableView
    }()
    
    private var alert: UIAlertController {
        let alert = UIAlertController(title: "Rename color", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self]_ in
            guard let fields = alert.textFields else {
                return
            }
            let nameField = fields[0]
            guard let newName = nameField.text, !newName.isEmpty else {
                return
            }
            if let newPosition = self?.cellPositionForRenaming {
                self?.manipulator.renameColor(name: newName, position: newPosition)
                self?.colorsTV.reloadData()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addTextField()
        return alert
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(colorsTV)
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressToRename(sender:)))
        colorsTV.addGestureRecognizer(longPressRecognizer)
        colorsTV.delegate = self
        colorsTV.dataSource = self
        NSLayoutConstraint.activate([
            colorsTV.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            colorsTV.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            colorsTV.heightAnchor.constraint(equalTo: view.heightAnchor),
            colorsTV.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manipulator.savedColors.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SavedColorCell.identifier, for: indexPath) as? SavedColorCell else {
            return UITableViewCell()
        }
        cell.configure(color: manipulator.savedColors[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            manipulator.deleteColor(position: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    @objc private func longPressToRename (sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            let touchPoint = sender.location(in: colorsTV)
            if let indexPath = colorsTV.indexPathForRow(at: touchPoint) {
                cellPositionForRenaming = indexPath.row
                present(alert, animated: true)
            }
        }
    }
}

