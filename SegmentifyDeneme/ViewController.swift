//
//  ViewController.swift
//  SegmentifyDeneme
//
//  Created by Ata Anıl Turgay on 7.12.2017.
//  Copyright © 2017 Ata Anıl Turgay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //SegmentifyAnalyticWrapper.shared.sendPageViewEvent()
        //SegmentifyAnalyticWrapper.shared.sendLoginEvent()
        //SegmentifyAnalyticWrapper.shared.sendLogoutEvent()
        //SegmentifyAnalyticWrapper.shared.sendPaymentSuccessEvent()
        //SegmentifyAnalyticWrapper.shared.sendViewBasketEvent()
        //SegmentifyAnalyticWrapper.shared.sendLoginEvent()
        //SegmentifyAnalyticWrapper.shared.sendPaymentSuccessEvent()
        //SegmentifyAnalyticWrapper.shared.sendPurchaseEvent()
        //SegmentifyAnalyticWrapper.shared.sendRegisterEvent()
        //SegmentifyAnalyticWrapper.shared.sendUserchangeEvent()
        //SegmentifyAnalyticWrapper.shared.sendUserUpdateEvent()
        SegmentifyAnalyticWrapper.shared.sendCustomevent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

