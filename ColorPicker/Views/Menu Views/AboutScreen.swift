//
//  AboutScreen.swift
//  ColorPicker
//
//  Created by Holy Light on 02.07.2022.
//

import UIKit

final class AboutViewController: UIViewController {
    
    private var portraitConstraints: [NSLayoutConstraint]?
    
    private var landscapeConstraints: [NSLayoutConstraint]?
 
    private var isPortrait: Bool {
        UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isPortrait ?? true
    }
    
    private lazy var hehe: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var message: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var igButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.setTitle("Instagram", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(igButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var tgButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.setTitle("Telegram", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(tgButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var ghButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.setTitle("GitHub", for: .normal)
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(ghButtonPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.setTitle("Dismiss", for: .normal)
        button.setTitleColor(UIColor.systemRed, for: .normal)
        button.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemGray5
        view.addSubview(hehe)
        view.addSubview(buttonsStackView)
        view.addSubview(message)
        buttonsStackView.addArrangedSubview(tgButton)
        buttonsStackView.addArrangedSubview(ghButton)
        buttonsStackView.addArrangedSubview(igButton)
        buttonsStackView.addArrangedSubview(dismissButton)
        hehe.image = UIImage(named: "hehe.jpg")
        message.text = "     This app is proudly crafted by some dude who want to become an iOS developer one day. Actually it's a huge mess acrhitecture wise and probably also on every other aspect, but I'll leave it as is after some point just to preserve it as a monument to my first steps. You can contact me by pushing some buttons below if you want."
    }
    
    private func setupLayout() {
        
        landscapeConstraints = [
            hehe.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            hehe.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            message.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            message.leadingAnchor.constraint(equalTo: hehe.trailingAnchor, constant: 16),
            buttonsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            buttonsStackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ]
        
        portraitConstraints = [
            hehe.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hehe.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            message.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            message.topAnchor.constraint(equalTo: hehe.bottomAnchor, constant: 34),
            buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsStackView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
        ]
        
        let constants = [
        hehe.widthAnchor.constraint(equalToConstant: 250),
        hehe.heightAnchor.constraint(equalToConstant: 250),
        message.widthAnchor.constraint(equalToConstant: 300),
        buttonsStackView.widthAnchor.constraint(equalToConstant: 150),
        tgButton.heightAnchor.constraint(equalToConstant: 30),
        tgButton.widthAnchor.constraint(equalToConstant: 100),
        ghButton.heightAnchor.constraint(equalToConstant: 30),
        ghButton.widthAnchor.constraint(equalToConstant: 100),
        igButton.heightAnchor.constraint(equalToConstant: 30),
        igButton.widthAnchor.constraint(equalToConstant: 100),
        dismissButton.heightAnchor.constraint(equalToConstant: 30),
        dismissButton.widthAnchor.constraint(equalToConstant: 100),
        ]
        NSLayoutConstraint.activate(constants)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isPortrait {
            NSLayoutConstraint.deactivate(landscapeConstraints!)
            NSLayoutConstraint.activate(portraitConstraints!)
        } else {
            NSLayoutConstraint.deactivate(portraitConstraints!)
            NSLayoutConstraint.activate(landscapeConstraints!)
        }
    }

    @objc private func dismissController() {
        self.dismiss(animated: true)
    }
    
    @objc private func tgButtonPressed() {
        UIApplication.shared.open(URL(string: "https://t.me/uhhohhgoldenjoe")!)
    }
    
    @objc private func ghButtonPressed() {
        UIApplication.shared.open(URL(string: "https://github.com/PurrfectStorm")!)
    }
    
    @objc private func igButtonPressed() {
        UIApplication.shared.open(URL(string: "https://instagram.com/stuckatgeodata")!)
    }
}

