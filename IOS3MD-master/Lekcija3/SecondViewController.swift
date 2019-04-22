//
//  SecondViewController.swift
//  Lekcija3
//
//  Created by Students on 13/03/2019.
//  Copyright © 2019 students. All rights reserved.
//

import UIKit
protocol secondControllerDelagate {
    func distance10kfilter (distance: Bool)
    func descriptionFilter (description: Bool)
}

class SecondViewController: UIViewController {

    @IBOutlet weak var ml: UILabel!
    @IBOutlet weak var HideDescription: UISwitch!
    @IBOutlet weak var distanceFilter: UISwitch!
    
    var mansTextsNoMainVC = "Nav teksta"
    var delegate: secondControllerDelagate?
    override func viewDidLoad() {
        distanceFilter.isOn =  UserDefaults.standard.bool(forKey: "switchState")
        HideDescription.isOn =  UserDefaults.standard.bool(forKey: "switchState2")
    }
    @IBAction func distancefilter(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "switchState")
        var is10k: Bool
        if distanceFilter.isOn{
            is10k = true
        }else {
            is10k = false
        }
        if delegate != nil{
            delegate?.distance10kfilter(distance: is10k)
        }
    }
    
    @IBAction func noDesFilter(_ sender: UISwitch) {
        UserDefaults.standard.set(sender.isOn, forKey: "switchState2")
        var donthaveDescription: Bool
        if HideDescription.isOn{
            donthaveDescription = true
        }else{
            donthaveDescription = false
        }
        if delegate != nil{
            delegate?.descriptionFilter(description: donthaveDescription)
        }
    }
}
