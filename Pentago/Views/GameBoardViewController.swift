//
//  GameBoardViewController.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 2/1/2026.
//  Redesigned programmatically on 11/5/2026
//

import UIKit

class GameBoardViewController: UIViewController
{
    // MARK: - Game State

    var gameController: GameBoardController!
    var gamePhase: GamePhase!
    var selectedSubgridCollectionView: UICollectionView?

    var upperLeftSubgridRotationMultiplier: CGFloat = 0
    var upperRightSubgridRotationMultiplier: CGFloat = 0
    var lowerLeftSubgridRotationMultiplier: CGFloat = 0
    var lowerRightSubgridRotationMultiplier: CGFloat = 0

    var snackbarFrame: CGRect!
    var snackbarVerticalTranslation: Double!
    var snackbarQueue: [SnackbarView] = []

    // MARK: - Background

    private let gradientLayer = CAGradientLayer()
    private let orb1 = FloatingOrbView(color: UIColor(red: 0.4, green: 0.2, blue: 0.9, alpha: 0.3), size: 280)
    private let orb2 = FloatingOrbView(color: UIColor(red: 0.1, green: 0.3, blue: 0.7, alpha: 0.25), size: 220)

    // MARK: - Player Header

    private let playerHeaderCard = UIView()
    private let player1Card = UIView()
    private let player2Card = UIView()
    private let player1ColorRing = UIView()
    private let player2ColorRing = UIView()
    private let player1AvatarView = UIImageView()
    private let player2AvatarView = UIImageView()
    private let player1NameLabel = UILabel()
    private let player2NameLabel = UILabel()
    private let playerTurnLabel = UILabel()

    // MARK: - Status Card

    private let statusCard = UIView()
    private let gameStatusLabel = UILabel()

    // MARK: - Board

    private let boardContainer = UIView()
    private let upperLeftContainer = UIView()
    private let upperRightContainer = UIView()
    private let lowerLeftContainer = UIView()
    private let lowerRightContainer = UIView()

    private let upperLeftSubgrid = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let upperRightSubgrid = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let lowerLeftSubgrid = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let lowerRightSubgrid = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    private var subgridContainerMap: [UICollectionView: UIView] = [:]

    // MARK: - Rotation Panel

    private let rotationPanel = UIView()
    private let clockwiseButton = UIButton(type: .system)
    private let anticlockwiseButton = UIButton(type: .system)

    // MARK: - Lifecycle

    override func viewDidLoad()
    {
        super.viewDidLoad()

        setupUI()
        setupConstraints()
        configureSubgrids()

        subgridContainerMap = [
            upperLeftSubgrid: upperLeftContainer,
            upperRightSubgrid: upperRightContainer,
            lowerLeftSubgrid: lowerLeftContainer,
            lowerRightSubgrid: lowerRightContainer
        ]

        configureInitialGameState()
    }

    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds

