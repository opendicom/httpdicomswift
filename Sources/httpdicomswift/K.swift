//
//  K.swift
//  CNIOAtomics
//
//  Created by cbaeza on 4/12/19.
//

import Foundation

class K {
    
    static let shared = K()
    
    let levels: Array<String>
    let modalities: Array<String>
    let key: Array<String>
    let tag: Array<String>
    let vr: Array<String>
    
    let dscdPrefixData: Data
    let dscdSuffixData: Data
    let scdPrefixData: Data
    let scdSuffixData: Data
    let cdaPrefixData: Data
    let cdaSuffixData: Data
    let pdfComponentPrefixData: Data
    let pdfComponentSuffixData: Data
    
    let defaultTimezone: String
    
    let scheme: Dictionary<String, AnyObject>
    let schemeIndexes: Dictionary<String, [AnyObject]>
    let code: Dictionary<String, AnyObject>
    let codeIndexes: Dictionary<String, [AnyObject]>
    let procedure: Dictionary<String, AnyObject>
    let procedureIndexes: Dictionary<String, [AnyObject]>
    
    private class Config {
        var defaultTimezone:String?
        var scheme: Dictionary<String, AnyObject>?
        var schemeIndexes: Dictionary<String, [AnyObject]>?
        var code: Dictionary<String, AnyObject>?
        var codeIndexes: Dictionary<String, [AnyObject]>?
        var procedure: Dictionary<String, AnyObject>?
        var procedureIndexes: Dictionary<String, [AnyObject]>?
    }
    
    private static let config = Config()
    
    class func setup(
        defaultTimezone: String,
        scheme: Dictionary<String, AnyObject>,
        schemeIndexes: Dictionary<String, [AnyObject]>,
        code: Dictionary<String, AnyObject>,
        codeIndexes: Dictionary<String, [AnyObject]>,
        procedure: Dictionary<String, AnyObject>,
        procedureIndexes: Dictionary<String, [AnyObject]>
        )
    {
        K.config.defaultTimezone = defaultTimezone
        K.config.scheme = scheme
        K.config.schemeIndexes = schemeIndexes
        K.config.code = code
        K.config.codeIndexes = codeIndexes
        K.config.procedure = procedure
        K.config.procedureIndexes = procedureIndexes
    }
    
