//
//  ProfileSelectViewController.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 6/12/2025.
//  Redesigned programmatically on 11/5/2026
//

import UIKit

class ProfileSelectViewController: UIViewController {
    
    // MARK: - Properties
    var profileManager: PlayerProfileManager?
    var nextScreen: MainMenuViewController.ProfileSelectScreenDestination = .editProfileScreen
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let gradientLayer = CAGradientLayer()
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    private var collectionView: UICollectionView!
    
    // Floating orbs for background animation
    private let orb1 = FloatingOrbView(color: UIColor.systemIndigo.withAlphaComponent(0.3), size: 250)
    private let orb2 = FloatingOrbView(color: UIColor.systemPurple.withAlphaComponent(0.25), size: 200)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        startAnimations()
        collectionView.reloadData()
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
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
        view.addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Title
        titleLabel.text = getTitleForScreen()
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 3)
        titleLabel.layer.shadowOpacity = 0.3
        titleLabel.layer.shadowRadius = 6
        contentView.addSubview(titleLabel)
        
        // Subtitle
        subtitleLabel.text = getSubtitleForScreen()
        subtitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subtitleLabel)
        
        // Collection View
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: "ProfileCell")
        collectionView.register(AddProfileCell.self, forCellWithReuseIdentifier: "AddProfileCell")
        contentView.addSubview(collectionView)
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
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Collection View
            collectionView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 200),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
    
    private func startAnimations() {
        orb1.startFloating(duration: 9.0, xRange: -80...80, yRange: -60...60)
        orb2.startFloating(duration: 7.0, xRange: -60...60, yRange: -80...80)
    }
    
    // MARK: - Helper Methods
    
    private func getTitleForScreen() -> String {
        switch nextScreen {
        case .editProfileScreen:
            return "Select Profile"
        case .gameplayStatsScreen:
            return "View Statistics"
        case .achievementScreen:
            return "View Achievements"
        }
    }
    
    private func getSubtitleForScreen() -> String {
        switch nextScreen {
        case .editProfileScreen:
            return "Choose a profile to edit or create a new one"
        case .gameplayStatsScreen:
            return "Select a profile to view their game stats"
        case .achievementScreen:
            return "Select a profile to view their achievements"
        }
    }
    
    private func handleProfileSelection(_ profile: PlayerProfile) {
        switch nextScreen {
        case .editProfileScreen:
            // TODO: Navigate to edit profile screen
            showAlert(title: "Edit Profile", message: "Navigate to edit screen for \(profile.userName)")
            
        case .gameplayStatsScreen:
            // TODO: Navigate to gameplay statistics screen
            showAlert(title: "Statistics", message: "Show stats for \(profile.userName)")
            
        case .achievementScreen:
            // TODO: Navigate to achievements screen
            showAlert(title: "Achievements", message: "Show achievements for \(profile.userName)")
        }
    }
    
    private func handleAddNewProfile() {
        // TODO: Navigate to create new profile screen
        showAlert(title: "Create Profile", message: "Navigate to create new profile screen")
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDataSource

extension ProfileSelectViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let profileManager = profileManager else { return 0 }
        
        let profileCount = profileManager.getPlayerProfileArray().count
        
        // Add extra cell for "Add New Profile" only in edit mode
        return nextScreen == .editProfileScreen ? profileCount + 1 : profileCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let profileManager = profileManager else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath)
        }
        
        let profiles = profileManager.getPlayerProfileArray()
        
        // Check if this is the "Add New Profile" cell
        if nextScreen == .editProfileScreen && indexPath.item == profiles.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddProfileCell", for: indexPath) as! AddProfileCell
            return cell
        }
        
        // Regular profile cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        let profile = profiles[indexPath.item]
        cell.configure(with: profile)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ProfileSelectViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let profileManager = profileManager else { return }
        
        let profiles = profileManager.getPlayerProfileArray()
        
        // Check if "Add New Profile" cell was tapped
        if nextScreen == .editProfileScreen && indexPath.item == profiles.count {
            handleAddNewProfile()
            return
        }
        
        // Regular profile was tapped
        let profile = profiles[indexPath.item]
        handleProfileSelection(profile)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileSelectViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 140, height: 180)
    }
}

