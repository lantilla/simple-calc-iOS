//
//  ViewController.swift
//  Simple Calc iOS
//
//  Created by Lauren Antilla on 10/24/17.
//  Copyright © 2017 Lauren Antilla. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var rpnSwitch: UISwitch!
    @IBOutlet weak var displayOutput: UILabel!
    @IBOutlet weak var btnMod: UIButton!
    @IBOutlet weak var btnDiv: UIButton!
    @IBOutlet weak var btnMult: UIButton!
    @IBOutlet weak var btnSub: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnEqual: UIButton!
    @IBOutlet weak var btnClear: UIButton!
    @IBOutlet weak var btnAvg: UIButton!
    @IBOutlet weak var btnFact: UIButton!
    @IBOutlet weak var btnCount: UIButton!
    @IBOutlet weak var btnNeg: UIButton!
    @IBOutlet weak var btnSpace: UIButton!
    
    
    var nums: [String] = []
    var numForArr = ""
    var operand = ""
    var validNormEq = true
    var pressedEq = false
    var currentOperation = ""
    var hasDecimal = false
    var negative = false

    override func viewDidLoad() {
        super.viewDidLoad()
        rpnSwitch.setOn(false, animated: false)
        displayOutput.text = ""
        btnUI(btn: btnMod)
        btnUI(btn: btnDiv)
        btnUI(btn: btnMult)
        btnUI(btn: btnSub)
        btnUI(btn: btnAdd)
        btnUI(btn: btnClear)
        btnUI(btn: btnEqual)
        btnUI(btn: btnAvg)
        btnUI(btn: btnFact)
        btnUI(btn: btnCount)
        btnUI(btn: btnNeg)
        btnUI(btn: btnSpace)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func btnUI(btn: UIButton) {
        btn.layer.cornerRadius = 10
        btn.clipsToBounds = true
    }

    @IBAction func negNum(_ sender: Any) {
        displayOutput.text = displayOutput.text! + "-"
        negative = !negative
        NSLog(String(negative))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnNumPressed(_ sender: UIButton) {
        NSLog("\((sender.titleLabel!.text)!) was pressed")
        if pressedEq == true {
            pressedEq = false
            displayOutput.text = (sender.titleLabel!.text)!
        } else {
            displayOutput.text = displayOutput.text! + (sender.titleLabel!.text)!
        }
        numForArr += (sender.titleLabel!.text)!
        NSLog(numForArr)
    }
    
    @IBAction func btnDecimalPRessed(_ sender: UIButton) {
        hasDecimal = true
        numForArr += (sender.titleLabel!.text)!
        displayOutput.text = displayOutput.text! + (sender.titleLabel!.text)!
    }
    
    @IBAction func btnClearPressed(_ sender: UIButton) {
        displayOutput.text = ""
        clearVars()
    }
    
    @IBAction func btnOperatorPressed(_ sender: UIButton) {
        nums.append(numForArr)
        numForArr = ""
        if rpnSwitch.isOn {
            operand = (sender.titleLabel!.text)!
            if hasDecimal == true {
                completeOperation(first: Double(nums[0])!)
            } else {
                completeOperation(first: Int(nums[0])!)
            }
            clearVars()
            pressedEq = true
        } else {
            currentOperation = "math"
            if operand != "" {
                validNormEq = false
            }
            operand = (sender.titleLabel!.text)!
            displayOutput.text = displayOutput.text! + operand
        }
    }
    
    func completeOperation(first: Int) {
        var tot: Int = first
        if nums.count - 1 == 0 {
            calcError()
        } else {
            for i in 1...(nums.count - 1) {
                var num = Int(nums[i])!
                NSLog(String(nums[i].contains("-")))
                if negative == true {
                    num = num * -1
                }
                switch operand {
                case "+":
                    tot += num
                case "-":
                    tot -= num
                case "*":
                    tot *= num
                case "/":
                    tot = tot / num
                case "%":
                    tot = tot % num
                default:
                    NSLog("Operand not found")
                }
            }
            displayOutput.text = String(tot)
        }
    }
    
    func completeOperation(first: Double) {
        var tot = first
        if nums.count - 1 == 0 {
            calcError()
        } else {
            for i in 1...(nums.count - 1) {
                var num = Double(nums[i])!
                if negative == true {
                    num = num * -1
                }
                switch operand {
                case "+":
                    tot += num
                case "-":
                    tot -= num
                case "*":
                    tot *= num
                case "/":
                    tot = tot / num
                case "%":
                    tot = tot.truncatingRemainder(dividingBy: num)
                default:
                    NSLog("Operand not found")
                }
            }
            displayOutput.text = String(tot)
        }
    }
    
    @IBAction func btnSpacePressed(_ sender: UIButton) {
        NSLog("\((sender.titleLabel!.text)!) was pressed")
        nums.append(numForArr)
        numForArr = ""
        displayOutput.text = displayOutput.text! + " "
    }
    
    @IBAction func btnEqualPressed(_ sender: UIButton) {
        nums.append(numForArr)
        numForArr = ""
        switch currentOperation {
        case "avg":
            avg()
        case "count":
            displayOutput.text = String(nums.count)
        case "math":
            equalTo()
        default:
            NSLog("Unknown Operation")
        }
        clearVars()
        pressedEq = true
    }
    
    func equalTo() {
        if nums.count != 2 || validNormEq == false {
            calcError()
        } else {
            if hasDecimal == true {
                completeOperation(first: Double(nums[0])!)
            } else {
                completeOperation(first: Int(nums[0])!)
            }
        }
    }
    
    @IBAction func btnAvgPressed(_ sender: UIButton) {
        nums.append(numForArr)
        numForArr = ""
        if rpnSwitch.isOn {
            avg()
            clearVars()
            pressedEq = true
        } else {
            displayOutput.text = displayOutput.text! + " avg "
            if currentOperation == "avg" || currentOperation == "" || nums.count != 0 {
                currentOperation = "avg"
            } else {
                calcError()
            }
        }
    }
    
    @IBAction func btnFactPressed(_ sender: UIButton) {
        nums.append(numForArr)
        numForArr = ""
        if nums.isEmpty || nums.count > 1 {
            calcError()
        } else {
            if hasDecimal != true {
                var res = 1
                let num = Int(nums[0])!
                for i in 1...num {
                    res = res * i
                }
                NSLog(String(res))
                displayOutput.text = String(res)
            } else {
                var res = 1.0
                let num = Double(nums[0])!
                for i in 1...Int(num) {
                    res = res * Double(i)
                }
                NSLog(String(res))
                displayOutput.text = String(res)
            }
            nums = []
        }
        clearVars()
        pressedEq = true
    }
    
    @IBAction func btnCountPressed(_ sender: UIButton) {
        currentOperation = "count"
        NSLog(String(nums.count))
        nums.append(numForArr)
        numForArr = ""
        if rpnSwitch.isOn {
            displayOutput.text = String(nums.count)
            clearVars()
            pressedEq = true
        } else {
            displayOutput.text = displayOutput.text! + " count "
        }
    }

    func avg() {
        var tot:Double = 0.0;
        for i in nums {
            var num = 0.0
            if negative == true {
                num = Double(i)! * -1.0
            } else {
                num = Double(i)!
            }
            tot += num
        }
        tot = tot / Double(nums.count)
        nums = []
        NSLog("avg: " + String(tot))
        displayOutput.text = String(tot)
        pressedEq = true
    }
    
    func calcError() {
        NSLog("Error")
        displayOutput.text = "Error"
        clearVars()
    }
    
    func clearVars() {
        nums = []
        numForArr = ""
        operand = ""
        validNormEq = true
        pressedEq = false
        currentOperation = ""
        hasDecimal = false
        negative = false
    }

}

