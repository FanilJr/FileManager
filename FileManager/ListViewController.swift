//
//  ListViewController.swift
//  FileManager
//
//  Created by Fanil_Jr on 19.10.2022.
//

import Foundation
import UIKit

final class ListViewController: UIViewController {

    private lazy var listView = ListView()
    private let fileManagerService: FileManagerServiceProtocol
    private let coordinator: ListFlowCoordinator
    private var contentsInfo = [ContentInfo]()
    private let cuurentDirectoryUrl: URL

// MARK: - Initialiser
    init(coordinator: ListFlowCoordinator, fileManagerService: FileManagerServiceProtocol, startUrl: URL) {
        self.cuurentDirectoryUrl = startUrl
        self.coordinator = coordinator
        self.fileManagerService = fileManagerService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCicle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        listView.setTable(delegate: self, dataSource: self)
        reloadTable()
        layout()
    }

    private func setNavBar() {
        // Additional bar button items
        let button1 = UIBarButtonItem(image: UIImage(systemName: "folder.badge.plus"), style: .plain, target: self, action: #selector(self.newFolder))
        let button2 = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(self.newPhoto))

        navigationItem.setRightBarButtonItems([button2, button1], animated: true)
        navigationItem.backButtonTitle = cuurentDirectoryUrl.lastPathComponent
    }

    private func reloadTable() {
        let result = fileManagerService.contentsOfDirectory(url: cuurentDirectoryUrl)
        switch result {
        case .success(var contentsInfo):
            contentsInfo = listSort(contentsInfo)
            self.contentsInfo = contentsInfo
            listView.reloadTable()
        case .failure(let error):
            print(error.localizedDescription)
        }
    }

    private func createDirectory(path: String) {
        let directoryUrl = cuurentDirectoryUrl.appendingPathComponent(path)
        fileManagerService.createDirectory(url: directoryUrl)
        reloadTable()
    }

    @objc private func debug() {
        reloadTable()
    }

    @objc private func newFolder() {
        showNewFolderAlert()
    }

    @objc private func newPhoto() {
        print("Добавляем фото")
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    private func showNewFolderAlert() {
        let alert = UIAlertController(title: "Create new folder", message: "", preferredStyle: .alert)

        alert.addTextField { (textField: UITextField!) in
            textField.placeholder = "Folder name"
        }
        let addAction = UIAlertAction(title: "Create", style: .default) { action in
            if let textField = alert.textFields?[0]{
                guard let folderName = textField.text else { return }
                self.createDirectory(path: folderName)
                print(folderName)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(addAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }

    private func layout() {
        listView.translatesAutoresizingMaskIntoConstraints = false
        [listView].forEach { view.addSubview($0) }

        NSLayoutConstraint.activate([

            listView.topAnchor.constraint(equalTo: view.topAnchor),
            listView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            listView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func listSort(_ array: [ContentInfo]) -> [ContentInfo] {
        //сортировка по имени, фото и папки сортируются отдельно, папки всегда наверху
        var folders = [ContentInfo]()
        var photos = [ContentInfo]()
        for item in array {
            if item.fileType == .folder {
                folders.append(item)
            } else {
                photos.append(item)
            }
        }
        folders = folders.sorted(by: { $0.lastPath < $1.lastPath })
        photos = photos.sorted(by: { $0.lastPath < $1.lastPath })
        return folders + photos
    }
}

// MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contentsInfo.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let contentInfo = contentsInfo[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = "\(contentInfo.lastPath)"
        if contentInfo.fileType == .folder {
            content.image = UIImage(systemName: "folder")
            cell.accessoryType = .disclosureIndicator
        } else {
            content.image = UIImage(systemName: "photo")
        }
        content.imageProperties.maximumSize = CGSize(width: 60, height: 30)
        cell.contentConfiguration = content
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let content = contentsInfo[indexPath.row]
        if content.fileType == .folder {
            let folderUrl = content.url
            coordinator.push(startUrl: folderUrl)
        }
    }

    // Create a standard header that includes the returned text.
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //Для того чтобы заглавной была только первая буква, имя задаётся в настройках (шрифт, цвет, фон) заголовка
        return "_"
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {

    // Создаём константу, именна через неё мы будем обращаться к свойствам и изменять их
        let header = view as! UITableViewHeaderFooterView

    // Установить цвет текста в label
        header.textLabel?.textColor = .black

    // Установить цвет фона для секции
        header.tintColor = UIColor.white

    // Установить название для заголовка
        header.textLabel?.text = cuurentDirectoryUrl.lastPathComponent

    // Установить шрифт и размер шрифта для label
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 25)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            let fileUrl = contentsInfo[indexPath.row].url
            fileManagerService.removeContent(url: fileUrl)
            reloadTable()
        }
    }
}

// MARK: - ImagePicker delegate
extension ListViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let pickedImage = info[.originalImage] as? UIImage, let imageUrl = info[.imageURL] as? URL else { return }
        
        var imageNewUrl = cuurentDirectoryUrl
        imageNewUrl.appendPathComponent(imageUrl.lastPathComponent)
        fileManagerService.createFile(file: pickedImage.pngData()!, url: imageNewUrl)
        picker.dismiss(animated: true, completion: nil)
        reloadTable()
    }
}
