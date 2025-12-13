//
//  ViewController.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 6/12/2025.
//
import UIKit

class MainMenuViewController: UIViewController
{
    @IBOutlet var playButton: UIButton!
    @IBOutlet var profileSettingsButton: UIButton!
    @IBOutlet var gameplayStatisticsButton: UIButton!
    @IBOutlet var achievementsButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //Fixing bug where the button fonts set in Interface Builder weren't applying to the running program
        let interfaceBuilderFont = UIFont(name: "Futura Bold", size: 19)
        
        playButton.configuration?.attributedTitle?[AttributeScopes.UIKitAttributes.FontAttribute.self] = interfaceBuilderFont
        profileSettingsButton.configuration?.attributedTitle?[AttributeScopes.UIKitAttributes.FontAttribute.self] = interfaceBuilderFont
        gameplayStatisticsButton.configuration?.attributedTitle?[AttributeScopes.UIKitAttributes.FontAttribute.self] = interfaceBuilderFont
        achievementsButton.configuration?.attributedTitle?[AttributeScopes.UIKitAttributes.FontAttribute.self] = interfaceBuilderFont
    }
}

