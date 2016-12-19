public struct TempConvert: WSDLService {
    public let targetNamespace = "http://www.w3schools.com/xml/"
    public var endpoint: String
    public let path = "xml/tempconvert.asmx"
    public var interceptURLRequest: ((URLRequest) -> URLRequest)?
    public var interceptResponse: ((Data?, URLResponse?, Error?) -> (Data?, URLResponse?, Error?))?
    public init(endpoint: String) {
        self.endpoint = endpoint
    }

    public func request(_ parameters: TempConvert_FahrenheitToCelsius) -> Future<TempConvert_FahrenheitToCelsiusResponse, WSDLOperationError> {
        return requestGeneric(parameters)
    }
    public func request(_ parameters: TempConvert_CelsiusToFahrenheit) -> Future<TempConvert_CelsiusToFahrenheitResponse, WSDLOperationError> {
        return requestGeneric(parameters)
    }
}
public struct TempConvert_FahrenheitToCelsius {
    public var Fahrenheit: String?
    // public memberwise init
    public init(Fahrenheit: String?) {
        self.Fahrenheit = Fahrenheit
    }
}

public struct TempConvert_FahrenheitToCelsiusResponse {
    public var FahrenheitToCelsiusResult: String?
    // public memberwise init
    public init(FahrenheitToCelsiusResult: String?) {
        self.FahrenheitToCelsiusResult = FahrenheitToCelsiusResult
    }
}

public struct TempConvert_CelsiusToFahrenheit {
    public var Celsius: String?
    // public memberwise init
    public init(Celsius: String?) {
        self.Celsius = Celsius
    }
}

public struct TempConvert_CelsiusToFahrenheitResponse {
    public var CelsiusToFahrenheitResult: String?
    // public memberwise init
    public init(CelsiusToFahrenheitResult: String?) {
        self.CelsiusToFahrenheitResult = CelsiusToFahrenheitResult
    }
}


import WSDL2Swift
import Foundation
import AEXML
import Result
import BrightFutures
import ISO8601

extension WSDLService {
    public init(endpoint: String, interceptURLRequest: ((URLRequest) -> URLRequest)? = nil, interceptResponse: ((Data?, URLResponse?, Error?) -> (Data?, URLResponse?, Error?))? = nil) {
        self.init(endpoint: endpoint)
        self.interceptURLRequest = interceptURLRequest
        self.interceptResponse = interceptResponse
    }
    fileprivate func requestGeneric<I: _XSDType, O>(_ parameters: I) -> Future<O, WSDLOperationError> where O: _XSDType, O: ExpressibleByXML {
        let promise = Promise<O, WSDLOperationError>()

        let soapRequest = parameters.soapRequest(targetNamespace)
        //        print("request to \(endpoint + path) using: \(soapRequest.xml)")

        var request = URLRequest(url: URL(string: endpoint)!.appendingPathComponent(path))
        request.httpMethod = "POST"
        request.addValue("text/xml", forHTTPHeaderField: "Content-Type")
        request.addValue("WSDL2Swift", forHTTPHeaderField: "User-Agent")
        if let data = soapRequest.xml.data(using: .utf8) {
            //            request.addValue(String(data.length), forHTTPHeaderField: "Content-Length")
            request.httpBody = data
        }
        //        NSLog("%@", "headers: \(request.allHTTPHeaderFields)")
        request = interceptURLRequest?(request) ?? request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let (data, _, error) = self.interceptResponse?(data, response, error) ?? (data, response, error)
            //            NSLog("%@", "\((response, error))")

            if let error = error {
                promise.failure(.urlSession(error))
                return
            }

            guard let d = data, let xml = try? AEXMLDocument(xml: d) else {
                promise.failure(.invalidXML)
                return
            }

            guard let soapMessage = SOAPMessage(xml: xml, targetNamespace: self.targetNamespace) else {
                promise.failure(.invalidXMLContent)
                return
            }

            guard let out = O(soapMessage: soapMessage) else {
                if let fault = soapMessage.body.fault {
                    promise.failure(.soapFault(fault))
                } else {
                    promise.failure(.invalidXMLContent)
                }
                return
            }

            promise.success(out)
        }
        task.resume()
        return promise.future
    }
}

