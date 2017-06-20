//
//  ViewController.swift
//  FbPhotosAlbumDownload
//
//  Created by Abderrahman Ajid on 6/16/17.
//  Copyright © 2017 Abderrahman Ajid. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var showAlbumButton: UIButton! {
        didSet {
            showAlbumButton.isHidden = true
        }
    }
    
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email", "user_photos"]
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(loginButton)
        loginButton.center = view.center
        loginButton.delegate = self
        if (FBSDKAccessToken.current()) != nil {
            showAlbumButton.isHidden = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AlbumDataService.instance.albums.removeAll()
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error != nil {
            print("Process error")
        } else if result!.isCancelled {
            print("Cancelled")
        } else {
            print("Process completed")
            self.showAlbumButton.isHidden = false
        }
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        showAlbumButton.isHidden = true
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
}
