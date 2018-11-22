//
//  QuestionViewController.swift
//  HLGT
//
//  Created by MAC on 7/25/17.
//  Copyright © 2017 MAC. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate {


    var getAllDataQuestionByCategoryId = NSMutableArray()
    
    @IBOutlet weak var questionName: UILabel!
    
    @IBOutlet weak var questionImage: UIImageView!
    
    @IBOutlet weak var questionAnswers: UITableView!
    
    @IBOutlet weak var questionImageHeight: NSLayoutConstraint!
    
    @IBOutlet weak var questionAnswersTop: NSLayoutConstraint!
    
    @IBOutlet weak var questionView: UIView!
    
    @IBOutlet weak var collectionQuestionView: UIView!

    @IBOutlet weak var isFavorite: UIButton!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var confirmAnswerButton: UIButton!
    
    @IBOutlet weak var listQuestionButton: UIButton!
    
    @IBOutlet weak var answerPopupView: UIView!
    
    @IBOutlet weak var answerExplainContent: UITextView!
    
    @IBOutlet weak var iconAnswerQuestion: UIButton!
    
    @IBOutlet weak var collectionViewQuestionPopup: UICollectionView!
    
    @IBOutlet weak var emptyDataView: UIView!
    
    @IBOutlet weak var emptyDataText: UILabel!
    
    var categoryId: Int = 0
    
    var categoryName: String = ""
    
    var currentQuestionModel = QuestionModel()
    
    var questionModels = [QuestionModel]()
    
    var answersSelected = [Int]()

    var positionItem = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.backItem?.title = "123"
 
        getAllDataQuestionByCategoryId = FMDBDatabaseModel.getInstance().GetAllDataQuestionByCategoryId(categoryId: categoryId)
        
        questionModels = getAllDataQuestionByCategoryId.copy() as! [QuestionModel]
     
        if(questionModels.count == 0)
        {
            questionView.isHidden = true
            emptyDataView.isHidden = false
            emptyDataText.text = "Chưa có dữ liệu cho mục này. \n Vui lòng quay trở lại sau."

        }
        else
        {
            
            currentQuestionModel = questionModels[positionItem] 
            
            questionName.text = "Câu \(currentQuestionModel.QuestionId): " + currentQuestionModel.QuestionName
            questionName.font = UIFont.boldSystemFont(ofSize: 16)

            checkIsFavorite()
            checkDirection()
            bindEventForTableAnswer()
   
        }
        
        self.title = categoryName
        collectionQuestionView.isHidden = true
        answerPopupView.isHidden = true
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return currentQuestionModel.AnswersText.count
        
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "answersCell") as! QuestionTableViewCell
        
        cell.answerContent?.text = currentQuestionModel.AnswersText[indexPath.row].AnswerName

        cell.answerImageText?.text = "\(indexPath.row + 1)"
        
        if currentQuestionModel.AnswersText[indexPath.row].IsCorrect
        {
            cell.borderColorLeft.backgroundColor = UIColor.red
            cell.borderColorLeft.isHidden = true
        }
       
        cell.answerImage.layer.cornerRadius = (24 / 2)
        cell.answerImage.layer.borderWidth = 1.5
        cell.answerImage.frame.size.height = 24
        cell.answerImage.layer.masksToBounds = true

        if currentQuestionModel.AnswersText[indexPath.row].IsCheckAnswer
        {
            cell.answerImage.layer.borderColor = UIColor.red.cgColor
            cell.answerImageText.textColor = UIColor.red
        }
        else
        {
            cell.answerImage.layer.borderColor = UIColor.black.cgColor
            cell.answerImageText.textColor = UIColor.black
        }
        
