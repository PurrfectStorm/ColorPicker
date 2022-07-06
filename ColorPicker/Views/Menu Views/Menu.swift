//
//  Menu.swift
//  ColorPicker
//
//  Created by Holy Light on 19.02.2022.
//

import UIKit

fileprivate struct MenuSection {
    let title: String
    let items: [MenuItem]
}

fileprivate struct MenuItem {
    let icon: UIImage?
    let title: String
    let handler: (() -> Void)
}

//MARK: - root menu view controller
final class MenuViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var pictureReceiver: (() -> UIImage)?
    
    private var manipulator = ColorManipulator()
    
    private var menuModel:[MenuSection] = []
    
    private lazy var rootTV: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var cellImageColor: UIColor {
        switch traitCollection.userInterfaceStyle {
        case .dark: return UIColor.white
        case .light: return UIColor.black
        default: return UIColor.systemBlue
        }
    }
    
    private func getSourceFilename() -> String {
        //give a unique id to it
        let id = UUID().uuidString
        //tell storage service to cache it
        StorageManager.shared.cachePhoto(data: pictureReceiver!().pngData() ?? Data(), name: id)
        return id
    }
    
    private func populateModel() {
        
        var setCreationDescription: String {(ColorManipulator.operatingMode == .regularPicking ? "New color set from current photo" : "Stop adding colors to current set")}
        var setCreationIcon: UIImage? {(ColorManipulator.operatingMode == .regularPicking ? UIImage(systemName: "plus.square")?.withTintColor(cellImageColor, renderingMode: .alwaysOriginal) : UIImage(systemName: "xmark.square")?.withTintColor(cellImageColor, renderingMode: .alwaysOriginal))}
        menuModel.append(MenuSection(title: "Creation", items: [MenuItem(icon: setCreationIcon, title: setCreationDescription,
                                                                         handler: { [weak self] in
            if ColorManipulator.operatingMode == .regularPicking {
                //create an empty color set
                self?.manipulator.saveColorSet(set: ColorSet(title: "New set " + String((self?.manipulator.savedColorSets.count)! + 1), colors: [], source: self?.getSourceFilename() ?? "none", dateCreated: Date()))
                //tell manipulator we are in set adding mode now
                ColorManipulator.operatingMode = .setEditing(setIndex: (self?.manipulator.savedColorSets.count)! - 1)
                self?.dismiss(animated: true)
            } else {
                //we stopped editing set ang back to normal mode
                ColorManipulator.operatingMode = .regularPicking
                self?.menuModel.removeAll()
                self?.populateModel()
                self?.rootTV.reloadData()
            }
        })]))
        
        menuModel.append(MenuSection(title: "Color operations", items: [MenuItem(icon: nil, title: "Colors", handler: {  [weak self] in
            ColorManipulator.operatingMode = .regularPicking
            self?.navigationController?.pushViewController(ColorsViewController(), animated: true)
        }),
                                                                        MenuItem(icon: nil, title: "Sets", handler: { [weak self] in
            ColorManipulator.operatingMode = .regularPicking
            self?.navigationController?.pushViewController(ColorSetsViewController(), animated: true) })
                                                                       ])
        )
        
        let deleteIcon = UIImage(systemName: "xmark.bin")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
        menuModel.append(MenuSection(title: "Data management", items: [MenuItem(icon: deleteIcon, title: "Delete all saved data", handler: { [weak self] in
            ColorManipulator.operatingMode = .regularPicking
            self?.manipulator.deleteAllData()
        })]))
        
        let aboutIcon = UIImage(systemName: "questionmark.square")?.withTintColor(cellImageColor, renderingMode: .alwaysOriginal)
        menuModel.append(MenuSection(title: "", items: [MenuItem(icon: aboutIcon, title: "About", handler: { [weak self] in
            self?.navigationController?.pushViewController(AboutViewController(), animated: true)
        })]))
    }
    
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        populateModel()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return menuModel.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuModel[section].items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return menuModel[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.imageView?.image = menuModel[indexPath.section].items[indexPath.row].icon
        cell.textLabel?.text = menuModel[indexPath.section].items[indexPath.row].title
        switch indexPath.section{
        case 1: cell.accessoryType = .disclosureIndicator
        case 2: cell.textLabel?.textColor = .systemRed
        default: break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        menuModel[indexPath.section].items[indexPath.row].handler()
    }
}
