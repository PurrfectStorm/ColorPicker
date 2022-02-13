//
//  NotificationView.swift
//  ColorPicker
//
//  Created by Holy Light on 13.02.2022.
//

import Foundation

import UIKit

//MARK: basically a UIlabel to show a given text of notification

enum NotificationType {
    case regular
    case error
}

class NotificationLabel: UILabel {
    init(text:String, type: NotificationType) {
        super.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.text = text
        self.numberOfLines = 0
        self.adjustsFontSizeToFitWidth = true
        self.textAlignment = .center
        self.font = .systemFont(ofSize: 22)
        self.textColor = .white
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
        switch type {
        case .regular: self.backgroundColor = UIColor(red: 0/255, green: 55/255, blue: 0/255, alpha: 0.5)
        case .error: self.backgroundColor = UIColor(red: 55/255, green: 0/255, blue: 0/255, alpha: 0.5)
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //    deinit{
    //        print("Notification label is deallocated from memory")
    //    }
}

