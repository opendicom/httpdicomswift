//
//  HTTPHandler+handleEchoWithBody.swift
//  CNIOAtomics
//
//  Created by cbaeza on 3/22/19.
//
import Foundation
import NIO
import NIOHTTP1

public extension HTTPHandler {
    
    func handleJSON(context: ChannelHandlerContext, request: HTTPServerRequestPart) {
        switch request {
        case .head(let request):
            self.infoSavedRequestHead = request
            self.infoSavedBodyBytes = 0
            self.keepAlive = request.isKeepAlive
            self.state.requestReceived()
            stringBody = ""
            receivedData = nil
        case .body(buffer: var buf):
            //self.infoSavedBodyBytes += buf.readableBytes
            guard let received = buf.readBytes(length: buf.readableBytes) else {
                return
            }
            if (receivedData == nil ){
                receivedData = Data(bytes: received, count: received.count)
            }else{
                receivedData?.append(Data(bytes: received, count: received.count))
            }
        case .end:
            self.state.requestComplete()
            stringBody.append(contentsOf: String(data: receivedData!, encoding: String.Encoding.utf8) ?? "")
            //print(stringBody)
            self.buffer.clear()
            self.buffer.writeString(stringBody)
            var headers = HTTPHeaders()
            headers.add(name: "Content-Length", value: "\(stringBody.utf8.count)")
            context.write(self.wrapOutboundOut(.head(httpResponseHead(request: self.infoSavedRequestHead!, status: .ok, headers: headers))), promise: nil)
            context.write(self.wrapOutboundOut(.body(.byteBuffer(self.buffer))), promise: nil)
            self.completeResponse(context, trailers: nil, promise: nil)
        }
    }
    
}
