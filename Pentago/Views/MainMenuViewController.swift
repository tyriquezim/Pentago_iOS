//
//  ViewController.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 6/12/2025.
//  Refactored to modern programmatic UIKit on 11/5/2026
//
import UIKit
import CoreData

class MainMenuViewController: UIViewController
{
    // MARK: - Properties
    var profileManager: PlayerProfileManager? //Stores and manages user profiles
    var achievementObserverStore: AchievementObserverStore?
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let gradientLayer = CAGradientLayer()
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    private let playButton = ModernButton()
    private let profileSettingsButton = ModernButton()
    private let gameplayStatisticsButton = ModernButton()
    private let achievementsButton = ModernButton()
    
    private let playerStatusContainer = UIView()
    private let player1StatusView = PlayerStatusView()
    private let player2StatusView = PlayerStatusView()
    
    // Floating orbs for background animation
    private let orb1 = FloatingOrbView(color: UIColor.systemBlue.withAlphaComponent(0.3), size: 300)
    private let orb2 = FloatingOrbView(color: UIColor.systemPurple.withAlphaComponent(0.3), size: 250)
    private let orb3 = FloatingOrbView(color: UIColor.systemTeal.withAlphaComponent(0.2), size: 200)
    
    // MARK: - Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setupProfileManager()
        setupNavigationBar()
        setupTabBar()
        setupUI()
        setupConstraints()
        loadProfiles()
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.saveProfiles), name: UIScene.didEnterBackgroundNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updatePlayerStatus()
        startAnimations()
        updateNavigationBarAppearance()
    }
    
    // MARK: - Setup Methods
    
    private func setupNavigationBar() {
        // Make navigation bar transparent with blur effect
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        
        // Add blur effect
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        
        // Title text attributes
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold)
        ]
        appearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 34, weight: .bold)
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        
        // Add subtle shadow
        navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        navigationController?.navigationBar.layer.shadowRadius = 8
        navigationController?.navigationBar.layer.shadowOpacity = 0.3
    }
    
    private func updateNavigationBarAppearance() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    private func setupTabBar() {
        guard let tabBar = tabBarController?.tabBar else { return }
        
        // Configure tab bar items with proper icons
        if let tabBarItems = tabBar.items {
            // Tab 1: Main Menu (Play icon)
            if tabBarItems.count > 0 {
                tabBarItems[0].image = UIImage(systemName: "gamecontroller")
                tabBarItems[0].selectedImage = UIImage(systemName: "gamecontroller.fill")
                tabBarItems[0].title = "Play"
            }
            
            // Tab 2: How To Play (Question mark icon)
            if tabBarItems.count > 1 {
                tabBarItems[1].image = UIImage(systemName: "questionmark.circle")
                tabBarItems[1].selectedImage = UIImage(systemName: "questionmark.circle.fill")
                tabBarItems[1].title = "How To Play"
            }
        }
        
        // Modern tab bar appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor(white: 0.1, alpha: 0.95)
        
        // Add subtle blur
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
        blurView.frame = tabBar.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tabBar.insertSubview(blurView, at: 0)
        
        // Item colors
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.white.withAlphaComponent(0.6)
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor.white.withAlphaComponent(0.6),
            .font: UIFont.systemFont(ofSize: 11, weight: .medium)
        ]
        
        appearance.stackedLayoutAppearance.selected.iconColor = .white
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 11, weight: .semibold)
        ]
        
        // Add gradient indicator for selected item
        let selectedColor = UIColor.white
        appearance.stackedLayoutAppearance.selected.iconColor = selectedColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: selectedColor,
            .font: UIFont.systemFont(ofSize: 11, weight: .semibold)
        ]
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        
        // Add top border with gradient
        let topBorder = CAGradientLayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 1)
        topBorder.colors = [
            UIColor.white.withAlphaComponent(0.3).cgColor,
            UIColor.white.withAlphaComponent(0.1).cgColor,
            UIColor.white.withAlphaComponent(0.3).cgColor
        ]
        topBorder.startPoint = CGPoint(x: 0, y: 0.5)
        topBorder.endPoint = CGPoint(x: 1, y: 0.5)
        topBorder.locations = [0, 0.5, 1]
        tabBar.layer.addSublayer(topBorder)
        
        // Add shadow
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: -3)
        tabBar.layer.shadowRadius = 12
        tabBar.layer.shadowOpacity = 0.4
    }
    
    private func setupProfileManager() {
        if self.profileManager == nil {
            self.profileManager = PlayerProfileManager()
        }
        if self.achievementObserverStore == nil {
            self.achievementObserverStore = AchievementObserverStore()
        }
    }
    
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
        view.addSubview(orb3)
        
        // ScrollView setup
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // Title
        titleLabel.text = "PENTAGO"
        titleLabel.font = UIFont.systemFont(ofSize: 56, weight: .black)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Add shadow to title
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 5)
        titleLabel.layer.shadowOpacity = 0.3
        titleLabel.layer.shadowRadius = 10
        contentView.addSubview(titleLabel)
        
        // Subtitle
        subtitleLabel.text = "STRATEGIC BOARD GAME"
        subtitleLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subtitleLabel)
        
        // Configure buttons
        setupButton(playButton, 
                   title: "Play Game", 
                   icon: UIImage(systemName: "gamecontroller.fill"),
                   colors: [UIColor.systemGreen, UIColor.systemTeal],
                   action: #selector(playButtonTapped))
        
        setupButton(profileSettingsButton,
                   title: "Profile Settings",
                   icon: UIImage(systemName: "person.circle.fill"),
                   colors: [UIColor.systemBlue, UIColor.systemPurple],
                   action: #selector(profileSettingsButtonTapped))
        
        setupButton(gameplayStatisticsButton,
                   title: "Gameplay Statistics",
                   icon: UIImage(systemName: "chart.bar.fill"),
                   colors: [UIColor.systemOrange, UIColor.systemRed],
                   action: #selector(gameStatsButtonTapped))
        
        setupButton(achievementsButton,
                   title: "Achievements",
                   icon: UIImage(systemName: "trophy.fill"),
                   colors: [UIColor.systemYellow, UIColor.systemOrange],
                   action: #selector(achievementsButtonTapped))
        
        contentView.addSubview(playButton)
        contentView.addSubview(profileSettingsButton)
        contentView.addSubview(gameplayStatisticsButton)
        contentView.addSubview(achievementsButton)
        
        // Player Status Container
        playerStatusContainer.translatesAutoresizingMaskIntoConstraints = false
        playerStatusContainer.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        playerStatusContainer.layer.cornerRadius = 20  // More rounded (was 16)
        playerStatusContainer.layer.borderWidth = 1
        playerStatusContainer.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        
        player1StatusView.translatesAutoresizingMaskIntoConstraints = false
        player2StatusView.translatesAutoresizingMaskIntoConstraints = false
        
        playerStatusContainer.addSubview(player1StatusView)
        playerStatusContainer.addSubview(player2StatusView)
        contentView.addSubview(playerStatusContainer)
    }
    
    private func setupButton(_ button: ModernButton, title: String, icon: UIImage?, colors: [UIColor], action: Selector) {
        button.configure(title: title, icon: icon, gradientColors: colors)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
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
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 60),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20),
            
            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            // Play Button
            playButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 50),
            playButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            playButton.heightAnchor.constraint(equalToConstant: 70),
            
            // Profile Settings Button
            profileSettingsButton.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 20),
            profileSettingsButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            profileSettingsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            profileSettingsButton.heightAnchor.constraint(equalToConstant: 70),
            
            // Gameplay Statistics Button
            gameplayStatisticsButton.topAnchor.constraint(equalTo: profileSettingsButton.bottomAnchor, constant: 20),
            gameplayStatisticsButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            gameplayStatisticsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            gameplayStatisticsButton.heightAnchor.constraint(equalToConstant: 70),
            
            // Achievements Button
            achievementsButton.topAnchor.constraint(equalTo: gameplayStatisticsButton.bottomAnchor, constant: 20),
            achievementsButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            achievementsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            achievementsButton.heightAnchor.constraint(equalToConstant: 70),
            
            // Player Status Container
            playerStatusContainer.topAnchor.constraint(equalTo: achievementsButton.bottomAnchor, constant: 40),
            playerStatusContainer.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            playerStatusContainer.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor, constant: 20),
            playerStatusContainer.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -20),
            playerStatusContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            
            // Player Status Views
            player1StatusView.leadingAnchor.constraint(equalTo: playerStatusContainer.leadingAnchor, constant: 16),
            player1StatusView.topAnchor.constraint(equalTo: playerStatusContainer.topAnchor, constant: 16),
            player1StatusView.bottomAnchor.constraint(equalTo: playerStatusContainer.bottomAnchor, constant: -16),
            
            player2StatusView.leadingAnchor.constraint(equalTo: player1StatusView.trailingAnchor, constant: 16),
            player2StatusView.trailingAnchor.constraint(equalTo: playerStatusContainer.trailingAnchor, constant: -16),
            player2StatusView.topAnchor.constraint(equalTo: playerStatusContainer.topAnchor, constant: 16),
            player2StatusView.bottomAnchor.constraint(equalTo: playerStatusContainer.bottomAnchor, constant: -16),
            player2StatusView.widthAnchor.constraint(equalTo: player1StatusView.widthAnchor)
        ])
    }
    
    // MARK: - Animation
    
    private func startAnimations() {
        orb1.startFloating(duration: 8.0, xRange: -100...100, yRange: -50...50)
        orb2.startFloating(duration: 10.0, xRange: -80...80, yRange: -100...100)
        orb3.startFloating(duration: 6.0, xRange: -50...50, yRange: -80...80)
    }
    
    // MARK: - Data Loading
    
    private func loadProfiles() {
        if(self.profileManager!.getPlayerProfileArray().isEmpty)
        {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let request: NSFetchRequest<PlayerEntity> = PlayerEntity.fetchRequest()

            do
            {
                var playerEntities = try context.fetch(request)
                
                if(!playerEntities.isEmpty)
                {
                    for playerEntity in playerEntities
                    {
                        let playerProfile = PlayerProfile(playerID: playerEntity.playerID, userName: playerEntity.userName, profilePicture: PlayerProfile.ProfilePicture(rawValue: playerEntity.profilePicture)!, marbleColour: Marble.MarbleColour(rawValue: playerEntity.marbleColour)!, isLocalPlayer1: playerEntity.isLocalPlayer1, isLocalPlayer2: playerEntity.isLocalPlayer2, numWins: Int(playerEntity.numWins), numLosses: Int(playerEntity.numLosses), numDraws: Int(playerEntity.numDraws), totalMovesMade: Int(playerEntity.totalMovesMade))
                        
                        let achievementsRequest: NSFetchRequest<AchievementEntity> = AchievementEntity.fetchRequest()
                        achievementsRequest.predicate = NSPredicate(format: "belongsTo == %@", playerEntity)
                        let achievementEntities = try context.fetch(achievementsRequest)
                        
                        var achievements: Array<Achievement> = Array()
                        
                        for achievementEntity in achievementEntities
                        {
                            let achievement = Achievement(achievementTitle: achievementEntity.achievementTitle, achievementDescription: achievementEntity.achievementDescription, hasBeenEarned: achievementEntity.hasBeenEarned, dateEarned: achievementEntity.dateEarned, hasBeenDisplayed: achievementEntity.hasBeenDisplayed)
                            achievements.append(achievement)
                        }
                            
                        playerProfile.addAchievementObservers(achievementObservers: self.achievementObserverStore!.createInitialisedObserverList(existingAchievements: achievements))
                        try self.profileManager!.addPlayerProfile(newProfile: playerProfile)
                    }
                }
            }
            catch let GeneralException.IllegalArgument(message)
            {
                fatalError(message)
            }
            catch
            {
                fatalError("Failed to extract players")
            }
        }
        if(self.profileManager!.getAIProfileArray().isEmpty)
        {
            let aiProfile = PlayerProfile(userName: "AI", profilePicture: .cpuRobot, marbleColour: .grey)
            
            do
            {
                try self.profileManager!.addAIProfile(newProfile: aiProfile)
                aiProfile.addAchievementObservers(achievementObservers: achievementObserverStore!.createInitialisedObserverList())
            }
            catch let GeneralException.IllegalArgument(message)
            {
                fatalError(message)
            }
            catch
            {
                fatalError("Failed to add AI profile")
            }
        }
    }
    
    private func updatePlayerStatus() {
        if let player1 = profileManager?.activePlayer1 {
            player1StatusView.configure(with: player1, label: "P1")
            player1StatusView.isHidden = false
        } else {
            player1StatusView.isHidden = true
        }
        
        if let player2 = profileManager?.activePlayer2 {
            player2StatusView.configure(with: player2, label: "P2")
            player2StatusView.isHidden = false
        } else {
            player2StatusView.isHidden = true
        }
    }
    
    // MARK: - Button Actions
    
    @objc private func playButtonTapped() {
        let opponentSelectVC = OpponentSelectViewController()
        opponentSelectVC.profileManager = self.profileManager
        navigationController?.pushViewController(opponentSelectVC, animated: true)
    }
    
    @objc private func profileSettingsButtonTapped() {
        let profileSelectVC = ProfileSelectViewController()
        profileSelectVC.profileManager = self.profileManager
        profileSelectVC.nextScreen = .editProfileScreen
        navigationController?.pushViewController(profileSelectVC, animated: true)
    }
    
    @objc private func gameStatsButtonTapped() {
        guard let profileManager = profileManager, profileManager.getPlayerProfileArray().count > 0 else {
            showAlert(title: "Set Up Profiles", message: "There are no profiles to view game statistics. Head to Profile Settings to set up a profile.")
            return
        }
        
        let profileSelectVC = ProfileSelectViewController()
        profileSelectVC.profileManager = self.profileManager
        profileSelectVC.nextScreen = .gameplayStatsScreen
        navigationController?.pushViewController(profileSelectVC, animated: true)
    }
    
    @objc private func achievementsButtonTapped() {
        guard let profileManager = profileManager, profileManager.getPlayerProfileArray().count > 0 else {
            showAlert(title: "Set Up Profiles", message: "There are no profiles to view achievements. Head to Profile Settings to set up a profile.")
            return
        }
        
        let profileSelectVC = ProfileSelectViewController()
        profileSelectVC.profileManager = self.profileManager
        profileSelectVC.nextScreen = .achievementScreen
        navigationController?.pushViewController(profileSelectVC, animated: true)
    }
    
    @objc func saveProfiles()
    {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request: NSFetchRequest<PlayerEntity> = PlayerEntity.fetchRequest()
        
        do
        {
            var playerEntities = try context.fetch(request)
            
            for playerEntity in playerEntities
            {
                for playerProfile in self.profileManager!.getPlayerProfileArray()
                {
                    if(playerEntity.playerID == playerProfile.playerID)
                    {
                        playerEntity.savePlayerProfileData(playerProfile: playerProfile)
                    }
                }
            }
        }
        catch
        {
            fatalError("Failed to save PlayerProfiles")
        }
    }
    
    // MARK: - Helper Methods
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
    }
    
    enum ProfileSelectScreenDestination
    {
        case editProfileScreen
        case gameplayStatsScreen
        case achievementScreen
    }
}

