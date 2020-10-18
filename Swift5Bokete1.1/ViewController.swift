//
//  ViewController.swift
//  Swift5Bokete1.1
//
//  Created by 坂本龍哉 on 2020/10/18.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage
import Photos

class ViewController: UIViewController {
 
    @IBOutlet weak var odaiImageView: UIImageView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.layer.cornerRadius = 20.0
        
        PHPhotoLibrary.requestAuthorization { (states) in
            
            switch(states){
            case .authorized:
                break
            case .denied:
                break
            case.notDetermined:
                break
            case.restricted:
                break
            case .limited:
                break
            @unknown default:
                break
            }
        }
        
        getImages(keyword: "funny")
    }
    
    //検索キーワードの値の元の画像を引っ張ってくる
    //pixabay.com
    func getImages(keyword:String){
        
        
        //APIKEY   18287181-510574e77736a950e09af9a76
        let url = "https://pixabay.com/api/?key=18287181-510574e77736a950e09af9a76&q=\(keyword)"
        
        //Alamofireを使ってhttpリクエストを投げる
        //methodにはgetかpostの２通りの投げ方がある（後で調べる。ほぼ同じらしい、）
        //parametersはurlのところで\(keyword)と書いたのでnilでいい
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default).responseJSON { (response) in
            //この中が後で呼ばれて、その結果がresponseの中に入る
            switch response.result{
            
            case .success:
                //データを取得してjsonに入れる
                let json:JSON = JSON(response.data as Any)
                //countは、取ってきたい画像の配列の番号のこと。次へボタンで＋１するように指定して画像を変更できるようにする
                var imageString = json["hits"][self.count]["webformatURL"].string
                
                if imageString == nil{
                    var imageString = json["hits"][self.count]["webformatURL"].string
                    self.odaiImageView.sd_setImage(with: URL(string: imageString!), completed: nil)
                }else{
                
                self.odaiImageView.sd_setImage(with: URL(string: imageString!), completed: nil)
                }
                
            case .failure(let error):
                print(error)
            
                
                
                
            }
        }
        //値が返ってくるのでjson解析を行う
        //imageView.imageに貼り付ける
        
    }
    
    @IBAction func nextOdai(_ sender: Any) {
        count += 1
        
        if searchTextField.text == ""{
           getImages(keyword: "funny")
        }else{
            getImages(keyword: searchTextField.text!)
        }
    }
    
    @IBAction func searchAction(_ sender: Any) {
        self.count = 0
        if searchTextField.text == ""{
           getImages(keyword: "funny")
        }else{
            getImages(keyword: searchTextField.text!)
        }
        
    }
    
    @IBAction func next(_ sender: Any) {
        performSegue(withIdentifier: "next", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let shareVC = segue.destination as? ShareViewController
        shareVC?.commemtString = commentTextView.text
        shareVC?.resultImage = odaiImageView.image!
    }
}

