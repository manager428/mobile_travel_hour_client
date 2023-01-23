#include "AppDelegate.h"
#include "GeneratedPluginRegistrant.h"
#import "GoogleMaps/GoogleMaps.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  // Override point for customization after application launch.
  [GMSServices provideAPIKey: @"AIzaSyAarJdnd3Q7GzxrJCxET3MsVdi40yWP6zU"];     // Paste your google map API key here
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
