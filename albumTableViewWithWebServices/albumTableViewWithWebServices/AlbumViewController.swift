//
//  ViewController.swift
//  albumTableViewWithWebServices
//
//  Created by Mac on 05/08/23.
//

import UIKit

class AlbumViewController: UIViewController {

    @IBOutlet weak var albumTableView: UITableView!
    //MARK : define reuseIdentifire for tableView cell
    private let reuseIdentifireForAlbumTableViewCell = "AlbumTableViewCell"
    
    //MARK : creating empty array for store Album object
    var albums : [Album] = []
    var uiNib : UINib?
   
    var url : URL?
    var urlResuest : URLRequest?
    var urlSession : URLSession?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        let urlString = "https://jsonplaceholder.typicode.com/albums"
        url = URL(string: urlString)
        
        urlResuest = URLRequest(url: url!)
        urlResuest?.httpMethod = "GET"
        urlSession = URLSession(configuration: .default)
        initViews()
        registerAnXIBForAlbumTableView()
        jsonParsing(urlRequest:urlResuest!, urlSession:urlSession!)
        
        
    }
    
    //MARK : creating initViews Function for DataSource and Delegate
    func initViews(){
        albumTableView.dataSource = self
        albumTableView.delegate = self
    }
    
    //MARK: creating Function for register an XIB to albumTableView
    func registerAnXIBForAlbumTableView(){
        uiNib = UINib(nibName: reuseIdentifireForAlbumTableViewCell, bundle: nil)
        self.albumTableView.register(uiNib, forCellReuseIdentifier: reuseIdentifireForAlbumTableViewCell)
        
    }
    //MARK : Creating function for JSONParsing
    
    func jsonParsing(urlRequest : URLRequest,urlSession : URLSession){
        var dataTask = urlSession.dataTask(with: urlRequest){data, response, erroe in
            
            let jsonResponse = try! JSONSerialization.jsonObject(with: data!) as! [[String:Any]]
            
            print(response)
            for eachJSONObject in jsonResponse{
                let albumObject = eachJSONObject
                let userId = eachJSONObject["userId"] as! Int
                let id = eachJSONObject["id"] as! Int
                let title = eachJSONObject["title"] as! String
                let newAlbum : Album = Album(userId: userId, id: id, title: title)
                
                self.albums.append(newAlbum)
            }
            DispatchQueue.main.async {
                self.albumTableView.reloadData()
            }
        }
        dataTask.resume()
    }
}

//MARK : UITalbeViewDataSource
extension AlbumViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        albums.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let albumTableViewCell = self.albumTableView.dequeueReusableCell(withIdentifier: reuseIdentifireForAlbumTableViewCell, for: indexPath) as! AlbumTableViewCell
        albumTableViewCell.userIdLabel.text = String(albums[indexPath.row].userId)
        albumTableViewCell.idLabel.text = String(albums[indexPath.row].id)
        albumTableViewCell.titleLabel.text = albums[indexPath.row].title
        seperatorStyleForCell()
        return albumTableViewCell
        
    }
    //MARK : creating function for cell seperator style
    func seperatorStyleForCell(){
        albumTableView.separatorStyle = .singleLine
        albumTableView.separatorInset = .init(top: 20.0, left: 10.0, bottom: 20.0, right: 10.0)
        albumTableView.separatorColor = .black
    }
}

//MARK : UITableViewDelegate
extension AlbumViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        160.0
    }
}
