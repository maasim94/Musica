//
//  Track.swift
//  Musica
//
//  Created by Arslan Asim on 10/06/2019.
//  Copyright © 2019 Arslan Asim. All rights reserved.
//

import UIKit
import RealmSwift

final class Track: Object, Decodable {
    @objc dynamic var name: String
    @objc dynamic var duration: String
}
