//
//  ViewController.swift
//  MovieDBHomeWork
//
//  Created by M A Hossan on 14/02/2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var userName: UITextField!
    
    var nameText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userName.text = nil
    }
    @IBAction func Save(_ sender: Any) {
        
        self.nameText  = userName.text!
        performSegue(withIdentifier: "show", sender: self)

    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        let nav = segue.destination as! UINavigationController
        let vc = nav.topViewController as! MovieViewController
       // var vc  = segue.destination as! MovieViewController
        vc.finalname = self.nameText
             
    }
}

