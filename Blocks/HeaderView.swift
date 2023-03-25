//
//  HeaderView.swift
//  Blocks
//
//  Created by Volodymyr Shyrochuk on 11.11.2022.
//  Copyright © 2022 QuasarClaster. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate: AnyObject {
    func didTapRestart()
}

class HeaderView: UIView {
    
    // MARK: - Constants
    
    private static let buttonStates: [UIControl.State] = [.normal, .highlighted]
    private static let restartText = Localization.General.restart.localized
    private static let buttonHeight: CGFloat = 44.0
    private static let stackViewSpacing: CGFloat = 2.0
    
    weak var delegate: HeaderViewDelegate?
    
    private lazy var restartButton: UIButton = {
        return createButton(title: Self.restartText, action: #selector(didTapRestart))
    }()
    
    private func createButton(title: String, action: Selector) -> UIButton {
        let button = UIButton()
        button.applyStyle(.actionButton)
        button.addTarget(self, action: action, for: .touchUpInside)
        Self.buttonStates.forEach({button.setTitle(title, for: $0)})
        return button
    }

    private lazy var scoreLabel: UILabel = {
        return createLabel()
    }()

    private lazy var bestLabel: UILabel = {
        return createLabel()
    }()
    
    private func createLabel() -> UILabel {
        let label = UILabel()
        label.applyStyle(.scoreLabel)
        label.numberOfLines = .zero
        return label
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        let bottomStackView = UIStackView(arrangedSubviews: [scoreLabel, bestLabel])
        bottomStackView.axis = .horizontal
        bottomStackView.spacing = Self.stackViewSpacing
        createAndAddContainer(restartButton: restartButton, bottomStackView: bottomStackView)
        
        [restartButton].forEach { button in
            button.heightAnchor.constraint(equalToConstant: Self.buttonHeight).isActive = true
        }
        
        [scoreLabel, bestLabel].forEach { label in
            label.heightAnchor.constraint(equalTo: restartButton.heightAnchor).isActive = true
        }
    }
    
    private func createAndAddContainer(restartButton: UIButton, bottomStackView: UIStackView) {
        let container = UIStackView(arrangedSubviews: [restartButton, bottomStackView])
        container.axis = .vertical
        container.alignment = .fill
        container.distribution = .fillEqually
        container.spacing = Self.stackViewSpacing
        addSubview(container)
        
        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc private func didTapRestart() {
        delegate?.didTapRestart()
    }
    
    func update(score: GameScore) {
        scoreLabel.text = Localization.Score.score(score.current).localized
        bestLabel.text = Localization.Score.best(score.best).localized
    }
}
