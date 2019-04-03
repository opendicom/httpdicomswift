//
//  SerializerMultipart.swift
//  CNIOAtomics
//
//  Created by cbaeza on 3/25/19.
//

import Foundation
import NIO

struct ParserMultipart {
    
    let boundary: String
    let endBoundary: String
    var dataAll: Data
    var data: Data
    var multipartParts: [MultipartPart]
    
    init(boundary: String){
        self.boundary = "\r\n--\(boundary)\r\n"
        self.endBoundary = "\r\n--\(boundary)--"
        self.dataAll = Data()
        self.data = Data()
        self.multipartParts = Array()
    }
    
    
    mutating func append(buffer: ByteBuffer) {
        var buf = buffer
        guard let received = buf.readBytes(length: buf.readableBytes) else {
            return
        }
        dataAll.append(contentsOf: received)
        data.append(contentsOf: received)
        if data.starts(with: self.boundary.data(using: String.Encoding.utf8)!){
            data.removeSubrange(0...self.boundary.count+1)
            let rangeEndPart = data.range(of: self.boundary.data(using: String.Encoding.utf8)!)
            if rangeEndPart != nil {
                let partData = data.subdata(in: 0..<rangeEndPart!.lowerBound)
                let rangeContenType = partData.range(of: "Content-Type:".data(using: String.Encoding.utf8)!)
                let rangeEndContentType = partData.range(of: "\r\n\r\n".data(using: String.Encoding.utf8)!)
                let part = MultipartPart(content_type: partData.subdata(in: rangeContenType!.upperBound..<rangeEndContentType!.lowerBound),
                                         data: partData.subdata(in: rangeEndContentType!.upperBound..<partData.count))
                multipartParts.append(part)
                data.removeSubrange(0..<rangeEndPart!.upperBound)
            }
            let rangeEndMultipart = data.range(of: self.endBoundary.data(using: String.Encoding.utf8)!)
            if rangeEndMultipart != nil {
                var partData = data.subdata(in: 0..<rangeEndMultipart!.lowerBound)
                let rangeContenType = partData.range(of: "Content-Type:".data(using: String.Encoding.utf8)!)
                let rangeEndContentType = partData.range(of: "\r\n\r\n".data(using: String.Encoding.utf8)!)
                let part = MultipartPart(content_type: partData.subdata(in: rangeContenType!.upperBound..<rangeEndContentType!.lowerBound),
                                         data: partData.subdata(in: rangeEndContentType!.upperBound..<partData.count))
                multipartParts.append(part)
                data.removeAll()
            }
        }else{
            
        }
    }
}
