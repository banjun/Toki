// https://github.com/Quick/Quick

import Quick
import Nimble
import Toki


extension WSDL2ObjCStubbable {
    public var ns2: String { return "http://service.example.com/" }
}

public protocol AuthenticationStubbable: WSDL2ObjCStubbable {}
public extension AuthenticationStubbable {
    public var endpoint: String { return "/authentication.ws" }
}

extension AuthenticationService_login: AuthenticationStubbable {}


class AuthenticationSpec: QuickSpec {
    override func spec() {
        describe("authentication") {
            it("login success") {
                self.stubSoap(AuthenticationService_login(), returnXMLs: ["success"])

                let request = AuthenticationService_login()
                request.arg0 = "user"
                request.arg1 = "password"

                let response = AuthenticationService.authenticationPortBinding().login(usingParameters: request)
                let part = response?.bodyParts.first as? AuthenticationService_loginResponse
                let ret = part?.return_
                expect(ret) == "success"
            }

            it("login failure") {
                self.stubSoap(AuthenticationService_login(), returnXMLs: ["failure"])

                let request = AuthenticationService_login()
                request.arg0 = "user"
                request.arg1 = "password"

                let response = AuthenticationService.authenticationPortBinding().login(usingParameters: request)
                let part = response?.bodyParts.first as? AuthenticationService_loginResponse
                let ret = part?.return_
                expect(ret) == "failure"
            }
        }
    }
}
