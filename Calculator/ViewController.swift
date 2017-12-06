//
//  ViewController.swift
//  Calculator
//
//  Created by Clementine Ferreol on 25/01/2017.
//  Copyright © 2017 Clementine Ferreol. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var display: UILabel!
    
    var displayText = [String]()//tableau de String pour garder en mémoire l'équivalent de ce quil y a sur l'écran
    var resultTab = ""
    
    @IBAction func btnNumber(_ sender: UIButton) {
        let text = display.text ?? "" //récupère ce qu'il y a l'écran et le transforme en string
        var value = ""
        
        if(sender.tag == 20){
            if(!resultTab.contains(".")){//si le resultTab ne contient pas déjà une virgule, il execute le code
                
                display.text = text + "." // affiche la virgule
                resultTab = resultTab.appending(".") //on rajoute "." à resultTa
            }else{
                display.text = text
            }
            
        }else{
            value = String(sender.tag)
            display.text = text + value//affiche les chiffres
            print(text + value)
            resultTab = resultTab.appending(value)//ajoute les chiffres dans resultTab
        }
        
    }
    func fillArray(operatorBtn: String)->(){
        displayText.append(resultTab)//ajouter resultTab au tableau displayText
        
        if(Float(displayText.last!) != nil){//Si la dernière valeur du tableau est un nombre
            displayText.append(operatorBtn)//ajoute opérateur au tableau
            let text = display.text ?? ""
            display.text = text + operatorBtn // affiche l'opérateur
            resultTab = ""//réinitialise resultTab
        }else{
            displayText.popLast()//enleve le dernier opérateur entré pour qu'il n'y en ai bien qu'un seul (pas 2 opérateurs à la suite)
            let text = display.text ?? ""
            display.text = text
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func percent(_ sender: UIButton) {
        let text = display.text ?? ""
        print(text)
        
        let float = Float(text) ?? 0
        print(float)
        
        let opp = float / 100
        let string = String(opp)
        
        display.text = string
        print(resultTab)
        
        resultTab = string
        print(resultTab)
    }
    
    @IBAction func divide(_ sender: UIButton) {
        fillArray(operatorBtn: Operator.division.rawValue)
    }
    
    @IBAction func multiply(_ sender: UIButton) {
        fillArray(operatorBtn: Operator.multiply.rawValue)
    }
    
    @IBAction func substract(_ sender: UIButton) {
        fillArray(operatorBtn: Operator.substraction.rawValue)
    }
    
    @IBAction func addition(_ sender: UIButton) {
        fillArray(operatorBtn: Operator.addition.rawValue)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func clear(_ sender: UIButton) {
        resultTab = ""
        displayText.removeAll()
        display.text = ""
    }
    
    /* @IBAction func OpBtn(_ sender: UIButton) {
     let text = display.text ?? ""
     displayText.append(resultTab)
     display.text = text + String(sender.tag)
     displayText.append(String(sender.tag))
     print(text + String(sender.tag))
     
     }*/
    
    @IBAction func result(_ sender: Any) {
        displayText.append(resultTab) // ajoute resultTab à displayText
        resultTab = "" // puis réinitialise resultTab
        //var opp: Operator?
        
        if(!displayText.isEmpty){//si le tableau n'est pas vide
            if(Float(displayText.last!) != nil){ // et que le dernier élément est un chiffre
                
                displayText = modifArray(array: displayText)//fonction modiArray dans displayText
                
                print(displayText)
                display.text = displayText[0] // on affiche le résultat
                resultTab = resultTab.appending(displayText[0])//on ajoute le résultat à resultTab
                displayText.removeAll()// on réinitialise le tableau displayText
            }else{
                displayText.popLast()
                let text = display.text ?? ""
                display.text = text
            }
        }else{
            display.text = ""
        }
    }
    
    func modifArray (array: [String])->([String]){
        
        var temp = array
        
        if(array.count > 1){//s'il y a plus qu'un chiffre
            if(temp.contains("*") || temp.contains("/") ){//et qu'il contient des "*" et des "/"
                for i in 0...temp.underestimatedCount{
                    
                    if(i+1 > temp.underestimatedCount){//si i+1 suppérieur à temp on arrête la boucle
                        break
                    }
                    
                    if(temp[i] == "*" || temp[i] == "/"){//quand on tombe sur "*" ou "/"
                        let nb1 = Float(temp[i-1])// on regarde le chiffre d'avant
                        let nb2 = Float(temp[i+1])// et le chiffre d'après
                        let operand = temp[i] // l'indice actuel
                        let idx1 = i-1 // l'indice du chiffre avant l'opérateur
                        
                        if(operand == "*"){//si l'opérateur est "*"
                            temp = compute(operand: Operator.multiply, numbers: temp, idx1: idx1, nb1: nb1!, nb2: nb2!)
                            break//arrête la boucle
                            
                        }else if(operand == "/"){//si l'opérateur est un "/"
                            temp = compute(operand: Operator.division, numbers: temp, idx1: idx1, nb1: nb1!, nb2: nb2!)
                            break
                        }
                        
                    }else{
                        continue
                    }
                }
                temp = modifArray(array: temp)//reprend le tableau modifié
            }
            
            print("\(temp)")
            for j in 0...temp.underestimatedCount { // exactement la même chose qu'au-dessus avec des "+" et des "-"
                if(j+1 > temp.underestimatedCount){
                    break
                }
                if(temp[j] == "+" || temp[j] == "-"){
                    let nb1 = Float(temp[j-1])
                    let nb2 = Float(temp[j+1])
                    let idx1 = j-1
                    
                    let operand = temp[j]
                    
                    if(operand == "+"){
                        temp = compute(operand: Operator.addition, numbers: temp, idx1: idx1, nb1: nb1!, nb2: nb2!)
                        break
                        
                    }else if(operand == "-"){
                        temp = compute(operand: Operator.substraction, numbers: temp, idx1: idx1, nb1: nb1!, nb2: nb2!)
                        break
                    }
                    
                    print(temp)
                    
                }else{
                    continue
                }
            }
            
            
            temp = modifArray(array: temp)//reprend le tableau modifié
        }else{
            return array
        }
        return temp
    }
    
    func compute(operand: Operator, numbers: [String], idx1: Int, nb1: Float, nb2: Float) -> [String]{
        let opp = operand
        var temp = numbers
        let result = String(Operator.operation(opp)(nb1: Float(nb1), nb2: Float(nb2)))
        temp.insert(result, at: idx1)
        temp.remove(at: idx1+1)
        temp.remove(at: idx1+1)
        temp.remove(at: idx1+1)
        return temp
    }
    
    enum Operator: String {
        case addition = "+"
        case substraction = "-"
        case multiply = "*"
        case division = "/"
        
        func operation(nb1:Float, nb2: Float) -> Float{
            switch self {
            case .addition :
                return (nb1 + nb2)
                
            case .substraction :
                return(nb1 - nb2)
                
            case .multiply :
                return(nb1 * nb2)
                
            case .division :
                return(nb1 / nb2)
            }
        }
        
    }
    
}