// MARK: - Modern Button Component

class ModernButton: UIButton {
    private let gradientLayer = CAGradientLayer()
    private let iconImageView = UIImageView()
    private let customTitleLabel = UILabel()
    private let chevronImageView = UIImageView()
    private let iconBackgroundView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    private func setupButton() {
        // Shadow (set first, before masksToBounds)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 8)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 15
        
        // Gradient background
        layer.insertSublayer(gradientLayer, at: 0)
        layer.cornerRadius = 28
        layer.masksToBounds = true  // This clips the gradient to rounded corners
        
        // Icon background - also more rounded
        iconBackgroundView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        iconBackgroundView.layer.cornerRadius = 28
        iconBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconBackgroundView)
        
        // Icon
        iconImageView.tintColor = .white
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconImageView)
        
        // Title
        customTitleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        customTitleLabel.textColor = .white
        customTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(customTitleLabel)
        
        // Chevron
        chevronImageView.image = UIImage(systemName: "chevron.right")
        chevronImageView.tintColor = UIColor.white.withAlphaComponent(0.6)
        chevronImageView.contentMode = .scaleAspectFit
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(chevronImageView)
        
        NSLayoutConstraint.activate([
            iconBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            iconBackgroundView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconBackgroundView.widthAnchor.constraint(equalToConstant: 56),
            iconBackgroundView.heightAnchor.constraint(equalToConstant: 56),
            
            iconImageView.centerXAnchor.constraint(equalTo: iconBackgroundView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconBackgroundView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 30),
            iconImageView.heightAnchor.constraint(equalToConstant: 30),
            
            customTitleLabel.leadingAnchor.constraint(equalTo: iconBackgroundView.trailingAnchor, constant: 18),
            customTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            chevronImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            chevronImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 18),
            chevronImageView.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        // Add touch animations
        addTarget(self, action: #selector(buttonPressed), for: .touchDown)
        addTarget(self, action: #selector(buttonReleased), for: [.touchUpInside, .touchUpOutside, .touchCancel])
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        
        // Update shadow path for better performance
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 28).cgPath
    }
    
    func configure(title: String, icon: UIImage?, gradientColors: [UIColor]) {
        customTitleLabel.text = title
        iconImageView.image = icon
        
        gradientLayer.colors = gradientColors.map { $0.cgColor }
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        
        // Set shadow color based on first gradient color
        layer.shadowColor = gradientColors.first?.cgColor ?? UIColor.black.cgColor
    }
    
    @objc private func buttonPressed() {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseInOut) {
            self.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
            self.layer.shadowOpacity = 0.15
            self.layer.shadowRadius = 5
            self.layer.shadowOffset = CGSize(width: 0, height: 2)
        }
    }
    
    @objc private func buttonReleased() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.5, options: .curveEaseInOut) {
            self.transform = .identity
            self.layer.shadowOpacity = 0.3
            self.layer.shadowRadius = 15
            self.layer.shadowOffset = CGSize(width: 0, height: 8)
        }
    }
}