private protocol ExpressibleByXML {
    // returns:
    //  * Self: parse succeeded to an value
    //  * nil: parse succeeded to nil
    //  * SOAPParamError.unknown: parse failed
    init?(xml: AEXMLElement) throws // SOAPParamError
    init?(xmlValue: String) throws // SOAPParamError
}

extension ExpressibleByXML {
    // default implementation for primitive values
    // element nil check and text value empty check
    fileprivate init?(xml: AEXMLElement) throws {
        guard let value = xml.value else { return nil }
        guard !value.isEmpty else { return nil }
        try self.init(xmlValue: value)
    }
}

extension String: ExpressibleByXML, SOAPParamConvertible {
    fileprivate init?(xmlValue: String) {
        self.init(xmlValue)
    }

    public func xmlElements(name: String) -> [AEXMLElement] {
        return [AEXMLElement(name: name, value: xmlEscaped)]
    }
}
extension Bool: ExpressibleByXML, SOAPParamConvertible {
    fileprivate init?(xmlValue: String) throws {
        switch xmlValue.lowercased() {
        case "true": self = true
        case "false": self = false
        default: throw SOAPParamError.unknown
        }
    }
    public func xmlElements(name: String) -> [AEXMLElement] {
        return [AEXMLElement(name: name, value: self ? "true" : "false")]
    }
}
extension Int32: ExpressibleByXML, SOAPParamConvertible {
    fileprivate init?(xmlValue: String) throws {
        guard let v = Int32(xmlValue) else { throw SOAPParamError.unknown }
        self = v
    }
    public func xmlElements(name: String) -> [AEXMLElement] {
        return [AEXMLElement(name: name, value: String(self))]
    }
}
extension Int64: ExpressibleByXML, SOAPParamConvertible {
    fileprivate init?(xmlValue: String) throws {
        guard let v = Int64(xmlValue) else { throw SOAPParamError.unknown }
        self = v
    }
    public func xmlElements(name: String) -> [AEXMLElement] {
        return [AEXMLElement(name: name, value: String(self))]
    }
}
extension Date: ExpressibleByXML, SOAPParamConvertible {
    fileprivate init?(xmlValue: String) throws {
        guard let v = NSDate(iso8601String: xmlValue) as Date? else { throw SOAPParamError.unknown }
        self = v
    }
    public func xmlElements(name: String) -> [AEXMLElement] {
        return [AEXMLElement(name: name, value: (self as NSDate).iso8601String())]
    }
}
extension Data: ExpressibleByXML, SOAPParamConvertible {
    fileprivate init?(xmlValue: String) {
        self.init(base64Encoded: xmlValue)
    }
    public func xmlElements(name: String) -> [AEXMLElement] {
        return [AEXMLElement(name: name, value: base64EncodedString())]
    }
}
extension Array: SOAPParamConvertible { // Swift 3 does not yet support conditional protocol conformance (where Element: SOAPParamConvertible)
    public func xmlElements(name: String) -> [AEXMLElement] {
        var a: [AEXMLElement] = []
        forEach { e in
            guard let children = (e as? SOAPParamConvertible)?.xmlElements(name: name) else { return }
            a.append(contentsOf: children)
        }
        return a
    }
}

extension XSDType {
    func soapRequest(_ tns: String) -> AEXMLDocument {
        let action = "\(String(describing: type(of: self)))".components(separatedBy: "_").last!
        let soapRequest = AEXMLDocument()
        let envelope = soapRequest.addChild(name: "S:Envelope", attributes: [
            "xmlns:S": "http://schemas.xmlsoap.org/soap/envelope/",
            "xmlns:tns": tns,
            ])
        let _ = envelope.addChild(name: "S:Header")
        let body = envelope.addChild(name: "S:Body")
        xmlElements(name: "tns:" + action).forEach {body.addChild($0)} // assumes "tns:" prefixed for all actions. JAX-WS requires prefixed or xmlns specification on this node.
        return soapRequest
    }

