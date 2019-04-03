//
//  Multipart.swift
//  CNIOAtomics
//
//  Created by cbaeza on 4/1/19.
//

import Foundation


struct MultipartPart {
    
    var content_type: Data
    var data: Data
    
    init(){
        self.content_type = Data()
        self.data = Data()
    }
    
    init(content_type: Data, data: Data){
        self.content_type = content_type
        self.data = data
    }

}
