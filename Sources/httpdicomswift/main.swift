import Foundation
/*let server = Server()
server.listen(11114)*/

let deployPath = "/Users/Shared/GitHub/httpdicom/deploy/"
let fileManager = FileManager.default

let schema = NSDictionary(contentsOfFile: deployPath + "voc/scheme.plist") as! Dictionary<String,AnyObject>
let schemaIndexes = Dictionary.dictionaryOfArray(from: schema)

var code = Dictionary<String, AnyObject>()
var codeIndexes = Dictionary<String, [AnyObject]>()
let codeFiles = try fileManager.contentsOfDirectory(atPath: deployPath +  "voc/code/")
for codeFile in codeFiles {
    if codeFile.hasPrefix("."){
        continue
    }else{
        let file = NSDictionary(contentsOfFile: deployPath + "voc/code/" + codeFile) as! Dictionary<String,AnyObject>
        code.updateValue(file as AnyObject, forKey: codeFile.replacingOccurrences(of: ".plist", with: ""))
        codeIndexes.updateValue([Dictionary.dictionaryOfArray(from: file) as AnyObject], forKey: codeFile.replacingOccurrences(of: ".plist", with: ""))
    }
}

var procedure = Dictionary<String, AnyObject>()
var procedureIndexes = Dictionary<String, [AnyObject]>()
let procedureFiles = try fileManager.contentsOfDirectory(atPath: deployPath + "voc/procedure/")
for procedureFile in procedureFiles{
    if procedureFile.hasPrefix("."){
        continue
    }else{
        let file = NSDictionary(contentsOfFile: deployPath + "voc/procedure/" + procedureFile) as! Dictionary<String,AnyObject>
        procedure.updateValue(file as AnyObject, forKey: procedureFile.replacingOccurrences(of: ".plist", with: ""))
        procedureIndexes.updateValue([Dictionary.dictionaryOfArray(from: file) as AnyObject], forKey: procedureFile.replacingOccurrences(of: ".plist", with: ""))
    }
}

let countries = NSArray(contentsOfFile: deployPath + "voc/country.plist")! as Array<AnyObject>
var iso3166PAIS = Array<String>()
var iso3166COUNTRY = Array<String>()
var iso3166AB = Array<String>()
var iso3166ABC = Array<String>()
var iso3166XXX = Array<String>()
for country in countries{
    iso3166PAIS.append(country[0] as? String ?? "")
    iso3166COUNTRY.append(country[1] as? String ?? "")
    iso3166AB.append(country[2] as? String ?? "")
    iso3166ABC.append(country[3] as? String ?? "")
    iso3166XXX.append(country[4] as? String ?? "")
}
var iso3166ByCountry =  [iso3166PAIS, iso3166COUNTRY, iso3166AB, iso3166ABC, iso3166XXX]

var personIDTypes = NSDictionary(contentsOfFile: deployPath + "voc/personIDType.plist") as! Dictionary<String,String>
//Default time zone "-0400"
K.setup(defaultTimezone: "-0400",
        scheme: schema,
        schemeIndexes: schemaIndexes!,
        code: code,
        codeIndexes: codeIndexes,
        procedure: procedure,
        procedureIndexes: procedureIndexes,
        iso3166: iso3166ByCountry,
        personIDTypes: personIDTypes)

print(K.shared.defaultTimezone)
print(K.shared.scheme)
print(K.shared.schemeIndexes)
print(K.shared.code)
print(K.shared.codeIndexes)
print(K.shared.procedure)
print(K.shared.procedureIndexes)
print(K.shared.iso3166)
print(K.shared.personIDTypes)
