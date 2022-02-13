//
//  ColorPreview.swift
//  ColorPicker
//
//  Created by Holy Light on 13.02.2022.
//

import UIKit

class ColorPreview: UIView {
    
    var isOnScreen: Bool = false
    
    private lazy var preview: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(color: UIColor) {
        super.init(frame: .zero)
        preview.backgroundColor = color
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        self.backgroundColor = .tertiaryLabel
        setupViews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private func setupViews() {
        addSubview(preview)
        setupLayout()
    }
    
    private func setupLayout(){
        NSLayoutConstraint.activate([
            preview.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            preview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            preview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            preview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        ])
    }
    
    override class var requiresConstraintBasedLayout: Bool {
        return true //they say this shit is important to override, need to run some tests on it
    }
}

