//
//  FileManagerService.swift
//  FileManager
//
//  Created by Fanil_Jr on 19.10.2022.
//

import Foundation

enum FileType: String {
    case folder = "NSFileTypeDirectory"
    case file = "NSFileTypeRegular"
}

struct ContentInfo {
    let url: URL
    let lastPath: String
    let fileType: FileType
}

protocol FileManagerServiceProtocol {
    var documentsUrl: URL {get}

    func contentsOfDirectory(url: URL?) -> Result<[ContentInfo], Error>
    func createDirectory(url: URL?)
    func createFile(file: Data, url: URL)
    func removeContent(url: URL)
}


final class FileManagerService: FileManagerServiceProtocol {

    private let fileManager = FileManager.default
    var documentsUrl: URL { getDocumentsUrl() }

    func contentsOfDirectory(url: URL?) -> Result<[ContentInfo], Error> {
        var result: [ContentInfo] = []
        let currentUrl = url ?? getDocumentsUrl()
        do {
            let contents = try fileManager.contentsOfDirectory(at: currentUrl, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for content in contents {
                do {
                    let attributes = try fileManager.attributesOfItem(atPath: content.path)
                    let lastPath = content.lastPathComponent
                    if let fileTypeString = attributes[FileAttributeKey.type] as? String {
                        let fileType: FileType = (fileTypeString == FileType.folder.rawValue) ? .folder : .file
                        result.append(ContentInfo(url: content, lastPath: lastPath, fileType: fileType))
                    }
                } catch let error {
                    return .failure(error)
                }
            }
        } catch let error {
            return .failure(error)
        }
        return .success(result)
    }

    func createDirectory(url: URL?) {
        guard let url = url else { return }
        try? fileManager.createDirectory(at: url, withIntermediateDirectories: false, attributes: nil)
        print("Create folder \(url.lastPathComponent)")
    }

    func createFile(file: Data, url: URL) {
        var result: Bool?
        result = fileManager.createFile(atPath: url.path, contents: file, attributes: nil)
        if let _ = result {
            print("Create file successful")
        } else {
            print("File not created")
        }
    }

    func removeContent(url: URL) {
        try? fileManager.removeItem(at: url)
        print("Remove content")
    }

    private func getDocumentsUrl() -> URL {
        try! fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    }
}
