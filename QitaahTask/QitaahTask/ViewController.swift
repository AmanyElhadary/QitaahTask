//
//  ViewController.swift
//  QitaahTask
//
//  Created by mac on 9/28/18.
//  Copyright © 2018 amany. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        LibraryApi.sharedInstance.PopularRequest(pagenum: 1,completion: {
            Responsesucses,NewsArray  in
            print(NewsArray)

        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }


}

