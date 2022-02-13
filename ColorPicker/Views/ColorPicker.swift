//
//  ColorPicker.swift
//  ColorPicker
//
//  Created by Holy Light on 16.12.2021.
//

import UIKit
import PhotosUI

class ColorPicker: UIViewController, CPImagePresenter {
    
    //MARK: - Setting initial variables
    lazy var provider = ImageProvider(presenter: self)
    var colorPreview = ColorPreview()
    var imageToShow: UIImage? {
        willSet {
            mainImage.image = newValue
        }
        didSet {
            updateScrollViewContentSize()
            scrollView.minimumZoomScale = view.frame.width/imageToShow!.size.width
            scrollView.maximumZoomScale = scrollView.minimumZoomScale*3
        }
    }
    lazy var mainImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    private lazy var cameraButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "camera.shutter.button"), for: .normal)
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(showCamera), for: .touchUpInside)
        return button
    }()
    private lazy var galleryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "photo.on.rectangle.angled"), for: .normal)
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(showGallery), for: .touchUpInside)
        return button
    }()
    private lazy var clipboardButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "doc.on.clipboard"), for: .normal)
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(importFromClipboard), for: .touchUpInside)
        return button
    }()
    private lazy var bottomButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 40
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        return scrollView
    }()
    
    //MARK: - Views setup and layout
    private func setupViews() {
        bottomButtonsStackView.addArrangedSubview(cameraButton)
        bottomButtonsStackView.addArrangedSubview(galleryButton)
        bottomButtonsStackView.addArrangedSubview(clipboardButton)
        let scrollRecognizer = UITapGestureRecognizer(target: self, action: #selector (pointTapped))
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector (resizeOnDoubleTap))
        doubleTapRecognizer.numberOfTapsRequired = 2
        // single tap gesture recognizer won't be activated at the same time with the double one because of next line
        scrollRecognizer.require(toFail: doubleTapRecognizer)
        scrollView.addGestureRecognizer(scrollRecognizer)
        scrollView.addGestureRecognizer(doubleTapRecognizer)
        view.addSubview(scrollView)
        updateScrollViewContentSize()
        scrollView.addSubview(mainImage)
        view.addSubview(bottomButtonsStackView)
    }
    
    private func setupLayout() {
        let constraints: [NSLayoutConstraint] = [
            
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.heightAnchor),
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            bottomButtonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomButtonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            cameraButton.heightAnchor.constraint(equalToConstant: 50),
            cameraButton.widthAnchor.constraint(equalToConstant: 50),
            
            clipboardButton.heightAnchor.constraint(equalToConstant: 50),
            clipboardButton.widthAnchor.constraint(equalToConstant: 50),
            
            galleryButton.heightAnchor.constraint(equalToConstant: 50),
            galleryButton.widthAnchor.constraint(equalToConstant: 50),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func updateScrollViewContentSize(){
        if let safeSize = mainImage.image?.size {
            scrollView.contentSize = safeSize
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
    }
    
    //MARK: - Primary function of this VC is showing images
    func show(image: UIImage) {
        imageToShow = image
    }
    //MARK: - User intents
    @objc func showCamera() {
        let cameraPhotoPicker = UIImagePickerController()
        cameraPhotoPicker.sourceType = .camera
        cameraPhotoPicker.delegate = self
        self.present(cameraPhotoPicker, animated: true)
    }
    
    @objc func showGallery() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        let galleryPhotoPicker = PHPickerViewController(configuration: config)
        galleryPhotoPicker.delegate = self
        self.present(galleryPhotoPicker, animated: true)
    }
    
    @objc private func pointTapped(_ sender:UITapGestureRecognizer) {
        
        let xPosition = sender.location(in: view).x
        let yPosition = sender.location(in: view).y
        let xPosForColorPicking = sender.location(in: mainImage).x
        let yPosForColorPicking = sender.location(in: mainImage).y
        let colorToShow = mainImage.image?.getPixelColor(pos: CGPoint(x: xPosForColorPicking, y: yPosForColorPicking))
        if !colorPreview.isOnScreen {
            colorPreview = ColorPreview(color: colorToShow!)
            presentColorPreview(at: xPosition, pointY: yPosition)
        } else {
            colorPreview.isOnScreen = false
            colorPreview.removeFromSuperview()
            colorPreview = ColorPreview(color: colorToShow!)
            presentColorPreview(at: xPosition, pointY: yPosition)
        }
    }
    @objc private func resizeOnDoubleTap(_ sender:UITapGestureRecognizer) {
        scrollView.setZoomScale(scrollView.minimumZoomScale, animated: true)
    }
    @objc private func importFromClipboard(_ sender: UIButton) {
        provider.makeImage(.clipboard)
    }
    
    private func presentColorPreview(at pointX: CGFloat, pointY: CGFloat) {
        view.addSubview(colorPreview)
        colorPreview.isOnScreen = true
        NSLayoutConstraint.activate([
            colorPreview.topAnchor.constraint(equalTo: view.topAnchor, constant: pointY),
            colorPreview.leftAnchor.constraint(equalTo: view.leftAnchor, constant: pointX),
            colorPreview.heightAnchor.constraint(equalToConstant: 50),
            colorPreview.widthAnchor.constraint(equalToConstant: 50)
            ])
    }
    
    //MARK: - Notification service
    func showNotification(text: String, mode: NotificationType) {
        let notification = NotificationLabel(text: text, type: mode)
        view.addSubview(notification)
        setupNotificationConstraints(notification)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            notification.removeFromSuperview()
        }
        
    }
    private func setupNotificationConstraints(_ notification: NotificationLabel) {
        NSLayoutConstraint.activate([
            notification.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            notification.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            notification.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            notification.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

