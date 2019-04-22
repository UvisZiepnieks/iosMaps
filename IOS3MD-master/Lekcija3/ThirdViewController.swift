//
//  ThirdViewController.swift
//  Lekcija3
//
//  Created by Students on 13/03/2019.
//  Copyright © 2019 students. All rights reserved.
//

import UIKit
protocol ThirdViewControllerDelegate {
    func ArrayUpdated(newArray: [[String]])
}
class ThirdViewController: UIViewController {
    var delegate: ThirdViewControllerDelegate?
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var textLat: UITextField!
    @IBOutlet weak var textLong: UITextField!
    var array = [[String]]()
    let sumtingwong = "Sumting went wrong"
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    @IBAction func buttonSave(_ sender: UIButton) {
        array.append([textLat.text ?? "",textLong.text ?? ""])
        delegate?.ArrayUpdated(newArray: array)
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        print("Segue")
//        if segue.identifier == "toViewAdd" {
//
//            if let first = segue.destination as? ViewController {
//                first.sumtingwong = array
//            }
//        }
//    }
    
}
