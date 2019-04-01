//
//  Multipart.swift
//  CNIOAtomics
//
//  Created by cbaeza on 4/1/19.
//

import Foundation


struct MultipartPart {
    
    let content_type: String
    let data: Data
    
    init(){
        self.content_type = ""
        self.data = Data()
    }
    
    init(content_type: String, data: Data){
        self.content_type = content_type
        self.data = data
    }

}
