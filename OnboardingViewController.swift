//
//  onboardingViewController.swift
//  LoginASL
//
//  Created by Arnav Reddy on 3/14/20.
//  Copyright © 2020 Arnav Reddy2. All rights reserved.
//

import Foundation
import UIKit
import paper_onboarding

@IBDesignable
class OnboardingViewController: UIViewController, PaperOnboardingDelegate, PaperOnboardingDataSource {
    var currIndex = 0
    var username: String?
    
    @IBOutlet weak var getStartedButton: UIBarButtonItem!
    func onboardingItemsCount() -> Int {
        return 3
    }
    
    func onboardingItem( at index: Int) -> OnboardingItemInfo {
        
        let bgColorOne = UIColor(red: 80/255, green: 170/255, blue: 194/255, alpha: 1)
        let bgColorTwo = UIColor(red: 106/255, green: 166/255, blue: 211/255, alpha: 1)
        let bgColorThree = UIColor(red: 68/255, green: 122/255, blue: 201/255, alpha: 1)
        
        let titleFont = UIFont(name: "AvenirNext-Bold", size: 24)!
        let descriptionFont = UIFont(name: "AvenirNext-Regular", size: 18)!
    
        
        return [OnboardingItemInfo(informationImage: UIImage(named: "rocket")!,
        title: "What is EducatAR?",
        description: "EducatAR is an IOS app that is aimed towards revolutionizing the way " + "that children are taught all around the world. All the users need is an iPhone and they can enjoy the completely new features that are introduced in this app. These features include interactivity and inclusivity for all students and teachers. Education will never be the same!",
        pageIcon: UIImage()//UIImage(named: "blank")!,
        ,color: bgColorOne,
        titleColor: UIColor.white,
        descriptionColor: UIColor.white,
        titleFont: titleFont,
        descriptionFont: descriptionFont),
        
        OnboardingItemInfo(informationImage: UIImage(named: "notification")!,
        title: "3d Draw/Video",
        description: "There are apps on the App Store that allow users to draw on their screen and the drawing appears in 3d space however this is very limited and can not be used in a classroom as the only user is the one who holds the iphone. With our app you can draw in mid air and see the 3d Drawing on your screen like in a sci-fi movie. Users can also scan an image in a textbook and an interactive video will replace it similar to the newspapers in Harry Potter.",
        pageIcon: UIImage(),
        color: bgColorTwo,
        titleColor: UIColor.white,
        descriptionColor: UIColor.white,
        titleFont: titleFont,
        descriptionFont: descriptionFont),
        
        OnboardingItemInfo(informationImage: UIImage(named: "brush")!,
        title: "Universal Translator",
        description: "EducatAR understands that there are many students who simply don't speak English as their first language and are hindered by the language barrier and therefore can not learn. For this reason users of EducatAR can scan text using their camera and the program will automatically translate the text to the language of their choice and the app will speak it back to the user.",
        pageIcon: UIImage(),
        color: bgColorThree,
        titleColor: UIColor.white,
        descriptionColor: UIColor.white,
        titleFont: titleFont,
        descriptionFont: descriptionFont)][index]
    }
    
    
    func onboardingConfigurationItem( item: OnboardingContentViewItem, index: Int) {
        
    }
    func onboardingWillTransitonToIndex(index: Int) {
        print("1")
        
    }
    
    func onboardingDidTransitonToIndex(index: Int) {
       }
    
    @IBOutlet weak var onboardingView: OnboardingView!
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .overFullScreen
        onboardingView.delegate = self
        onboardingView.dataSource = self
        
        }
    }
