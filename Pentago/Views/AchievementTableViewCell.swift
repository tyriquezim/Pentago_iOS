//
//  AchievementTableViewCell.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 2/1/2026.
//  Redesigned programmatically on 11/5/2026
//

import UIKit

class AchievementTableViewCell: UITableViewCell {

    static let reuseIdentifier = "AchievementTableViewCell"

    // MARK: - UI Components
    private let cardView = UIView()
    private let statusImageView = UIImageView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let dateLabel = UILabel()

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
        cardView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardView)

        statusImageView.contentMode = .scaleAspectFit
        statusImageView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(statusImageView)

        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        titleLabel.textColor = .white
        titleLabel.numberOfLines = 1
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(titleLabel)

        descriptionLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        descriptionLabel.textColor = UIColor.white.withAlphaComponent(0.75)
        descriptionLabel.numberOfLines = 2
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(descriptionLabel)

        dateLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        dateLabel.textColor = UIColor.systemYellow
        dateLabel.textAlignment = .right
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(dateLabel)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),

            statusImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            statusImageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            statusImageView.widthAnchor.constraint(equalToConstant: 44),
            statusImageView.heightAnchor.constraint(equalToConstant: 44),
            statusImageView.topAnchor.constraint(greaterThanOrEqualTo: cardView.topAnchor, constant: 14),
            statusImageView.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor, constant: -14),

            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 14),
            titleLabel.leadingAnchor.constraint(equalTo: statusImageView.trailingAnchor, constant: 14),
            titleLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -8),

            dateLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 14),
            dateLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            dateLabel.widthAnchor.constraint(equalToConstant: 95),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            descriptionLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -14)
        ])
    }

    // MARK: - Configure

    func configure(with achievement: Achievement, dateFormatter: DateFormatter) {
        titleLabel.text = achievement.achievementTitle
        descriptionLabel.text = achievement.achievementDescription
        statusImageView.image = ImageAssetFactory.getAchievementEarnStatusUIImage(hasBeenEarned: achievement.hasBeenEarned)

        if let date = achievement.dateEarned {
            dateLabel.text = dateFormatter.string(from: date)
            dateLabel.isHidden = false
        } else {
            dateLabel.isHidden = true
        }

        if achievement.hasBeenEarned {
            cardView.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.15)
            cardView.layer.borderColor = UIColor.systemYellow.withAlphaComponent(0.5).cgColor
            contentView.alpha = 1.0
        } else {
            cardView.backgroundColor = UIColor.white.withAlphaComponent(0.08)
            cardView.layer.borderColor = UIColor.white.withAlphaComponent(0.15).cgColor
            contentView.alpha = 0.6
        }
    }
}
