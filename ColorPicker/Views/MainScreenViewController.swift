//
//  MainScreenViewController.swift
//  MainScreenViewController
//
//  Created by Holy Light on 16.12.2021.
//

import UIKit
import PhotosUI

final class MainScreenViewController: UIViewController, CPImagePresenter {
    
    //MARK: - Setting initial variables
    private(set) lazy var provider = ImageProvider(presenter: self)
    
    private lazy var manipulator = ColorManipulator()
    
    private var colorPreview = ColorPreview()
    
    private var imageToShow: UIImage? {
        willSet {
            mainImage.image = newValue
        }
        didSet {
            updateScrollViewContentSize()
            imageScrollView.minimumZoomScale = view.frame.width/imageToShow!.size.width
            imageScrollView.maximumZoomScale = imageScrollView.minimumZoomScale*5
            resizeOnDoubleTap()
        }
    }
    
    lazy var mainImage: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
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
    
    private lazy var menuButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "list.bullet.rectangle.portrait"), for: .normal)
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
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
    
    private lazy var imageScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        return scrollView
    }()
    
    //MARK: - Views setup and layout
    private func setupViews() {
        bottomButtonsStackView.addArrangedSubview(menuButton)
        bottomButtonsStackView.addArrangedSubview(cameraButton)
        bottomButtonsStackView.addArrangedSubview(galleryButton)
        bottomButtonsStackView.addArrangedSubview(clipboardButton)
        let colorRecognizer = UITapGestureRecognizer(target: self, action: #selector (pointTapped))
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector (resizeOnDoubleTap))
        doubleTapRecognizer.numberOfTapsRequired = 2
        // single tap gesture recognizer won't be activated at the same time with the double one because of next line
        colorRecognizer.require(toFail: doubleTapRecognizer)
        mainImage.addGestureRecognizer(colorRecognizer)
        imageScrollView.addGestureRecognizer(doubleTapRecognizer)
        view.addSubview(imageScrollView)
        imageScrollView.addSubview(mainImage)
        updateScrollViewContentSize()
        view.addSubview(bottomButtonsStackView)
    }
    private func setupLayout() {
        let constraints: [NSLayoutConstraint] = [
            
            imageScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageScrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            imageScrollView.heightAnchor.constraint(equalTo: view.heightAnchor),
            
            mainImage.topAnchor.constraint(equalTo: imageScrollView.topAnchor),
            mainImage.leadingAnchor.constraint(equalTo: imageScrollView.leadingAnchor),
            
            bottomButtonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomButtonsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            
            cameraButton.heightAnchor.constraint(equalToConstant: 50),
            cameraButton.widthAnchor.constraint(equalToConstant: 50),
            
            clipboardButton.heightAnchor.constraint(equalToConstant: 50),
            clipboardButton.widthAnchor.constraint(equalToConstant: 50),
            
            galleryButton.heightAnchor.constraint(equalToConstant: 50),
            galleryButton.widthAnchor.constraint(equalToConstant: 50),
            
            menuButton.heightAnchor.constraint(equalToConstant: 50),
            menuButton.widthAnchor.constraint(equalToConstant: 50),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    private func updateScrollViewContentSize(){
        if let safeSize = mainImage.image?.size {
            imageScrollView.contentSize = safeSize
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupLayout()
    }
    
    func show(image: UIImage) {
        removeColorPreview()
        imageToShow = image
    }
    //MARK: - User intents
    
    //MARK: paste photo from clipboard
    @objc private func importFromClipboard(_ sender: UIButton) {
        removeColorPreview()
        provider.makeImage(.clipboard)
    }
    //MARK: take photo
    @objc private func showCamera() {
        removeColorPreview()
        let cameraPhotoPicker = UIImagePickerController()
        cameraPhotoPicker.sourceType = .camera
        cameraPhotoPicker.delegate = self
        self.present(cameraPhotoPicker, animated: true)
    }
    //MARK: choose photo from gallery
    @objc private func showGallery() {
        removeColorPreview()
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        let galleryPhotoPicker = PHPickerViewController(configuration: config)
        galleryPhotoPicker.delegate = self
        self.present(galleryPhotoPicker, animated: true)
    }
    //MARK: pick a color from photo
    @objc private func pointTapped(_ sender:UITapGestureRecognizer) {
        let xPosition = sender.location(in: view).x
        let yPosition = sender.location(in: view).y
        let xPosForColorPicking = sender.location(in: mainImage).x
        let yPosForColorPicking = sender.location(in: mainImage).y
        let colorToShow = mainImage.image?.getPixelColor(pos: CGPoint(x: xPosForColorPicking, y: yPosForColorPicking))
        let newPosition = calculateAdjustedPosition(originX: xPosition, originY: yPosition)
        if !colorPreview.isOnScreen {
            colorPreview = ColorPreview(color: colorToShow!)
            presentColorPreview(pointX: newPosition.x, pointY: newPosition.y)
        } else {
            colorPreview.isOnScreen = false
            colorPreview.removeFromSuperview()
            colorPreview = ColorPreview(color: colorToShow!)
            presentColorPreview(pointX: newPosition.x, pointY: newPosition.y)
        }
    }
    //MARK: show settings
    @objc private func showMenu() {
        let menuVC = MenuViewController()
        menuVC.title = "Menu"
        let navVC = UINavigationController(rootViewController: menuVC)
        present(navVC, animated: true)
    }
    //checking input coordinates to prevent color preview appearing offscreen
    private func calculateAdjustedPosition(originX: CGFloat, originY: CGFloat) -> (x:CGFloat, y:CGFloat){
        var adjX = originX
        var adjY = originY
        if originX > (view.bounds.width - 100) {
            adjX = originX - 90
        }
        if originY > (view.bounds.height - 100) {
            adjY = originY - 90
        }
        return (adjX,adjY)
    }
    //MARK: resize current photo to min zoom scale
    @objc private func resizeOnDoubleTap() {
        imageScrollView.setZoomScale(imageScrollView.minimumZoomScale, animated: true)
        imageScrollView.scrollRectToVisible(view.bounds, animated: true)
    }
    //MARK: - show a view with picked color and actions
    private func presentColorPreview(pointX: CGFloat, pointY: CGFloat) {
        view.addSubview(colorPreview)
        colorPreview.isOnScreen = true
        NSLayoutConstraint.activate([
            colorPreview.topAnchor.constraint(equalTo: view.topAnchor, constant: pointY),
            colorPreview.leftAnchor.constraint(equalTo: view.leftAnchor, constant: pointX),
            colorPreview.heightAnchor.constraint(equalToConstant: 80),
            colorPreview.widthAnchor.constraint(equalToConstant: 80)
        ])
    }
    
    func colorPrevivewTapped() {
        guard let components = colorPreview.preview.backgroundColor!.cgColor.components, components.count >= 3 else {return}
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        let a = Float(components[3])
        var colorsCount: Int
        switch ColorManipulator.operatingMode {
        case .regularPicking:
            colorsCount = manipulator.savedColors.count
        case .setEditing(let index):
            colorsCount = manipulator.savedColorSets[index].colors.count
        }
        let colorToSave = Color(title: "Color \(colorsCount)", rValue: r, gValue: g, bValue: b, aValue: a, dateTaken: Date())
        manipulator.saveColor(color: colorToSave)
        showNotification(text: "Color saved", mode: .regular)
    }
    //MARK: - removing color preview on user action
    private func removeColorPreview() {
        if colorPreview.isOnScreen {
            colorPreview.removeFromSuperview()
        }
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        removeColorPreview()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeColorPreview()
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
            notification.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            notification.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            notification.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            notification.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}

