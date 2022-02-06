//
//  QuestionsViewController.swift
//  PersonalQuizz
//
//  Created by Felix Titov on 06.02.2022.
//  Copyright © 2022 by Felix Titov. All rights reserved.
//  


import UIKit

class QuestionsViewController: UIViewController {

    //MARK: Information UI elements
    @IBOutlet var questionNavigationItem: UINavigationItem!
    
    @IBOutlet var questionProgresView: UIProgressView!
    @IBOutlet var questionTitleLable: UILabel!
    
    //MARK: Single answers UI elements
    @IBOutlet var singleAnswersStackView: UIStackView!
    @IBOutlet var singleAnswerButtons: [UIButton]!
    
    //MARK: Multiple answers UI elements
    @IBOutlet var multipleAnswersStackView: UIStackView!
    @IBOutlet var multipleAnswersTitileLabel: [UILabel]!
    @IBOutlet var multipleAnswersSwitches: [UISwitch]!
    
    //MARK: Ranged answers UI elements
    @IBOutlet var rangedAnswersStackView: UIStackView!
    @IBOutlet var rangedAnswerSlider: UISlider! {
        didSet{
            let answerCount = Float(currentAnswers.count - 1)
            rangedAnswerSlider.maximumValue = answerCount
            rangedAnswerSlider.value = answerCount / 2
        }
    }
    @IBOutlet var rangeAnswerTitleLabels: [UILabel]!
    
    
    private let questions = Question.getQuestions()
    private var currentQuestionIndex = 0
    
    private var answersChosen: [Answer] = []
    private var currentAnswers: [Answer] {
        questions[currentQuestionIndex].answers
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let resultVC = segue.destination as? ResultViewController else {return}
        resultVC.chosenAnswers = answersChosen
    }
    
    @IBAction func singleAnswerButtonPressed(_ sender: UIButton) {
        guard let answerButton = singleAnswerButtons.firstIndex(of: sender) else {return}
        let currentAnswer = currentAnswers[answerButton]
        answersChosen.append(currentAnswer)
        
        nextQuestion()
    }
    
    @IBAction func multipleAsnwersButtonPressed() {
        for (answerSwitch, answer) in zip(multipleAnswersSwitches, currentAnswers) {
            if answerSwitch.isOn {
                answersChosen.append(answer)
            }
        }
        
        nextQuestion()
    }
    
    @IBAction func rangedAnswerButtonPressed() {
        let chosenValue = lrintf(rangedAnswerSlider.value)

        answersChosen.append(currentAnswers[chosenValue])
        
        nextQuestion()
    }
    
    
}

//MARK: Logic of display UI elements
extension QuestionsViewController {
    private func updateUI() {
        for stackView in [
            singleAnswersStackView,
            multipleAnswersStackView,
            rangedAnswersStackView
        ] {
            stackView?.isHidden = true
        }
        
        let currentQuestion = questions[currentQuestionIndex]
        
        questionTitleLable.text = currentQuestion.title
        
        let totalProgress = Float(currentQuestionIndex) / Float(questions.count)
        
        questionProgresView.setProgress(totalProgress, animated: true)
        
        navigationItem.title = "Вопрос №\(currentQuestionIndex + 1) из \(questions.count)"
        
        showAnswers(with: currentQuestion.responseType)
    }
    
    private func showAnswers(with type: ResponseType) {
        switch type {
            case .single: showSingleAnswers()
            case .multiple: showMultipleAnswers()
            case .ranged: showRangedAnswers()
        }
    }
    
    private func showSingleAnswers() {
        singleAnswersStackView.isHidden.toggle()
        
        for (answerButton, answer) in zip(singleAnswerButtons, currentAnswers) {
            answerButton.setTitle(answer.title, for: .normal)
        }
    }
    
    private func showMultipleAnswers() {
        multipleAnswersStackView.isHidden.toggle()
        
        for (answerLabel, answer) in zip(multipleAnswersTitileLabel, currentAnswers) {
            answerLabel.text = answer.title
        }
    }
    
    private func showRangedAnswers() {
        rangedAnswersStackView.isHidden.toggle()
        
        rangeAnswerTitleLabels.first?.text = currentAnswers.first?.title
        rangeAnswerTitleLabels.last?.text = currentAnswers.last?.title

    }
    
    private func nextQuestion() {
        currentQuestionIndex += 1
        
        if currentQuestionIndex < questions.count {
            updateUI()
            return
        }
        
        performSegue(withIdentifier: "showResult", sender: nil)
    }
}
