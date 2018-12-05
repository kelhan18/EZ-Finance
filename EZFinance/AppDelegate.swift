//
//  AppDelegate.swift
//  EZFinance
//
//  Created by CS3714 on 11/6/18.
//  Copyright © 2018 Anthony Medovar. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var dict_Expense_ExpenseData: NSMutableDictionary = NSMutableDictionary()

    var myBudget: NSMutableDictionary = NSMutableDictionary()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        
        let documentDirectoryPath = paths[0] as String
        let plistFilePathInDocumentDirectory = documentDirectoryPath + "/ExpenseList.plist"
        let plistFilePathInDocumentDirectory2 = documentDirectoryPath + "/Budget.plist"
        
        let dictionaryFromFile: NSMutableDictionary? = NSMutableDictionary(contentsOfFile: plistFilePathInDocumentDirectory)
        
        if let dictionaryFromFileInDocumentDirectory = dictionaryFromFile {
            dict_Expense_ExpenseData = dictionaryFromFileInDocumentDirectory
        } else {
            let plistFilePathInMainBundle = Bundle.main.path(forResource: "ExpenseList", ofType: "plist")
            let dictionaryFromFileInMainBundle: NSMutableDictionary? = NSMutableDictionary(contentsOfFile: plistFilePathInMainBundle!)
            
            dict_Expense_ExpenseData = dictionaryFromFileInMainBundle!
            
        }
        
        let dictionaryFromFile2: NSMutableDictionary? = NSMutableDictionary(contentsOfFile: plistFilePathInDocumentDirectory2)

        if let dictionaryFromFileInDocumentDirectory2 = dictionaryFromFile2 {
            myBudget = dictionaryFromFileInDocumentDirectory2
        } else {
            let plistFilePathInMainBundle2 = Bundle.main.path(forResource: "Budget", ofType: "plist")
            let dictionaryFromFileInMainBundle2: NSMutableDictionary? = NSMutableDictionary(contentsOfFile: plistFilePathInMainBundle2!)
            myBudget = dictionaryFromFileInMainBundle2!

        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectoryPath = paths[0] as String
        let plistFilePathInDocumentDirectory = documentDirectoryPath + "/ExpenseList.plist"
        dict_Expense_ExpenseData.write(toFile: plistFilePathInDocumentDirectory, atomically: true)
        
        let paths2 = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectoryPath2 = paths2[0] as String
        let plistFilePathInDocumentDirectory2 = documentDirectoryPath2 + "/Budget.plist"
        myBudget.write(toFile: plistFilePathInDocumentDirectory2, atomically: true)

    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