    private init() {
        
        guard K.config.defaultTimezone != nil else {
            fatalError("Error - you must call setup before accessing K.shared")
        }
        
        defaultTimezone = K.config.defaultTimezone!
        scheme = K.config.scheme!
        schemeIndexes = K.config.schemeIndexes!
        code = K.config.code!
        codeIndexes = K.config.codeIndexes!
        procedure = K.config.procedure!
        procedureIndexes = K.config.procedureIndexes!
        
        levels = ["/patients", "/studies", "/series", "/instances"]
        modalities=["CR","CT","MR","PT","XA","US","MG","RF","DX","EPS"];
        key=[
        "IssuerOfPatientID",//0
        "IssuerOfPatientIDQualifiersSequence.LocalNamespaceEntityID",//1
        "IssuerOfPatientIDQualifiersSequence.UniversalEntityID",//2
        "IssuerOfPatientIDQualifiersSequence.UniversalEntityIDType",//3
        "PatientID",//4
        "PatientName",//5
        "PatientBirthDate",//6
        "PatientSex",//7
        "",//8
        "",//9
        "",//10
        "",//11
        "",//12
        "",//13
        "",//14
        "",//15
        "",//16
        "ProcedureCodeSequence.CodeValue",//17
        "ProcedureCodeSequence.CodingSchemeDesignator",//18
        "ProcedureCodeSequence.CodeMeaning",//19
        "StudyInstanceUID",//20
        "StudyDescription",//21
        "StudyDate",//22
        "StudyTime",//23
        "StudyID",//24
        "",//25
        "",//26
        "",//27
        "",//28
        "AccessionNumber",//29
        "IssuerOfAccessionNumberSequence.LocalNamespaceEntityID",//30
        "IssuerOfAccessionNumberSequence.UniversalEntityID",//31
        "IssuerOfAccessionNumberSequence.UniversalEntityIDType",//32
        "ReferringPhysicianName",//33
        "NameofPhysiciansrStudy",//34
        "ModalitiesInStudy",//35
        "NumberOfStudyRelatedSeries",//36
        "NumberOfStudyRelatedInstances",//37
        "",//38
        "",//39
        "SeriesInstanceUID",//40
        "Modality",//41
        "SeriesDescription",//42
        "SeriesNumber",//43
        "BodyPartExamined",//44
        "",//45
        "",//46
        "StationName",//47
        "InstitutionalDepartmentName",//48
        "InstitutionName",//49
        "Performing​Physician​Name",//50
        "",//51
        "InstitutionCodeSequence.CodeValue",//52
        "InstitutionCodeSequence.schemeDesignator",//53
        "",//54
        "PerformedProcedureStepStartDate",//55
        "PerformedProcedureStepStartTime",//56
        "RequestAttributeSequence.ScheduledProcedureStepID",//57
        "RequestAttributeSequence.RequestedProcedureID",//58
        "NumberOfSeriesRelatedInstances",//59
        "SOPInstanceUID",//60
        "SOPClassUID",//61
        "InstanceNumber",//62
        "HL7InstanceIdentifier",//63
        ""//64
        ];
        
        tag=[
        "00100021",//0
        "00100024.00400031",//1
        "00100024.00400032",//2
        "00100024.00400033",//3
        "00100020",//4
        "00100010",//5
        "00100030",//6
        "00100040",//7
        "",//8
        "",//9
        "",//10
        "",//11
        "",//12
        "",//13
        "",//14
        "",//15
        "",//16
        "00081032.00080100",//17
        "00081032.00080102",//18
        "00081032.00080104",//19
        "0020000D",//20
        "00081030",//21
        "00080020",//22
        "00080030",//23
        "00200010",//24
        "",//25
        "",//26
        "",//27
        "",//28
        "00080050",//29
        "00080051.00400031",//30
        "00080051.00400032",//31
        "00080051.00400033",//32
        "00080090",//33
        "00081060",//34
        "00080061",//35
        "00201206",//36
        "00201208",//37
        "",//38
        "",//39
        "0020000E",//40
        "00080060",//41
        "0008103E",//42
        "00200011",//43
        "00180015",//44
        "",//45
        "",//46
        "00081010",//47
        "00081040",//48
        "00080080",//49
        "00081050",//50
        "",//51
        "00080082.00080100",//52
        "00080082.00080102",//53
        "",//54
        "00400244",//55
        "00400245",//56
        "00400275.00400009",//57
        "00400275.00401001",//58
        "00201209",//59
        "00080018",//60
        "00080016",//61
        "00200013",//62
        "0040E001",//63
        ""//64
        ];
        
        vr=[
        "LO",//0
        "UT",//1
        "UT",//2
        "CS",//3
        "LO",//4
        "PN",//5
        "DA",//6
        "CS",//7
        "",//8
        "",//9
        "",//10
        "",//11
        "",//12
        "",//13
        "",//14
        "",//15
        "",//16
        "SH",//17
        "SH",//18
        "LO",//19
        "UI",//20
        "LO",//21
        "DA",//22
        "TM",//23
        "SH",//24
        "",//25
        "",//26
        "",//27
        "",//28
        "SH",//29
        "UT",//30
        "UT",//31
        "CS",//32
        "PN",//33
        "PN",//34
        "CS",//35
        "IS",//36
        "IS",//37
        "",//38
        "",//39
        "UI",//40
        "CS",//41
        "LO",//42
        "IS",//43
        "CS",//44
        "",//45
        "",//46
        "SH",//47
        "LO",//48
        "LO",//49
        "PN",//50
        "",//51
        "SH",//52
        "SH",//53
        "",//54
        "DA",//55
        "TM",//56
        "SH",//57
        "SH",//58
        "IS",//59
        "UI",//60
        "UI",//61
        "IS",//62
        "ST",//63
        ""//64
        ];
        
        dscdPrefixData = "<dscd".data(using: String.Encoding.utf8)!
        dscdSuffixData = "</dscd>".data(using: String.Encoding.utf8)!
        scdPrefixData = "<SignedClinicalDocument".data(using: String.Encoding.utf8)!
        scdSuffixData = "</SignedClinicalDocument>".data(using: String.Encoding.utf8)!
        cdaPrefixData = "<ClinicalDocument".data(using: String.Encoding.utf8)!
        cdaSuffixData = "</ClinicalDocument>".data(using: String.Encoding.utf8)!
        pdfComponentPrefixData = "data:application/pdf;base64,".data(using: String.Encoding.utf8)!
        pdfComponentSuffixData = "\"/>".data(using: String.Encoding.utf8)!
        
    }
    
}
