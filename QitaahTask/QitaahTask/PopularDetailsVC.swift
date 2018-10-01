//
//  PopularDetailsVC.swift
//  QitaahTask
//
//  Created by mac on 9/30/18.
//  Copyright © 2018 amany. All rights reserved.
//

import UIKit
import ImageSlideShowSwift

class PopularDetailsVC: UIViewController {
    @IBOutlet var mainImg: UIImageView!
    @IBOutlet var DescriptionLabel: UILabel!
    @IBOutlet var movieImgsCollectionView: UICollectionView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var BDLabel: UILabel!
    @IBOutlet var JobLabel: UILabel!
    @IBOutlet var Loadingview: LoadingView!
    @IBOutlet var nonetview: NoNetView!
    
    private var images:[Image] = []
    var detailsObj:PersonDetails?
    var detailsImg:[PersonImagesObject]?
    var personID = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        detailsImg = [PersonImagesObject]()
        self.featchData()
        NotificationCenter.default.addObserver(self, selector: #selector(PopularDetailsVC.featchData), name: Notification.Name("reloadDetails"), object: nil)


        // Do any additional setup after loading the view.
    }
    @objc func featchData(){
 if Reachability.isConnectedToNetwork() == true {
    self.Loadingview.alpha = 1
        LibraryApi.sharedInstance.PersonDetailsRequest(person_id: personID, completion: {
            Responsesucses,populardetails,popularArr  in
            guard Responsesucses else {
                self.view.makeToast(message:"can't load details now please try again later", duration: 1.0, position: HRToastPositionCenter as AnyObject, title: "error")
                return
            }
            self.Loadingview.alpha = 0
            self.nonetview.alpha = 0
            self.detailsObj = populardetails
            self.detailsImg = popularArr
            self.setBasicInfo()
            self.generateImages()
            self.configurcollection()
            self.movieImgsCollectionView.reloadData()

        })
        }
 else {
    self.Loadingview.alpha = 0
       self.nonetview.alpha = 1

        self.navigationController?.view.makeToast(message:"please check your connection" , duration: 1.5, position: HRToastPositionDefault as AnyObject, title:"Error")

    
        }


    }


    private func generateImages()
    {

        for obj in detailsImg! {
            let imageStr = "\(LibraryApi.APIConstants.originalImagePath)\((obj.file_path)!)"
            if let mainImageURL = URL(string: imageStr){
                let Im = Image(url: mainImageURL)
                images.append(Im)
            }
        }

    }

    func setBasicInfo(){
        let mainimageStr = "\(LibraryApi.APIConstants.ImagePath)\((detailsObj!.profile_path)!)"
        if let mainImageURL = URL(string: mainimageStr){
            self.mainImg.hnk_setImageFromURL(mainImageURL)
            self.mainImg.dropShadow()
        }
        nameLabel.text = detailsObj?.name
        DescriptionLabel.text = detailsObj?.biography
        BDLabel.text = detailsObj?.birthday
        JobLabel.text = detailsObj?.known_for_department
    }
    func configurcollection(){
        movieImgsCollectionView.register(UINib.init(nibName: "CollectionImgCell", bundle: nil), forCellWithReuseIdentifier: "CollectionImgCell")

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if let flowLayout = movieImgsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */

}
extension PopularDetailsVC:UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        ImageSlideShowViewController.presentFrom(self){ [weak self] controller in

            controller.dismissOnPanGesture = true
            controller.slides = self?.images
            controller.enableZoom = true
            controller.controllerDidDismiss = {
            }
            controller.goToPage(withIndex: indexPath.row)

        }


    }
}
extension PopularDetailsVC:UICollectionViewDataSource{

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:CollectionImgCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionImgCell", for: indexPath) as! CollectionImgCell
        let imageStr = "\(LibraryApi.APIConstants.ImagePath)\((detailsImg![indexPath.row].file_path)!)"
        if let mainImageURL = URL(string: imageStr){
            cell.MovieImg.hnk_setImageFromURL(mainImageURL)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (detailsImg?.count)!
    }





}
class Image:NSObject, ImageSlideShowProtocol
{
    fileprivate let url:URL

    init(url:URL) {
        self.url = url
    }

    func slideIdentifier() -> String {
        return String(describing: url)
    }

    func image(completion: @escaping (_ image: UIImage?, _ error: Error?) -> Void) {

        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: self.url) { data, response, error in

            if let data = data, error == nil
            {
                let image = UIImage(data: data)
                completion(image, nil)
            }
            else
            {
                completion(nil, error)
            }

            }.resume()

    }
}
