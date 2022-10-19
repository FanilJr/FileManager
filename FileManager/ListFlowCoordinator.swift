//
//  ListFlowCoordinator.swift
//  FileManager
//
//  Created by Fanil_Jr on 19.10.2022.
//

import Foundation
import UIKit

final class ListFlowCoordinator {

    private let fileManagerService: FileManagerServiceProtocol
    private lazy var navCon: UINavigationController = UINavigationController(rootViewController: ListViewController(coordinator: self, fileManagerService: fileManagerService, startUrl: fileManagerService.documentsUrl))

    //MARK: - Initialiser
    init(fileManagerService: FileManagerServiceProtocol) {
        self.fileManagerService = fileManagerService
    }

    func startApplication() -> UINavigationController {
        navCon.tabBarItem = UITabBarItem()
        return navCon
    }

    func push(startUrl: URL) {
        let vc = ListViewController(coordinator: self, fileManagerService: fileManagerService, startUrl: startUrl)
        navCon.pushViewController(vc, animated: true)
    }

    func pop() {
        navCon.popViewController(animated: true)
    }
}
