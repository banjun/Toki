import WSDL2Swift
import BrightFutures
import AEXML
import Fuzi
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

extension TempConvert_FahrenheitToCelsius: ExpressibleByXML, XSDType {
    public init?(xml: XMLElement) {
        do {
            self.Fahrenheit = try parseXSDType(xml.children(tag: "Fahrenheit"))
        } catch _ {
            return nil
        }
    }
    public var xmlParams: [(String, SOAPParamConvertible?, String)] {return [
        ("Fahrenheit", Fahrenheit, "tns"),
        ]}
}

extension TempConvert_FahrenheitToCelsiusResponse: ExpressibleByXML, XSDType {
    public init?(xml: XMLElement) {
        do {
            self.FahrenheitToCelsiusResult = try parseXSDType(xml.children(tag: "FahrenheitToCelsiusResult"))
        } catch _ {
            return nil
        }
    }
    public var xmlParams: [(String, SOAPParamConvertible?, String)] {return [
        ("FahrenheitToCelsiusResult", FahrenheitToCelsiusResult, "tns"),
        ]}
}

extension TempConvert_CelsiusToFahrenheit: ExpressibleByXML, XSDType {
    public init?(xml: XMLElement) {
        do {
            self.Celsius = try parseXSDType(xml.children(tag: "Celsius"))
        } catch _ {
            return nil
        }
    }
    public var xmlParams: [(String, SOAPParamConvertible?, String)] {return [
        ("Celsius", Celsius, "tns"),
        ]}
}

extension TempConvert_CelsiusToFahrenheitResponse: ExpressibleByXML, XSDType {
    public init?(xml: XMLElement) {
        do {
            self.CelsiusToFahrenheitResult = try parseXSDType(xml.children(tag: "CelsiusToFahrenheitResult"))
        } catch _ {
            return nil
        }
    }
    public var xmlParams: [(String, SOAPParamConvertible?, String)] {return [
        ("CelsiusToFahrenheitResult", CelsiusToFahrenheitResult, "tns"),
        ]}
}
