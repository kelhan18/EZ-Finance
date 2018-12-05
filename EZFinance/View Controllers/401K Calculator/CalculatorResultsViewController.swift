//
//  401kCalculatorResultsViewController.swift
//  EZFinance
//
//  Created by Keller Han on 12/3/18.
//  Copyright © 2018 Anthony Medovar. All rights reserved.
//

import UIKit

//https://stackoverflow.com/questions/24196689/how-to-get-the-power-of-some-integer-in-swift-language/24201042
precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ^^ : PowerPrecedence
func ^^ (radix: Double, power: Double) -> Double {
    return pow(Double(radix), Double(power))
}

class CalculatorResultsViewController: UIViewController {
    
    @IBOutlet var withEmployerMatchLabel: UILabel!
    @IBOutlet var withoutEmployerMatchLabel: UILabel!
    
    var infoPassed = [String]()
    
    
    //infoPassed = [percentToContribute, annualSalary, annualSalaryIncrease, currentAge, ageOfRetirement, currentBalance, annualRateOfReturn, employerMatchPercentage, employerMatchMaxPercentage]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //print(infoPassed)
        
        let percentToContribute = Double(infoPassed[0])! / 100.0
        var annualSalary = Double(infoPassed[1])!
        let annualSalaryIncrease = Double(infoPassed[2])! / 100.0
        let currentAge = Double(infoPassed[3])!
        let ageOfRetirement = Double(infoPassed[4])!
        let currentBalance = Double(infoPassed[5])!
        let annualRateOfReturn = Double(infoPassed[6])! / 100.0
        let employerMatchPercentage = Double(infoPassed[7])! / 100.0
        let employerMatchMaxPercentage = Double(infoPassed[8])! / 100.0
        let maxMatch = employerMatchPercentage * employerMatchMaxPercentage
        let yearsOfGain = ageOfRetirement - currentAge
        var noEmployerMatchResult = currentBalance
        var employerMatchResult = currentBalance
        
        for n in 0...Int(yearsOfGain) {
            
            annualSalary = annualSalary + (annualSalary * annualSalaryIncrease)
            var yearlyContribution = annualSalary * percentToContribute
            if (yearlyContribution > 18500.00) {
                yearlyContribution = 18500.00
            }
            noEmployerMatchResult = yearlyContribution + (noEmployerMatchResult * (1.00 + annualRateOfReturn))
            
            var employerMatch = annualSalary * maxMatch
            if (employerMatch > yearlyContribution) {
                employerMatch = yearlyContribution
            }
            employerMatchResult = yearlyContribution + employerMatch + (employerMatchResult * (1.00 + annualRateOfReturn))
        }
        
        let convertedString = String(format: "%.2f", noEmployerMatchResult)
        let largeNumber = Double(convertedString)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:largeNumber!))
        withoutEmployerMatchLabel.text = "$" + String(formattedNumber!)
        
        let convertedString2 = String(format: "%.2f", employerMatchResult)
        let largeNumber2 = Double(convertedString2)
        let numberFormatter2 = NumberFormatter()
        numberFormatter2.numberStyle = NumberFormatter.Style.decimal
        let formattedNumber2 = numberFormatter.string(from: NSNumber(value:largeNumber2!))
        withEmployerMatchLabel.text = "$" + String(formattedNumber2!)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