        if snackbarFrame == nil {
            let snackbarWidth = view.frame.width / 1.5
            let snackbarHeight: CGFloat = 60
            let snackbarX = (view.frame.width - snackbarWidth) / 2
            let snackbarY = view.frame.height
            snackbarFrame = CGRect(x: snackbarX, y: snackbarY, width: snackbarWidth, height: snackbarHeight)
            snackbarVerticalTranslation = 100
        }
    }

    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        orb1.startFloating(duration: 10.0, xRange: -100...100, yRange: -80...80)
        orb2.startFloating(duration: 8.0, xRange: -80...80, yRange: -100...100)
    }

    // MARK: - Setup

    private func setupUI()
    {
        // Gradient background — slightly darker / more saturated than main menu for game focus
        gradientLayer.colors = [
            UIColor(red: 0.05, green: 0.1, blue: 0.3, alpha: 1).cgColor,
            UIColor(red: 0.15, green: 0.05, blue: 0.28, alpha: 1).cgColor,
            UIColor(red: 0.08, green: 0.08, blue: 0.22, alpha: 1).cgColor
        ]
        gradientLayer.locations = [0, 0.5, 1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        view.layer.insertSublayer(gradientLayer, at: 0)

        view.addSubview(orb1)
        view.addSubview(orb2)

        // Player header card
        applyGlassStyle(to: playerHeaderCard, cornerRadius: 20)
        view.addSubview(playerHeaderCard)

        // Player 1 card (left half of header)
        applyGlassStyle(to: player1Card, cornerRadius: 14)
        playerHeaderCard.addSubview(player1Card)

        player1ColorRing.layer.cornerRadius = 28
        player1ColorRing.layer.borderWidth = 3
        player1ColorRing.translatesAutoresizingMaskIntoConstraints = false
        player1Card.addSubview(player1ColorRing)

        player1AvatarView.contentMode = .scaleAspectFill
        player1AvatarView.clipsToBounds = true
        player1AvatarView.layer.cornerRadius = 23
        player1AvatarView.translatesAutoresizingMaskIntoConstraints = false
        player1Card.addSubview(player1AvatarView)

        player1NameLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        player1NameLabel.textColor = .white
        player1NameLabel.textAlignment = .center
        player1NameLabel.numberOfLines = 1
        player1NameLabel.translatesAutoresizingMaskIntoConstraints = false
        player1Card.addSubview(player1NameLabel)

        // Player 2 card (right half of header — mirrored)
        applyGlassStyle(to: player2Card, cornerRadius: 14)
        playerHeaderCard.addSubview(player2Card)

        player2ColorRing.layer.cornerRadius = 28
        player2ColorRing.layer.borderWidth = 3
        player2ColorRing.translatesAutoresizingMaskIntoConstraints = false
        player2Card.addSubview(player2ColorRing)

        player2AvatarView.contentMode = .scaleAspectFill
        player2AvatarView.clipsToBounds = true
        player2AvatarView.layer.cornerRadius = 23
        player2AvatarView.translatesAutoresizingMaskIntoConstraints = false
        player2Card.addSubview(player2AvatarView)

        player2NameLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        player2NameLabel.textColor = .white
        player2NameLabel.textAlignment = .center
        player2NameLabel.numberOfLines = 1
        player2NameLabel.translatesAutoresizingMaskIntoConstraints = false
        player2Card.addSubview(player2NameLabel)

        // Turn label — centred between the two player cards
        playerTurnLabel.font = .systemFont(ofSize: 12, weight: .bold)
        playerTurnLabel.textColor = UIColor.systemYellow
        playerTurnLabel.textAlignment = .center
        playerTurnLabel.numberOfLines = 2
        playerTurnLabel.adjustsFontSizeToFitWidth = true
        playerTurnLabel.translatesAutoresizingMaskIntoConstraints = false
        playerHeaderCard.addSubview(playerTurnLabel)

        // Status card — instruction text
        applyGlassStyle(to: statusCard, cornerRadius: 14)
        view.addSubview(statusCard)

        gameStatusLabel.font = .systemFont(ofSize: 13, weight: .medium)
        gameStatusLabel.textColor = UIColor.white.withAlphaComponent(0.9)
        gameStatusLabel.textAlignment = .center
        gameStatusLabel.numberOfLines = 2
        gameStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusCard.addSubview(gameStatusLabel)

        // Board container
        boardContainer.backgroundColor = UIColor(red: 0.06, green: 0.04, blue: 0.18, alpha: 0.95)
        boardContainer.layer.cornerRadius = 20
        boardContainer.layer.borderWidth = 1
        boardContainer.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        boardContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(boardContainer)

        // 4 subgrid containers (glass-style dark cards)
        for container in [upperLeftContainer, upperRightContainer, lowerLeftContainer, lowerRightContainer] {
            container.backgroundColor = UIColor(red: 0.12, green: 0.08, blue: 0.3, alpha: 0.9)
            container.layer.cornerRadius = 10
            container.layer.borderWidth = 1
            container.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
            container.clipsToBounds = true
            container.translatesAutoresizingMaskIntoConstraints = false
            boardContainer.addSubview(container)
        }

        // 4 collection views
        for cv in [upperLeftSubgrid, upperRightSubgrid, lowerLeftSubgrid, lowerRightSubgrid] {
            if let layout = cv.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.minimumInteritemSpacing = 0
                layout.minimumLineSpacing = 0
                layout.sectionInset = .zero
            }
            cv.backgroundColor = .clear
            cv.isScrollEnabled = false
            cv.translatesAutoresizingMaskIntoConstraints = false
        }
        // Preserve original scroll behaviour
        upperLeftSubgrid.isScrollEnabled = true

        upperLeftContainer.addSubview(upperLeftSubgrid)
        upperRightContainer.addSubview(upperRightSubgrid)
        lowerLeftContainer.addSubview(lowerLeftSubgrid)
        lowerRightContainer.addSubview(lowerRightSubgrid)

        // Cross divider lines between the 4 subgrids
        let vDivider = UIView()
        vDivider.backgroundColor = UIColor.white.withAlphaComponent(0.12)
        vDivider.translatesAutoresizingMaskIntoConstraints = false
        boardContainer.addSubview(vDivider)

        let hDivider = UIView()
        hDivider.backgroundColor = UIColor.white.withAlphaComponent(0.12)
        hDivider.translatesAutoresizingMaskIntoConstraints = false
        boardContainer.addSubview(hDivider)

        boardDividerV = vDivider
        boardDividerH = hDivider

        // Rotation panel (hidden until marble placed and subgrid selected)
        applyGlassStyle(to: rotationPanel, cornerRadius: 18)
        rotationPanel.isHidden = true
        view.addSubview(rotationPanel)

        styleRotationButton(anticlockwiseButton, symbolName: "arrow.counterclockwise", label: "Anticlockwise")
        anticlockwiseButton.addTarget(self, action: #selector(anticlockwiseRotationAnimation), for: .touchUpInside)
        rotationPanel.addSubview(anticlockwiseButton)

        styleRotationButton(clockwiseButton, symbolName: "arrow.clockwise", label: "Clockwise")
        clockwiseButton.addTarget(self, action: #selector(clockwiseRotationAnimation), for: .touchUpInside)
        rotationPanel.addSubview(clockwiseButton)
    }

    // Stored references for dividers (need constraints)
    private var boardDividerV: UIView!
    private var boardDividerH: UIView!

    private func setupConstraints()
    {
        let edgePad: CGFloat = 16
        let gap: CGFloat = 8
        let subgridGap: CGFloat = 8
        let boardInset: CGFloat = 10

        NSLayoutConstraint.activate([

            // ── Player Header ──────────────────────────────────────────────
            playerHeaderCard.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: gap),
            playerHeaderCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: edgePad),
            playerHeaderCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -edgePad),
            playerHeaderCard.heightAnchor.constraint(equalToConstant: 90),

            // Player 1 Card (left 38%)
            player1Card.leadingAnchor.constraint(equalTo: playerHeaderCard.leadingAnchor, constant: 8),
            player1Card.topAnchor.constraint(equalTo: playerHeaderCard.topAnchor, constant: 8),
            player1Card.bottomAnchor.constraint(equalTo: playerHeaderCard.bottomAnchor, constant: -8),
            player1Card.widthAnchor.constraint(equalTo: playerHeaderCard.widthAnchor, multiplier: 0.37),

            // P1 colour ring — centred horizontally, offset left
            player1ColorRing.leadingAnchor.constraint(equalTo: player1Card.leadingAnchor, constant: 8),
            player1ColorRing.centerYAnchor.constraint(equalTo: player1Card.centerYAnchor),
            player1ColorRing.widthAnchor.constraint(equalToConstant: 56),
            player1ColorRing.heightAnchor.constraint(equalToConstant: 56),

            // P1 avatar inside ring
            player1AvatarView.centerXAnchor.constraint(equalTo: player1ColorRing.centerXAnchor),
            player1AvatarView.centerYAnchor.constraint(equalTo: player1ColorRing.centerYAnchor),
            player1AvatarView.widthAnchor.constraint(equalToConstant: 48),
            player1AvatarView.heightAnchor.constraint(equalToConstant: 48),

            // P1 name — right of ring
            player1NameLabel.leadingAnchor.constraint(equalTo: player1ColorRing.trailingAnchor, constant: 6),
            player1NameLabel.trailingAnchor.constraint(equalTo: player1Card.trailingAnchor, constant: -6),
            player1NameLabel.centerYAnchor.constraint(equalTo: player1Card.centerYAnchor),

            // Turn label — centred in header card
            playerTurnLabel.centerXAnchor.constraint(equalTo: playerHeaderCard.centerXAnchor),
            playerTurnLabel.centerYAnchor.constraint(equalTo: playerHeaderCard.centerYAnchor),
            playerTurnLabel.widthAnchor.constraint(equalTo: playerHeaderCard.widthAnchor, multiplier: 0.22),

            // Player 2 Card (right 38%)
            player2Card.trailingAnchor.constraint(equalTo: playerHeaderCard.trailingAnchor, constant: -8),
            player2Card.topAnchor.constraint(equalTo: playerHeaderCard.topAnchor, constant: 8),
            player2Card.bottomAnchor.constraint(equalTo: playerHeaderCard.bottomAnchor, constant: -8),
            player2Card.widthAnchor.constraint(equalTo: playerHeaderCard.widthAnchor, multiplier: 0.37),

            // P2 colour ring — mirrored (right side)
            player2ColorRing.trailingAnchor.constraint(equalTo: player2Card.trailingAnchor, constant: -8),
            player2ColorRing.centerYAnchor.constraint(equalTo: player2Card.centerYAnchor),
            player2ColorRing.widthAnchor.constraint(equalToConstant: 56),
            player2ColorRing.heightAnchor.constraint(equalToConstant: 56),

            player2AvatarView.centerXAnchor.constraint(equalTo: player2ColorRing.centerXAnchor),
            player2AvatarView.centerYAnchor.constraint(equalTo: player2ColorRing.centerYAnchor),
            player2AvatarView.widthAnchor.constraint(equalToConstant: 48),
            player2AvatarView.heightAnchor.constraint(equalToConstant: 48),

            // P2 name — left of ring
            player2NameLabel.trailingAnchor.constraint(equalTo: player2ColorRing.leadingAnchor, constant: -6),
            player2NameLabel.leadingAnchor.constraint(equalTo: player2Card.leadingAnchor, constant: 6),
            player2NameLabel.centerYAnchor.constraint(equalTo: player2Card.centerYAnchor),

            // ── Status Card ───────────────────────────────────────────────
            statusCard.topAnchor.constraint(equalTo: playerHeaderCard.bottomAnchor, constant: gap),
            statusCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: edgePad),
            statusCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -edgePad),
            statusCard.heightAnchor.constraint(equalToConstant: 44),

            gameStatusLabel.centerXAnchor.constraint(equalTo: statusCard.centerXAnchor),
            gameStatusLabel.centerYAnchor.constraint(equalTo: statusCard.centerYAnchor),
            gameStatusLabel.leadingAnchor.constraint(equalTo: statusCard.leadingAnchor, constant: 12),
            gameStatusLabel.trailingAnchor.constraint(equalTo: statusCard.trailingAnchor, constant: -12),

            // ── Board Container (square) ───────────────────────────────────
            boardContainer.topAnchor.constraint(equalTo: statusCard.bottomAnchor, constant: gap),
            boardContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: edgePad),
            boardContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -edgePad),
            boardContainer.heightAnchor.constraint(equalTo: boardContainer.widthAnchor),

            // ── Rotation Panel ────────────────────────────────────────────
            rotationPanel.topAnchor.constraint(equalTo: boardContainer.bottomAnchor, constant: gap),
            rotationPanel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: edgePad),
            rotationPanel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -edgePad),
            rotationPanel.heightAnchor.constraint(equalToConstant: 72),

            anticlockwiseButton.leadingAnchor.constraint(equalTo: rotationPanel.leadingAnchor, constant: 16),
            anticlockwiseButton.topAnchor.constraint(equalTo: rotationPanel.topAnchor, constant: 10),
            anticlockwiseButton.bottomAnchor.constraint(equalTo: rotationPanel.bottomAnchor, constant: -10),
            anticlockwiseButton.widthAnchor.constraint(equalToConstant: 130),

            clockwiseButton.trailingAnchor.constraint(equalTo: rotationPanel.trailingAnchor, constant: -16),
            clockwiseButton.topAnchor.constraint(equalTo: rotationPanel.topAnchor, constant: 10),
            clockwiseButton.bottomAnchor.constraint(equalTo: rotationPanel.bottomAnchor, constant: -10),
            clockwiseButton.widthAnchor.constraint(equalToConstant: 130),
        ])

        setupBoardInternalConstraints(inset: boardInset, gap: subgridGap)
    }

    private func setupBoardInternalConstraints(inset: CGFloat, gap: CGFloat)
    {
        let half = gap / 2

        NSLayoutConstraint.activate([
            // Upper Left
            upperLeftContainer.topAnchor.constraint(equalTo: boardContainer.topAnchor, constant: inset),
            upperLeftContainer.leadingAnchor.constraint(equalTo: boardContainer.leadingAnchor, constant: inset),
            upperLeftContainer.trailingAnchor.constraint(equalTo: boardContainer.centerXAnchor, constant: -half),
            upperLeftContainer.bottomAnchor.constraint(equalTo: boardContainer.centerYAnchor, constant: -half),

            // Upper Right
            upperRightContainer.topAnchor.constraint(equalTo: boardContainer.topAnchor, constant: inset),
            upperRightContainer.leadingAnchor.constraint(equalTo: boardContainer.centerXAnchor, constant: half),
            upperRightContainer.trailingAnchor.constraint(equalTo: boardContainer.trailingAnchor, constant: -inset),
            upperRightContainer.bottomAnchor.constraint(equalTo: boardContainer.centerYAnchor, constant: -half),

            // Lower Left
            lowerLeftContainer.topAnchor.constraint(equalTo: boardContainer.centerYAnchor, constant: half),
            lowerLeftContainer.leadingAnchor.constraint(equalTo: boardContainer.leadingAnchor, constant: inset),
            lowerLeftContainer.trailingAnchor.constraint(equalTo: boardContainer.centerXAnchor, constant: -half),
            lowerLeftContainer.bottomAnchor.constraint(equalTo: boardContainer.bottomAnchor, constant: -inset),

            // Lower Right
            lowerRightContainer.topAnchor.constraint(equalTo: boardContainer.centerYAnchor, constant: half),
            lowerRightContainer.leadingAnchor.constraint(equalTo: boardContainer.centerXAnchor, constant: half),
            lowerRightContainer.trailingAnchor.constraint(equalTo: boardContainer.trailingAnchor, constant: -inset),
            lowerRightContainer.bottomAnchor.constraint(equalTo: boardContainer.bottomAnchor, constant: -inset),

            // Collection views fill their containers
            upperLeftSubgrid.topAnchor.constraint(equalTo: upperLeftContainer.topAnchor),
            upperLeftSubgrid.leadingAnchor.constraint(equalTo: upperLeftContainer.leadingAnchor),
            upperLeftSubgrid.trailingAnchor.constraint(equalTo: upperLeftContainer.trailingAnchor),
            upperLeftSubgrid.bottomAnchor.constraint(equalTo: upperLeftContainer.bottomAnchor),

            upperRightSubgrid.topAnchor.constraint(equalTo: upperRightContainer.topAnchor),
            upperRightSubgrid.leadingAnchor.constraint(equalTo: upperRightContainer.leadingAnchor),
            upperRightSubgrid.trailingAnchor.constraint(equalTo: upperRightContainer.trailingAnchor),
            upperRightSubgrid.bottomAnchor.constraint(equalTo: upperRightContainer.bottomAnchor),

            lowerLeftSubgrid.topAnchor.constraint(equalTo: lowerLeftContainer.topAnchor),
            lowerLeftSubgrid.leadingAnchor.constraint(equalTo: lowerLeftContainer.leadingAnchor),
            lowerLeftSubgrid.trailingAnchor.constraint(equalTo: lowerLeftContainer.trailingAnchor),
            lowerLeftSubgrid.bottomAnchor.constraint(equalTo: lowerLeftContainer.bottomAnchor),

            lowerRightSubgrid.topAnchor.constraint(equalTo: lowerRightContainer.topAnchor),
            lowerRightSubgrid.leadingAnchor.constraint(equalTo: lowerRightContainer.leadingAnchor),
            lowerRightSubgrid.trailingAnchor.constraint(equalTo: lowerRightContainer.trailingAnchor),
            lowerRightSubgrid.bottomAnchor.constraint(equalTo: lowerRightContainer.bottomAnchor),

            // Cross dividers
            boardDividerV.centerXAnchor.constraint(equalTo: boardContainer.centerXAnchor),
            boardDividerV.topAnchor.constraint(equalTo: boardContainer.topAnchor),
            boardDividerV.bottomAnchor.constraint(equalTo: boardContainer.bottomAnchor),
            boardDividerV.widthAnchor.constraint(equalToConstant: 1),

            boardDividerH.centerYAnchor.constraint(equalTo: boardContainer.centerYAnchor),
            boardDividerH.leadingAnchor.constraint(equalTo: boardContainer.leadingAnchor),
            boardDividerH.trailingAnchor.constraint(equalTo: boardContainer.trailingAnchor),
            boardDividerH.heightAnchor.constraint(equalToConstant: 1),
        ])
    }

    private func configureSubgrids()
    {
        for cv in [upperLeftSubgrid, upperRightSubgrid, lowerLeftSubgrid, lowerRightSubgrid] {
            cv.delegate = self
            cv.dataSource = self
            cv.register(GameBoardCollectionViewCell.self, forCellWithReuseIdentifier: "GameBoardCollectionViewCell")
        }
    }

    private func configureInitialGameState()
    {
        gamePhase = .placeMarble
        rotationPanel.isHidden = true
        selectedSubgridCollectionView = nil
        snackbarQueue = []

        // Player info
        player1AvatarView.image = ImageAssetFactory.getProfilePictureUIImage(profilePicture: gameController.gameBoard.player1Profile.profilePicture)
        player2AvatarView.image = ImageAssetFactory.getProfilePictureUIImage(profilePicture: gameController.gameBoard.player2Profile.profilePicture)
        player1NameLabel.text = gameController.gameBoard.player1Profile.userName
        player2NameLabel.text = gameController.gameBoard.player2Profile.userName

        player1ColorRing.layer.borderColor = marbleUIColor(for: gameController.gameBoard.player1Profile.marbleColour).cgColor
        player2ColorRing.layer.borderColor = marbleUIColor(for: gameController.gameBoard.player2Profile.marbleColour).cgColor

        // Turn / status
        playerTurnLabel.text = gameController.gameBoard.currentTurnPlayerProfile.userName + GameStateInfoStore.playerTurnTrailing.rawValue
        gameStatusLabel.text = GameStateInfoStore.placeMarbleInstruction.rawValue

        updateTurnHighlight()
    }

    // MARK: - Rotation Animations

    @objc func clockwiseRotationAnimation()
    {
        rotationPanel.isHidden = true
        unhighlightAllSubgridContainers()
        setAllSubgridsSelection(enabled: false)

        guard let cv = selectedSubgridCollectionView else { return }

        // Update game model and get the cumulative angle for this subgrid
        let subgrid = gameSubgrid(for: cv)
        gameController.rotateSubgrid(subgrid: subgrid, rotationDirection: .clockwise)
        let previousAngle = rotationMultiplier(for: cv)
        updateRotationMultiplier(for: cv, delta: .pi / 2)
        let finalAngle = rotationMultiplier(for: cv)

        gamePhase = .animationOccuring

        runRotationAnimation(cv: cv, previousAngle: previousAngle, finalAngle: finalAngle) {
            self.onSubgridRotate()

            if self.gamePhase != .gameOver {
                for cell in cv.visibleCells {
                    (cell as! GameBoardCollectionViewCell).updateGameBoardIndices(rotationDirection: .clockwise)
                }
                self.selectedSubgridCollectionView = nil
                self.handlePostRotationState()
            }
        }
    }

    @objc func anticlockwiseRotationAnimation()
    {
        rotationPanel.isHidden = true
        unhighlightAllSubgridContainers()
        setAllSubgridsSelection(enabled: false)

        guard let cv = selectedSubgridCollectionView else { return }

        let subgrid = gameSubgrid(for: cv)
        gameController.rotateSubgrid(subgrid: subgrid, rotationDirection: .anticlockwise)
        let previousAngle = rotationMultiplier(for: cv)
        updateRotationMultiplier(for: cv, delta: -.pi / 2)
        let finalAngle = rotationMultiplier(for: cv)

        gamePhase = .animationOccuring

        runRotationAnimation(cv: cv, previousAngle: previousAngle, finalAngle: finalAngle) {
            self.onSubgridRotate()

            if self.gamePhase != .gameOver {
                for cell in cv.visibleCells {
                    (cell as! GameBoardCollectionViewCell).updateGameBoardIndices(rotationDirection: .anticlockwise)
                }
                self.selectedSubgridCollectionView = nil
                self.handlePostRotationState()
            }
        }
    }

    // Shrink → rotate → grow: avoids cells clipping the container during rotation.
    // previousAngle preserves the cumulative rotation during the shrink phase so the
    // rotate phase only sweeps the delta (90°), not the full cumulative angle.
    private func runRotationAnimation(cv: UICollectionView, previousAngle: CGFloat, finalAngle: CGFloat, completion: @escaping () -> Void)
    {
        let shrinkDuration = 0.12
        let rotateDuration = Duration.gridRotationDuration.rawValue - 0.24
        let growDuration = 0.12

        UIView.animate(withDuration: shrinkDuration, delay: 0, options: .curveEaseIn) {
            cv.transform = CGAffineTransform(rotationAngle: previousAngle).scaledBy(x: 0.72, y: 0.72)
        } completion: { _ in
            UIView.animate(withDuration: rotateDuration, delay: 0, options: .curveEaseInOut) {
                cv.transform = CGAffineTransform(rotationAngle: finalAngle).scaledBy(x: 0.72, y: 0.72)
            } completion: { _ in
                UIView.animate(withDuration: growDuration, delay: 0, options: .curveEaseOut) {
                    cv.transform = CGAffineTransform(rotationAngle: finalAngle)
                } completion: { _ in
                    completion()
                }
            }
        }
    }

    // MARK: - AI Turn

    func handleAITurn()
    {
        do
        {
            let aiMoveInfo = try gameController.aiPlaceMarble()

            guard let rowIndex = aiMoveInfo.rowIndex, let columnIndex = aiMoveInfo.columnIndex else { return }

            // Update the cell image for the AI's marble
            let targetCV = collectionViewForPosition(row: rowIndex, column: columnIndex)
            for cell in targetCV.visibleCells {
                let castedCell = cell as! GameBoardCollectionViewCell
                if castedCell.gameBoardRowIndex == rowIndex && castedCell.gameBoardColumnIndex == columnIndex {
                    castedCell.cellImageView.image = ImageAssetFactory.getGameBoardCellUIImage(
                        cellType: castedCell.initialCellType,
                        colour: gameController.gameBoard.currentTurnPlayerProfile.marbleColour)
                }
            }

            onMarblePlace(rowIndex: rowIndex, columnIndex: columnIndex)

            // aiRotateSubgrid updates the game board and returns the chosen subgrid/direction
            let aiRotateInfo = gameController.aiRotateSubgrid()
            let aiSubgrid = aiRotateInfo.subgrid
            let aiDirection = aiRotateInfo.rotationDirection

            let cv = collectionView(for: aiSubgrid)
            let previousAngle = rotationMultiplier(for: cv)
            updateRotationMultiplier(for: cv, delta: aiDirection == .clockwise ? .pi / 2 : -.pi / 2)
            let finalAngle = rotationMultiplier(for: cv)

            DispatchQueue.main.asyncAfter(deadline: .now() + Duration.rotateSubgridWait.rawValue) {
                self.gamePhase = .animationOccuring

                self.runRotationAnimation(cv: cv, previousAngle: previousAngle, finalAngle: finalAngle) {
                    self.onSubgridRotate()

                    if self.gamePhase != .gameOver {
                        self.gamePhase = .placeMarble
                        self.setAllSubgridsSelection(enabled: true)
                        self.gameStatusLabel.text = GameStateInfoStore.placeMarbleInstruction.rawValue
                        self.playerTurnLabel.text = self.gameController.gameBoard.currentTurnPlayerProfile.userName + GameStateInfoStore.playerTurnTrailing.rawValue
                        self.updateTurnHighlight()

                        for cell in cv.visibleCells {
                            (cell as! GameBoardCollectionViewCell).updateGameBoardIndices(rotationDirection: aiDirection)
                        }
                    }
                }
            }
        }
        catch let GeneralException.IllegalArgument(message)
        {
            fatalError(message)
        }
        catch let GameBoardException.CellOccupied(message)
        {
            fatalError(message)
        }
        catch let GameBoardException.GameGridFull(message)
        {
            fatalError(message)
        }
        catch
        {
            fatalError("An unaccounted for error was thrown by the placeMarble function")
        }
    }

    // MARK: - Game Events

    func onSubgridRotate()
    {
        let winner: PlayerProfile? = gameController.checkWinConditionPostRotation()

        if winner != nil {
            handleGameOverState(winner: winner)

            let achievements = winner!.updateWins()
            if !achievements.isEmpty { onAchievementEarned(playerProfile: winner!, achievementsEarned: achievements) }

            if winner === gameController.gameBoard.player1Profile {
                let achievements = gameController.gameBoard.player2Profile.updateLosses()
                if !achievements.isEmpty && !gameController.gameBoard.isAgainstAiOpponent {
                    onAchievementEarned(playerProfile: gameController.gameBoard.player2Profile, achievementsEarned: achievements)
                }
            } else if winner === gameController.gameBoard.player2Profile {
                let achievements = gameController.gameBoard.player1Profile.updateLosses()
                if !achievements.isEmpty { onAchievementEarned(playerProfile: gameController.gameBoard.player1Profile, achievementsEarned: achievements) }
            }
        } else {
            if gameController.didDrawHappen() { onDraw() }
        }

        // Track moves — pass the player who JUST finished (turns already switched inside rotateSubgrid)
        if gameController.gameBoard.currentTurnPlayerProfile === gameController.gameBoard.player1Profile {
            onPlayerMove(playerProfile: gameController.gameBoard.player2Profile)
        } else {
            onPlayerMove(playerProfile: gameController.gameBoard.player1Profile)
        }

        displaySnackbars()
    }

    func onMarblePlace(rowIndex: Int, columnIndex: Int)
    {
        let winner: PlayerProfile? = gameController.checkWinCondition(rowIndex: rowIndex, columnIndex: columnIndex)

        if winner != nil {
            handleGameOverState(winner: winner)

            let achievements = winner!.updateWins()
            if !achievements.isEmpty { onAchievementEarned(playerProfile: winner!, achievementsEarned: achievements) }

            if winner === gameController.gameBoard.player1Profile {
                let achievements = gameController.gameBoard.player2Profile.updateLosses()
                if !achievements.isEmpty && !gameController.gameBoard.isAgainstAiOpponent {
                    onAchievementEarned(playerProfile: gameController.gameBoard.player2Profile, achievementsEarned: achievements)
                }
                onPlayerMove(playerProfile: gameController.gameBoard.player1Profile)
            } else if winner === gameController.gameBoard.player2Profile {
                let achievements = gameController.gameBoard.player1Profile.updateLosses()
                if !achievements.isEmpty { onAchievementEarned(playerProfile: gameController.gameBoard.player1Profile, achievementsEarned: achievements) }
                onPlayerMove(playerProfile: gameController.gameBoard.player2Profile)
            }
        } else {
            if gameController.didDrawHappen() { onDraw() }
        }

        displaySnackbars()
    }

    func onDraw()
    {
        handleGameOverState(winner: nil)

        let p1Achievements = gameController.gameBoard.player1Profile.updateDraws()
        let p2Achievements = gameController.gameBoard.player2Profile.updateDraws()

        if !p1Achievements.isEmpty { onAchievementEarned(playerProfile: gameController.gameBoard.player1Profile, achievementsEarned: p1Achievements) }
        if !p2Achievements.isEmpty && !gameController.gameBoard.isAgainstAiOpponent {
            onAchievementEarned(playerProfile: gameController.gameBoard.player2Profile, achievementsEarned: p2Achievements)
        }
    }

    func onAchievementEarned(playerProfile: PlayerProfile, achievementsEarned: [Achievement])
    {
        for achievement in achievementsEarned {
            if !achievement.hasBeenDisplayed {
                let message = playerProfile.userName + " earned " + achievement.achievementTitle
                let viewModel = SnackbarViewModel(type: .info, text: message, image: .init(systemName: "trophy.circle.fill"))
                let snackbar = SnackbarView(
                    viewModel: viewModel,
                    frame: snackbarFrame,
                    verticalTranslation: snackbarVerticalTranslation,
                    backgroundColour: .systemGreen,
                    imageColour: .yellow,
                    duration: Duration.snackbarDuration.rawValue)
                snackbarQueue.append(snackbar)
                achievement.hasBeenDisplayed = true
            }
        }
    }

    func onPlayerMove(playerProfile: PlayerProfile)
    {
        let achievements = playerProfile.updateTotalMovesMade()
        if !achievements.isEmpty {
            if !(gameController.gameBoard.isAgainstAiOpponent && playerProfile === gameController.gameBoard.player2Profile) {
                onAchievementEarned(playerProfile: playerProfile, achievementsEarned: achievements)
            }
        }
    }

    func displaySnackbars()
    {
        guard !snackbarQueue.isEmpty else { return }
        var offset: Double = 0
        let copy = snackbarQueue
        for snackbar in copy {
            DispatchQueue.main.asyncAfter(deadline: .now() + offset) {
                snackbar.showSnackbar(view: self.view.window!)
                self.snackbarQueue.removeAll(where: { $0 === snackbar })
            }
            offset += Duration.snackbarDuration.rawValue
        }
    }

    // MARK: - Enums

    enum GamePhase
    {
        case placeMarble
        case rotateSubgid
        case animationOccuring
        case aiTurn
        case gameOver
    }

    enum Duration: Double
    {
        case gridRotationDuration = 1.5
        case placeMarbleWait = 0.75
        case rotateSubgridWait = 1
        case snackbarDuration = 2.5
    }

    // MARK: - Private Helpers

    private func handleGameOverState(winner: PlayerProfile?)
    {
        setAllSubgridsUserInteraction(enabled: false)
        rotationPanel.isHidden = true
        gamePhase = .gameOver
        gameStatusLabel.text = GameStateInfoStore.gameOver.rawValue

        if let winner = winner {
            playerTurnLabel.text = winner.userName + GameStateInfoStore.playerWinTrailing.rawValue
            let isP1Winner = winner === gameController.gameBoard.player1Profile
            UIView.animate(withDuration: 0.5) {
                self.player1Card.backgroundColor = isP1Winner ? UIColor.systemYellow.withAlphaComponent(0.3) : UIColor.white.withAlphaComponent(0.05)
                self.player1Card.layer.borderColor = isP1Winner ? UIColor.systemYellow.cgColor : UIColor.white.withAlphaComponent(0.1).cgColor
                self.player2Card.backgroundColor = !isP1Winner ? UIColor.systemYellow.withAlphaComponent(0.3) : UIColor.white.withAlphaComponent(0.05)
                self.player2Card.layer.borderColor = !isP1Winner ? UIColor.systemYellow.cgColor : UIColor.white.withAlphaComponent(0.1).cgColor
            }
        } else {
            playerTurnLabel.text = GameStateInfoStore.draw.rawValue
        }
    }

    private func handlePostRotationState()
    {
        if gameController.gameBoard.isAgainstAiOpponent {
            gamePhase = .aiTurn
            gameStatusLabel.text = GameStateInfoStore.aiMoveIndicator.rawValue
            playerTurnLabel.text = gameController.gameBoard.currentTurnPlayerProfile.userName + GameStateInfoStore.playerTurnTrailing.rawValue
            DispatchQueue.main.asyncAfter(deadline: .now() + Duration.placeMarbleWait.rawValue) {
                self.handleAITurn()
            }
        } else {
            gamePhase = .placeMarble
            setAllSubgridsSelection(enabled: true)
            gameStatusLabel.text = GameStateInfoStore.placeMarbleInstruction.rawValue
            playerTurnLabel.text = gameController.gameBoard.currentTurnPlayerProfile.userName + GameStateInfoStore.playerTurnTrailing.rawValue
            updateTurnHighlight()
        }
    }

    private func updateTurnHighlight()
    {
        let isP1Turn = gameController.gameBoard.currentTurnPlayerProfile === gameController.gameBoard.player1Profile
        UIView.animate(withDuration: 0.3) {
            self.player1Card.backgroundColor = isP1Turn ? UIColor.white.withAlphaComponent(0.2) : UIColor.white.withAlphaComponent(0.07)
            self.player1Card.layer.borderColor = isP1Turn ? UIColor.systemYellow.withAlphaComponent(0.8).cgColor : UIColor.white.withAlphaComponent(0.15).cgColor
            self.player1Card.layer.borderWidth = isP1Turn ? 2 : 1

            self.player2Card.backgroundColor = !isP1Turn ? UIColor.white.withAlphaComponent(0.2) : UIColor.white.withAlphaComponent(0.07)
            self.player2Card.layer.borderColor = !isP1Turn ? UIColor.systemYellow.withAlphaComponent(0.8).cgColor : UIColor.white.withAlphaComponent(0.15).cgColor
            self.player2Card.layer.borderWidth = !isP1Turn ? 2 : 1
        }
    }

    private func unhighlightAllSubgridContainers()
    {
        for container in [upperLeftContainer, upperRightContainer, lowerLeftContainer, lowerRightContainer] {
            container.layer.borderWidth = 1
            container.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        }
    }

    private func setAllSubgridsSelection(enabled: Bool)
    {
        for cv in [upperLeftSubgrid, upperRightSubgrid, lowerLeftSubgrid, lowerRightSubgrid] {
            cv.allowsSelection = enabled
        }
    }

    private func setAllSubgridsUserInteraction(enabled: Bool)
    {
        for cv in [upperLeftSubgrid, upperRightSubgrid, lowerLeftSubgrid, lowerRightSubgrid] {
            cv.isUserInteractionEnabled = enabled
        }
    }

    private func gameSubgrid(for cv: UICollectionView) -> GameBoard.Subgrid
    {
        if cv === upperLeftSubgrid { return .upperLeft }
        if cv === upperRightSubgrid { return .upperRight }
        if cv === lowerLeftSubgrid { return .lowerLeft }
        return .lowerRight
    }

    private func collectionView(for subgrid: GameBoard.Subgrid) -> UICollectionView
    {
        switch subgrid {
        case .upperLeft: return upperLeftSubgrid
        case .upperRight: return upperRightSubgrid
        case .lowerLeft: return lowerLeftSubgrid
        default: return lowerRightSubgrid
        }
    }

    private func collectionViewForPosition(row: Int, column: Int) -> UICollectionView
    {
        if row <= 2 && column <= 2 { return upperLeftSubgrid }
        if row <= 2 { return upperRightSubgrid }
        if column <= 2 { return lowerLeftSubgrid }
        return lowerRightSubgrid
    }

    private func rotationMultiplier(for cv: UICollectionView) -> CGFloat
    {
        if cv === upperLeftSubgrid { return upperLeftSubgridRotationMultiplier }
        if cv === upperRightSubgrid { return upperRightSubgridRotationMultiplier }
        if cv === lowerLeftSubgrid { return lowerLeftSubgridRotationMultiplier }
        return lowerRightSubgridRotationMultiplier
    }

    private func updateRotationMultiplier(for cv: UICollectionView, delta: CGFloat)
    {
        if cv === upperLeftSubgrid { upperLeftSubgridRotationMultiplier += delta }
        else if cv === upperRightSubgrid { upperRightSubgridRotationMultiplier += delta }
        else if cv === lowerLeftSubgrid { lowerLeftSubgridRotationMultiplier += delta }
        else { lowerRightSubgridRotationMultiplier += delta }
    }

    private func marbleUIColor(for colour: Marble.MarbleColour) -> UIColor
    {
        switch colour {
        case .black: return .white
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

    private func applyGlassStyle(to view: UIView, cornerRadius: CGFloat)
    {
        view.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        view.layer.cornerRadius = cornerRadius
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.white.withAlphaComponent(0.2).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
    }

    private func styleRotationButton(_ button: UIButton, symbolName: String, label: String)
    {
        button.backgroundColor = UIColor.white.withAlphaComponent(0.15)
        button.layer.cornerRadius = 14
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        button.translatesAutoresizingMaskIntoConstraints = false

        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 17, weight: .semibold)
        button.setImage(UIImage(systemName: symbolName, withConfiguration: symbolConfig), for: .normal)
        button.setTitle("  \(label)", for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        button.semanticContentAttribute = .forceLeftToRight
    }
}

// MARK: - UICollectionViewDelegate

extension GameBoardViewController: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool
    {
        return !(gamePhase == .animationOccuring || gamePhase == .aiTurn)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt index: IndexPath)
    {
        let cell = collectionView.cellForItem(at: index) as! GameBoardCollectionViewCell

        if gamePhase == .placeMarble {
            do {
                try gameController.placeMarble(rowIndex: cell.gameBoardRowIndex, columnIndex: cell.gameBoardColumnIndex)
                cell.cellImageView.image = ImageAssetFactory.getGameBoardCellUIImage(
                    cellType: cell.initialCellType,
                    colour: gameController.gameBoard.currentTurnPlayerProfile.marbleColour)
                onMarblePlace(rowIndex: cell.gameBoardRowIndex, columnIndex: cell.gameBoardColumnIndex)

                if gamePhase != .gameOver {
                    gamePhase = .rotateSubgid
                    gameStatusLabel.text = GameStateInfoStore.subgridSelectInstruction.rawValue
                }
            }
            catch let GeneralException.IllegalArgument(message) { fatalError(message) }
            catch GameBoardException.CellOccupied {
                let message = "This Cell already has a Marble in it!"
                let viewModel = SnackbarViewModel(type: .info, text: message, image: .init(systemName: "exclamationmark.circle.fill"))
                let snackbar = SnackbarView(viewModel: viewModel, frame: snackbarFrame, verticalTranslation: snackbarVerticalTranslation, backgroundColour: .systemGray2, imageColour: .systemPurple, duration: Duration.snackbarDuration.rawValue)
                snackbar.showSnackbar(view: view.window!)
            }
            catch GameBoardException.GameGridFull {
                let message = "The Gameboard is Full!"
                let viewModel = SnackbarViewModel(type: .info, text: message, image: .init(systemName: "exclamationmark.circle.fill"))
                let snackbar = SnackbarView(viewModel: viewModel, frame: snackbarFrame, verticalTranslation: snackbarVerticalTranslation, backgroundColour: .systemGray2, imageColour: .systemPurple, duration: Duration.snackbarDuration.rawValue)
                snackbar.showSnackbar(view: view.window!)
            }
            catch { fatalError("An unaccounted for error was thrown by the placeMarble function") }

        } else if gamePhase == .rotateSubgid {
            // Unhighlight any previously highlighted container
            unhighlightAllSubgridContainers()

            // Highlight the selected subgrid's container
            if let container = subgridContainerMap[collectionView] {
                container.layer.borderWidth = 3
                container.layer.borderColor = UIColor.systemYellow.cgColor
            }

            selectedSubgridCollectionView = collectionView
            rotationPanel.isHidden = false
            gameStatusLabel.text = GameStateInfoStore.rotationInstruction.rawValue
        }
    }
}

