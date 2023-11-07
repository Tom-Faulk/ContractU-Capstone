//
//  FileUploading.swift
//  ContractU
//
//  Created by Tom Faulkner on 4/8/2021.
//

import Foundation

protocol FileUploading {}

extension FileUploading {
    func createRequestBody(
        parameters: [String: String]?,
        data: Data?,
        name: String,
        filename: String,
        contentType: String,
        boundary: String
    ) -> Data {
        var body = Data()
        
        let lineBreak = "\r\n"

        parameters?.forEach { key, value in
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
            body.append("\(value + lineBreak)")
        }

        if let data = data {
            body.append("--\(boundary + lineBreak)")
            body.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\(lineBreak)")
            body.append("Content-Type: \(contentType)\(lineBreak + lineBreak)")
            body.append(data)
            body.append(lineBreak)
        }
        
        body.append("--\(boundary)--\r\n")

        return body
    }
}