// MARK: - Floating Orb View

class FloatingOrbView: UIView {
    init(color: UIColor, size: CGFloat) {
        super.init(frame: CGRect(x: 0, y: 0, width: size, height: size))
        
        backgroundColor = .clear
        layer.cornerRadius = size / 2
        
        // Create radial gradient
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.type = .radial
        gradientLayer.colors = [color.cgColor, UIColor.clear.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        layer.addSublayer(gradientLayer)
        
        // Blur effect
        layer.opacity = 0.6
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startFloating(duration: TimeInterval, xRange: ClosedRange<CGFloat>, yRange: ClosedRange<CGFloat>) {
        let randomX = CGFloat.random(in: xRange)
        let randomY = CGFloat.random(in: yRange)
        
        UIView.animate(withDuration: duration, delay: 0, options: [.repeat, .autoreverse, .curveEaseInOut]) {
            self.transform = CGAffineTransform(translationX: randomX, y: randomY)
        }
    }
}

// MARK: - Player Status View

class PlayerStatusView: UIView {
    private let labelLabel = UILabel()
    private let colorDot = UIView()
    private let nameLabel = UILabel()
    private let containerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        containerView.layer.cornerRadius = 20  // More rounded (was 16)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        labelLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        labelLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        labelLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(labelLabel)
        
        colorDot.layer.cornerRadius = 6
        colorDot.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(colorDot)
        
        nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        nameLabel.textColor = .white
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            labelLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            labelLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            colorDot.leadingAnchor.constraint(equalTo: labelLabel.trailingAnchor, constant: 8),
            colorDot.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            colorDot.widthAnchor.constraint(equalToConstant: 12),
            colorDot.heightAnchor.constraint(equalToConstant: 12),
            
            nameLabel.leadingAnchor.constraint(equalTo: colorDot.trailingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -12),
            nameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            containerView.heightAnchor.constraint(equalToConstant: 44)  // Slightly taller (was 40)
        ])
    }
    
    func configure(with profile: PlayerProfile, label: String) {
        labelLabel.text = label
        nameLabel.text = profile.userName
        colorDot.backgroundColor = marbleColor(for: profile.marbleColour)
    }
    
    private func marbleColor(for colour: Marble.MarbleColour) -> UIColor {
        switch colour {
        case .black: return .black
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


