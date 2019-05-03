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
//Default time zone "-0400"
K.setup(defaultTimezone: "-0400",
        scheme: schema,
        schemeIndexes: schemaIndexes!,
        code: code,
        codeIndexes: codeIndexes,
        procedure: procedure,
        procedureIndexes: procedureIndexes,
        iso3166: iso3166ByCountry)

print(K.shared.defaultTimezone)
print(K.shared.scheme)
print(K.shared.schemeIndexes)
print(K.shared.code)
print(K.shared.codeIndexes)
print(K.shared.procedure)
print(K.shared.procedureIndexes)
print(K.shared.iso3166)

//===----------------------------------------------------------------------===//
//
// This source file is part of the SwiftNIO open source project
//
// Copyright (c) 2017-2018 Apple Inc. and the SwiftNIO project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of SwiftNIO project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//
/*import NIO
import NIOHTTP1

extension String {
    func chopPrefix(_ prefix: String) -> String? {
        if self.unicodeScalars.starts(with: prefix.unicodeScalars) {
            return String(self[self.index(self.startIndex, offsetBy: prefix.count)...])
        } else {
            return nil
        }
    }
    
    func containsDotDot() -> Bool {
        for idx in self.indices {
            if self[idx] == "." && idx < self.index(before: self.endIndex) && self[self.index(after: idx)] == "." {
                return true
            }
        }
        return false
    }
}

// First argument is the program path
var arguments = CommandLine.arguments.dropFirst(0) // just to get an ArraySlice<String> from [String]
var allowHalfClosure = true
if arguments.dropFirst().first == .some("--disable-half-closure") {
    allowHalfClosure = false
    arguments = arguments.dropFirst()
}
let arg1 = arguments.dropFirst().first
let arg2 = arguments.dropFirst(2).first
let arg3 = arguments.dropFirst(3).first

let defaultHost = "::1"
let defaultPort = 8888
let defaultHtdocs = "/dev/null/"

enum BindTo {
    case ip(host: String, port: Int)
    case unixDomainSocket(path: String)
}

let htdocs: String
let bindTarget: BindTo

switch (arg1, arg1.flatMap(Int.init), arg2, arg2.flatMap(Int.init), arg3) {
case (.some(let h), _ , _, .some(let p), let maybeHtdocs):
    /* second arg an integer --> host port [htdocs] */
    bindTarget = .ip(host: h, port: p)
    htdocs = maybeHtdocs ?? defaultHtdocs
case (_, .some(let p), let maybeHtdocs, _, _):
    /* first arg an integer --> port [htdocs] */
    bindTarget = .ip(host: defaultHost, port: p)
    htdocs = maybeHtdocs ?? defaultHtdocs
case (.some(let portString), .none, let maybeHtdocs, .none, .none):
    /* couldn't parse as number --> uds-path [htdocs] */
    bindTarget = .unixDomainSocket(path: portString)
    htdocs = maybeHtdocs ?? defaultHtdocs
default:
    htdocs = defaultHtdocs
    bindTarget = BindTo.ip(host: defaultHost, port: defaultPort)
}

let group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
let threadPool = NIOThreadPool(numberOfThreads: 6)
threadPool.start()

let fileIO = NonBlockingFileIO(threadPool: threadPool)
let bootstrap = ServerBootstrap(group: group)
    // Specify backlog and enable SO_REUSEADDR for the server itself
    .serverChannelOption(ChannelOptions.backlog, value: 256)
    .serverChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
    
    // Set the handlers that are applied to the accepted Channels
    .childChannelInitializer { channel in
        channel.pipeline.configureHTTPServerPipeline(withErrorHandling: true).flatMap {
            channel.pipeline.addHandler(HTTPHandler(fileIO: fileIO, htdocsPath: htdocs))
        }
    }
    
    // Enable TCP_NODELAY and SO_REUSEADDR for the accepted Channels
    .childChannelOption(ChannelOptions.socket(IPPROTO_TCP, TCP_NODELAY), value: 1)
    .childChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
    .childChannelOption(ChannelOptions.maxMessagesPerRead, value: 1)
    .childChannelOption(ChannelOptions.allowRemoteHalfClosure, value: allowHalfClosure)

defer {
    try! group.syncShutdownGracefully()
    try! threadPool.syncShutdownGracefully()
}

print("htdocs = \(htdocs)")

let channel = try { () -> Channel in
    switch bindTarget {
    case .ip(let host, let port):
        return try bootstrap.bind(host: host, port: port).wait()
    case .unixDomainSocket(let path):
        return try bootstrap.bind(unixDomainSocketPath: path).wait()
    }
    }()

guard let localAddress = channel.localAddress else {
    fatalError("Address was unable to bind. Please check that the socket was not closed or that the address family was understood.")
}
print("Server started and listening on \(localAddress), htdocs path \(htdocs)")

// This will never unblock as we don't close the ServerChannel
try channel.closeFuture.wait()

print("Server closed")
*/
