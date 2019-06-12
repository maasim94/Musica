//
//  TableViewExtension.swift
//  Musica
//
//  Created by Arslan Asim on 10/06/2019.
//  Copyright © 2019 Arslan Asim. All rights reserved.
//

import UIKit

extension UITableView  {
    func registerNib<T: UITableViewCell>(_: T.Type)  {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.identifierCell, bundle: bundle)
        
        register(nib, forCellReuseIdentifier: T.identifierCell)
    }
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T  {
        guard let cell = dequeueReusableCell(withIdentifier: T.identifierCell, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.identifierCell)")
        }
        return cell
    }
}
extension UICollectionView  {
    func registerNib<T: UICollectionViewCell>(_: T.Type)  {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.identifierCell, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: T.identifierCell)
    }
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T  {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.identifierCell, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.identifierCell)")
        }
        return cell
    }
}
public protocol Reusable {
    static var identifierCell: String { get } // reuse Identifer is also nib name
}
extension UITableViewCell: Reusable {
    public static var identifierCell: String { return String(describing: self)}
}
extension UICollectionViewCell: Reusable {
    public static var identifierCell: String { return String(describing: self)}
}
