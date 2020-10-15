#import <AppleIDCallbacksDelegate.h>
#import <AppleID.h>
#import <UIKit/UIKit.h>
#import <AuthenticationServices/AuthenticationServices.h>

@implementation AppleIDCallbacksDelegate

 - (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization  API_AVAILABLE(ios(13.0)){
	
	NSLog(@"%s", __FUNCTION__);
	NSLog(@"%@", controller);
	NSLog(@"%@", authorization);
	
	NSLog(@"authorization.credential：%@", authorization.credential);
	
	if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
		ASAuthorizationAppleIDCredential *appleIDCredential = authorization.credential;

		NSString* user_ = @"";
		NSString* email_ = @"";
		NSString* givenName_ = @"";
		NSString* familyName_ = @"";
		NSString* identityToken_ = @"";

		if (appleIDCredential.user) {
			user_ = appleIDCredential.user;
		}
		if (appleIDCredential.email) {
			email_ = appleIDCredential.email;
		}
		if (appleIDCredential.fullName.givenName) {
			givenName_ = appleIDCredential.fullName.givenName;
		}
		if (appleIDCredential.fullName.familyName) {
			familyName_ = appleIDCredential.fullName.familyName;
		}
		if ([appleIDCredential identityToken]) {
			NSData *tokenData = [appleIDCredential identityToken];
			auto token = [[NSString alloc] initWithData:tokenData encoding:NSUTF8StringEncoding];
			identityToken_ = token;
		}

		extension_appleid::onLoginSuccessCallback(
			[user_ UTF8String],
			[email_ UTF8String],
			[givenName_ UTF8String],
			[familyName_ UTF8String],
			[identityToken_ UTF8String]
		);
	}
	else {
		extension_appleid::onLoginFailedCallback();
	}
}
 
 - (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error API_AVAILABLE(ios(13.0)) {
	
	NSLog(@"%s", __FUNCTION__);
	NSLog(@"error ：%@", error);

	NSString *errorMsg = nil;
	switch (error.code) {
		case ASAuthorizationErrorCanceled:
			errorMsg = @"ASAuthorizationErrorCanceled";
			break;
		case ASAuthorizationErrorFailed:
			errorMsg = @"ASAuthorizationErrorFailed";
			break;
		case ASAuthorizationErrorInvalidResponse:
			errorMsg = @"ASAuthorizationErrorInvalidResponse";
			break;
		case ASAuthorizationErrorNotHandled:
			errorMsg = @"ASAuthorizationErrorNotHandled";
			break;
		case ASAuthorizationErrorUnknown:
			errorMsg = @"ASAuthorizationErrorUnknown";
			break;
	}
	
	if (errorMsg) {
		extension_appleid::onLoginErrorCallback([errorMsg UTF8String]);
	} else if (error.localizedDescription) {
		extension_appleid::onLoginErrorCallback([error.localizedDescription UTF8String]);
	} else {
		extension_appleid::onLoginErrorCallback("Unknown error");
	}
   
}
@end
