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
    var data: Data
    
    init(boundary: String){
        self.boundary = "\r\n--\(boundary)\r\n"
        self.endBoundary = "\r\n--\(boundary)--"
        self.data = Data()
    }
    
    
    mutating func append(buffer: ByteBuffer) {
        var buf = buffer
        guard let received = buf.readBytes(length: buf.readableBytes) else {
            return
        }
        data.append(contentsOf: received)
        if data.starts(with: self.boundary.data(using: String.Encoding.ascii)!){
            print("inicio de boundary")
            data.removeSubrange(0...self.boundary.count)
            let rangeendpart = data.range(of: self.boundary.data(using: String.Encoding.ascii)!)
            print(rangeendpart)
            let rangeendpartmulti = data.range(of: self.endBoundary.data(using: String.Encoding.ascii)!)
            print(rangeendpartmulti)
        }else{
            
        }
        
    }
}
