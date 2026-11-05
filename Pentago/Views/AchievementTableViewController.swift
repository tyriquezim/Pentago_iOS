//
//  AchievementTableViewController.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 2/1/2026.
//  Redesigned programmatically on 11/5/2026
//

import UIKit
import EasyConfetti

class AchievementTableViewController: UIViewController {

    // MARK: - Properties
    var sourceProfile: PlayerProfile!
    private var confettiView: ConfettiView!
    private let confettiDuration: Double = 5
    private let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()

    // MARK: - UI Components
    private let gradientLayer = CAGradientLayer()
    private let orb1 = FloatingOrbView(color: UIColor.systemYellow.withAlphaComponent(0.2), size: 220)
    private let orb2 = FloatingOrbView(color: UIColor.systemOrange.withAlphaComponent(0.15), size: 180)

    private let headerCard = UIView()
    private let profileImageView = UIImageView()
    private let profileNameLabel = UILabel()
    private let achievementCountLabel = UILabel()

    private let tableView = UITableView(frame: .zero, style: .plain)

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
        confettiView?.frame = view.bounds
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        orb1.startFloating(duration: 8.0, xRange: -70...70, yRange: -50...50)
        orb2.startFloating(duration: 10.0, xRange: -60...60, yRange: -70...70)
    }

    // MARK: - Setup

    private func setupUI() {
        title = "Achievements"

        // Gradient background
        gradientLayer.colors = [
            UIColor(red: 0.1, green: 0.2, blue: 0.45, alpha: 1.0).cgColor,
            UIColor(red: 0.2, green: 0.1, blue: 0.3, alpha: 1.0).cgColor,
            UIColor(red: 0.15, green: 0.15, blue: 0.35, alpha: 1.0).cgColor
        ]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)

        view.addSubview(orb1)
        view.addSubview(orb2)

        // Header card
        headerCard.backgroundColor = UIColor.white.withAlphaComponent(0.12)
        headerCard.layer.cornerRadius = 24
        headerCard.layer.borderWidth = 1
        headerCard.layer.borderColor = UIColor.white.withAlphaComponent(0.25).cgColor
        headerCard.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerCard)

        // Profile image
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = 35
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.borderColor = UIColor.white.cgColor
        profileImageView.image = ImageAssetFactory.getProfilePictureUIImage(profilePicture: sourceProfile.profilePicture)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        headerCard.addSubview(profileImageView)

        // Profile name
        profileNameLabel.text = sourceProfile.userName
        profileNameLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        profileNameLabel.textColor = .white
        profileNameLabel.translatesAutoresizingMaskIntoConstraints = false
        headerCard.addSubview(profileNameLabel)

        // Achievement count
        let earned = sourceProfile.numAchievementsEarned
        let total = sourceProfile.numAchievements
        achievementCountLabel.text = "\(earned) of \(total) earned"
        achievementCountLabel.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        achievementCountLabel.textColor = UIColor.systemYellow
        achievementCountLabel.translatesAutoresizingMaskIntoConstraints = false
        headerCard.addSubview(achievementCountLabel)

        // Table view
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(AchievementTableViewCell.self, forCellReuseIdentifier: AchievementTableViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        // Confetti — frame is updated to view.bounds before each start() call so the
        // emitter spans the full screen width rather than spawning from a single point.
        confettiView = ConfettiView(frame: view.bounds)
        confettiView.config.particle = .confetti(allowedShapes: Particle.ConfettiShape.all)
        confettiView.isUserInteractionEnabled = false
        view.addSubview(confettiView)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerCard.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            headerCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headerCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            profileImageView.leadingAnchor.constraint(equalTo: headerCard.leadingAnchor, constant: 16),
            profileImageView.topAnchor.constraint(equalTo: headerCard.topAnchor, constant: 16),
            profileImageView.bottomAnchor.constraint(equalTo: headerCard.bottomAnchor, constant: -16),
            profileImageView.widthAnchor.constraint(equalToConstant: 70),
            profileImageView.heightAnchor.constraint(equalToConstant: 70),

            profileNameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 16),
            profileNameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 8),
            profileNameLabel.trailingAnchor.constraint(equalTo: headerCard.trailingAnchor, constant: -16),

            achievementCountLabel.leadingAnchor.constraint(equalTo: profileNameLabel.leadingAnchor),
            achievementCountLabel.topAnchor.constraint(equalTo: profileNameLabel.bottomAnchor, constant: 6),

            tableView.topAnchor.constraint(equalTo: headerCard.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UITableViewDataSource

extension AchievementTableViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sourceProfile.achievements.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AchievementTableViewCell.reuseIdentifier, for: indexPath) as! AchievementTableViewCell
        let achievement = sourceProfile.achievements[indexPath.row]

        if achievement.hasBeenEarned && achievement.dateEarned == nil {
            fatalError("Achievement configuration error: hasBeenEarned is true but dateEarned is nil")
        }
        if !achievement.hasBeenEarned && achievement.dateEarned != nil {
            fatalError("Achievement configuration error: hasBeenEarned is false but dateEarned is not nil")
        }

        cell.configure(with: achievement, dateFormatter: dateFormatter)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension AchievementTableViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if sourceProfile.achievements[indexPath.row].hasBeenEarned {
            confettiView.frame = view.bounds
            confettiView.start()
            DispatchQueue.main.asyncAfter(deadline: .now() + confettiDuration) {
                self.confettiView.stop()
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
