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
            let content_type = request.headers["content-type"][0].split(separator: ";")
            for value in content_type {
                if value.contains("boundary="){                    
                    parser = ParserMultipart(boundary: String(value[(value.range(of: "boundary=")?.upperBound...)!]))
                }
            }
        case .body(buffer: var buf):
            parser?.append(buffer: buf) { multipartParts in
                print(multipartParts.count)
                if multipartParts.count > 0 {
                    multipartParts.forEach { part in
                        print(String(data: part.content_type, encoding: String.Encoding.utf8))
                        print(String(data: part.data, encoding: String.Encoding.utf8))
                    }
                }
            }
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
