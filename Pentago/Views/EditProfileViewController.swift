//
//  EditProfileViewController.swift
//  Pentago
//
//  Created programmatically on 11/5/2026
//

import UIKit

class EditProfileViewController: UIViewController {
    
    // MARK: - Properties
    var profile: PlayerProfile?
    var profileManager: PlayerProfileManager?
    var onProfileUpdated: ((PlayerProfile) -> Void)?
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let gradientLayer = CAGradientLayer()
    
    // Floating orbs for background animation
    private let orb1 = FloatingOrbView(color: UIColor.systemPurple.withAlphaComponent(0.3), size: 200)
    private let orb2 = FloatingOrbView(color: UIColor.systemBlue.withAlphaComponent(0.25), size: 180)
    
    // Profile Display Section
    private let profileDisplayContainer = UIView()
    private let profileImageView = UIImageView()
    private let marbleColorView = UIView()
    private let usernameDisplayLabel = UILabel()
    private let marbleColorNameLabel = UILabel()
    private let idLabel = UILabel()
    
    // Form Section
    private let formContainer = UIView()
    
    private let usernameFieldContainer = UIView()
    private let usernameLabel = UILabel()
    private let usernameTextField = UITextField()
    
    private let player1Container = UIView()
    private let player1Label = UILabel()
    private let player1StatusLabel = UILabel()
    
    private let player2Container = UIView()
    private let player2Label = UILabel()
    private let player2StatusLabel = UILabel()
    
    private let profilePictureContainer = UIView()
    private let profilePictureLabel = UILabel()
    private let profilePictureButton = UIButton(type: .system)
    
    private let marbleColorContainer = UIView()
    private let marbleColorLabel = UILabel()
    private let marbleColorButton = UIButton(type: .system)
    
    // Delete Button
    private let deleteButton = UIButton(type: .system)
    
    // Available profile pictures and colors
    private let availableProfilePictures = ["Tiger", "Lion", "Bear", "Eagle", "Wolf", "Panda", "Fox", "Owl"]
    private let availableMarbleColors = [
        ("Red", UIColor.systemRed),
        ("Blue", UIColor.systemBlue),
        ("Green", UIColor.systemGreen),
        ("Yellow", UIColor.systemYellow),
        ("Purple", UIColor.systemPurple),
        ("Orange", UIColor.systemOrange),
        ("Pink", UIColor.systemPink),
        ("Teal", UIColor.systemTeal)
    ]
    
    private var selectedProfilePicture: String = "Tiger"
    private var selectedMarbleColor: String = "Red"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        setupActions()
        loadProfileData()
        
        // Dismiss keyboard on tap
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        startAnimations()
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        title = "Edit Profile"
        
        // Gradient Background
        gradientLayer.colors = [
            UIColor(red: 0.1, green: 0.2, blue: 0.45, alpha: 1.0).cgColor,
            UIColor(red: 0.2, green: 0.1, blue: 0.3, alpha: 1.0).cgColor,
            UIColor(red: 0.15, green: 0.15, blue: 0.35, alpha: 1.0).cgColor
        ]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        // Add floating orbs
        view.addSubview(orb1)
        view.addSubview(orb2)
        
        // ScrollView setup
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.keyboardDismissMode = .interactive
        view.addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Profile Display Container
        profileDisplayContainer.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        profileDisplayContainer.layer.cornerRadius = 20
        profileDisplayContainer.layer.borderWidth = 1
        profileDisplayContainer.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        profileDisplayContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(profileDisplayContainer)
        
        // Profile Image
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 75
        profileImageView.layer.borderWidth = 4
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.image = UIImage(named: "Tiger") ?? UIImage(systemName: "person.circle.fill")
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileDisplayContainer.addSubview(profileImageView)
        
        // Marble Color View
        marbleColorView.layer.cornerRadius = 50
        marbleColorView.backgroundColor = .systemRed
        marbleColorView.layer.borderWidth = 3
        marbleColorView.layer.borderColor = UIColor.white.cgColor
        marbleColorView.translatesAutoresizingMaskIntoConstraints = false
        profileDisplayContainer.addSubview(marbleColorView)
        
