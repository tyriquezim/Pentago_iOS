//
//  SnackbarView.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 9/1/2026.
//
//This code was taken from the iOS Academy tutorial on Youtube. https://www.youtube.com/watch?v=oTPows48MRs


import UIKit

class SnackbarView: UIView
{
    let viewModel: SnackbarViewModel
    private let label: UILabel
    private let iconContainer: UIView
    private let imageView: UIImageView
    private let accentBar: UIView
    private var handler: (() -> Void)?
    private let verticalTranslation: Double
    private let duration: Double

    init(viewModel: SnackbarViewModel, frame: CGRect, verticalTranslation: Double, backgroundColour: UIColor, imageColour: UIColor, duration: Double)
    {
        self.viewModel = viewModel
        self.verticalTranslation = verticalTranslation
        self.duration = duration

        self.label = UILabel()
        self.iconContainer = UIView()
        self.imageView = UIImageView()
        self.accentBar = UIView()

        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = true

        // Glass background matching the app's card style
        self.backgroundColor = UIColor(red: 0.07, green: 0.05, blue: 0.18, alpha: 0.97)
        self.layer.cornerRadius = 18
        self.layer.borderWidth = 1
        self.layer.borderColor = backgroundColour.withAlphaComponent(0.5).cgColor

        // Coloured glow shadow
        self.layer.shadowColor = backgroundColour.cgColor
        self.layer.shadowOpacity = 0.35
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 14
        self.clipsToBounds = false

        // Left accent bar
        accentBar.backgroundColor = backgroundColour
        accentBar.layer.cornerRadius = 2
        accentBar.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(accentBar)

        // Circular icon container
        iconContainer.backgroundColor = backgroundColour.withAlphaComponent(0.2)
        iconContainer.layer.cornerRadius = 18
        iconContainer.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(iconContainer)

        // Icon image
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.tintColor = imageColour
        imageView.translatesAutoresizingMaskIntoConstraints = false
        iconContainer.addSubview(imageView)

        // Message label
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont(name: "Futura Bold", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)

        NSLayoutConstraint.activate([
            accentBar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            accentBar.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            accentBar.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            accentBar.widthAnchor.constraint(equalToConstant: 3),

            iconContainer.leadingAnchor.constraint(equalTo: accentBar.trailingAnchor, constant: 10),
            iconContainer.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            iconContainer.widthAnchor.constraint(equalToConstant: 36),
            iconContainer.heightAnchor.constraint(equalToConstant: 36),

            imageView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 20),

            label.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -14),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            label.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: 10),
            label.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -10),
        ])

        self.configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure()
    {
        self.label.text = viewModel.text
        self.imageView.image = viewModel.image

        switch self.viewModel.type
        {
            case .info:
                break
            case .action(let handler):
                self.handler = handler

            self.isUserInteractionEnabled = true
            let tapGestureRecog = UITapGestureRecognizer(target: self, action: #selector(self.didTapSnackbar))
            self.addGestureRecognizer(tapGestureRecog)
        }
    }

    @objc func didTapSnackbar()
    {
        self.handler?()
    }

    public func showSnackbar(view: UIView)
    {
        view.addSubview(self)

        let popAnimator: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut)
        {
            self.transform = CGAffineTransform(translationX: 0, y: -self.verticalTranslation)
        }

        popAnimator.addCompletion()
        {_ in
            let dismissAnimator: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut)
            {
                self.transform = CGAffineTransform(translationX: 0, y: self.verticalTranslation)
            }
            dismissAnimator.addCompletion()
            {_ in
                self.removeFromSuperview()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + self.duration)
            {
                dismissAnimator.startAnimation()
            }
        }
        popAnimator.startAnimation()
    }
}
