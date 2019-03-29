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
    private var parts: [Data]?
    private let boundary: String
    
    init(boundary: String){
        self.boundary = boundary
    }
    
    mutating func append(buffer: ByteBuffer, returnParts: (_: [Data]?) -> Void ) {
        var buf = buffer
        guard let received = buf.readBytes(length: buf.readableBytes) else {
            return
        }
        if (self.multipart == nil ){
            self.multipart = Data(bytes: received, count: received.count)
        }else{
            self.multipart?.append(Data(bytes: received, count: received.count))
        }
        let rangea = self.multipart?.range(of: self.boundary.data(using: String.Encoding.ascii)!)
        let rangeb = self.multipart?.range(of: self.boundary.data(using: String.Encoding.ascii)!, options: .backwards)
        print(rangea)
        print(rangeb)
        returnParts(parts)
    }
}
