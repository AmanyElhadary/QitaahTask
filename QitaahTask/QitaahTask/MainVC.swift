//
//  ViewController.swift
//  QitaahTask
//
//  Created by mac on 9/28/18.
//  Copyright © 2018 amany. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper


class MainVC: UIViewController {



    var popularDataArr:[popularObject]=[popularObject]()
    var popularFilteredDataArr:[popularObject]=[popularObject]()

    @IBOutlet var popularTable: UITableView!
    @IBOutlet var LoadingView: LoadingView!
    @IBOutlet var loadingindicator: UIActivityIndicatorView!
    @IBOutlet var nonetview: NoNetView!
    let searchController = UISearchController(searchResultsController: nil)

    var PageNum = 1
    var showSearchBar =  0
    var noDataMore = false
    lazy var searchtext = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        LoadingView.alpha = 1

        let nib = UINib(nibName: "popularCell", bundle: nil)
        popularTable.register(nib, forCellReuseIdentifier: "popularCell")
        GetPopularData()



        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search popluar"
        searchController.searchBar.barTintColor = #colorLiteral(red: 0.9371048808, green: 0.9410254955, blue: 0.962559998, alpha: 1)
        definesPresentationContext = true

        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(MainVC.GetPopularData), name: Notification.Name("reload"), object: nil)

    }

    @IBAction func searchNavAction(_ sender: Any) {
        guard showSearchBar == 0 else {

            popularTable.tableHeaderView = nil // hide search bar
            searchController.isActive = false
            showSearchBar =  0
            return
        }
        popularTable.setContentOffset(.zero, animated: true)
        self.popularTable.tableHeaderView = self.searchController.searchBar // show search bar
        showSearchBar = 1

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.

    }



    @objc func GetPopularData(){
        loadingindicator.alpha=1
        if (self.PageNum == 1 ){
            self.LoadingView.alpha = 1
        }
          if Reachability.isConnectedToNetwork() == true {


            DispatchQueue.main.async {
                LibraryApi.sharedInstance.PopularRequest(pagenum: self.PageNum,completion: {
            Responsesucses,popularArr  in
            guard (Responsesucses) else {
                self.view.makeToast(message:"error occurred please try again ", duration: 1.0, position: HRToastPositionCenter as AnyObject, title: "error")
                return
            }
            guard (!(popularArr.isEmpty))else {
                self.noDataMore = true
                self.loadingindicator.alpha = 0
                 self.LoadingView.alpha = 0
                self.view.makeToast(message:"no Data to view ", duration: 1.0, position: HRToastPositionCenter as AnyObject, title: "Empty")


                return
            }
            print("GetData paging \(self.PageNum)")
            if self.isFiltering() {

                let popularArrFilterd = popularArr.filter{($0.name?.lowercased().contains(self.searchtext.lowercased()))!}
                self.popularFilteredDataArr.append(contentsOf: popularArrFilterd)

            }
            else {
            self.popularDataArr.append(contentsOf: popularArr)
            }
            self.LoadingView.alpha = 0
            self.nonetview.alpha = 0
            self.loadingindicator.alpha = 0
                    DispatchQueue.main.async {
                        self.popularTable.reloadData()
                        self.popularTable.layoutIfNeeded()
                    
                    }

        })


        }

        }
          else {

            if (self.PageNum == 1 ){
                self.LoadingView.alpha = 0
                self.loadingindicator.alpha = 0
                self.loadingindicator.stopAnimating()
                nonetview.alpha = 1

            }
            self.navigationController?.view.makeToast(message:"please check your connection" , duration: 1.5, position: HRToastPositionDefault as AnyObject, title:"Error")


        }

    }

      // MARK: - Private instance methods for saerch bar
    func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    func isFiltering() -> Bool {
        return searchController.isActive && (!searchBarIsEmpty())
    }

    



}
extension MainVC : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        searchtext = text

    }




}

extension MainVC : UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.PageNum = 1
        self.popularTable.reloadData()

    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.PageNum = 1
        searchBar.resignFirstResponder()
        if searchtext.count > 0 {
                        self.popularFilteredDataArr = self.popularDataArr.filter{($0.name?.lowercased().contains(searchtext.lowercased()))!}

                        self.popularTable.reloadData()
                    }else {
                        self.popularTable.reloadData()
                    }
    }


}
extension MainVC : UITableViewDelegate{

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 231.5
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {


        let lastrow = tableView.numberOfRows(inSection: 0)
        //print ("lastrow \(lastrow)")
        //print("indexrow \(indexPath.row)")
        if(indexPath.row == lastrow - 1  && self.PageNum  < 896){
            if (self.PageNum < 896){
            self.PageNum = self.PageNum + 1
            if noDataMore == false {
                self.GetPopularData()
            }
        }
            else
            {
                    self.view.makeToast(message: "there is no other data ", duration: 1.0, position: HRToastPositionDefault as AnyObject)


            }
        }


    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var id:Int = 0
        if (isFiltering()){
            if popularFilteredDataArr.count > 0 {
                id = popularFilteredDataArr[indexPath.row].id!

            }
        }else
        {
            if popularDataArr.count > 0 {
                id = popularDataArr[indexPath.row].id!

            }

        }

//        LibraryApi.sharedInstance.PersonDetailsRequest(person_id: id, completion: {
//                    Responsesucses,populardetails,popularArr  in
//            guard Responsesucses else {
//                self.view.makeToast(message:"can't load details now please try again later", duration: 1.0, position: HRToastPositionCenter as AnyObject, title: "error")
//                return
//            }
            let mainStoryBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let DetailVc = mainStoryBoard.instantiateViewController(withIdentifier: "PopularDetailsVC") as! PopularDetailsVC
            DetailVc.personID = id
            self.navigationController?.pushViewController(DetailVc, animated: true)


          //  })


    }


}
extension MainVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {


        return popularFilteredDataArr.count
        }
        else
        {
            return popularDataArr.count
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "popularCell") as! popularCell
        let popularObj: popularObject
        if popularDataArr.count > 0 {
            if isFiltering() {
                popularObj = popularFilteredDataArr[indexPath.row]
            }
            else
            {
                popularObj = popularDataArr[indexPath.row]

            }
            cell.popularObj_ = popularObj
        }
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.clear
        cell.selectedBackgroundView = backgroundView
        return cell
    }



}


