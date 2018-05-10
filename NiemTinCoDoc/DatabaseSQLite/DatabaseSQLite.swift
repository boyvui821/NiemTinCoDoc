//
//  DatabaseSQLite.swift
//  NiemTinCoDoc
//
//  Created by Nguyen Hieu Trung on 4/10/18.
//  Copyright © 2018 NHTSOFT. All rights reserved.
//

import Foundation
import SQLite

class DatabaseSQLite{
    var dbName:String?
    var dbFormat:String?
    var destPathConnectSql:String?
    var dbConnection:Connection?
    
    var strQuery = "select StoryName, StoryContent from Story order by Story.StoryName ASC"
    
    init(dbname:String!, dbformat:String!) {
        self.dbName = dbname;
        self.dbFormat = dbformat;
    }
    
    func CopyFileFromBundleToDirectory(){
        let bundlePath = Bundle.main.path(forResource: self.dbName, ofType: self.dbFormat);
        print("bundlePath: \(bundlePath!)");
        
        let destPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!;
        
        let fileManager = FileManager.default
        let fullDestPath = NSURL(fileURLWithPath: destPath).appendingPathComponent("\(self.dbName!).\(self.dbFormat!)");
        let fullDestPathString = fullDestPath?.path
        self.destPathConnectSql = fullDestPathString;
    
        //Copy file qua
        do
        {
            //Copy file database
            if fileManager.fileExists(atPath: fullDestPathString!){
                try fileManager.removeItem(atPath: fullDestPathString!)
            }
            try fileManager.copyItem(atPath: bundlePath!, toPath: fullDestPathString!)
            print("DB Copied")

        }
        catch
        {
            print("\n")
            print(error)
        }
    }
    
    func GetConnection(){
        self.CopyFileFromBundleToDirectory();
        
        //Connect to DB SQLite
        do{
            let db = try Connection(self.destPathConnectSql!);
            self.dbConnection = db;
        }catch{
            print(error);
        }
    }
    
    func SelectData()->[FaithStory]{
        var arrStory = [FaithStory]();
//        let table = Table("Story");
//        let id = Expression<Int>("ID");
//        let storyname = Expression<String>("StoryName");
//        let storycontent = Expression<String>("StoryContent");
        //Select* from Story
        if let db = dbConnection{
            do{
                for row in try db.prepare(self.strQuery) {
                    //print(row[storyname]);
                    let storyname = row[0] as! String;
                    let storycontent = row[1] as! String;
                    arrStory.append(FaithStory(name: storyname, content: storycontent));
                }
            }catch{
                print("Query Error");
            }
            
        }
        return arrStory;
    }
    
    func ConnectToDB(){
        //Đường dẫn trong source
        let url = Bundle.main.url(forResource: self.dbName, withExtension: self.dbFormat);
        let strFrom = url?.path;
        //Đường dẫn tới Document
        let pathTo = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first!
        let pathFile = "\(pathTo)/\(self.dbName!).\(self.dbFormat!)";
        
        let fileManager = FileManager.default;
        
        if(!fileManager.fileExists(atPath: pathFile)){
            do{
                try fileManager.copyItem(atPath: strFrom!, toPath: pathTo);
            }catch{
                print("Copy thất bại");
            }
        }else{
            do{
                let urlOriginal = URL(fileURLWithPath: pathFile);
                let urlReplace = URL(fileURLWithPath: strFrom!);
                try fileManager.replaceItemAt(urlOriginal, withItemAt: urlReplace);
            }catch{
                print("Replace thất bại");
            }
        }
        do{
            let db = try Connection(pathFile);
            let table = Table("Story");
            let storyname = Expression<String>("StoryName");
            let storycontent = Expression<String>("StoryContent");
            //Select* from Story
            for row in try db.prepare(table) {
                print("\(row[storyname])");
            }
        }catch{
            print(error);
        }
    }
}