//        if answersSelected.contains(currentQuestionModel.AnswersText[indexPath.row].AnswerId)
//        {
//            cell.answerImage.layer.borderColor = UIColor.red.cgColor
//            cell.answerImageText.textColor = UIColor.red
//        }
//        else
//        {
//            cell.answerImage.layer.borderColor = UIColor.black.cgColor
//            cell.answerImageText.textColor = UIColor.black
//        }
        
        cell.answerId?.text = "\(currentQuestionModel.AnswersText[indexPath.row].AnswerId)"
        
        cell.selectionStyle = .none
        
        return cell

    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! QuestionTableViewCell
        
        cell.answerImage.layer.borderColor = UIColor.red.cgColor
        cell.answerImageText.textColor = UIColor.red

        let answer = currentQuestionModel.AnswersText[indexPath.row]
        answer.IsCheckAnswer = true
        
        if let index = answersSelected.index(of: answer.AnswerId) {
            answersSelected.remove(at: index)
            cell.answerImage.layer.borderColor = UIColor.black.cgColor
            cell.answerImageText.textColor = UIColor.black
        }
        else
        {
            answersSelected.append(answer.AnswerId)
            cell.answerImage.layer.borderColor = UIColor.red.cgColor
            cell.answerImageText.textColor = UIColor.red
        }
        
    }
    
    internal func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! QuestionTableViewCell
        
        cell.answerImage.layer.borderColor = UIColor.black.cgColor
        cell.answerImageText.textColor = UIColor.black
        let answer = currentQuestionModel.AnswersText[indexPath.row]
        answer.IsCheckAnswer = false
        
