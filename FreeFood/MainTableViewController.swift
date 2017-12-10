//
//  MainTableViewController.swift
//  FreeFood
//
//  Created by 김종현 on 2017. 11. 19..
//  Copyright © 2017년 김종현. All rights reserved.
//

import UIKit

class MainTableViewController: UIViewController, XMLParserDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var myActvityIndicator: UIActivityIndicatorView!
    
    var item:[String:String] = [:]
    var items:[[String:String]] = []
    var key = ""
    var servieKey = "aT2qqrDmCzPVVXR6EFs6I50LZTIvvDrlvDKekAv9ltv9dbO%2F8i8JBz2wsrkpr9yrPEODkcXYzAqAEX1m%2Fl4nHQ%3D%3D"
    var listEndPoint = "http://apis.data.go.kr/6260000/BusanFreeFoodProvidersInfoService/getFreeProvidersListInfo"
    let detailEndPoint = "http://apis.data.go.kr/6260000/BusanFreeFoodProvidersInfoService/getFreeProvidersDetailsInfo"
    
    var totalCount = 0 //총 갯수를 저장하는 변수

    override func viewDidLoad() {
        super.viewDidLoad()
        //myActvityIndicator.startAnimating()
        //getList(numOfRows: 0)
        // Do any additional setup after loading the view.
        myTableView.dataSource = self
        myTableView.delegate = self
        
        self.title = "부산 무료 급식소"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
//        let fileManager = FileManager.default
//        let url = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("data.plist")
        
//        print("file path = \(String(describing: url))")
//
//        시작할때마다 TotalCount를 받아옴
//        getList(numOfRows: 0)
//
//        if fileManager.fileExists(atPath: (url?.path)!) {
//            //파일이 있으면 파일에서 읽어옴
//            items = NSArray(contentsOf: url!) as! Array
//
//            //파일에서 읽어본 갯수와 totalCount를 비교
//            if (items.count != totalCount) {
//                //파일에서 읽어본 갯수와 totalCount가 다르면(변화가 있으면) 다시 읽어와서 저장
//                getList(numOfRows: totalCount)
//                saveDetail(url: url!)
//            }
//        } else {
//            //******* 파일이 없으면
//            getList(numOfRows: totalCount)
//            saveDetail(url: url!)
//        }
        
        let path = Bundle.main.path(forResource: "data", ofType: "plist")
        items = NSArray(contentsOfFile: path!) as! [[String : String]]
        
        //saveDetail(url: url!)
        
        myTableView.reloadData()
 
    }
    
    func getList(numOfRows:Int) { //numOfRows를 입력
        //let str = detailEndPoint + "?serviceKey=\(servieKey)&numsofRows=20"
        let str = listEndPoint + "?serviceKey=\(servieKey)&numOfRows=\(numOfRows)"
        print(str)
            
        if let url = URL(string: str) {
            if let parser = XMLParser(contentsOf: url) {
                
                parser.delegate = self
                let success = parser.parse()
                if success {
                    print("parse success in getList")
                    print("totalCount = \(totalCount)")
                    
                } else {
                    print("parse failed in hetList")
                }
            }
        }
    }
    
    func getDetail(idx: String) {
        let str = detailEndPoint + "?serviceKey=\(servieKey)&idx=\(idx)"
        
        if let url = URL(string: str) {
            if let parser = XMLParser(contentsOf: url) {
                parser.delegate = self
                let success = parser.parse()
                if success {
                    print("parse success in getDetail")
                    //print(items)
                    
                } else {
                    print("parse fail in getDeatil")
                }
            }
        }
    }
    
    //*******새로 추가된 함수 - 목록데이터를 가지고 상세데이터를 가져와서 저장하는 함수
    // Detail Data 가져오는 부분을 saveDetail 메소드로 extract
    func saveDetail(url:URL) {
        
        // "loc" key로 items를 sort
        let sortedItems = items.sorted{($1["loc"])! > ($0["loc"])!}
        let tempItems = sortedItems  // tableView에서 재활용
        //print("items = \(items)")
        
        items = []
        
        //-----------------thread controll----------------------
        //-------DispatchQueue선언(멀티 thread)-------------------
        //qos 속성에 따라 우선순위 변경
        let equeue = DispatchQueue(label:"com.yangsoo.queue", qos:DispatchQoS.userInitiated)
        //-------xml parxer(background thread사용)---------------
        equeue.async {
            for dic in tempItems {
                // 상세 목록 파싱
                self.getDetail(idx: dic["idx"]!)
                //-------tableview(main thread사용(ui는 main thread 사용 필수))---
                DispatchQueue.main.async {
                    self.myTableView.reloadData()
                    //let temp = self.items as NSArray  // NSArry는 화일로 저장하기 위함
                    //temp.write(to: url, atomically: true)
                }
            }

        }
        //-----------------thread controll------------------------
    }
 
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        //key = elementName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        key = elementName
        if key == "item" {
            item = [:]
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        // foundCharacters가 두번 호출
        if item[key] == nil {
            item[key] = string.trimmingCharacters(in: .whitespaces)
            //print("item(\(key)) = \(item[key])")
            
            //*******key가 totalCount 이면 totalCount 변수에 저장
            if key == "totalCount" {
                totalCount = Int(string.trimmingCharacters(in: .whitespaces))!
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            items.append(item)
        }
    }

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Configure the cell...
        // cell이 11개가 되면 Activity Indicator를 stop & Hide
//        if indexPath.row == 11 {
//                self.myActvityIndicator.stopAnimating()
//                self.myActvityIndicator.hidesWhenStopped = true
//        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RE", for: indexPath)
        
        let dic = items[indexPath.row]
        cell.textLabel?.text = dic["loc"]
        cell.detailTextLabel?.text = dic["addr"]
        
        return cell
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "goTotalMap" {
            let totalMVC = segue.destination as! TotalMapViewController
            totalMVC.tItems = items
            
        } else if segue.identifier == "goSingleMap" {
            let singleMTVC = segue.destination as! SingleMapTableViewController
            let selectedIndex = myTableView.indexPathForSelectedRow
            singleMTVC.sItem = items[(selectedIndex?.row)!]
            
        }
    }
    
}
