//
//  SavedColorCell.swift
//  ColorPicker
//
//  Created by Holy Light on 20.02.2022.
//

import UIKit

//MARK: - basic cell representing a single saved color
final class SavedColorCell: UITableViewCell {
    
    static let identifier = "ColorCell"
    
    private lazy var preview: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 5
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var  hexDescription: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(preview)
        contentView.addSubview(dateLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(hexDescription)
        setupLayout()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            preview.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            preview.trailingAnchor.constraint(equalTo: hexDescription.leadingAnchor, constant: -5),
            preview.widthAnchor.constraint(equalToConstant: 40),
            preview.heightAnchor.constraint(equalToConstant: 40),
            
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            dateLabel.widthAnchor.constraint(equalToConstant: 150),
            
            hexDescription.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            hexDescription.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            hexDescription.widthAnchor.constraint(equalToConstant: 170),
        ])
    }
    
    func configure(color: Color) {
        let colorToShow = UIColor(red: CGFloat(color.rValue),
                                  green: CGFloat(color.gValue),
                                  blue: CGFloat(color.bValue),
                                  alpha: CGFloat(color.aValue))
        preview.backgroundColor = colorToShow
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        dateLabel.text = "Taken \(formatter.string(from: color.dateTaken))"
        titleLabel.text = color.title
        if let description = UIColor.convertToHex(color: colorToShow) {
            hexDescription.text = "Hex value #\(description)"
        }
    }
}
