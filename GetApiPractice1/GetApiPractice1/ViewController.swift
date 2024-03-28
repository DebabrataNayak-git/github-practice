//
//  ViewController.swift
//  GetApiPractice1
//
//  Created by iOS Developer on 02/02/24.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var table1: UITableView!
        var getApi = GetApi()
        var ProductArray:[Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        table1.register(UINib(nibName: "ProductXib", bundle: nil), forCellReuseIdentifier: "cell2")
        hitGetApi()
    
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProductArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! ProductXib
        cell.idLable.text = String(ProductArray[indexPath.row].id)
        cell.priceLable.text = String(ProductArray[indexPath.row].userId)
        cell.titleLable.text = ProductArray[indexPath.row].title
        cell.descriptionLable.text = ProductArray[indexPath.row].body
        return cell
    }
    
    func hitGetApi(){
        getApi.getApiFunc{[weak self] result in
            switch result {
            case.success(let success):
                self?.ProductArray = success
                DispatchQueue.main.async{
                    self?.table1.reloadData()
                }
            case.failure(let error):
                switch error{
                case.invalidUrl:
                    print("invalid url")
                    
                case.noData:
                    print("No Data")
                    
                case.DecodingError:
                    print("Decoding Error")
                }
            }
        }
    }

    class GetApi{
       static let shared = GetApi()
        init(){}
        
        let stringToUrl = "https://jsonplaceholder.typicode.com/posts"
        
        func getApiFunc(complitionHandler:@escaping(Result<[Product],getProductError>)->Void){
            
            let urlSession = URLSession.shared
            
            guard let url = URL(string: "stringToUrl") else{
                complitionHandler(.failure(.invalidUrl))
                return
            }
            
            let task = urlSession.dataTask(with: url){ data, response, error in
                if error != nil {
                    complitionHandler(.failure(.DecodingError))
                    return
                }
                guard let data else{
                    complitionHandler(.failure(.noData))
                    return
                }
                do{
                    let decodejson = try JSONDecoder().decode([Product].self, from: data)
                    complitionHandler(.success(decodejson))
                }
                catch{
                    complitionHandler(.failure(.DecodingError))
                }
                
            }
            task.resume()
        }
        
    }
    
    
    enum getProductError: Error {
        case invalidUrl
        case DecodingError
        case noData
    }
    
    struct Product:Codable {
        let userId: Int
        let id: Int
        let title: String
        let body: String
    }
    
}

