#import <Foundation/Foundation.h>
#import "USAdditions.h"
#import <libxml/tree.h>
#import "USGlobals.h"
#import <objc/runtime.h>
@class AuthenticationService_login;
@class AuthenticationService_loginResponse;
@interface AuthenticationService_login : NSObject <NSCoding> {
SOAPSigner *soapSigner;
/* elements */
	NSString * arg0;
	NSString * arg1;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AuthenticationService_login *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (retain) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, retain) NSString * arg0;
@property (nonatomic, retain) NSString * arg1;
/* attributes */
- (NSDictionary *)attributes;
@end
@interface AuthenticationService_loginResponse : NSObject <NSCoding> {
SOAPSigner *soapSigner;
/* elements */
	NSString * return_;
/* attributes */
}
- (NSString *)nsPrefix;
- (xmlNodePtr)xmlNodeForDoc:(xmlDocPtr)doc elementName:(NSString *)elName elementNSPrefix:(NSString *)elNSPrefix;
- (void)addAttributesToNode:(xmlNodePtr)node;
- (void)addElementsToNode:(xmlNodePtr)node;
+ (AuthenticationService_loginResponse *)deserializeNode:(xmlNodePtr)cur;
- (void)deserializeAttributesFromNode:(xmlNodePtr)cur;
- (void)deserializeElementsFromNode:(xmlNodePtr)cur;
@property (retain) SOAPSigner *soapSigner;
/* elements */
@property (nonatomic, retain) NSString * return_;
/* attributes */
- (NSDictionary *)attributes;
@end
/* Cookies handling provided by http://en.wikibooks.org/wiki/Programming:WebObjects/Web_Services/Web_Service_Provider */
#import <libxml/parser.h>
#import "xs.h"
#import "AuthenticationService.h"
@class AuthenticationPortBinding;
@interface AuthenticationService : NSObject {
	
}
+ (AuthenticationPortBinding *)AuthenticationPortBinding;
@end
@class AuthenticationPortBindingResponse;
@class AuthenticationPortBindingOperation;
@protocol AuthenticationPortBindingResponseDelegate <NSObject>
- (void) operation:(AuthenticationPortBindingOperation *)operation completedWithResponse:(AuthenticationPortBindingResponse *)response;
@end
#define kServerAnchorCertificates   @"kServerAnchorCertificates"
#define kServerAnchorsOnly          @"kServerAnchorsOnly"
#define kClientIdentity             @"kClientIdentity"
#define kClientCertificates         @"kClientCertificates"
#define kClientUsername             @"kClientUsername"
#define kClientPassword             @"kClientPassword"
#define kNSURLCredentialPersistence @"kNSURLCredentialPersistence"
#define kValidateResult             @"kValidateResult"
@interface AuthenticationPortBinding : NSObject <AuthenticationPortBindingResponseDelegate> {
	NSURL *address;
	NSTimeInterval timeout;
	NSMutableArray *cookies;
	NSMutableDictionary *customHeaders;
	BOOL logXMLInOut;
	BOOL ignoreEmptyResponse;
	BOOL synchronousOperationComplete;
	id<SSLCredentialsManaging> sslManager;
	SOAPSigner *soapSigner;
}
@property (nonatomic, copy) NSURL *address;
@property (nonatomic) BOOL logXMLInOut;
@property (nonatomic) BOOL ignoreEmptyResponse;
@property (nonatomic) NSTimeInterval timeout;
@property (nonatomic, retain) NSMutableArray *cookies;
@property (nonatomic, retain) NSMutableDictionary *customHeaders;
@property (nonatomic, retain) id<SSLCredentialsManaging> sslManager;
@property (nonatomic, retain) SOAPSigner *soapSigner;
+ (NSTimeInterval) defaultTimeout;
- (id)initWithAddress:(NSString *)anAddress;
- (void)sendHTTPCallUsingBody:(NSString *)body soapAction:(NSString *)soapAction forOperation:(AuthenticationPortBindingOperation *)operation;
- (void)addCookie:(NSHTTPCookie *)toAdd;
- (NSString *)MIMEType;
- (AuthenticationPortBindingResponse *)loginUsingParameters:(AuthenticationService_login *)aParameters ;
- (void)loginAsyncUsingParameters:(AuthenticationService_login *)aParameters  delegate:(id<AuthenticationPortBindingResponseDelegate>)responseDelegate;
@end
@interface AuthenticationPortBindingOperation : NSOperation {
	AuthenticationPortBinding *binding;
	AuthenticationPortBindingResponse *response;
	id<AuthenticationPortBindingResponseDelegate> delegate;
	NSMutableData *responseData;
	NSURLConnection *urlConnection;
}
@property (nonatomic, retain) AuthenticationPortBinding *binding;
@property (nonatomic, readonly) AuthenticationPortBindingResponse *response;
@property (nonatomic, assign) id<AuthenticationPortBindingResponseDelegate> delegate;
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, retain) NSURLConnection *urlConnection;
- (id)initWithBinding:(AuthenticationPortBinding *)aBinding delegate:(id<AuthenticationPortBindingResponseDelegate>)aDelegate;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
@end
@interface AuthenticationPortBinding_login : AuthenticationPortBindingOperation {
	AuthenticationService_login * parameters;
}
@property (nonatomic, retain) AuthenticationService_login * parameters;
- (id)initWithBinding:(AuthenticationPortBinding *)aBinding delegate:(id<AuthenticationPortBindingResponseDelegate>)aDelegate
	parameters:(AuthenticationService_login *)aParameters
;
@end
@interface AuthenticationPortBinding_envelope : NSObject {
}
+ (AuthenticationPortBinding_envelope *)sharedInstance;
- (NSString *)serializedFormUsingHeaderElements:(NSDictionary *)headerElements bodyElements:(NSDictionary *)bodyElements bodyKeys:(NSArray *)bodyKeys;
@end
@interface AuthenticationPortBindingResponse : NSObject {
	NSArray *headers;
	NSArray *bodyParts;
	NSError *error;
}
@property (nonatomic, retain) NSArray *headers;
@property (nonatomic, retain) NSArray *bodyParts;
@property (nonatomic, retain) NSError *error;
@end
