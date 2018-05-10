//
//  TableFaithStoryController.swift
//  NiemTinCoDoc
//
//  Created by Nguyen Hieu Trung on 4/10/18.
//  Copyright © 2018 NHTSOFT. All rights reserved.
//

import UIKit
import GoogleMobileAds

class TableFaithStoryController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, GADInterstitialDelegate {
    @IBOutlet weak var tblStory: UITableView!
    
    @IBOutlet weak var btnSearch: UIBarButtonItem!
    @IBOutlet weak var visualEffect: UIVisualEffectView!
    let searchbar = UISearchBar()
    var listFaithStory = [FaithStory]();
    var listFiltered = [FaithStory]();
    
//    //Bar button
//    var rightBarSearch:UIBarButtonItem!
    var leftBarBack:UIBarButtonItem!
    
    var searchActive:Bool = false

    //Admob
    var interstitial: GADInterstitial!

    override func viewDidLoad() {
        super.viewDidLoad()
        visualEffect.alpha = 0;
        
        //load database và lấy dữ liệu
        var dbsqlite = DatabaseSQLite(dbname: "NiemTinCoDocNhan", dbformat: "sqlite3");
        dbsqlite.GetConnection();
        self.listFaithStory = dbsqlite.SelectData();
        
        //TableView
        self.tblStory.dataSource = self;
        self.tblStory.delegate = self;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        //Khởi tạo admob
        interstitial = createAndLoadInterstitial()
        
//        rightBarSearch = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(self.RightBarSearchPress));
//
        leftBarBack = UIBarButtonItem(title: "Trở lại", style: .done, target: self, action: #selector(self.LeftBarBackPress));
    
        
        //CreateTitle();
        AddBarButtons();
        CreateSearchBar();
        self.tblStory.reloadData();
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        searchActive = false;
        //self.tblStory.reloadData();
        
        visualEffect.alpha = 0;
    }
    
    func AddBarButtons(){
        //self.navigationItem.setRightBarButton(rightBarSearch, animated: true);
        self.navigationItem.setLeftBarButton(leftBarBack, animated: true);
    }
    
    //Press Search
    @objc func RightBarSearchPress(){
        CreateSearchBar();
        searchbar.isHidden = false;
        self.navigationItem.setRightBarButtonItems(nil, animated: true);
        self.navigationItem.setLeftBarButton(nil, animated: true);
    }
    
    //Press Back
    @objc func LeftBarBackPress(){
        dismiss(animated: true, completion: nil);
    }
    
    //MARK: -Searchbar
    func CreateSearchBar(){
        searchbar.showsCancelButton = false;
        searchbar.text = "";
        searchbar.placeholder = "Tìm kiếm";
        searchbar.delegate = self;
        searchbar.isHidden = false;
        
        self.navigationItem.titleView = searchbar;
    }
    
    func CreateTitle(){
        let labelTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        labelTitle.text = "Niềm Tin Cơ Đốc Nhân";
        labelTitle.numberOfLines = 3;
        labelTitle.adjustsFontSizeToFitWidth = true;
        labelTitle.minimumScaleFactor = 0.5;
        labelTitle.textAlignment = NSTextAlignment.center;
        labelTitle.font = UIFont(name: "UVNDoiMoi", size: 25);
        self.navigationItem.titleView = labelTitle;
    }
    
    //Ẩn search và add lại barbutton
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        CreateTitle();
        searchbar.isHidden = true;
        searchBar.text = "";
        //Add Barbutton vào navigationbar
        //AddBarButtons();
        searchActive = false;
        self.tblStory.reloadData();
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }

    
    func XoaDauTiengViet(strIn: String)->String{
        var str = strIn;
        str = str.replacingOccurrences(of: "đ", with: "D");
        str = str.replacingOccurrences(of: "Đ", with: "D");
        var data = str.data(using: .ascii, allowLossyConversion: true);
        var strOut =  String(data: data!, encoding: String.Encoding.ascii);
        return strOut!;
    }
    
    //Thao tác search
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText);
        
        listFiltered = listFaithStory.filter { (faithstory) -> Bool in
            print(faithstory);
            let story:FaithStory = faithstory;
            var storynameXD = XoaDauTiengViet(strIn: story.StoryName);
            var searchtextXD = XoaDauTiengViet(strIn: searchText);
            
            let range = storynameXD.range(of: searchtextXD, options: .caseInsensitive, range: nil, locale: nil);
            return range != nil;
        }
        
        if searchText == ""{
            searchActive = false;
        }else{
            searchActive = true;
        }
        
        print(listFiltered.count);
        
        self.tblStory.reloadData();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive){
            return listFiltered.count;
        }else{
            return listFaithStory.count;
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReuseCell", for: indexPath) as! StoryTVCell;
        //var story = listFaithStory[indexPath.row];
        var story: FaithStory!
        if(searchActive){
            story = listFiltered[indexPath.row];
        }else{
            story = listFaithStory[indexPath.row];
        }
        
        cell.lblStoryName.text = story.StoryName;
        //cell.lblStoryName.font = UIFont(name: "UVNHoaDao", size: 22);
        
        cell.imgIcon.image = UIImage(named: "BibleImage.png");
        
        cell.viewInCell.layer.borderColor = UIColor.white.cgColor;
        cell.viewInCell.layer.borderWidth = 2;
        cell.viewInCell.layer.cornerRadius = 10;
        cell.viewInCell.layer.shadowRadius = 20;
        cell.viewInCell.layer.shadowColor = UIColor.red.cgColor;
        return cell;
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let transform = CATransform3DTranslate(CATransform3DIdentity, self.view.bounds.size.width, 10, 0)
        cell.layer.transform = transform;
        
        UIView.animate(withDuration: 1.0) {
            cell.layer.transform = CATransform3DIdentity;
        }
    }
    
    //MARK: - Sự kiện Scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        visualEffect.alpha = 1;
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        visualEffect.alpha = 0;
    }
    
    //MARK: - Select Cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "SegueShowContent", sender: listFaithStory[indexPath.row]);
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
    }
    //Send dữ liệu qua segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let des = segue.destination as? FaithStoryContentController{
            if let story = sender as? FaithStory{
                des.currentStory = story;
            }
        }
    }
    
    //MARK: - ADMOB
    func createAndLoadInterstitial() -> GADInterstitial {
        //Test ADMOB Interstitial
        //var interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        
        //ADS ADMOB Intertitial
        var interstitial = GADInterstitial(adUnitID: "ca-app-pub-3167518105754283/4969039974")
        interstitial.delegate = self
        
        let request = GADRequest()
        //Chỉ dùng dòng này khi test device, khi add app thì xoá
        request.testDevices = [ "43744b22b205846017e49d0314e591e4", kGADSimulatorID];
        interstitial.load(request)
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
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
