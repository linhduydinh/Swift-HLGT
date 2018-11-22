//
//  LamBaiViewController.swift
//  HLGT
//
//  Created by MAC on 9/12/17.
//  Copyright © 2017 MAC. All rights reserved.
//

import UIKit

class LamBaiViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate {

    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var showListQuestionsButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var tamDungButton: UIButton!
    
    @IBOutlet weak var collectionQuestionView: UIView!
    @IBOutlet weak var questionView: UIView!
    @IBOutlet weak var collectionViewQuestionPopup: UICollectionView!
    
    
    @IBOutlet weak var questionName: UILabel!
    @IBOutlet weak var questionAnswers: UITableView!
    @IBOutlet weak var questionImage: UIImageView!
    
    @IBOutlet weak var questionAnswerTop: NSLayoutConstraint!
    @IBOutlet weak var questionImageHeight: NSLayoutConstraint!
    
    var getAllDataQuestionByCategoryId = NSMutableArray()
    var currentQuestionModel = QuestionModel()
    var questionModels = [QuestionModel]()
    var positionItem = 0
    
    
    var seconds = 1800
    var timer = Timer()
    var isTimerRunning = false
    var resumeTapped = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        navigationController?.navigationBar.barTintColor = UIColor(red: 42/255, green: 210/255, blue: 201/255, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue: UIColor.white])
        
        self.title = timeString(time: TimeInterval(seconds))
        runTimer()
        
        getAllDataQuestionByCategoryId = FMDBDatabaseModel.getInstance().GetAllDataQuestionByCategoryId(categoryId: 3)
        
        questionModels = getAllDataQuestionByCategoryId.copy() as! [QuestionModel]
        
        if(questionModels.count == 0)
        {
            questionView.isHidden = true
            
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
        
        collectionQuestionView.isHidden = true
    
        
    }
    
    @IBAction func huyBoFunc(_ sender: Any) {
        
        // create the alert
        let alert = UIAlertController(title: "UIAlertController", message: "Would you like to continue learning how to use iOS alerts?", preferredStyle: UIAlertController.Style.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Continue", style: UIAlertAction.Style.default, handler: nil))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.destructive, handler: { action in
            
            // do something like...
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)

        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return currentQuestionModel.AnswersText.count
        
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
        
        cell.answerId?.text = "\(currentQuestionModel.AnswersText[indexPath.row].AnswerId)"
        
        cell.selectionStyle = .none
        
        return cell
        
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! QuestionTableViewCell
        
        cell.answerImage.layer.borderColor = UIColor.red.cgColor
        cell.answerImageText.textColor = UIColor.red
        
        //let answer = currentQuestionModel.AnswersText[indexPath.row]
        //answer.IsCheckAnswer = true
        
        let answer = currentQuestionModel.AnswersText.first(where: {$0.AnswerId == Int(cell.answerId.text!)!})
        answer?.IsCheckAnswer = true
//        for answer in currentQuestionModel.AnswersText
//        {
//            if answer.AnswerId == Int(cell.answerId.text!)!
//            {
//                answer.IsCheckAnswer = true
//            }
//        }
        
    }
    
    internal func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! QuestionTableViewCell
        
        cell.answerImage.layer.borderColor = UIColor.black.cgColor
        cell.answerImageText.textColor = UIColor.black
        let answer = currentQuestionModel.AnswersText[indexPath.row]
        answer.IsCheckAnswer = false
        
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
            questionImageHeight.constant = 0
            questionAnswerTop.constant = 8
            
        }
        
        self.questionAnswers.tableFooterView = UIView(frame: .zero)
        self.questionAnswers.rowHeight = UITableView.automaticDimension
        self.questionAnswers.estimatedRowHeight = 300
        self.questionAnswers.allowsMultipleSelection = true
        
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
    
    @IBAction func addOrRemoveIsFavorite(_ sender: Any) {
        
        if currentQuestionModel.IsFavorite
        {
            FMDBDatabaseModel.getInstance().updateFavoriteData(questionId: currentQuestionModel.QuestionId, isFavorite: false)
            favoriteButton.setImage(UIImage(named: "favorite.png"), for: .normal)
            currentQuestionModel.IsFavorite = false
        }
        else
        {
            FMDBDatabaseModel.getInstance().updateFavoriteData(questionId: currentQuestionModel.QuestionId, isFavorite: true)
            favoriteButton.setImage(UIImage(named: "is-favorite.png"), for: .normal)
            currentQuestionModel.IsFavorite = true
        }
        
    }
    
    
    func prepareQuestion(isBack : Bool){
        
        currentQuestionModel = questionModels[positionItem]
        
        self.questionAnswers.tableFooterView = UIView(frame: .zero)
        self.questionName.text = "Câu \(currentQuestionModel.QuestionId): " + self.currentQuestionModel.QuestionName

        
        checkIsFavorite()
        checkDirection()
        bindEventForTableAnswer()
        
        self.questionAnswers.reloadData()
        
        if currentQuestionModel.IsCheckQuestion
        {
            //confirmAnswerButton.setImage(UIImage(named: "confirmAnswerDisable.png"), for: .normal)
            //confirmAnswerButton.isEnabled = false
            let cells = questionAnswers.visibleCells as! Array<QuestionTableViewCell>
            
            for cell in cells
            {
                cell.borderColorLeft.isHidden = false
            }
            questionAnswers.allowsSelection = false

        }
        else
        {
            //confirmAnswerButton.setImage(UIImage(named: "confirmAnswerEnable.png"), for: .normal)
            //confirmAnswerButton.isEnabled = true
            let cells = questionAnswers.visibleCells as! Array<QuestionTableViewCell>
            for cell in cells
            {
                cell.borderColorLeft.isHidden = true
            }

        }
        
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
    
    func checkIsFavorite()
    {
        if currentQuestionModel.IsFavorite
        {
            favoriteButton.setImage(UIImage(named: "is-favorite.png"), for: .normal)
        }
        else
        {
            favoriteButton.setImage(UIImage(named: "favorite.png"), for: .normal)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func tamDungButtonFunc(_ sender: Any) {
        
        bindEventTimer()
        
    }
    
    
    
    func doneBtnAction(sender: UIBarButtonItem)
    {
        //self.navigationItem.rightBarButtonItem = playBtn
        //self.labelMusicState.text = "Music Not Playing"
    }

    func runTimer() {
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(LamBaiViewController.updateTimer)), userInfo: nil, repeats: true)
        
    }
    
    @objc func updateTimer() {
        
        if seconds < 1 {
            timer.invalidate()
            //Send alert to indicate time's up.
        } else {
            seconds -= 1
            self.title = timeString(time: TimeInterval(seconds))
        }
        
    }
    
    func timeString(time: TimeInterval) -> String {
        
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
        
    }
    
    func bindEventTimer()  {
        
        if self.resumeTapped == false {
            timer.invalidate()
            isTimerRunning = false
            self.resumeTapped = true
        } else {
            runTimer()
            self.resumeTapped = false
            isTimerRunning = true
        }
        
    }

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
