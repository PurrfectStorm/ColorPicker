//
//  Menu.swift
//  ColorPicker
//
//  Created by Holy Light on 19.02.2022.
//

import UIKit

//MARK: - root menu view controller
class MenuViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.accessoryType = .disclosureIndicator
        switch indexPath.row {
        case 0 : cell.textLabel?.text = "Colors"
        case 1 : cell.textLabel?.text = "Sets"
        default: break
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0: navigationController?.pushViewController(ColorsViewController(mode: .standalone), animated: true)
        case 1: navigationController?.pushViewController(ColorSetsViewController(), animated: true)
        default: break
        }
    }
}