// MARK: - UICollectionViewDataSource

extension GameBoardViewController: UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 9
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameBoardCollectionViewCell", for: indexPath) as! GameBoardCollectionViewCell

        var rowIndex = 0
        var columnIndex = 0

        switch indexPath.item {
        case 0: cell.initialCellType = .topLeftCell;      cell.currentCellType = .topLeftCell;      rowIndex = 0; columnIndex = 0
        case 1: cell.initialCellType = .topMiddleCell;    cell.currentCellType = .topMiddleCell;    rowIndex = 0; columnIndex = 1
        case 2: cell.initialCellType = .topRightCell;     cell.currentCellType = .topRightCell;     rowIndex = 0; columnIndex = 2
        case 3: cell.initialCellType = .middleLeftCell;   cell.currentCellType = .middleLeftCell;   rowIndex = 1; columnIndex = 0
        case 4: cell.initialCellType = .middleMiddleCell; cell.currentCellType = .middleMiddleCell; rowIndex = 1; columnIndex = 1
        case 5: cell.initialCellType = .middleRightCell;  cell.currentCellType = .middleRightCell;  rowIndex = 1; columnIndex = 2
        case 6: cell.initialCellType = .bottomLeftCell;   cell.currentCellType = .bottomLeftCell;   rowIndex = 2; columnIndex = 0
        case 7: cell.initialCellType = .bottomMiddleCell; cell.currentCellType = .bottomMiddleCell; rowIndex = 2; columnIndex = 1
        case 8: cell.initialCellType = .bottomRightCell;  cell.currentCellType = .bottomRightCell;  rowIndex = 2; columnIndex = 2
        default: fatalError("There should only be 9 items in each subgrid collection view")
        }

        var rowOffset = 0
        var colOffset = 0

        if collectionView === upperLeftSubgrid  { rowOffset = 0; colOffset = 0 }
        else if collectionView === upperRightSubgrid { rowOffset = 0; colOffset = 3 }
        else if collectionView === lowerLeftSubgrid  { rowOffset = 3; colOffset = 0 }
        else if collectionView === lowerRightSubgrid { rowOffset = 3; colOffset = 3 }

        cell.gameBoardRowIndex = rowIndex + rowOffset
        cell.gameBoardColumnIndex = columnIndex + colOffset

        cell.cellImageView.image = ImageAssetFactory.getGameBoardCellUIImage(cellType: cell.initialCellType, colour: nil)

        guard cell.cellImageView.image != nil else {
            fatalError("Could not get a cell image for cell at row \(cell.gameBoardRowIndex!), col \(cell.gameBoardColumnIndex!)")
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension GameBoardViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let side = floor(collectionView.bounds.width / 3)
        return CGSize(width: side, height: side)
    }
}
