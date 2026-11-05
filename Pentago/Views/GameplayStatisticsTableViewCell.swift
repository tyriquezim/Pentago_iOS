//
//  GameplayStatisticsTableViewCell.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 2/1/2026.
//  Redesigned programmatically on 11/5/2026
//

import UIKit

class GameplayStatisticsTableViewCell: UITableViewCell {

    static let reuseIdentifier = "GameplayStatisticsTableViewCell"

    // MARK: - UI Components
    private let cardView = UIView()
    private let iconContainerView = UIView()
    private let iconImageView = UIImageView()
    private let statNameLabel = UILabel()
    private let valueLabel = UILabel()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupView() {
        backgroundColor = .clear
        selectionStyle = .none

        cardView.layer.cornerRadius = 16
        cardView.layer.borderWidth = 1
        cardView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        cardView.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)

        iconContainerView.layer.cornerRadius = 14
        iconContainerView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(iconContainerView)

        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconContainerView.addSubview(iconImageView)

        statNameLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        statNameLabel.textColor = .white
        statNameLabel.numberOfLines = 1
        statNameLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(statNameLabel)

        valueLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        valueLabel.textAlignment = .right
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(valueLabel)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),

            iconContainerView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 14),
            iconContainerView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            iconContainerView.widthAnchor.constraint(equalToConstant: 48),
            iconContainerView.heightAnchor.constraint(equalToConstant: 48),
            iconContainerView.topAnchor.constraint(greaterThanOrEqualTo: cardView.topAnchor, constant: 14),
            iconContainerView.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor, constant: -14),

            iconImageView.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 28),
            iconImageView.heightAnchor.constraint(equalToConstant: 28),

            statNameLabel.leadingAnchor.constraint(equalTo: iconContainerView.trailingAnchor, constant: 14),
            statNameLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            statNameLabel.trailingAnchor.constraint(equalTo: valueLabel.leadingAnchor, constant: -8),

            valueLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -18),
            valueLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            valueLabel.widthAnchor.constraint(equalToConstant: 90)
        ])
    }

    // MARK: - Configure

    func configure(displayStat: GameDisplayStatisticStore, value: String) {
        statNameLabel.text = displayStat.rawValue
        valueLabel.text = value

        let accent = accentColor(for: displayStat)
        iconContainerView.backgroundColor = accent.withAlphaComponent(0.2)
        iconImageView.image = ImageAssetFactory.getStatUIImage(gameDisplayStat: displayStat)
        iconImageView.tintColor = accent
        valueLabel.textColor = accent
    }

    private func accentColor(for stat: GameDisplayStatisticStore) -> UIColor {
        switch stat {
        case .win:               return .systemGreen
        case .lose:              return .systemRed
        case .draw:              return .systemGray
        case .winPercentage:     return .systemTeal
        case .gamesPlayed:       return .systemBlue
        case .movesMade:         return .systemPurple
        case .achievementsEarned: return .systemYellow
        }
    }
}
