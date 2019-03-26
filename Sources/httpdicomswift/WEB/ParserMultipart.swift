//
//  SerializerMultipart.swift
//  CNIOAtomics
//
//  Created by cbaeza on 3/25/19.
//

import Foundation
import NIO

struct ParserMultipart {
    
    private var multipart: Data?
    private let boundary: String
    
    init(boundary: String){
        self.boundary = boundary
    }
    
    mutating func append(buffer: ByteBuffer){
        var buf = buffer
        guard let received = buf.readBytes(length: buf.readableBytes) else {
            return
        }
        if (self.multipart == nil ){
            self.multipart = Data(bytes: received, count: received.count)
        }else{
            self.multipart?.append(Data(bytes: received, count: received.count))
        }
        
    }
    
    func getParts() -> [Data]? {
        //let parts: [Data]? = self.multipart?.split(whereSeparator: { $0 == "a" })
        return parts
    }
    

}
