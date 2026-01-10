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
    private let imageView: UIImageView
    private var handler: (() -> Void)?
    private let verticalTranslation: Double
    private let duration: Double
    
    init(viewModel: SnackbarViewModel, frame: CGRect, verticalTranslation: Double, backgroundColour: UIColor, duration: Double)
    {
        self.viewModel = viewModel
        
        self.label = UILabel()
        self.label.textColor = .label
        self.label.numberOfLines = 0
        self.label.textAlignment = .center
        
        self.imageView = UIImageView()
        self.imageView.clipsToBounds = true
        self.imageView.contentMode = .scaleAspectFit
        self.verticalTranslation = verticalTranslation
        self.duration = duration
        
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = true
        self.addSubview(self.label)
        
        if(self.viewModel.image != nil)
        {
            self.addSubview(self.imageView)
        }
        
        self.backgroundColor = backgroundColour
        self.clipsToBounds = true
        self.layer.cornerRadius = 30
        self.layer.masksToBounds = true
        
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
        if(self.viewModel.image != nil)
        {
            self.imageView.frame = CGRect(x: 0, y: 0, width: self.frame.height, height: self.frame.height)
            self.label.frame = CGRect(x: self.imageView.frame.width, y: 0, width: self.frame.width - self.imageView.frame.width, height: self.frame.height)
        }
        else
        {
            label.frame = self.bounds
        }
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
        
        //let originalFrame = self.frame
        let popAnimator: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut)
        {
            self.transform = CGAffineTransform(translationX: 0, y: -self.verticalTranslation)
            //self.frame = self.popUpFrame
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