//        for answer in currentQuestionModel.AnswersText
//        {
//            if answer.AnswerId == Int(cell.answerId.text!)!
//            {
//                answer.IsCheckAnswer = false
//            }
//        }
        
        //answersSelected.remove(at: answer.AnswerId)
        
        if let index = answersSelected.index(of: answer.AnswerId) {
            answersSelected.remove(at: index)
            cell.answerImage.layer.borderColor = UIColor.black.cgColor
            cell.answerImageText.textColor = UIColor.black
        }
        else
        {
            answersSelected.append(answer.AnswerId)
            cell.answerImage.layer.borderColor = UIColor.red.cgColor
            cell.answerImageText.textColor = UIColor.red
        }
        
    }
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        
//        if(segue.identifier == "showListQuestionCollection"){
//            
//            let questionCollectionView : QuestionCollectionViewController = segue.destination as! QuestionCollectionViewController
//            
//            for question in getAllDataQuestionByCategoryId
//            {
//                let questionModel = question as! QuestionModel
//                questionCollectionView.questionIds.append("\(questionModel.QuestionId)")
//            }
//        }
    }
    

    @IBAction func nextQuestion(_ sender: Any) {
        
        if positionItem >= questionModels.count - 1
        {
            nextButton.isEnabled = false
            nextButton.setImage(UIImage(named: "nextDisable.png"), for: .normal)
        }
        else
        {
            positionItem = positionItem + 1
            prepareQuestion(isBack: false)
            backButton.isEnabled = true
            backButton.setImage(UIImage(named: "backEnable.png"), for: .normal)
        }
   
    }
    
    @IBAction func backQuestion(_ sender: Any) {
        
        if(positionItem > 0){
            
            positionItem = positionItem - 1
            prepareQuestion(isBack: true)
            nextButton.isEnabled = true
            nextButton.setImage(UIImage(named: "nextEnable.png"), for: .normal)
        }
        else
        {
            backButton.isEnabled = false
            backButton.setImage(UIImage(named: "backDisable.png"), for: .normal)
        }
    }


    func prepareQuestion(isBack : Bool){
        
        currentQuestionModel = questionModels[positionItem]
        
        self.questionAnswers.tableFooterView = UIView(frame: .zero)
        self.questionName.text = "Câu \(currentQuestionModel.QuestionId): " + self.currentQuestionModel.QuestionName

        
        checkIsFavorite()
        checkDirection()
        bindEventForTableAnswer()
        
        if currentQuestionModel.IsCheckQuestion
        {
            confirmAnswerButton.setImage(UIImage(named: "confirmAnswerDisable.png"), for: .normal)
            confirmAnswerButton.isEnabled = false
            let cells = questionAnswers.visibleCells as! Array<QuestionTableViewCell>
            
            for cell in cells
            {
                cell.borderColorLeft.isHidden = false
            }
            questionAnswers.allowsSelection = false
            iconAnswerQuestion.isHidden = false
        }
        else
        {
            confirmAnswerButton.setImage(UIImage(named: "confirmAnswerEnable.png"), for: .normal)
            confirmAnswerButton.isEnabled = true
            let cells = questionAnswers.visibleCells as! Array<QuestionTableViewCell>
            for cell in cells
            {
                cell.borderColorLeft.isHidden = true
            }
            iconAnswerQuestion.isHidden = true
            answerPopupView.isHidden = true
        }
        
        self.questionAnswers.reloadData()
        
        if(isBack)
        {
            UIView.transition(from: questionView, to: questionView, duration: 0.3, options: [.transitionCurlDown, .showHideTransitionViews])
        }
        else
        {
            UIView.transition(from: questionView, to: questionView, duration: 0.3, options: [.transitionCurlUp, .showHideTransitionViews])
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return questionModels.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "questionCollectionCell", for: indexPath) as! QuestionCollectionViewCell
        
        let currentQuestion = questionModels[indexPath.row]
        
        cell.collectionText.text = "\(currentQuestion.QuestionId)"
        
        if (currentQuestion.IsCheckQuestion)
        {
            let isCorrect = checkCorrectAnswer(listAnswers: currentQuestion.AnswersText)
            if isCorrect
            {
                cell.collectionImage.layer.borderColor = UIColor.green.cgColor
            }
            else
            {
                cell.collectionImage.layer.borderColor = UIColor.red.cgColor
            }
        }
        else
        {
            cell.collectionImage.layer.borderColor = UIColor.black.cgColor
        }
        
        cell.collectionImage.layer.cornerRadius = (48 / 2)
        cell.collectionImage.layer.borderWidth = 1.5
        cell.collectionImage.frame.size.height = 48
        cell.collectionImage.layer.masksToBounds = true 
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionQuestionView.isHidden = true
        
        positionItem = indexPath.row
        
        prepareQuestion(isBack: false)
        
        bindEventClosedPopup()
        
    }
    
    @IBAction func showPopup(_ sender: Any) {
    
        if currentQuestionModel.IsShowPopup
        {
            bindEventClosedPopup()
        }
        else
        {
            collectionQuestionView.isHidden = false
            questionView.backgroundColor = UIColor.gray.withAlphaComponent(0.8)
            questionAnswers.isHidden = true
            questionImage.isHidden = true
            currentQuestionModel.IsShowPopup = true
            collectionViewQuestionPopup.reloadData()
            answerPopupView.isHidden = true
        }

    }
    
    
    @IBAction func closedPopup(_ sender: Any) {
        
        bindEventClosedPopup()
    }
    
    func bindEventClosedPopup()
    {
        collectionQuestionView.isHidden = true
        questionView.backgroundColor = UIColor.white.withAlphaComponent(1.0)
        questionAnswers.isHidden = false
        questionImage.isHidden = false
        currentQuestionModel.IsShowPopup = false
        if currentQuestionModel.IsCheckQuestion
        {
            iconAnswerQuestion.isHidden = false
        }
    }

    @IBAction func addOrRemoveIsFavorite(_ sender: Any) {
        
        if currentQuestionModel.IsFavorite
        {
            FMDBDatabaseModel.getInstance().updateFavoriteData(questionId: currentQuestionModel.QuestionId, isFavorite: false)
            isFavorite.setImage(UIImage(named: "favorite.png"), for: .normal)
            currentQuestionModel.IsFavorite = false
        }
        else
        {
            FMDBDatabaseModel.getInstance().updateFavoriteData(questionId: currentQuestionModel.QuestionId, isFavorite: true)
            isFavorite.setImage(UIImage(named: "is-favorite.png"), for: .normal)
            currentQuestionModel.IsFavorite = true
        }
  
    }
    
    @IBAction func confirmAnswerQuestion(_ sender: Any) {
        
        let cells = questionAnswers.visibleCells as! Array<QuestionTableViewCell>
        
        for cell in cells
        {
            cell.borderColorLeft.isHidden = false
        }
        
        if currentQuestionModel.IsCheckQuestion
        {
     
        }
        else
        {
            let checkAnswer = checkCorrectAnswerForQuestion()
            
            if(checkAnswer)
            {
                FMDBDatabaseModel.getInstance().updateNumberNotCorrectData(questionId: currentQuestionModel.QuestionId, numberNotCorrect: currentQuestionModel.NumberNoCorrect - 1)
            }
            else
            {
                FMDBDatabaseModel.getInstance().updateNumberNotCorrectData(questionId: currentQuestionModel.QuestionId, numberNotCorrect: currentQuestionModel.NumberNoCorrect + 1)
                
            }
            currentQuestionModel.IsCheckQuestion = true
        }
        
        confirmAnswerButton.setImage(UIImage(named: "confirmAnswerDisable.png"), for: .normal)
        confirmAnswerButton.isEnabled = false
        questionAnswers.allowsSelection = false
        
        answerPopupView.isHidden = false
        
    }
    
    @IBAction func closedPopupAnswerPopup(_ sender: Any) {
        
        answerPopupView.isHidden = true
        
        iconAnswerQuestion.isHidden = false
        
    }
    
    @IBAction func showPopupAnswerView(_ sender: Any) {
        
        answerPopupView.isHidden = false
        
        iconAnswerQuestion.isHidden = true
        
    }
    
    func checkCorrectAnswerForQuestion() -> Bool {
        
        for answer in currentQuestionModel.AnswersText
        {
            if answer.IsCorrect
            {
                if !answer.IsCheckAnswer
                {
                    return false
                }
            }
        }
        return true
    }
    
    func checkCorrectAnswer(listAnswers: [AnswersModel]) -> Bool {
        
        for answer in listAnswers
        {
            if answer.IsCorrect
            {
                if !answer.IsCheckAnswer
                {
                    return false
                }
            }
        }
        return true
    }
    
    func checkIsFavorite()
    {
        if currentQuestionModel.IsFavorite
        {
            isFavorite.setImage(UIImage(named: "is-favorite.png"), for: .normal)
        }
        else
        {
            isFavorite.setImage(UIImage(named: "favorite.png"), for: .normal)
        }
    }
    
    func bindEventForTableAnswer()
    {
        if currentQuestionModel.HasImage
        {
            let image = UIImage(named: "Cau_\(currentQuestionModel.QuestionId).jpg")
            if image == nil
            {
                questionImage.image! = UIImage(named: "default_image.png")!
            }
            else
            {
                questionImage.image = image
            }
        }
        else
        {
            // questionImageHeight.constant = 0
            // questionAnswersTop.constant = 8
            
        }
        
        self.questionAnswers.tableFooterView = UIView(frame: .zero)
        self.questionAnswers.rowHeight = UITableView.automaticDimension
        self.questionAnswers.estimatedRowHeight = 300
        self.questionAnswers.allowsMultipleSelection = true

    }
    
    func checkDirection()
    {
        if positionItem >= questionModels.count - 1
        {
            nextButton.isEnabled = false
            nextButton.setImage(UIImage(named: "nextDisable.png"), for: .normal)
        }
        else
        {
            nextButton.isEnabled = true
            nextButton.setImage(UIImage(named: "nextEnable.png"), for: .normal)
        }
        if(positionItem <= 0)
        {
            backButton.isEnabled = false
            backButton.setImage(UIImage(named: "backDisable.png"), for: .normal)
        }
        else
        {
            backButton.isEnabled = true
            backButton.setImage(UIImage(named: "backEnable.png"), for: .normal)
        }
    }
    
}
