//
//  ColorPreview.swift
//  ColorPicker
//
//  Created by Holy Light on 13.02.2022.
//

import UIKit

final class ColorPreview: UIView {
    
    var isOnScreen = false
    
    var tapHandler:(()->Void)?
    
    lazy var preview: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.systemBlue.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    
    lazy var icon: UIImageView = {
        let container = UIImageView()
        container.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 50, weight: .ultraLight), scale: UIImage.SymbolScale.small)
        let image = (ColorManipulator.operatingMode == .regularPicking ? UIImage(systemName: "plus.circle", withConfiguration: config) : UIImage(systemName: "plus.viewfinder", withConfiguration: config))
        container.image = image
        return container
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(color: UIColor) {
        super.init(frame: .zero)
        preview.backgroundColor = color
        let recognizer = UITapGestureRecognizer(target: self, action: #selector (colorPrevivewTapped))
        self.addGestureRecognizer(recognizer)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor(red: 80/255, green: 80/255, blue: 80/255, alpha: 0.5)
        setupViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private func setupViews() {
        addSubview(preview)
        preview.addSubview(icon)
        setupLayout()
    }
    
    private func setupLayout(){
        NSLayoutConstraint.activate([
            preview.topAnchor.constraint(equalTo: topAnchor),
            preview.leadingAnchor.constraint(equalTo: leadingAnchor),
            preview.trailingAnchor.constraint(equalTo: trailingAnchor),
            preview.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            icon.centerXAnchor.constraint(equalTo: centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    @objc private func colorPrevivewTapped() {
        tapHandler!()
    }
    
    override class var requiresConstraintBasedLayout: Bool {
        return true //they say this shit is important to override, need to run some tests on it
    }
}