// MARK: - Profile Cell

class ProfileCell: UICollectionViewCell {
    
    private let containerView = UIView()
    private let avatarImageView = UIImageView()
    private let colorRing = UIView()
    private let usernameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        // Container
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.12)
        containerView.layer.cornerRadius = 20
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.white.withAlphaComponent(0.25).cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        // Color Ring
        colorRing.layer.cornerRadius = 55
        colorRing.layer.borderWidth = 4
        colorRing.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(colorRing)
        
        // Avatar
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.tintColor = .white
        avatarImageView.layer.cornerRadius = 50
        avatarImageView.clipsToBounds = true
        avatarImageView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(avatarImageView)
        
        // Username
        usernameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        usernameLabel.textColor = .white
        usernameLabel.textAlignment = .center
        usernameLabel.numberOfLines = 1
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(usernameLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            colorRing.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            colorRing.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            colorRing.widthAnchor.constraint(equalToConstant: 110),
            colorRing.heightAnchor.constraint(equalToConstant: 110),
            
            avatarImageView.centerXAnchor.constraint(equalTo: colorRing.centerXAnchor),
            avatarImageView.centerYAnchor.constraint(equalTo: colorRing.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            avatarImageView.heightAnchor.constraint(equalToConstant: 100),
            
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 16),
            usernameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            usernameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8)
        ])
    }
    
    func configure(with profile: PlayerProfile) {
        usernameLabel.text = profile.userName
        
        // Set avatar image based on profile picture enum
        let avatarIcon = getAvatarIcon(for: profile.profilePicture)
        avatarImageView.image = avatarIcon
        
        // Set color ring
        colorRing.layer.borderColor = getMarbleColor(for: profile.marbleColour).cgColor
    }
    
    private func getAvatarIcon(for picture: PlayerProfile.ProfilePicture) -> UIImage? {
        // Map profile pictures to SF Symbols
        switch picture {
        case .cpuRobot:
            return UIImage(systemName: "cpu")
        default:
            // For other profile pictures, use a person icon
            // You can expand this with more specific mappings
            return UIImage(systemName: "person.circle.fill")
        }
    }
    
    private func getMarbleColor(for colour: Marble.MarbleColour) -> UIColor {
        switch colour {
        case .black: return .white // Inverted for visibility
        case .blue: return .systemBlue
        case .green: return .systemGreen
        case .orange: return .systemOrange
        case .pink: return .systemPink
        case .purple: return .systemPurple
        case .red: return .systemRed
        case .yellow: return .systemYellow
        case .grey: return .systemGray
        }
    }
}

// MARK: - Add Profile Cell

class AddProfileCell: UICollectionViewCell {
    
    private let containerView = UIView()
    private let iconView = UIImageView()
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        // Container with dashed border
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.08)
        containerView.layer.cornerRadius = 20
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.white.withAlphaComponent(0.4).cgColor
        containerView.layer.borderStyle = .dashed
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        // Plus Icon
        iconView.image = UIImage(systemName: "plus.circle.fill")
        iconView.tintColor = UIColor.white.withAlphaComponent(0.7)
        iconView.contentMode = .scaleAspectFit
        iconView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(iconView)
        
        // Label
        label.text = "Add Profile"
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            iconView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -15),
            iconView.widthAnchor.constraint(equalToConstant: 60),
            iconView.heightAnchor.constraint(equalToConstant: 60),
            
            label.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 12),
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 8),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -8)
        ])
    }
}

// MARK: - CALayer Dashed Border Extension

extension CALayer {
    var borderStyle: CAShapeLayerLineDashPattern {
        get {
            return .solid
        }
        set {
            if newValue == .dashed {
                let shapeLayer = CAShapeLayer()
                shapeLayer.strokeColor = borderColor
                shapeLayer.lineWidth = borderWidth
                shapeLayer.lineDashPattern = [6, 3]
                shapeLayer.frame = bounds
                shapeLayer.fillColor = nil
                shapeLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
                addSublayer(shapeLayer)
            }
        }
    }
}

enum CAShapeLayerLineDashPattern {
    case solid
    case dashed
}
