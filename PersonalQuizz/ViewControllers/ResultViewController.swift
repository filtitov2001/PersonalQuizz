//
//  ResultViewController.swift
//  PersonalQuizz
//
//  Created by Felix Titov on 06.02.2022.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var descriptionOfResultLabel: UILabel!
    
    var chosenAnswers: [Answer]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        updateResult()
    }
    
    private func updateResult() {
        var frequencyOfAnimals = [Animal : Int]()
        let animals = chosenAnswers.map { $0.animal }
        
        for animal in animals {
            if let animalTypeCount = frequencyOfAnimals[animal] {
                frequencyOfAnimals.updateValue(animalTypeCount + 1, forKey: animal)
            } else {
                frequencyOfAnimals[animal] = 1
            }
        }
        //MARK: Second variant of cicle
        /*
        for animal in animals {
            frequencyOfAnimals[animal] = (frequencyOfAnimals[animal] ?? 0) + 1
        }
         */
        
        let sortedFrequencyOfAnimals = frequencyOfAnimals.sorted { $0.value > $1.value }
        guard let mostFrequencyAnimal = sortedFrequencyOfAnimals.first?.key else {
            return
        }
        
        //MARK: Decision for one string
        /*
         let mostFrequencyAnimal = Dictionary(grouping: chosenAnswers) { $0.animal }
         .sorted { $0.value > $1.value }
         .first?.key
         */
        
        
        updateUI(with: mostFrequencyAnimal)
    }
    
    private func updateUI(with animal: Animal) {
        resultLabel.text = "Вы - \(animal.rawValue)"
        descriptionOfResultLabel.text = animal.description
    }
}


//MARK: My first realization
/*
 class ResultViewController: UIViewController {
     
     // 1. Передать сюда массив с ответами
     // 2. Определить наиболее часто встречающийся тип животного
     // 3. Отобразить результат в соответствии с этим животным
     // 4. Избавиться от кнопки возврата на предыдущий экран
     
     @IBOutlet var navItem: UINavigationItem!
     @IBOutlet var emogiLabel: UILabel!
     @IBOutlet var descriptionLabel: UILabel!
     
     
     private var dict: [Animal : Int] = [:]
     
     var chosenAnswers: [Answer]!

     override func viewDidLoad() {
         super.viewDidLoad()
         navItem.hidesBackButton = true
         checkAnswers()
         updateUI()
     }
     
     private func updateUI() {
         let resultAnimal = findMax()
         
         emogiLabel.text = "Вы - \(resultAnimal.rawValue)"
         descriptionLabel.text = resultAnimal.definition


     }
     
     private func checkAnswers() {
         if let answers = chosenAnswers {
             for answer in answers {
                 switch answer.animal {
                 case .dog: setValue(for: .dog)
                     case .cat: setValue(for: .cat)
                     case .rabbit: setValue(for: .rabbit)
                     case .turtle: setValue(for: .turtle)
                 }
             }
         }
     }
     
     private func setValue(for animal: Animal) {
         if let value = dict[animal] {
             let newValue = value + 1
             dict.updateValue(newValue, forKey: animal)
         } else  {
             dict.updateValue(1, forKey: animal)
         }
     }
     
     private func findMax() -> Animal {
         var maxValue = 0
         var keyOfMaxValue: Animal = .dog
         
         for (key, value) in dict {
             if max(maxValue, value) > maxValue {
                 maxValue = value
                 keyOfMaxValue = key
             }
         }
         
         return keyOfMaxValue
     }
     
 }
chosen
 */
