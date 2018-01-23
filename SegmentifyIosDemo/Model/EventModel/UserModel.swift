//
//  UserRegisterModel.swift
//  SegmentifyDeneme
//
//  Created by Ata Anıl Turgay on 23.01.2018.
//  Copyright © 2018 Ata Anıl Turgay. All rights reserved.
//

import Foundation

class UserModel : SegmentifyObject {
    var username:String?
    var email:String?
    var age:String?
    var birthdate:String?
    var gender:String?
    var fullName:String?
    var mobilePhone:String?
    var isRegistered:Bool?
    var isLogin:Bool?
    var userOperationStep:String?
    var memberSince:String?
    var oldUserId:String?
    var location:String?
    var segments:[String]?
    var step:String?
}
