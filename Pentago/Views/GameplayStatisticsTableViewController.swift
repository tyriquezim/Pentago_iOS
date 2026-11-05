//
//  GameplayStatisticsTableViewController.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 2/1/2026.
//  Redesigned programmatically on 11/5/2026
//

import UIKit

class GameplayStatisticsTableViewController: UIViewController {

    // MARK: - Properties
    var sourceProfile: PlayerProfile!
    private let percentageFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .percent
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()

    // MARK: - UI Components
    private let gradientLayer = CAGradientLayer()
    private let orb1 = FloatingOrbView(color: UIColor.systemBlue.withAlphaComponent(0.25), size: 220)
    private let orb2 = FloatingOrbView(color: UIColor.systemTeal.withAlphaComponent(0.2), size: 180)

    private let headerCard = UIView()
    private let profileImageView = UIImageView()
    private let profileNameLabel = UILabel()
    private let winRateBadge = UIView()
    private let winRateLabel = UILabel()
    private let winRateTitleLabel = UILabel()

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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        orb1.startFloating(duration: 9.0, xRange: -70...70, yRange: -50...50)
        orb2.startFloating(duration: 11.0, xRange: -60...60, yRange: -70...70)
    }

    // MARK: - Setup

    private func setupUI() {
        title = "Statistics"

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

        // Win rate badge
        winRateBadge.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.2)
        winRateBadge.layer.cornerRadius = 14
        winRateBadge.layer.borderWidth = 1
        winRateBadge.layer.borderColor = UIColor.systemTeal.withAlphaComponent(0.5).cgColor
        winRateBadge.translatesAutoresizingMaskIntoConstraints = false
        headerCard.addSubview(winRateBadge)

        winRateLabel.text = percentageFormatter.string(from: NSNumber(value: sourceProfile.winPercentage)) ?? "0%"
        winRateLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        winRateLabel.textColor = .systemTeal
        winRateLabel.textAlignment = .center
        winRateLabel.translatesAutoresizingMaskIntoConstraints = false
        winRateBadge.addSubview(winRateLabel)

        winRateTitleLabel.text = "Win Rate"
        winRateTitleLabel.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        winRateTitleLabel.textColor = UIColor.white.withAlphaComponent(0.7)
        winRateTitleLabel.textAlignment = .center
        winRateTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        winRateBadge.addSubview(winRateTitleLabel)

        // Table view
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
        tableView.rowHeight = 72
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(GameplayStatisticsTableViewCell.self, forCellReuseIdentifier: GameplayStatisticsTableViewCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
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
            profileNameLabel.centerYAnchor.constraint(equalTo: headerCard.centerYAnchor),
            profileNameLabel.trailingAnchor.constraint(equalTo: winRateBadge.leadingAnchor, constant: -12),

            winRateBadge.trailingAnchor.constraint(equalTo: headerCard.trailingAnchor, constant: -16),
            winRateBadge.centerYAnchor.constraint(equalTo: headerCard.centerYAnchor),
            winRateBadge.widthAnchor.constraint(equalToConstant: 72),
            winRateBadge.heightAnchor.constraint(equalToConstant: 56),

            winRateLabel.topAnchor.constraint(equalTo: winRateBadge.topAnchor, constant: 8),
            winRateLabel.leadingAnchor.constraint(equalTo: winRateBadge.leadingAnchor),
            winRateLabel.trailingAnchor.constraint(equalTo: winRateBadge.trailingAnchor),

            winRateTitleLabel.topAnchor.constraint(equalTo: winRateLabel.bottomAnchor, constant: 2),
            winRateTitleLabel.leadingAnchor.constraint(equalTo: winRateBadge.leadingAnchor),
            winRateTitleLabel.trailingAnchor.constraint(equalTo: winRateBadge.trailingAnchor),

            tableView.topAnchor.constraint(equalTo: headerCard.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Helpers

    private func valueString(for stat: GameDisplayStatisticStore) -> String {
        switch stat {
        case .achievementsEarned: return String(sourceProfile.numAchievementsEarned)
        case .draw:               return String(sourceProfile.numDraws)
        case .gamesPlayed:        return String(sourceProfile.numGamesPlayed)
        case .lose:               return String(sourceProfile.numLosses)
        case .movesMade:          return String(sourceProfile.totalMovesMade)
        case .win:                return String(sourceProfile.numWins)
        case .winPercentage:      return percentageFormatter.string(from: NSNumber(value: sourceProfile.winPercentage)) ?? "0%"
        }
    }
}

// MARK: - UITableViewDataSource

extension GameplayStatisticsTableViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GameDisplayStatisticStore.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GameplayStatisticsTableViewCell.reuseIdentifier, for: indexPath) as! GameplayStatisticsTableViewCell
        let stat = GameDisplayStatisticStore.allCases[indexPath.row]
        cell.configure(displayStat: stat, value: valueString(for: stat))
        return cell
    }
}

// MARK: - UITableViewDelegate

extension GameplayStatisticsTableViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
