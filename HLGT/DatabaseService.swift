//
//  DatabaseService.swift
//  HLGT
//
//  Created by MAC on 7/30/17.
//  Copyright © 2017 MAC. All rights reserved.
//
import Foundation
import UIKit


let sharedInstance = FMDBDatabaseModel()

class FMDBDatabaseModel: NSObject {
    
    var database:FMDatabase? = nil
    
    class func getInstance() -> FMDBDatabaseModel
    {
        if (sharedInstance.database == nil)
        {
            sharedInstance.database = FMDatabase(path: Util.getPath(fileName: "hocluatgiaothong4.sqlite"))
        }
        return sharedInstance
    }
    
    //MARK:- insert data into table
    
    //    func InsertData(_ Tbl_Info:Tbl_Info) -> Bool {
    //        sharedInstance.databese!.open()
    //        let isInserted = sharedInstance.databese!.executeUpdate("INSERT INTO Info(Name,MobileNo,Email) VALUES(?,?,?)", withArgumentsIn: [Tbl_Info.Name,Tbl_Info.MobileNo,Tbl_Info.Email])
    //
    //        sharedInstance.databese!.close()
    //        return (isInserted != nil)
    //
    //    }
    
    func GetAllDataQuestion() -> NSMutableArray {
        sharedInstance.database!.open()
        
        let resultSet:FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM Question", withArgumentsIn: [0])
        
        let itemInfo:NSMutableArray = NSMutableArray ()
        if (resultSet != nil)
        {
            while resultSet.next() {
                
                let item:QuestionModel = QuestionModel()
                item.QuestionId = Int(resultSet.int(forColumn: "Id"))
                item.CategoryId = Int(resultSet.int(forColumn: "CategoryId"))
                item.QuestionName = String(resultSet.string(forColumn: "Name")!)
                item.QuestionImage? = String(resultSet.string(forColumn: "QuestionImage")!)
                item.IsFavorite = Bool(resultSet.bool(forColumn: "IsFavorite"))
                item.NumberNoCorrect = Int(resultSet.int(forColumn: "NotCorrectAnswers"))
                
                let resultSetAnswer:FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM Q_A where QuestionId = \(item.QuestionId)", withArgumentsIn: [0])
                while resultSetAnswer.next() {
                    
                    let answer:AnswersModel = AnswersModel()
                    answer.AnswerId = Int(resultSetAnswer.int(forColumn: "Id"))
                    answer.AnswerName = String(resultSetAnswer.string(forColumn: "Name")!)
                    answer.QuestionId = Int(resultSetAnswer.int(forColumn: "QuestionId"))
                    answer.IsCorrect = Bool(resultSetAnswer.bool(forColumn: "IsCorrect"))
                    
                    item.AnswersText.append(answer)                }
                
                itemInfo.add(item)
            }
        }
        
        sharedInstance.database!.close()
        return itemInfo
    }
    
    func GetAllDataCategory() -> NSMutableArray {
        sharedInstance.database!.open()

        let resultSet:FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM Category order by No", withArgumentsIn: [0])
        
        let itemInfo:NSMutableArray = NSMutableArray ()
        if (resultSet != nil)
        {
            while resultSet.next() {
                
                let item:CategoryModel = CategoryModel()
                item.CategoryId = Int(resultSet.int(forColumn: "Id"))
                item.CategoryName = String(resultSet.string(forColumn: "Name"))
                item.CategoryImage = String(resultSet.string(forColumn: "Image"))
                item.No = Int(resultSet.int(forColumn: "No"))
                
                itemInfo.add(item)
            }
        }
        
        sharedInstance.database!.close()
        return itemInfo
    }
    
    func GetAllDataQuestionByCategoryId(categoryId: Int) -> NSMutableArray {
        
        sharedInstance.database!.open()
        
        var queryString = ""
        if(categoryId == 8)
        {
            queryString = "SELECT * FROM Question where NotCorrectAnswers >= 2"
        }
        else if(categoryId == 9)
        {
            queryString = "SELECT * FROM Question where IsFavorite = 1"
        }
        else if(categoryId == 10)
        {
            queryString = "SELECT * FROM Question"
        }
        else
        {
            queryString = "SELECT * FROM Question where CategoryId = \(categoryId)"
        }
        
        let resultSet:FMResultSet! = sharedInstance.database!.executeQuery(queryString, withArgumentsIn: [0])
        
        let itemInfo:NSMutableArray = NSMutableArray ()
        if (resultSet != nil)
        {
            while resultSet.next() {
                
                let item:QuestionModel = QuestionModel()
                item.QuestionId = Int(resultSet.int(forColumn: "Id"))
                item.CategoryId = Int(resultSet.int(forColumn: "CategoryId"))
                item.QuestionName = resultSet.string(forColumn: "Name")!
                item.QuestionImage? = resultSet.string(forColumn: "QuestionImage")!
                item.HasImage = resultSet.bool(forColumn: "HasImage")
                item.IsFavorite = resultSet.bool(forColumn: "IsFavorite")
                item.NumberNoCorrect = Int(resultSet.int(forColumn: "NotCorrectAnswers"))
                
                let resultSetAnswer:FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM Question_Answer where QuestionId = \(item.QuestionId)", withArgumentsIn: [0])
                while resultSetAnswer.next() {
                    
                    let answer:AnswersModel = AnswersModel()
                    answer.AnswerId = Int(resultSetAnswer.int(forColumn: "Id"))
                    answer.AnswerName = String(resultSetAnswer.string(forColumn: "Name")!)
                    answer.QuestionId = Int(resultSetAnswer.int(forColumn: "QuestionId"))
                    answer.IsCorrect = Bool(resultSetAnswer.bool(forColumn: "IsCorrect"))
                    
                    item.AnswersText.append(answer)
                }
                
                itemInfo.add(item)
            }
        }
        
        sharedInstance.database!.close()
        return itemInfo
    }
    
    func updateNumberNotCorrectData(questionId: Int, numberNotCorrect: Int){
        sharedInstance.database!.open()
        sharedInstance.database!.executeUpdate("UPDATE Question SET NotCorrectAnswers=? where Id = \(questionId)", withArgumentsIn: [numberNotCorrect])
        sharedInstance.database!.close()
    }
    
    
    func updateFavoriteData(questionId: Int, isFavorite: Bool){
        sharedInstance.database!.open()
        sharedInstance.database!.executeUpdate("UPDATE Question SET IsFavorite=? where Id = \(questionId)", withArgumentsIn: [isFavorite])
        sharedInstance.database!.close()
    }
    
    //    func deleteRecode(RecoreId:Int) -> NSMutableArray {
    //        sharedInstance.databese!.open()
    //
    //        let resultSet:FMResultSet! = sharedInstance.databese!.executeQuery("DELETE FROM Info WHERE Id = ?", withArgumentsIn: [RecoreId])
    //
    //        let itemInfo:NSMutableArray = NSMutableArray ()
    //        if (resultSet != nil)
    //        {
    //            while resultSet.next() {
    //
    //                let item:Tbl_Info = Tbl_Info()
    //                item.Id = Int(resultSet.int(forColumn: "Id"))
    //                item.Name = String(resultSet.string(forColumn: "Name")!)
    //                item.MobileNo = String(resultSet.string(forColumn: "MobileNo")!)
    //                item.Email = String(resultSet.string(forColumn: "Email")!)
    //                itemInfo.add(item)
    //            }
    //        }
    //
    //        sharedInstance.databese!.close()
    //        return itemInfo
    //        
    //    }
    
    
}
