//
//  EditProfileViewController.swift
//  Pentago
//
//  Created by Tyrique Zimbizi on 2/1/2026.
//

import UIKit

class EditProfileViewController: UIViewController
{
    @IBOutlet var profilePictureImageView: UIImageView!
    @IBOutlet var marbleColourImageView: UIImageView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var colourLabel: UILabel!
    @IBOutlet var profileEditTableView: UITableView!
    
    var sourceProfile: PlayerProfile!
}
