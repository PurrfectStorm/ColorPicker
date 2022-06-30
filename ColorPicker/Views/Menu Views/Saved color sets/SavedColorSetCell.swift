//
//  SavedColorSetCell.swift
//  ColorPicker
//
//  Created by Holy Light on 13.06.2022.
//

import UIKit

final class SavedColorSetCell: UITableViewCell {
    
    static let identifier = "ColorSetCell"
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var previewsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 2
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let config = UIImage.SymbolConfiguration(textStyle: .title1)
        button.setImage(UIImage(systemName: "plus.circle", withConfiguration: config), for: .normal)
        button.isUserInteractionEnabled = true
        button.addTarget(nil, action: #selector(continueSetEditing), for: .touchUpInside)
        return button
    }()
    
    var addToSetButtonTapHandler:(()->Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(previewsStackView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(editButton)
        setupLayout()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            previewsStackView.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -5),
            previewsStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            dateLabel.widthAnchor.constraint(equalToConstant: 150),
            
            editButton.trailingAnchor.constraint(equalTo: previewsStackView.trailingAnchor, constant: -5),
            editButton.topAnchor.constraint(equalTo: previewsStackView.topAnchor, constant: 5),
            editButton.widthAnchor.constraint(equalToConstant: 30),
            editButton.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    func configure(cSet: ColorSet) {
        previewsStackView.removeAllArrangedSubviews()
        let colorsSlice = Array(cSet.colors.prefix(3))
        for color in colorsSlice {
            let colorToShow = UIColor(red: CGFloat(color.rValue),
                                      green: CGFloat(color.gValue),
                                      blue: CGFloat(color.bValue),
                                      alpha: CGFloat(color.aValue))
            let preview = UIView()
            preview.translatesAutoresizingMaskIntoConstraints = false
            preview.layer.masksToBounds = true
            preview.layer.cornerRadius = 5
            preview.backgroundColor = colorToShow
            NSLayoutConstraint.activate([
                preview.widthAnchor.constraint(equalToConstant: 40),
                preview.heightAnchor.constraint(equalToConstant: 40)
            ])
            previewsStackView.addArrangedSubview(preview)
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        dateLabel.text = "Taken \(formatter.string(from: cSet.dateCreated))"
        titleLabel.text = cSet.title
    }
    
    @objc func continueSetEditing() {
        addToSetButtonTapHandler!()
    }
}
