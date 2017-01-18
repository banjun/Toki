import XCTest
import Mockingjay
import OHHTTPStubs // see https://github.com/AliSoftware/OHHTTPStubs/wiki/Testing-for-the-request-body-in-your-stubs
import AEXML
import WSDL2Swift
import Fuzi

// all WSDLServices in test should conform to this protocol, declared in the test target
public protocol WSDLServiceStubbable {
    var endpoint: String { get set }
    var path: String { get }
    var targetNamespace: String { get }
    // this should be implemented by the test target (using @testable import the app target)
    func soapRequest<R: XSDType>(_ response: R, _ tns: String) -> AEXMLDocument
}

// extension for stub request and response in WSDLService
public extension XCTest {
    @discardableResult
    func stub<S: WSDLServiceStubbable, T: XSDType, R: XSDType>(_ service: S, _ type: T.Type, _ response: R, requestDataModifier: @escaping (Data) -> Data = {$0}, responseDataModifier: @escaping (Data) -> Data = {$0}) -> Stub {
        return stub(
            service.stubMatcher(type, dataModifier: requestDataModifier),
            service.stubBuilder(response, dataModifier: responseDataModifier))
    }

    @discardableResult
    func stub<S: WSDLServiceStubbable, T: XSDType & ExpressibleByXML, R: XSDType>(_ service: S, requestMatcher: @escaping (T) -> Bool, _ response: R, requestDataModifier: @escaping (Data) -> Data = {$0}, responseDataModifier: @escaping (Data) -> Data = {$0}) -> Stub {
        return stub(
            service.stubMatcher(requestMatcher: requestMatcher, dataModifier: requestDataModifier),
            service.stubBuilder(response, dataModifier: responseDataModifier))
    }
}

private let optionsForNamespaceRemoving: AEXMLOptions = {
    var options = AEXMLOptions()
    options.parserSettings.shouldProcessNamespaces = true
    options.parserSettings.shouldReportNamespacePrefixes = false
    return options
}()

extension WSDLServiceStubbable {
    func stubMatcher<T: XSDType>(_ type: T.Type, dataModifier: @escaping (Data) -> Data = {$0}) -> Matcher {
        return { request in
            let body = (request as NSURLRequest).ohhttpStubs_HTTPBody()
            guard let data = body.map(dataModifier),
                let xml = try? AEXMLDocument(xml: data, options: optionsForNamespaceRemoving) else { return false }

            let typeName = String(describing: type)
            let typeSuffix = typeName.components(separatedBy: "_").last ?? typeName

            return (uri(self.endpoint + self.path)(request) &&
                xml["Envelope"]["Body"][typeSuffix].first != nil)
        }
    }

    func stubMatcher<T: XSDType & ExpressibleByXML>(requestMatcher: @escaping (T) -> Bool, dataModifier: @escaping (Data) -> Data = {$0}) -> Matcher {
        return { request in
            guard self.stubMatcher(T.self, dataModifier: dataModifier)(request) else { return false }

            let body = (request as NSURLRequest).ohhttpStubs_HTTPBody()
            guard let data = body.map(dataModifier),
                let xml = try? Fuzi.XMLDocument(data: data),
                let soapMessage = SOAPMessage(xml: xml, targetNamespace: self.targetNamespace),
                let req = (T(soapMessage: soapMessage).flatMap {$0}) else { return false }
            return requestMatcher(req)
        }
    }

    func stubBuilder<R: XSDType>(_ response: R, dataModifier: @escaping (Data) -> Data = {$0}) -> Builder {
        let targetNamespace = self.targetNamespace
        return { request in
            let soapResponse = self.soapRequest(response, targetNamespace)
            guard let data = soapResponse.xml.data(using: .utf8) else {
                return .failure(NSError(domain: "", code: 0, userInfo: nil))
            }
            return http(200, headers: [:], download: .content(dataModifier(data)))(request)
        }
    }
}
