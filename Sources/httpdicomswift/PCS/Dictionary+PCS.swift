//
//  Dictionary+PCS.swift
//  CNIOAtomics
//
//  Created by cbaeza on 4/15/19.
//

import Foundation

extension Dictionary {
    
    static func dictionaryOfArray(from dictionaryOfDictionary: Dictionary) -> [String: [AnyObject]]? {
        if (dictionaryOfDictionary.isEmpty) {
            return nil
        }
        var dkeys = Array(dictionaryOfDictionary.keys)
        let dicddkeys =  dictionaryOfDictionary[dkeys[0]] as! Dictionary<String, AnyObject>
        let ddkeys = Array(dicddkeys.keys)
        var keys = [String]()
        keys.append("key")
        keys.append(contentsOf: ddkeys)
        var mdma = [String: [AnyObject]]()
        for k in keys {
            mdma[k] = [AnyObject]()
        }
        for dk in dkeys {
            mdma["key"]?.append(dk as AnyObject)
            var kd = dictionaryOfDictionary[dk] as! Dictionary<String, AnyObject>
            for ddk in ddkeys{
                mdma[ddk]?.append(kd[ddk]!)
            }
        }
        var mda = [String: [AnyObject]]()
        for key in keys {
            mda[key] = mdma[key]
        }
        return mda
    }

}
