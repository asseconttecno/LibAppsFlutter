#import "AssecontservicesPlugin.h"
#if __has_include(<assecontservices/assecontservices-Swift.h>)
#import <assecontservices/assecontservices-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "assecontservices-Swift.h"
#endif

@implementation AssecontservicesPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAssecontservicesPlugin registerWithRegistrar:registrar];
}
@end
