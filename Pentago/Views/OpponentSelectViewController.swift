//
//  OpponentSelectViewController.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 6/12/2025.
//  Redesigned programmatically on 11/5/2026
//

import UIKit

class OpponentSelectViewController: UIViewController
{
    
    // MARK: - Properties
    var profileManager: PlayerProfileManager?
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let gradientLayer = CAGradientLayer()
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    private let playerVsAICard = OpponentSelectionCard()
    private let playerVsPlayerCard = OpponentSelectionCard()
    
    // Floating orbs for background animation
    private let orb1 = FloatingOrbView(color: UIColor.systemGreen.withAlphaComponent(0.3), size: 250)
    private let orb2 = FloatingOrbView(color: UIColor.systemBlue.withAlphaComponent(0.25), size: 200)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupConstraints()
        setupActions()
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
        titleLabel.text = "Choose Opponent"
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
        subtitleLabel.text = "Select your game mode"
        subtitleLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        subtitleLabel.textAlignment = .center
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.8)
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subtitleLabel)
        
        // Player vs Player Card (First)
        playerVsPlayerCard.configure(
            mode: .playerVsPlayer,
            title: "Player vs Player",
            subtitle: "Play with a friend",
            gradientColors: [UIColor.systemBlue, UIColor.systemTeal]
        )
        playerVsPlayerCard.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(playerVsPlayerCard)
        
        // Player vs AI Card (Second)
        playerVsAICard.configure(
            mode: .playerVsAI,
            title: "Player vs AI",
            subtitle: "Challenge the computer",
            gradientColors: [UIColor.systemPurple, UIColor.systemIndigo]
        )
        playerVsAICard.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(playerVsAICard)
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
            
            // Player vs Player Card (First)
            playerVsPlayerCard.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 40),
            playerVsPlayerCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            playerVsPlayerCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            playerVsPlayerCard.heightAnchor.constraint(equalToConstant: 200),
            
            // Player vs AI Card (Second)
            playerVsAICard.topAnchor.constraint(equalTo: playerVsPlayerCard.bottomAnchor, constant: 20),
            playerVsAICard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            playerVsAICard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -30),
            playerVsAICard.heightAnchor.constraint(equalToConstant: 200),
            playerVsAICard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
    
    private func setupActions() {
        let aiTap = UITapGestureRecognizer(target: self, action: #selector(playerVsAITapped))
        playerVsAICard.addGestureRecognizer(aiTap)
        
        let playerTap = UITapGestureRecognizer(target: self, action: #selector(playerVsPlayerTapped))
        playerVsPlayerCard.addGestureRecognizer(playerTap)
    }
    
    private func startAnimations() {
        orb1.startFloating(duration: 9.0, xRange: -80...80, yRange: -60...60)
        orb2.startFloating(duration: 7.0, xRange: -60...60, yRange: -80...80)
    }
    
    // MARK: - Actions
    
    @objc private func playerVsAITapped() {
        bounceCard(playerVsAICard)

        guard let profileManager = profileManager else { return }

        guard let player1 = profileManager.activePlayer1 else {
            showAlert(
                title: "No Active Player",
                message: "No profile is set as Player 1. Go to Profile Settings and mark a profile as Player 1 to play against the AI.")
            return
        }

        let aiPlayer2 = profileManager.getAIProfile(index: 0)

        let sheet = UIAlertController(title: "Choose Difficulty", message: "How challenging should the AI be?", preferredStyle: .actionSheet)
        sheet.addAction(UIAlertAction(title: "Easy", style: .default) { _ in
            self.startGame(player1: player1, player2: aiPlayer2, isAgainstAI: true, difficulty: .easy)
        })
        sheet.addAction(UIAlertAction(title: "Medium", style: .default) { _ in
            self.startGame(player1: player1, player2: aiPlayer2, isAgainstAI: true, difficulty: .medium)
        })
        sheet.addAction(UIAlertAction(title: "Hard", style: .default) { _ in
            self.startGame(player1: player1, player2: aiPlayer2, isAgainstAI: true, difficulty: .hard)
        })
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(sheet, animated: true)
    }

    @objc private func playerVsPlayerTapped() {
        bounceCard(playerVsPlayerCard)

        guard let profileManager = profileManager else { return }

        guard let player1 = profileManager.activePlayer1 else {
            showAlert(
                title: "No Active Players Set",
                message: "No profiles are set as Player 1 or Player 2. Go to Profile Settings and assign both before starting a match.")
            return
        }

        guard let player2 = profileManager.activePlayer2 else {
            showAlert(
                title: "Player 2 Not Set",
                message: "No profile is set as Player 2. Go to Profile Settings and mark a profile as Player 2 before starting a match.")
            return
        }

        guard player1.marbleColour != player2.marbleColour else {
            showAlert(
                title: "Matching Marble Colors",
                message: "Both players have the same marble color. Go to Profile Settings and change one player's marble color before starting a match.")
            return
        }

        startGame(player1: player1, player2: player2, isAgainstAI: false)
    }

    private func startGame(player1: PlayerProfile, player2: PlayerProfile, isAgainstAI: Bool, difficulty: GameBoard.AIDifficulty = .medium) {
        let board = GameBoard(player1Profile: player1, player2Profile: player2, isAgainstAiOpponent: isAgainstAI, aiDifficulty: difficulty)
        let controller = GameBoardController(gameBoard: board)
        let gameBoardVC = GameBoardViewController()
        gameBoardVC.gameController = controller
        navigationController?.pushViewController(gameBoardVC, animated: true)
    }

    private func bounceCard(_ card: UIView) {
        UIView.animate(withDuration: 0.1, animations: {
            card.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
                card.transform = .identity
            })
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Opponent Selection Card

class OpponentSelectionCard: UIView {
    
    enum GameMode {
        case playerVsAI
        case playerVsPlayer
    }
    
    private let containerView = UIView()
    private let gradientLayer = CAGradientLayer()
    
    private let iconContainerView = UIView()
    private let leftIconView = UIImageView()
    private let vsLabel = UILabel()
    private let rightIconView = UIImageView()
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = containerView.bounds
        
        // Set shadow path for better performance and proper shape
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 32).cgPath
    }
    
    private func setupView() {
        // Make tappable
        isUserInteractionEnabled = true
        
        // Shadow (on main layer, no masking)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 8)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 15
        
        // Container view (for gradient and content)
        containerView.backgroundColor = .clear
        containerView.layer.cornerRadius = 32  // More rounded!
        containerView.layer.masksToBounds = true
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        // Gradient background inside container
        gradientLayer.cornerRadius = 32
        containerView.layer.insertSublayer(gradientLayer, at: 0)
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        // Icon Container
        iconContainerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(iconContainerView)
        
        // Left Icon
        leftIconView.contentMode = .scaleAspectFit
        leftIconView.tintColor = .white
        leftIconView.translatesAutoresizingMaskIntoConstraints = false
        iconContainerView.addSubview(leftIconView)
        
        // VS Label
        vsLabel.text = "VS"
        vsLabel.font = UIFont.systemFont(ofSize: 24, weight: .black)
        vsLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        vsLabel.textAlignment = .center
        vsLabel.translatesAutoresizingMaskIntoConstraints = false
        iconContainerView.addSubview(vsLabel)
        
        // Right Icon
        rightIconView.contentMode = .scaleAspectFit
        rightIconView.tintColor = .white
        rightIconView.translatesAutoresizingMaskIntoConstraints = false
        iconContainerView.addSubview(rightIconView)
        
        // Title
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        // Subtitle
        subtitleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            // Icon Container
            iconContainerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconContainerView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            iconContainerView.heightAnchor.constraint(equalToConstant: 80),
            
            // Left Icon
            leftIconView.leadingAnchor.constraint(equalTo: iconContainerView.leadingAnchor),
            leftIconView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            leftIconView.widthAnchor.constraint(equalToConstant: 60),
            leftIconView.heightAnchor.constraint(equalToConstant: 60),
            
            // VS Label
            vsLabel.leadingAnchor.constraint(equalTo: leftIconView.trailingAnchor, constant: 20),
            vsLabel.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            vsLabel.widthAnchor.constraint(equalToConstant: 50),
            
            // Right Icon
            rightIconView.leadingAnchor.constraint(equalTo: vsLabel.trailingAnchor, constant: 20),
            rightIconView.trailingAnchor.constraint(equalTo: iconContainerView.trailingAnchor),
            rightIconView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            rightIconView.widthAnchor.constraint(equalToConstant: 60),
            rightIconView.heightAnchor.constraint(equalToConstant: 60),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: iconContainerView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            
            // Subtitle
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            subtitleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ])
    }
    
    func configure(mode: GameMode, title: String, subtitle: String, gradientColors: [UIColor]) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        
        gradientLayer.colors = gradientColors.map { $0.cgColor }
        layer.shadowColor = gradientColors.first?.cgColor ?? UIColor.black.cgColor
        
        switch mode {
        case .playerVsAI:
            leftIconView.image = UIImage(systemName: "person.circle.fill")
            rightIconView.image = UIImage(systemName: "cpu")
            
        case .playerVsPlayer:
            leftIconView.image = UIImage(systemName: "person.circle.fill")
            rightIconView.image = UIImage(systemName: "person.circle.fill")
        }
    }
    
}
