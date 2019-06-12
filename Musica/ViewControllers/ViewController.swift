//
//  ViewController.swift
//  Musica
//
//  Created by Arslan Asim on 09/06/2019.
//  Copyright © 2019 Arslan Asim. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let fetcher = DataFetcher()
        let realm = try! Realm()
        let obj =  realm.objects(Album.self)
        print(obj.count)
        
        fetcher.fetchNetworkData(method: .artist, queryParam: ["artist":"cher"]) { (errr:AppError?, code: ArtistRoot?) in
            fetcher.fetchNetworkData(method: .album, queryParam: ["mbid" : code!.artist.first!.mbid], completion: { (error:AppError?, album: AlbumRoot?) in
                if let first = album?.album.first {
                    fetcher.fetchNetworkData(method: .albumDetails, queryParam: ["mbid": first.mbid], completion: { (error:AppError?, album:AlbumDetailsRoot?) in
                        print(album)
                    })
//                    try!  realm.write {
//                        realm.add(first)
//                    }
                    
                }
            })
        }
        
        // Do any additional setup after loading the view.
    }


}

