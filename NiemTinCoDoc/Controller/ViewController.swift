//
//  ViewController.swift
//  NiemTinCoDoc
//
//  Created by Nguyen Hieu Trung on 4/9/18.
//  Copyright © 2018 NHTSOFT. All rights reserved.
//

import UIKit
import SQLite
import UserNotifications
import FBSDKShareKit

class ViewController: UIViewController {

    @IBOutlet weak var lblNiemTin: UILabel!
  
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var btnInfo: UIButton!
    @IBOutlet weak var lblCoDocNhan: UILabel!
    @IBOutlet weak var btnFacebook: UIButton!
    @IBOutlet weak var btnStartReadStory: CustomButton!
    
    var isShow:Bool!
    var readCenter:CGPoint!
    var infoCenter:CGPoint!
    var faceCenter:CGPoint!
    var menuCenter:CGPoint!
    
    var urlMyApp = "https://itunes.apple.com/app/id1377746810"
    
    
    override var prefersStatusBarHidden: Bool{
        return true;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("btnMenu Center: \(btnMenu.center)")
        //User Notification
        let delegate = UIApplication.shared.delegate as? AppDelegate;
        delegate?.ScheduleNotification();
        ////////////////////////////////////////////////////////////////////////
        
        let fontNiemTin = UIFont(name: "UVNDoiMoi", size: 63);
        lblNiemTin.attributedText = NSAttributedString(string: "NIỀM TIN", attributes: self.stroke(font: fontNiemTin!, strokeWidth: 4, insideColor: UIColor.white, strokeColor: UIColor.black));
        
        let fontCoDocNhan = UIFont(name: "UVNDoiMoi", size: 40);
        lblCoDocNhan.attributedText = NSAttributedString(string: "CƠ ĐỐC NHÂN", attributes: self.stroke(font: fontCoDocNhan!, strokeWidth: 4, insideColor: UIColor.white, strokeColor: UIColor.black));
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        self.isShow = false;
        
        readCenter = btnStartReadStory.center;
        infoCenter = btnInfo.center;
        faceCenter = btnFacebook.center;
        menuCenter = btnMenu.center;

        btnStartReadStory.center = btnMenu.center;
        btnInfo.center = btnMenu.center;
        btnFacebook.center = btnMenu.center;

        self.btnStartReadStory.alpha = 0;
        self.btnInfo.alpha = 0;
        self.btnFacebook.alpha = 0;

        print(btnMenu.center);
    }
    
    
    @IBAction func PressButtonMenu(_ sender: UIButton) {
        if self.isShow == false{
            self.isShow = true;
            //sender.setImage(#imageLiteral(resourceName: "MenuIcon_Collapse"), for: .normal);
            btnMenu.setImage(#imageLiteral(resourceName: "MenuIcon_Collapse"), for: .normal);
            UIView.animate(withDuration: 0.5, animations: {
                 self.view.layoutIfNeeded();
                
                self.btnStartReadStory.center = self.readCenter;
                self.btnInfo.center = self.infoCenter;
                self.btnFacebook.center = self.faceCenter;

                self.btnStartReadStory.alpha = 1;
                self.btnInfo.alpha = 1;
                self.btnFacebook.alpha = 1;
            })
        }else{
            self.isShow = false;
            
            self.collapseButton()
        }
    }
    
    func collapseButton(){
        self.isShow = false;
        self.btnMenu.setImage(#imageLiteral(resourceName: "MenuIcon_Expand"), for: .normal);
        UIView.animate(withDuration: 0.5, animations: {
            self.view.layoutIfNeeded();
            self.btnStartReadStory.center = self.menuCenter
            self.btnInfo.center = self.menuCenter
            self.btnFacebook.center = self.menuCenter
            
            self.btnStartReadStory.alpha = 0;
            self.btnInfo.alpha = 0;
            self.btnFacebook.alpha = 0;
        })
    }
    
    public func stroke(font: UIFont, strokeWidth: Float, insideColor: UIColor, strokeColor: UIColor) -> [NSAttributedStringKey: Any]{
        return [
            NSAttributedStringKey.strokeColor : strokeColor,
            NSAttributedStringKey.foregroundColor : insideColor,
            NSAttributedStringKey.strokeWidth : -strokeWidth,
            NSAttributedStringKey.font : font
        ]
    }

    @IBAction func PressReadStory(_ sender: UIButton) {
        self.performSegue(withIdentifier: "SegueShowListStory", sender: nil);
        collapseButton();
        
    }
    
    @IBAction func PressInfoButton(_ sender: UIButton) {
        collapseButton();
        self.performSegue(withIdentifier: "SegueShowPopInfo", sender: nil);
    }
    
    @IBAction func PressShareFaceBook(_ sender: UIButton) {
        let myContent = FBSDKShareLinkContent();
        myContent.contentURL = URL(string: self.urlMyApp);
        let shareDialog = FBSDKShareDialog();
        shareDialog.fromViewController = self;
        shareDialog.mode = .native;
        shareDialog.shareContent = myContent;
        shareDialog.show();
    }
    

}

