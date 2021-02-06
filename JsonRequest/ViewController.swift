//
//  ViewController.swift
//  JsonRequest
//
//  Created by 王凯霖 on 2/6/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = "https://api.sunrise-sunset.org/json?lat=36.7201600&lng=-4.4203400"
        getData(from: url)
    }

    
    func getData(from url: String){
        let session = URLSession.shared
        let task = session.dataTask(with: URL(string: url)!, completionHandler: { data, response, error in
            guard let revData = data, error == nil else{
                print("URL获取数据失败")
                return
            }

            //获取到了数据
            var res: Response?
            do{
                res = try JSONDecoder().decode(Response.self, from: revData)
            }
            catch{
                print("Json转struct失败\(error)")
            }
            
            if let json = res {
                print(json.results)
                print(json.status)
               
            }
        })
        
        task.resume()
    }
    

}







