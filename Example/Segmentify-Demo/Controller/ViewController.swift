//
//  ViewController.swift
//  Segmentify-Demo
//
//  Created by Mehmet Koca on 30.01.2018.
//  Copyright © 2018 mehmetkoca. All rights reserved.
//

import UIKit
import Segmentify

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let categoryObj = PageModel()
        categoryObj.category = "Category Page"
        categoryObj.subCategory = "Womanswear"
        
        SegmentifyManager.sharedManager().sendPageView(segmentifyObject: categoryObj) { (response: [RecommendationModel]) in
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