        // Username Display
        usernameDisplayLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        usernameDisplayLabel.textColor = .white
        usernameDisplayLabel.textAlignment = .center
        usernameDisplayLabel.text = "Username"
        usernameDisplayLabel.translatesAutoresizingMaskIntoConstraints = false
        profileDisplayContainer.addSubview(usernameDisplayLabel)
        
        // Marble Color Name
        marbleColorNameLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        marbleColorNameLabel.textColor = .white
        marbleColorNameLabel.textAlignment = .center
        marbleColorNameLabel.text = "Red"
        marbleColorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        profileDisplayContainer.addSubview(marbleColorNameLabel)
        
        // ID Label
        idLabel.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        idLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        idLabel.textAlignment = .center
        idLabel.numberOfLines = 2
        idLabel.text = "ID:\nXXXXXXXX-XXXX-XXXX"
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        profileDisplayContainer.addSubview(idLabel)
        
        // Form Container
        formContainer.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        formContainer.layer.cornerRadius = 20
        formContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(formContainer)
        
        setupFormFields()
        setupDeleteButton()
    }
    
    private func setupFormFields() {
        // Username Field
        usernameFieldContainer.translatesAutoresizingMaskIntoConstraints = false
        formContainer.addSubview(usernameFieldContainer)
        
        usernameLabel.text = "Username"
        usernameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        usernameLabel.textColor = .black
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameFieldContainer.addSubview(usernameLabel)
        
        usernameTextField.placeholder = "Enter username"
        usernameTextField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        usernameTextField.textColor = UIColor.systemBlue
        usernameTextField.borderStyle = .roundedRect
        usernameTextField.backgroundColor = UIColor.systemGray6
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameFieldContainer.addSubview(usernameTextField)
        
        // Player 1 Status
        player1Container.translatesAutoresizingMaskIntoConstraints = false
        formContainer.addSubview(player1Container)
        
        player1Label.text = "Player 1"
        player1Label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        player1Label.textColor = .black
        player1Label.translatesAutoresizingMaskIntoConstraints = false
        player1Container.addSubview(player1Label)
        
        player1StatusLabel.text = "Active"
        player1StatusLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        player1StatusLabel.textColor = UIColor.systemBlue
        player1StatusLabel.translatesAutoresizingMaskIntoConstraints = false
        player1Container.addSubview(player1StatusLabel)
        
        // Player 2 Status
        player2Container.translatesAutoresizingMaskIntoConstraints = false
        formContainer.addSubview(player2Container)
        
        player2Label.text = "Player 2"
        player2Label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        player2Label.textColor = .black
        player2Label.translatesAutoresizingMaskIntoConstraints = false
        player2Container.addSubview(player2Label)
        
        player2StatusLabel.text = "Inactive"
        player2StatusLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        player2StatusLabel.textColor = UIColor.systemBlue
        player2StatusLabel.translatesAutoresizingMaskIntoConstraints = false
        player2Container.addSubview(player2StatusLabel)
        
        // Profile Picture Selection
        profilePictureContainer.translatesAutoresizingMaskIntoConstraints = false
        formContainer.addSubview(profilePictureContainer)
        
        profilePictureLabel.text = "Profile Picture"
        profilePictureLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        profilePictureLabel.textColor = .black
        profilePictureLabel.translatesAutoresizingMaskIntoConstraints = false
        profilePictureContainer.addSubview(profilePictureLabel)
        
        profilePictureButton.setTitle("Tiger", for: .normal)
        profilePictureButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        profilePictureButton.setTitleColor(UIColor.systemBlue, for: .normal)
        profilePictureButton.contentHorizontalAlignment = .right
        profilePictureButton.translatesAutoresizingMaskIntoConstraints = false
        profilePictureContainer.addSubview(profilePictureButton)
        
        // Marble Color Selection
        marbleColorContainer.translatesAutoresizingMaskIntoConstraints = false
        formContainer.addSubview(marbleColorContainer)
        
        marbleColorLabel.text = "Marble Colour"
        marbleColorLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        marbleColorLabel.textColor = .black
        marbleColorLabel.translatesAutoresizingMaskIntoConstraints = false
        marbleColorContainer.addSubview(marbleColorLabel)
        
        marbleColorButton.setTitle("Red", for: .normal)
        marbleColorButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        marbleColorButton.setTitleColor(UIColor.systemBlue, for: .normal)
        marbleColorButton.contentHorizontalAlignment = .right
        marbleColorButton.translatesAutoresizingMaskIntoConstraints = false
        marbleColorContainer.addSubview(marbleColorButton)
        
        // Add separators
        addSeparator(to: usernameFieldContainer)
        addSeparator(to: player1Container)
        addSeparator(to: player2Container)
        addSeparator(to: profilePictureContainer)
    }
    
    private func setupDeleteButton() {
        deleteButton.setTitle("🗑 Delete Profile", for: .normal)
        deleteButton.setTitleColor(.systemRed, for: .normal)
        deleteButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        deleteButton.backgroundColor = UIColor.systemRed.withAlphaComponent(0.1)
        deleteButton.layer.cornerRadius = 15
        deleteButton.layer.borderWidth = 2
        deleteButton.layer.borderColor = UIColor.systemRed.cgColor
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(deleteButton)
    }
    
    private func addSeparator(to container: UIView) {
        let separator = UIView()
        separator.backgroundColor = UIColor.separator
        separator.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(separator)
        
        NSLayoutConstraint.activate([
            separator.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Profile Display Container
            profileDisplayContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            profileDisplayContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            profileDisplayContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            profileDisplayContainer.heightAnchor.constraint(equalToConstant: 300),
            
            // Profile Image
            profileImageView.topAnchor.constraint(equalTo: profileDisplayContainer.topAnchor, constant: 20),
            profileImageView.leadingAnchor.constraint(equalTo: profileDisplayContainer.leadingAnchor, constant: 40),
            profileImageView.widthAnchor.constraint(equalToConstant: 150),
            profileImageView.heightAnchor.constraint(equalToConstant: 150),
            
            // Marble Color View
            marbleColorView.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor),
            marbleColorView.trailingAnchor.constraint(equalTo: profileDisplayContainer.trailingAnchor, constant: -40),
            marbleColorView.widthAnchor.constraint(equalToConstant: 100),
            marbleColorView.heightAnchor.constraint(equalToConstant: 100),
            
            // Username Display
            usernameDisplayLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 15),
            usernameDisplayLabel.leadingAnchor.constraint(equalTo: profileDisplayContainer.leadingAnchor, constant: 20),
            usernameDisplayLabel.centerXAnchor.constraint(equalTo: profileImageView.centerXAnchor),
            
            // Marble Color Name
            marbleColorNameLabel.centerYAnchor.constraint(equalTo: usernameDisplayLabel.centerYAnchor),
            marbleColorNameLabel.trailingAnchor.constraint(equalTo: profileDisplayContainer.trailingAnchor, constant: -20),
            marbleColorNameLabel.centerXAnchor.constraint(equalTo: marbleColorView.centerXAnchor),
            
            // ID Label
            idLabel.topAnchor.constraint(equalTo: usernameDisplayLabel.bottomAnchor, constant: 8),
            idLabel.leadingAnchor.constraint(equalTo: profileDisplayContainer.leadingAnchor, constant: 20),
            idLabel.trailingAnchor.constraint(equalTo: profileDisplayContainer.trailingAnchor, constant: -20),
            
            // Form Container
            formContainer.topAnchor.constraint(equalTo: profileDisplayContainer.bottomAnchor, constant: 30),
            formContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            formContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Username Field Container
            usernameFieldContainer.topAnchor.constraint(equalTo: formContainer.topAnchor, constant: 15),
            usernameFieldContainer.leadingAnchor.constraint(equalTo: formContainer.leadingAnchor, constant: 15),
            usernameFieldContainer.trailingAnchor.constraint(equalTo: formContainer.trailingAnchor, constant: -15),
            usernameFieldContainer.heightAnchor.constraint(equalToConstant: 60),
            
            usernameLabel.leadingAnchor.constraint(equalTo: usernameFieldContainer.leadingAnchor),
            usernameLabel.centerYAnchor.constraint(equalTo: usernameFieldContainer.centerYAnchor),
            usernameLabel.widthAnchor.constraint(equalToConstant: 120),
            
            usernameTextField.leadingAnchor.constraint(equalTo: usernameLabel.trailingAnchor, constant: 10),
            usernameTextField.trailingAnchor.constraint(equalTo: usernameFieldContainer.trailingAnchor),
            usernameTextField.centerYAnchor.constraint(equalTo: usernameFieldContainer.centerYAnchor),
            usernameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            // Player 1 Container
            player1Container.topAnchor.constraint(equalTo: usernameFieldContainer.bottomAnchor),
            player1Container.leadingAnchor.constraint(equalTo: formContainer.leadingAnchor, constant: 15),
            player1Container.trailingAnchor.constraint(equalTo: formContainer.trailingAnchor, constant: -15),
            player1Container.heightAnchor.constraint(equalToConstant: 50),
            
            player1Label.leadingAnchor.constraint(equalTo: player1Container.leadingAnchor),
            player1Label.centerYAnchor.constraint(equalTo: player1Container.centerYAnchor),
            
            player1StatusLabel.trailingAnchor.constraint(equalTo: player1Container.trailingAnchor),
            player1StatusLabel.centerYAnchor.constraint(equalTo: player1Container.centerYAnchor),
            
            // Player 2 Container
            player2Container.topAnchor.constraint(equalTo: player1Container.bottomAnchor),
            player2Container.leadingAnchor.constraint(equalTo: formContainer.leadingAnchor, constant: 15),
            player2Container.trailingAnchor.constraint(equalTo: formContainer.trailingAnchor, constant: -15),
            player2Container.heightAnchor.constraint(equalToConstant: 50),
            
            player2Label.leadingAnchor.constraint(equalTo: player2Container.leadingAnchor),
            player2Label.centerYAnchor.constraint(equalTo: player2Container.centerYAnchor),
            
            player2StatusLabel.trailingAnchor.constraint(equalTo: player2Container.trailingAnchor),
            player2StatusLabel.centerYAnchor.constraint(equalTo: player2Container.centerYAnchor),
            
            // Profile Picture Container
            profilePictureContainer.topAnchor.constraint(equalTo: player2Container.bottomAnchor),
            profilePictureContainer.leadingAnchor.constraint(equalTo: formContainer.leadingAnchor, constant: 15),
            profilePictureContainer.trailingAnchor.constraint(equalTo: formContainer.trailingAnchor, constant: -15),
            profilePictureContainer.heightAnchor.constraint(equalToConstant: 50),
            
            profilePictureLabel.leadingAnchor.constraint(equalTo: profilePictureContainer.leadingAnchor),
            profilePictureLabel.centerYAnchor.constraint(equalTo: profilePictureContainer.centerYAnchor),
            
            profilePictureButton.trailingAnchor.constraint(equalTo: profilePictureContainer.trailingAnchor),
            profilePictureButton.centerYAnchor.constraint(equalTo: profilePictureContainer.centerYAnchor),
            profilePictureButton.widthAnchor.constraint(equalToConstant: 150),
            
            // Marble Color Container
            marbleColorContainer.topAnchor.constraint(equalTo: profilePictureContainer.bottomAnchor),
            marbleColorContainer.leadingAnchor.constraint(equalTo: formContainer.leadingAnchor, constant: 15),
            marbleColorContainer.trailingAnchor.constraint(equalTo: formContainer.trailingAnchor, constant: -15),
            marbleColorContainer.heightAnchor.constraint(equalToConstant: 50),
            marbleColorContainer.bottomAnchor.constraint(equalTo: formContainer.bottomAnchor, constant: -15),
            
            marbleColorLabel.leadingAnchor.constraint(equalTo: marbleColorContainer.leadingAnchor),
            marbleColorLabel.centerYAnchor.constraint(equalTo: marbleColorContainer.centerYAnchor),
            
            marbleColorButton.trailingAnchor.constraint(equalTo: marbleColorContainer.trailingAnchor),
            marbleColorButton.centerYAnchor.constraint(equalTo: marbleColorContainer.centerYAnchor),
            marbleColorButton.widthAnchor.constraint(equalToConstant: 150),
            
            // Delete Button
            deleteButton.topAnchor.constraint(equalTo: formContainer.bottomAnchor, constant: 40),
            deleteButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            deleteButton.widthAnchor.constraint(equalToConstant: 250),
            deleteButton.heightAnchor.constraint(equalToConstant: 50),
            deleteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
    
    private func setupActions() {
        profilePictureButton.addTarget(self, action: #selector(selectProfilePicture), for: .touchUpInside)
        marbleColorButton.addTarget(self, action: #selector(selectMarbleColor), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteProfileTapped), for: .touchUpInside)
        usernameTextField.addTarget(self, action: #selector(usernameChanged), for: .editingChanged)
    }
    
    private func startAnimations() {
        orb1.startFloating(duration: 10.0, xRange: -60...60, yRange: -50...50)
        orb2.startFloating(duration: 8.0, xRange: -70...70, yRange: -60...60)
    }
    
    private func loadProfileData() {
        guard let profile = profile else { return }
        
        usernameTextField.text = profile.username
        usernameDisplayLabel.text = profile.username
        idLabel.text = "ID:\n\(profile.id.uuidString)"
        
        selectedProfilePicture = profile.profilePicture
        profilePictureButton.setTitle(profile.profilePicture, for: .normal)
        profileImageView.image = UIImage(named: profile.profilePicture) ?? UIImage(systemName: "person.circle.fill")
        
        selectedMarbleColor = profile.marbleColour
        marbleColorButton.setTitle(profile.marbleColour, for: .normal)
        marbleColorNameLabel.text = profile.marbleColour
        
        if let colorTuple = availableMarbleColors.first(where: { $0.0 == profile.marbleColour }) {
            marbleColorView.backgroundColor = colorTuple.1
        }
        
        player1StatusLabel.text = profile.player1 ? "Active" : "Inactive"
        player1StatusLabel.textColor = profile.player1 ? .systemBlue : .systemGray
        
        player2StatusLabel.text = profile.player2 ? "Active" : "Inactive"
        player2StatusLabel.textColor = profile.player2 ? .systemBlue : .systemGray
    }
    
    // MARK: - Actions
    
    @objc private func usernameChanged() {
        usernameDisplayLabel.text = usernameTextField.text?.isEmpty == true ? "Username" : usernameTextField.text
        profile?.username = usernameTextField.text ?? ""
        saveProfile()
    }
    
    @objc private func selectProfilePicture() {
        let alert = UIAlertController(title: "Select Profile Picture", message: nil, preferredStyle: .actionSheet)
        
        for picture in availableProfilePictures {
            alert.addAction(UIAlertAction(title: picture, style: .default, handler: { _ in
                self.selectedProfilePicture = picture
                self.profilePictureButton.setTitle(picture, for: .normal)
                self.profileImageView.image = UIImage(named: picture) ?? UIImage(systemName: "person.circle.fill")
                self.profile?.profilePicture = picture
                self.saveProfile()
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = profilePictureButton
            popover.sourceRect = profilePictureButton.bounds
        }
        
        present(alert, animated: true)
    }
    
    @objc private func selectMarbleColor() {
        let alert = UIAlertController(title: "Select Marble Color", message: nil, preferredStyle: .actionSheet)
        
        for colorTuple in availableMarbleColors {
            alert.addAction(UIAlertAction(title: colorTuple.0, style: .default, handler: { _ in
                self.selectedMarbleColor = colorTuple.0
                self.marbleColorButton.setTitle(colorTuple.0, for: .normal)
                self.marbleColorView.backgroundColor = colorTuple.1
                self.marbleColorNameLabel.text = colorTuple.0
                self.profile?.marbleColour = colorTuple.0
                self.saveProfile()
            }))
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = marbleColorButton
            popover.sourceRect = marbleColorButton.bounds
        }
        
        present(alert, animated: true)
    }
    
    @objc private func deleteProfileTapped() {
        let alert = UIAlertController(
            title: "Delete Profile",
            message: "Are you sure you want to delete this profile? This action cannot be undone.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            self.deleteProfile()
        }))
        
        present(alert, animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Helper Methods
    
    private func saveProfile() {
        guard let profile = profile else { return }
        profileManager?.updateProfile(profile)
        onProfileUpdated?(profile)
    }
    
    private func deleteProfile() {
        guard let profile = profile else { return }
        profileManager?.deleteProfile(profile)
        navigationController?.popViewController(animated: true)
    }
}
