//
//  HocLuatTableViewController.swift
//  HLGT
//
//  Created by MAC on 7/24/17.
//  Copyright © 2017 MAC. All rights reserved.
//

import UIKit

struct menuHocLuatCellData {
    let menuBarText: String!
    let menuBarIcon: UIImage!
}

class HocLuatTableViewController: UITableViewController {
    
    var getAllDataCategory = NSMutableArray()
    
    @IBOutlet weak var menuBarBtn: UIBarButtonItem!
    
    
    
    var menuHocLuatCellDatas = [menuHocLuatCellData]()

    override func viewDidLoad() {
        super.viewDidLoad()

        
        menuBarBtn.target = revealViewController()
        menuBarBtn.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        navigationController?.navigationBar.tintColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        navigationController?.navigationBar.barTintColor = UIColor(red: 42/255, green: 210/255, blue: 201/255, alpha: 1.0)
        navigationController?.navigationBar.titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue: UIColor.white])
        
        menuHocLuatCellDatas = [menuHocLuatCellData(menuBarText: "Những Câu Hay Trả Lời Sai", menuBarIcon: #imageLiteral(resourceName: "menu-hoc-luat")),
                                menuHocLuatCellData(menuBarText: "Những Câu Đánh Dấu", menuBarIcon: #imageLiteral(resourceName: "menu-hoc-luat")),
                                menuHocLuatCellData(menuBarText: "Khái Niệm Và Quy Tắc", menuBarIcon: #imageLiteral(resourceName: "menu-hoc-luat")),
                                menuHocLuatCellData(menuBarText: "Nghiệp Vụ Vận Tải", menuBarIcon: #imageLiteral(resourceName: "menu-thi-thu")),
                                menuHocLuatCellData(menuBarText: "Đạo Đức Nghề Nghiệp", menuBarIcon: #imageLiteral(resourceName: "menu-meo")),
                                menuHocLuatCellData(menuBarText: "Kỹ Thuật Lái Xe", menuBarIcon: #imageLiteral(resourceName: "menu-meo")),
                                menuHocLuatCellData(menuBarText: "Cấu Tạo Và Sửa Chữa", menuBarIcon: #imageLiteral(resourceName: "menu-meo")),
                                menuHocLuatCellData(menuBarText: "Hệ Thống Biển Báo", menuBarIcon: #imageLiteral(resourceName: "menu-meo")),
                                menuHocLuatCellData(menuBarText: "Sa Hình", menuBarIcon: #imageLiteral(resourceName: "menu-meo"))]

        getAllDataCategory = FMDBDatabaseModel.getInstance().GetAllDataCategory()
        
        tableView.separatorColor = UIColor.red
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return getAllDataCategory.count
        }
    
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
            let cell = tableView.dequeueReusableCell(withIdentifier: "HocLuatViewCell") as! HocLuatTableViewCell
    
            var category = CategoryModel()
            category = getAllDataCategory.object(at: indexPath.row) as!  CategoryModel
            let imageCategory = category.CategoryImage + ".png"
            cell.hocLuatImage.image =  UIImage(named: imageCategory)
            cell.hocLuatTitle.text! = category.CategoryName
            cell.categoryId.text = "\(category.CategoryId)"
            
            return cell
        }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
    
        if(segue.identifier == "getQuestionByCategoryId"){
            
//            var selectedRow = self.tableView.indexPathForSelectedRow
//            let questionView : QuestionViewController = segue.destination as! QuestionViewController
//
//            var category = CategoryModel()
//            category = getAllDataCategory.object(at: (selectedRow?.row)!) as!  CategoryModel
//
//            questionView.categoryId = category.CategoryId as Int
//            questionView.categoryName = category.CategoryName as String
        }
    }

}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