    public func xmlElements(name: String) -> [AEXMLElement] {
        let typeElement = AEXMLElement(name: name)
        for case let (k, v?, ns) in (self as? _XSDType)?.xmlParams ?? [] {
            let name = ns.isEmpty ? k : (ns + ":" + k)
            let children = v.xmlElements(name: name)
            children.forEach {typeElement.addChild($0)}
        }
        return [typeElement]
    }
}

private protocol _XSDType: XSDType, SOAPParamConvertible {
    // name, swiftName, xmlns
    var xmlParams: [(String, SOAPParamConvertible?, String)] { get }
}
extension _XSDType where Self: ExpressibleByXML {
    fileprivate init?(xmlValue: String) throws {
        // compound type cannot be initialized with a text element
        throw SOAPParamError.unknown
    }
    fileprivate init?(soapMessage message: SOAPMessage) {
        guard let xml = message.body.output else { return nil }
        try? self.init(xml: xml)
    }
}

enum SOAPParamError: Error { case unknown }

// ex. let x: Bool = parseXSDType(v), success only if T(v) is succeeded
private func parseXSDType<T: ExpressibleByXML>(_ element: AEXMLElement) throws -> T {
    guard let v = try T(xml: element) else { throw SOAPParamError.unknown }
    return v
}

// ex. let x: Bool? = parseXSDType(v), failure only if T(v) is failed
private func parseXSDType<T: ExpressibleByXML>(_ element: AEXMLElement) throws -> T? {
    return try T(xml: element)
}

// ex. let x: [String] = parseXSDType(v), failure only if any T(v.children) is failed
private func parseXSDType<T: ExpressibleByXML>(_ element: AEXMLElement) throws -> [T] {
    return try (element.all ?? []).map(parseXSDType)
}

extension TempConvert_FahrenheitToCelsius: ExpressibleByXML, _XSDType {
    fileprivate init?(xml: AEXMLElement) {
        do {
            self.Fahrenheit = try parseXSDType(xml["Fahrenheit"])
        } catch _ {
            return nil
        }
    }
    fileprivate var xmlParams: [(String, SOAPParamConvertible?, String)] {return [
        ("Fahrenheit", Fahrenheit, "tns"),
    ]}
}

extension TempConvert_FahrenheitToCelsiusResponse: ExpressibleByXML, _XSDType {
    fileprivate init?(xml: AEXMLElement) {
        do {
            self.FahrenheitToCelsiusResult = try parseXSDType(xml["FahrenheitToCelsiusResult"])
        } catch _ {
            return nil
        }
    }
    fileprivate var xmlParams: [(String, SOAPParamConvertible?, String)] {return [
        ("FahrenheitToCelsiusResult", FahrenheitToCelsiusResult, "tns"),
    ]}
}

extension TempConvert_CelsiusToFahrenheit: ExpressibleByXML, _XSDType {
    fileprivate init?(xml: AEXMLElement) {
        do {
            self.Celsius = try parseXSDType(xml["Celsius"])
        } catch _ {
            return nil
        }
    }
    fileprivate var xmlParams: [(String, SOAPParamConvertible?, String)] {return [
        ("Celsius", Celsius, "tns"),
    ]}
}

extension TempConvert_CelsiusToFahrenheitResponse: ExpressibleByXML, _XSDType {
    fileprivate init?(xml: AEXMLElement) {
        do {
            self.CelsiusToFahrenheitResult = try parseXSDType(xml["CelsiusToFahrenheitResult"])
        } catch _ {
            return nil
        }
    }
    fileprivate var xmlParams: [(String, SOAPParamConvertible?, String)] {return [
        ("CelsiusToFahrenheitResult", CelsiusToFahrenheitResult, "tns"),
    ]}
}
