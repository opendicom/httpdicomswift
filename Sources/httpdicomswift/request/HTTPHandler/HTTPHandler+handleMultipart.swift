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
    
    func handleMultipart(context: ChannelHandlerContext, request: HTTPServerRequestPart) {
        switch request {
        case .head(let request):
            self.infoSavedRequestHead = request
            self.infoSavedBodyBytes = 0
            self.keepAlive = request.isKeepAlive
            self.state.requestReceived()
            stringBody = ""
            receivedData = nil
            parser = ParserMultipart(boundary: "X-INSOMNIA-BOUNDARY")
        case .body(buffer: var buf):
            parser?.append(buffer: buf)/* { (parts) in
                if parts?.count ?? 0 > 0 {
                    print("return parts")
                }else{
                    print("NO return parts")
                }
                
            }*/
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
            self.buffer.clear()
            self.buffer.writeBytes(receivedData!)
            var headers = HTTPHeaders()
            headers.add(name: "Content-Length", value: "\(receivedData!.count)")
            context.write(self.wrapOutboundOut(.head(httpResponseHead(request: self.infoSavedRequestHead!, status: .ok, headers: headers))), promise: nil)
            context.write(self.wrapOutboundOut(.body(.byteBuffer(self.buffer))), promise: nil)
            self.completeResponse(context, trailers: nil, promise: nil)
        }
    }
    
}
