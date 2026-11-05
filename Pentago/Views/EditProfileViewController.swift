//
//  EditProfileViewController.swift
//  Pentago
//
//  Created programmatically on 11/5/2026
//

import UIKit

class EditProfileViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Properties
    var profile: PlayerProfile?
    var profileManager: PlayerProfileManager?
    var achievementObserverStore: AchievementObserverStore?
    var onProfileUpdated: ((PlayerProfile) -> Void)?
    var isCreatingNewProfile: Bool = false
    
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
    private let player1Switch = UISwitch()
    
    private let player2Container = UIView()
    private let player2Label = UILabel()
    private let player2Switch = UISwitch()
    
    private let profilePictureContainer = UIView()
    private let profilePictureLabel = UILabel()
    private let profilePictureButton = UIButton(type: .system)
    
    private let marbleColorContainer = UIView()
    private let marbleColorLabel = UILabel()
    private let marbleColorButton = UIButton(type: .system)
    
    // Delete Button
    private let deleteButton = UIButton(type: .system)
    
    // Available profile pictures and colors
    private let availableProfilePictures: [PlayerProfile.ProfilePicture] = [
        .tiger, .lion, .giraffe, .zebra, .ostrich, .puppy, .beach, .desert, .mountain, .tree, .defaultIcon
    ]
    private let availableMarbleColors: [(Marble.MarbleColour, UIColor)] = [
        (.red, UIColor.systemRed),
        (.blue, UIColor.systemBlue),
        (.green, UIColor.systemGreen),
        (.yellow, UIColor.systemYellow),
        (.purple, UIColor.systemPurple),
        (.orange, UIColor.systemOrange),
        (.pink, UIColor.systemPink),
        (.black, UIColor.black)
    ]
    
    private var selectedProfilePicture: PlayerProfile.ProfilePicture = .tiger
    private var selectedMarbleColor: Marble.MarbleColour = .red
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a default profile if in creation mode
        if isCreatingNewProfile {
            profile = PlayerProfile(
                userName: "",
                profilePicture: .tiger,
                marbleColour: .red
            )
        }
        
        setupUI()
        setupConstraints()
        setupActions()
        loadProfileData()
        
        // Disable back button if creating new profile with empty name
        if isCreatingNewProfile {
            navigationItem.hidesBackButton = true
            title = "Create Profile"
        }
        
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
        title = isCreatingNewProfile ? "Create Profile" : "Edit Profile"
        
        // Add Save button to navigation bar if creating new profile
        if isCreatingNewProfile {
            let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveNewProfile))
            navigationItem.rightBarButtonItem = saveButton
            saveButton.isEnabled = false // Disabled until name is entered
        }
        
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
        profileImageView.image = ImageAssetFactory.getProfilePictureUIImage(profilePicture: .tiger)
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
        
        // ID Label - Hide if creating new profile
        idLabel.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        idLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        idLabel.textAlignment = .center
        idLabel.numberOfLines = 2
        idLabel.text = "ID:\nXXXXXXXX-XXXX-XXXX"
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        idLabel.isHidden = isCreatingNewProfile
        profileDisplayContainer.addSubview(idLabel)
        
        // Form Container
        formContainer.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        formContainer.layer.cornerRadius = 24
        formContainer.layer.borderWidth = 1
        formContainer.layer.borderColor = UIColor.white.withAlphaComponent(0.25).cgColor
        formContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(formContainer)
        
        setupFormFields()
        
        // Only add delete button if editing existing profile
        if !isCreatingNewProfile {
            setupDeleteButton()
        }
    }
    
    private func setupFormFields() {
        // Username Field
        usernameFieldContainer.translatesAutoresizingMaskIntoConstraints = false
        formContainer.addSubview(usernameFieldContainer)
        
        usernameLabel.text = "Username"
        usernameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        usernameLabel.textColor = .white
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameFieldContainer.addSubview(usernameLabel)
        
        usernameTextField.placeholder = "Enter username"
        usernameTextField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        usernameTextField.textColor = .white
        usernameTextField.attributedPlaceholder = NSAttributedString(
            string: "Enter username",
            attributes: [.foregroundColor: UIColor.white.withAlphaComponent(0.5)]
        )
        usernameTextField.borderStyle = .none
        usernameTextField.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        usernameTextField.layer.cornerRadius = 8
        usernameTextField.layer.borderWidth = 1
        usernameTextField.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        usernameTextField.autocorrectionType = .no
        usernameTextField.autocapitalizationType = .words
        usernameTextField.returnKeyType = .done
        usernameTextField.delegate = self
        // Add padding to text field
        usernameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        usernameTextField.leftViewMode = .always
        usernameTextField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
        usernameTextField.rightViewMode = .always
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.autocorrectionType = .no
        usernameTextField.spellCheckingType = .no
        usernameFieldContainer.addSubview(usernameTextField)
        
        // Player 1 Status
        player1Container.translatesAutoresizingMaskIntoConstraints = false
        formContainer.addSubview(player1Container)
        
        player1Label.text = "Player 1"
        player1Label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        player1Label.textColor = .white
        player1Label.translatesAutoresizingMaskIntoConstraints = false
        player1Container.addSubview(player1Label)
        
        player1Switch.onTintColor = UIColor.systemGreen
        player1Switch.translatesAutoresizingMaskIntoConstraints = false
        player1Container.addSubview(player1Switch)
        
        // Player 2 Status
        player2Container.translatesAutoresizingMaskIntoConstraints = false
        formContainer.addSubview(player2Container)
        
        player2Label.text = "Player 2"
        player2Label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        player2Label.textColor = .white
        player2Label.translatesAutoresizingMaskIntoConstraints = false
        player2Container.addSubview(player2Label)
        
        player2Switch.onTintColor = UIColor.systemGreen
        player2Switch.translatesAutoresizingMaskIntoConstraints = false
        player2Container.addSubview(player2Switch)
        
        // Profile Picture Selection
        profilePictureContainer.translatesAutoresizingMaskIntoConstraints = false
        formContainer.addSubview(profilePictureContainer)
        
        profilePictureLabel.text = "Profile Picture"
        profilePictureLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        profilePictureLabel.textColor = .white
        profilePictureLabel.translatesAutoresizingMaskIntoConstraints = false
        profilePictureContainer.addSubview(profilePictureLabel)
        
        profilePictureButton.setTitle("Tiger", for: .normal)
        profilePictureButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        profilePictureButton.setTitleColor(UIColor.systemBlue.withAlphaComponent(0.9), for: .normal)
        profilePictureButton.contentHorizontalAlignment = .right
        profilePictureButton.translatesAutoresizingMaskIntoConstraints = false
        profilePictureContainer.addSubview(profilePictureButton)
        
        // Add chevron icon to profile picture button
        let chevronImage = UIImage(systemName: "chevron.right")
        profilePictureButton.setImage(chevronImage, for: .normal)
        profilePictureButton.semanticContentAttribute = .forceRightToLeft
        profilePictureButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        
        // Marble Color Selection
        marbleColorContainer.translatesAutoresizingMaskIntoConstraints = false
        formContainer.addSubview(marbleColorContainer)
        
        marbleColorLabel.text = "Marble Colour"
        marbleColorLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        marbleColorLabel.textColor = .white
        marbleColorLabel.translatesAutoresizingMaskIntoConstraints = false
        marbleColorContainer.addSubview(marbleColorLabel)
        
        marbleColorButton.setTitle("Red", for: .normal)
        marbleColorButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        marbleColorButton.setTitleColor(UIColor.systemBlue.withAlphaComponent(0.9), for: .normal)
        marbleColorButton.contentHorizontalAlignment = .right
        marbleColorButton.translatesAutoresizingMaskIntoConstraints = false
        marbleColorContainer.addSubview(marbleColorButton)
        
        // Add chevron icon to marble color button
        marbleColorButton.setImage(chevronImage, for: .normal)
        marbleColorButton.semanticContentAttribute = .forceRightToLeft
        marbleColorButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        
        // Add separators
        addSeparator(to: usernameFieldContainer)
        addSeparator(to: player1Container)
        addSeparator(to: player2Container)
        addSeparator(to: profilePictureContainer)
    }
    
    private func setupDeleteButton() {
        // Create a configuration for the button
        var config = UIButton.Configuration.plain()
        config.title = "Delete Profile"
        config.image = UIImage(systemName: "trash")
        config.imagePlacement = .leading
        config.imagePadding = 8
        config.baseForegroundColor = .systemRed
        
        deleteButton.configuration = config
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
        separator.backgroundColor = UIColor.white.withAlphaComponent(0.2)
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
        var constraints: [NSLayoutConstraint] = [
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
            
            player1Switch.trailingAnchor.constraint(equalTo: player1Container.trailingAnchor),
            player1Switch.centerYAnchor.constraint(equalTo: player1Container.centerYAnchor),
            
            // Player 2 Container
            player2Container.topAnchor.constraint(equalTo: player1Container.bottomAnchor),
            player2Container.leadingAnchor.constraint(equalTo: formContainer.leadingAnchor, constant: 15),
            player2Container.trailingAnchor.constraint(equalTo: formContainer.trailingAnchor, constant: -15),
            player2Container.heightAnchor.constraint(equalToConstant: 50),
            
            player2Label.leadingAnchor.constraint(equalTo: player2Container.leadingAnchor),
            player2Label.centerYAnchor.constraint(equalTo: player2Container.centerYAnchor),
            
            player2Switch.trailingAnchor.constraint(equalTo: player2Container.trailingAnchor),
            player2Switch.centerYAnchor.constraint(equalTo: player2Container.centerYAnchor),
            
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
        ]
        
        // Add delete button constraints only if not creating new profile
        if !isCreatingNewProfile {
            constraints.append(contentsOf: [
                deleteButton.topAnchor.constraint(equalTo: formContainer.bottomAnchor, constant: 30),
                deleteButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                deleteButton.widthAnchor.constraint(equalToConstant: 250),
                deleteButton.heightAnchor.constraint(equalToConstant: 50),
                deleteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -100)
            ])
        } else {
            // If creating new profile, form container should be the last element
            constraints.append(
                formContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -100)
            )
        }
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func setupActions() {
        profilePictureButton.addTarget(self, action: #selector(selectProfilePicture), for: .touchUpInside)
        marbleColorButton.addTarget(self, action: #selector(selectMarbleColor), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteProfileTapped), for: .touchUpInside)
        usernameTextField.addTarget(self, action: #selector(usernameChanged), for: .editingChanged)
        player1Switch.addTarget(self, action: #selector(player1SwitchChanged), for: .valueChanged)
        player2Switch.addTarget(self, action: #selector(player2SwitchChanged), for: .valueChanged)
    }
    
    private func startAnimations() {
        orb1.startFloating(duration: 10.0, xRange: -60...60, yRange: -50...50)
        orb2.startFloating(duration: 8.0, xRange: -70...70, yRange: -60...60)
    }
    
    private func loadProfileData() {
        guard let profile = profile else { return }
        
        usernameTextField.text = profile.userName
        usernameDisplayLabel.text = profile.userName
        idLabel.text = "ID:\n\(profile.playerID.uuidString)"
        
        selectedProfilePicture = profile.profilePicture
        profilePictureButton.setTitle(profile.profilePicture.rawValue, for: .normal)
        profileImageView.image = ImageAssetFactory.getProfilePictureUIImage(profilePicture: profile.profilePicture)
        
        selectedMarbleColor = profile.marbleColour
        marbleColorButton.setTitle(profile.marbleColour.rawValue, for: .normal)
        marbleColorNameLabel.text = profile.marbleColour.rawValue
        
        if let colorTuple = availableMarbleColors.first(where: { $0.0 == profile.marbleColour }) {
            marbleColorView.backgroundColor = colorTuple.1
        }
        
        player1Switch.isOn = profile.isLocalPlayer1
        player2Switch.isOn = profile.isLocalPlayer2
    }
    
    // MARK: - Actions
    
    @objc private func usernameChanged() {
        let newUsername = usernameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        usernameDisplayLabel.text = newUsername.isEmpty ? "Username" : newUsername
        profile?.userName = newUsername
        
        // Enable/disable save button based on whether username is empty
        if isCreatingNewProfile {
            navigationItem.rightBarButtonItem?.isEnabled = !newUsername.isEmpty
        } else {
            if let profile = profile {
                onProfileUpdated?(profile)
            }
        }
    }
    
    @objc private func player1SwitchChanged() {
        if player1Switch.isOn, let profileManager = profileManager {
            for other in profileManager.getPlayerProfileArray() where other !== profile {
                other.isLocalPlayer1 = false
            }
        }
        profile?.isLocalPlayer1 = player1Switch.isOn
        if let profile = profile {
            onProfileUpdated?(profile)
        }
        player1Switch.isOn = profile?.isLocalPlayer1 ?? false
        player2Switch.isOn = profile?.isLocalPlayer2 ?? false
    }

    @objc private func player2SwitchChanged() {
        if player2Switch.isOn, let profileManager = profileManager {
            for other in profileManager.getPlayerProfileArray() where other !== profile {
                other.isLocalPlayer2 = false
            }
        }
        profile?.isLocalPlayer2 = player2Switch.isOn
        if let profile = profile {
            onProfileUpdated?(profile)
        }
        player1Switch.isOn = profile?.isLocalPlayer1 ?? false
        player2Switch.isOn = profile?.isLocalPlayer2 ?? false
    }
    
    @objc private func selectProfilePicture() {
        let alert = UIAlertController(title: "Select Profile Picture", message: nil, preferredStyle: .actionSheet)
        
        for picture in availableProfilePictures {
            alert.addAction(UIAlertAction(title: picture.rawValue, style: .default, handler: { _ in
                self.selectedProfilePicture = picture
                self.profilePictureButton.setTitle(picture.rawValue, for: .normal)
                self.profileImageView.image = ImageAssetFactory.getProfilePictureUIImage(profilePicture: picture)
                self.profile?.profilePicture = picture
                if let profile = self.profile {
                    self.onProfileUpdated?(profile)
                }
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
            alert.addAction(UIAlertAction(title: colorTuple.0.rawValue, style: .default, handler: { _ in
                self.selectedMarbleColor = colorTuple.0
                self.marbleColorButton.setTitle(colorTuple.0.rawValue, for: .normal)
                self.marbleColorView.backgroundColor = colorTuple.1
                self.marbleColorNameLabel.text = colorTuple.0.rawValue
                self.profile?.marbleColour = colorTuple.0
                if let profile = self.profile {
                    self.onProfileUpdated?(profile)
                }
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
    
    @objc private func saveNewProfile() {
        guard let profile = profile,
              let profileManager = profileManager,
              !profile.userName.isEmpty else { return }

        // Try to add the profile
        do {
            try profileManager.addPlayerProfile(newProfile: profile)

            // Wire up achievements using the store if available
            if let store = achievementObserverStore {
                profile.addAchievementObservers(achievementObservers: store.createInitialisedObserverList())
            }

            // Notify that profile was created
            onProfileUpdated?(profile)

            // Pop back to profile list
            navigationController?.popViewController(animated: true)
        } catch {
            // Show error if profile couldn't be added (e.g., duplicate username)
            let alert = UIAlertController(
                title: "Error",
                message: "Could not create profile. A profile with this username may already exist.",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    private func deleteProfile() {
        guard let profile = profile,
              let profileManager = profileManager else { return }
        
        // Find the index of the profile in the array
        let profiles = profileManager.getPlayerProfileArray()
        if let index = profiles.firstIndex(where: { $0.playerID == profile.playerID }) {
            profileManager.removePlayerProfile(index: index)
        }
        
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension EditProfileViewController {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

