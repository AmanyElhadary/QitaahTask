//
//  ViewController.swift
//  QitaahTask
//
//  Created by mac on 9/28/18.
//  Copyright © 2018 amany. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    var popularDataArr:[popularObject]=[popularObject]()

    @IBOutlet var popularTable: UITableView!
    @IBOutlet var LoadingView: LoadingView!
    @IBOutlet var loadingindicator: UIActivityIndicatorView!
    var PageNum = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        LoadingView.alpha = 1

        let nib = UINib(nibName: "popularCell", bundle: nil)
        popularTable.register(nib, forCellReuseIdentifier: "popularCell")
        GetPopularData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }
    func GetPopularData(){
        loadingindicator.alpha=1
        LibraryApi.sharedInstance.PopularRequest(pagenum: PageNum,completion: {
            Responsesucses,popularArr  in
            print("GetData")
            self.popularDataArr.append(contentsOf: popularArr)
            self.LoadingView.alpha = 0
            self.loadingindicator.alpha = 0
            self.popularTable.reloadData()

        })

    }


}
extension MainVC : UITableViewDelegate{

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 231.5
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {


        let lastrow = self.popularTable.numberOfRows(inSection: 0)

        if(indexPath.row == lastrow - 1){
            self.PageNum = self.PageNum + 1
            if self.PageNum <= 10 {
                self.GetPopularData()
            }else {
                self.view.makeToast(message: "there is no other data ", duration: 1.0, position: HRToastPositionCenter as AnyObject, title: "")
            }
        }

    }


}
extension MainVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return popularDataArr.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "popularCell") as! popularCell
        if popularDataArr.count > 0 {
            cell.popularObj_ = popularDataArr[indexPath.row]
        }
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
        return cell
    }



}


