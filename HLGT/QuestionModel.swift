//
//  QuestionModel.swift
//  HLGT
//
//  Created by MAC on 7/29/17.
//  Copyright © 2017 MAC. All rights reserved.
//

import Foundation

class QuestionModel: NSObject {
    
    var QuestionId: Int = Int()
    var CategoryId : Int = Int()
    var QuestionName: String = String()
    var QuestionImage: String?
    var IsFavorite : Bool = Bool()
    var HasImage : Bool = Bool()
    var NumberNoCorrect : Int = Int()
    var AnswersText = [AnswersModel]()
    var IsCheckQuestion : Bool = Bool()
    var IsShowPopup : Bool = Bool()
}

class AnswersModel: NSObject {
    
    var AnswerId : Int = Int()
    var AnswerName : String = String()
    var QuestionId : Int = Int()
    var IsCorrect : Bool = Bool()
    var IsCheckAnswer : Bool = Bool()
    
    
}
