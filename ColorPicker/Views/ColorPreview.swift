//
//  ColorPreview.swift
//  ColorPicker
//
//  Created by Holy Light on 13.02.2022.
//

import UIKit

final class ColorPreview: UIView {
    
    var isOnScreen = false
    
    lazy var preview: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 10
        return view
    }()
    
    lazy var icon: UIImageView = {
        let container = UIImageView()
        container.translatesAutoresizingMaskIntoConstraints = false
        let image = (ColorManipulator.operatingMode == .regularPicking ? UIImage(systemName: "plus.circle") : UIImage(systemName: "pencil.tip.crop.circle.badge.plus"))
        container.image = image
        container.alpha = 0.5
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
            preview.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            preview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            preview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            preview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            icon.centerXAnchor.constraint(equalTo: centerXAnchor),
            icon.centerYAnchor.constraint(equalTo: centerYAnchor),
            icon.widthAnchor.constraint(equalTo: widthAnchor, constant: -50),
            icon.heightAnchor.constraint(equalTo: heightAnchor, constant: -50),
        ])
    }
    
    @objc private func colorPrevivewTapped() {
        var parentViewController: UIViewController? {
            let s = sequence(first: self) { $0.next }
            return s.compactMap { $0 as? UIViewController }.first
        }
        if let hostVC = parentViewController as? MainScreenViewController {
            hostVC.colorPrevivewTapped()
        }
    }
    
    override class var requiresConstraintBasedLayout: Bool {
        return true //they say this shit is important to override, need to run some tests on it
    }
}
