//
//  AcademyWelcomeController.h
//  Compositor (MacVim fork — Detroit Automation Academy build line)
//
//  SDS-8 welcome screen + SDS-10 conformance, following the estate's
//  conforming pattern (`MPWelcomeController`, MacDown test-12): the
//  welcome draws the app's own AppIcon composition (via
//  [NSApp applicationIconImage], so the welcome mark is the bundle
//  icon by construction — SDS-10 10.1.2), displays the build's
//  version read from the bundle's own Info.plist at runtime
//  (10.2.2, never hardcoded), and plays the standard startup sound
//  once at presentation (10.3; the bundled startup-sound.wav is
//  byte-identical to the SDS-10 library master, SHA-256
//  07a113244c6b432b22954a089ce519bd239311b14a48f26ae85214ed8c25b09a).
//
//  Presentation rule: once per build — the welcome is the build's
//  startup screen; a new Academy build (a new CFBundleVersion)
//  presents it again, a relaunch of the same build does not.
//

#import <Cocoa/Cocoa.h>

@interface AcademyWelcomeController : NSWindowController

// Present the SDS-8 welcome unless it has already been presented for
// the running build (keyed on the bundle's own CFBundleVersion).
+ (void)presentWelcomeIfNeeded;

@end
