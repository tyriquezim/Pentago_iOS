//
//  HowToPlayTableViewController.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 1/1/2026.
//  Redesigned programmatically on 11/5/2026
//
import UIKit

class HowToPlayTableViewController: UIViewController
{
    // MARK: - Properties
    private var gameRuleInfoStore: GameRulesInfoStore!
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let gradientLayer = CAGradientLayer()
    
    private let headerContainer = UIView()
    private let logoImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    
    private let rulesStackView = UIStackView()
    
    // Floating orbs for background animation
    private let orb1 = FloatingOrbView(color: UIColor.systemIndigo.withAlphaComponent(0.3), size: 250)
    private let orb2 = FloatingOrbView(color: UIColor.systemPurple.withAlphaComponent(0.25), size: 200)
    
    // MARK: - Lifecycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.gameRuleInfoStore = GameRulesInfoStore()
        
        setupUI()
        setupConstraints()
        populateRules()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startAnimations()
    }
    
    // MARK: - Setup Methods
    
    private func setupUI() {
        // Gradient Background
        gradientLayer.colors = [
            UIColor(red: 0.1, green: 0.15, blue: 0.4, alpha: 1.0).cgColor,
            UIColor(red: 0.15, green: 0.1, blue: 0.35, alpha: 1.0).cgColor,
            UIColor(red: 0.1, green: 0.2, blue: 0.45, alpha: 1.0).cgColor
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
        
        // Header Container
        headerContainer.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        headerContainer.layer.cornerRadius = 24
        headerContainer.layer.borderWidth = 1
        headerContainer.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        contentView.addSubview(headerContainer)
        
        // Logo Image
        logoImageView.image = ImageAssetFactory.getAppLogoUIImage()
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.clipsToBounds = true
        logoImageView.layer.cornerRadius = 50  // Half of width/height to make it circular
        logoImageView.layer.borderWidth = 3
        logoImageView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        logoImageView.layer.shadowColor = UIColor.black.cgColor
        logoImageView.layer.shadowOffset = CGSize(width: 0, height: 4)
        logoImageView.layer.shadowOpacity = 0.3
        logoImageView.layer.shadowRadius = 8
        headerContainer.addSubview(logoImageView)
        
        // Title
        titleLabel.text = "HOW TO PLAY"
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .black)
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 3)
        titleLabel.layer.shadowOpacity = 0.3
        titleLabel.layer.shadowRadius = 6
        headerContainer.addSubview(titleLabel)
        
        // Description
        descriptionLabel.text = gameRuleInfoStore.gameDescription
        descriptionLabel.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        descriptionLabel.textAlignment = .left
        descriptionLabel.textColor = UIColor.white.withAlphaComponent(0.95)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.addSubview(descriptionLabel)
        
        // Rules Stack View
        rulesStackView.axis = .vertical
        rulesStackView.spacing = 16
        rulesStackView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rulesStackView)
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
            
            // Header Container
            headerContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            headerContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            headerContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Logo
            logoImageView.topAnchor.constraint(equalTo: headerContainer.topAnchor, constant: 24),
            logoImageView.centerXAnchor.constraint(equalTo: headerContainer.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -20),
            
            // Description
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -20),
            descriptionLabel.bottomAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: -24),
            
            // Rules Stack View
            rulesStackView.topAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: 24),
            rulesStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            rulesStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            rulesStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }
    
    private func populateRules() {
        for (index, rule) in gameRuleInfoStore.gameRulesArray.enumerated() {
            let ruleCard = RuleCardView(
                number: index + 1,
                title: rule.ruleTitle.rawValue,
                description: rule.ruleDescription,
                icon: nil  // Don't show icons
            )
            rulesStackView.addArrangedSubview(ruleCard)
        }
    }
    
    // MARK: - Animation
    
    private func startAnimations() {
        orb1.startFloating(duration: 9.0, xRange: -80...80, yRange: -60...60)
        orb2.startFloating(duration: 7.0, xRange: -60...60, yRange: -80...80)
    }
}

// MARK: - Rule Card View

class RuleCardView: UIView {
    private let containerView = UIView()
    private let numberLabel = UILabel()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dividerView = UIView()
    
    init(number: Int, title: String, description: String, icon: UIImage?) {
        super.init(frame: .zero)
        
        setupView()
        configure(number: number, title: title, description: description, icon: icon)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        
        // Container
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.12)
        containerView.layer.cornerRadius = 20
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor.white.withAlphaComponent(0.25).cgColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        // Number Badge
        numberLabel.font = UIFont.systemFont(ofSize: 20, weight: .black)
        numberLabel.textColor = .white
        numberLabel.textAlignment = .center
        numberLabel.backgroundColor = UIColor.systemIndigo.withAlphaComponent(0.8)
        numberLabel.layer.cornerRadius = 18
        numberLabel.layer.masksToBounds = true
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(numberLabel)
        
        // Icon (hidden by default)
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.tintColor = .white
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.isHidden = true  // Hidden by default
        containerView.addSubview(iconImageView)
        
        // Title
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(titleLabel)
        
        // Divider
        dividerView.backgroundColor = UIColor.white.withAlphaComponent(0.2)
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(dividerView)
        
        // Description
        descriptionLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        descriptionLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            numberLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            numberLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            numberLabel.widthAnchor.constraint(equalToConstant: 36),
            numberLabel.heightAnchor.constraint(equalToConstant: 36),
            
            iconImageView.centerYAnchor.constraint(equalTo: numberLabel.centerYAnchor),
            iconImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            iconImageView.widthAnchor.constraint(equalToConstant: 36),
            iconImageView.heightAnchor.constraint(equalToConstant: 36),
            
            titleLabel.topAnchor.constraint(equalTo: numberLabel.bottomAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            dividerView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            dividerView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            dividerView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            
            descriptionLabel.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    private func configure(number: Int, title: String, description: String, icon: UIImage?) {
        numberLabel.text = "\(number)"
        titleLabel.text = title
        descriptionLabel.text = description
        
        if let icon = icon {
            iconImageView.image = icon
            iconImageView.isHidden = false
        } else {
            iconImageView.isHidden = true
        }
    }
}
