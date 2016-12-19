import Quick
import Nimble
import Toki
import WSDL2Swift
import AEXML
// @testable import App

extension TempConvert: WSDLServiceStubbable {}
extension WSDLService {
    public func soapRequest<R : XSDType>(_ response: R, _ tns: String) -> AEXMLDocument {
        return response.soapRequest(tns)
    }
}

class TempConvertSpec: QuickSpec {
    let service = TempConvert(endpoint: "/")

    override func spec() {
        describe("TempConvert") {
            it("C to F") {
                self.stub(self.service,
                          TempConvert_CelsiusToFahrenheit.self,
                          TempConvert_CelsiusToFahrenheitResponse(CelsiusToFahrenheitResult: "999"))

                let future = self.service.request(TempConvert_CelsiusToFahrenheit(Celsius: "30"))
                expect(future.value).toEventuallyNot(beNil())
                expect(future.value?.CelsiusToFahrenheitResult).toEventually(equal("999"))
            }

            it("F to C") {
                self.stub(self.service,
                          TempConvert_FahrenheitToCelsius.self,
                          TempConvert_FahrenheitToCelsiusResponse(FahrenheitToCelsiusResult: "1234"))

                let future = self.service.request(TempConvert_FahrenheitToCelsius(Fahrenheit: "80"))
                expect(future.value).toEventuallyNot(beNil())
                expect(future.value?.FahrenheitToCelsiusResult).toEventually(equal("1234"))
            }
        }
    }
}
