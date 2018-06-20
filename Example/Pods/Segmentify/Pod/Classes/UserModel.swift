//
//  UserModel.swift
//  Segmentify
//
//  Created by Ata Anıl Turgay on 23.01.2018.
//  Copyright © 2018 segmentify. All rights reserved.
//

import Foundation

public class UserModel : SegmentifyObject {
    public override init() {}
    public var username:String?
    public var email:String?
    public var age:String?
    public var birthdate:String?
    public var gender:String?
    public var fullName:String?
    public var mobilePhone:String?
    public var isRegistered:Bool?
    public var isLogin:Bool?
    public var userOperationStep:String?
    public var memberSince:String?
    public var oldUserId:String?
    public var location:String?
    public var segments:[String]?
    public var step:String?
}
