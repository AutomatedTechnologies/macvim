//
//  AcademyWelcomeController.m
//  Compositor (MacVim fork — Detroit Automation Academy build line)
//
//  Code-constructed SDS-8 welcome screen, following the estate's
//  conforming patterns: `DistroWelcomeController` (Distro,
//  distro-test-40) for the window/label/version-line construction
//  and `MPWelcomeController` (MacDown) for the overall shape.
//  No nib, no auto-dismiss: a single user-driven Continue action.
//

#import "AcademyWelcomeController.h"


static NSString * const AcademyWelcomeShownBuildKey =
    @"AcademyWelcomeShownBuild";


static NSTextField *AcademyWelcomeLabel(NSString *text, CGFloat size,
                                        BOOL bold, NSColor *color)
{
    NSTextField *label = [[NSTextField alloc] initWithFrame:NSZeroRect];
    [label setStringValue:text];
    [label setFont:bold ? [NSFont boldSystemFontOfSize:size]
                        : [NSFont systemFontOfSize:size]];
    [label setTextColor:color];
    [label setBezeled:NO];
    [label setDrawsBackground:NO];
    [label setEditable:NO];
    [label setSelectable:NO];
    [label setAlignment:NSTextAlignmentCenter];
    return label;
}


@interface AcademyWelcomeController ()
@property (nonatomic, strong) NSSound *startupSound;
@property (nonatomic) BOOL soundPlayed;
@end


@implementation AcademyWelcomeController

static AcademyWelcomeController *sharedWelcomeController = nil;

+ (void)presentWelcomeIfNeeded
{
    NSString *build = [[NSBundle mainBundle]
        objectForInfoDictionaryKey:@"CFBundleVersion"];
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if (build.length &&
        [build isEqualToString:[ud stringForKey:AcademyWelcomeShownBuildKey]])
        return;
    if (build.length)
        [ud setObject:build forKey:AcademyWelcomeShownBuildKey];

    if (!sharedWelcomeController)
        sharedWelcomeController = [[AcademyWelcomeController alloc] init];
    [sharedWelcomeController showWindow:nil];
    [[sharedWelcomeController window] makeKeyAndOrderFront:nil];
    [NSApp activateIgnoringOtherApps:YES];
    [sharedWelcomeController playStartupSoundOnce];
}

- (instancetype)init
{
    NSRect frame = NSMakeRect(0, 0, 480, 440);
    NSWindow *window = [[NSWindow alloc] initWithContentRect:frame
        styleMask:(NSWindowStyleMaskTitled | NSWindowStyleMaskClosable)
          backing:NSBackingStoreBuffered
            defer:NO];
    [window setTitle:@"Welcome to Compositor"];
    [window setReleasedWhenClosed:NO];
    self = [super initWithWindow:window];
    if (self)
    {
        NSView *content = [window contentView];
        CGFloat w = NSWidth(frame);

        // SDS-10 10.1.2: the welcome mark is the bundle AppIcon
        // composition itself — the application icon image, not a
        // second drawing that could drift from the Dock icon.
        NSImageView *icon = [[NSImageView alloc]
            initWithFrame:NSMakeRect((w - 112) / 2, 440 - 40 - 112, 112, 112)];
        [icon setImage:[NSApp applicationIconImage]];
        [icon setImageScaling:NSImageScaleProportionallyUpOrDown];
        [content addSubview:icon];

        NSTextField *name = AcademyWelcomeLabel(@"Compositor", 28, YES,
                                                [NSColor blackColor]);
        [name setFrame:NSMakeRect(40, NSMinY(icon.frame) - 52, w - 80, 36)];
        [content addSubview:name];

        NSTextField *signature = AcademyWelcomeLabel(
            @"Detroit Automation Academy", 13, NO,
            [NSColor colorWithCalibratedWhite:0.27 alpha:1.0]);
        [signature setFrame:NSMakeRect(40, NSMinY(name.frame) - 28,
                                       w - 80, 20)];
        [content addSubview:signature];

        NSTextField *copyLine = AcademyWelcomeLabel(
            @"Vim, with a native Mac face — a modal editor for code "
            @"and prose, maintained for macOS High Sierra.", 12.5, NO,
            [NSColor blackColor]);
        [copyLine setFrame:NSMakeRect(50, NSMinY(signature.frame) - 58,
                                      w - 100, 44)];
        [[copyLine cell] setWraps:YES];
        [content addSubview:copyLine];

        NSTextField *provenance = AcademyWelcomeLabel(
            @"Built from the MacVim fork of Vim (Vim License). "
            @"Modified by the Detroit Automation Academy.", 11, NO,
            [NSColor colorWithCalibratedWhite:0.27 alpha:1.0]);
        [provenance setFrame:NSMakeRect(50, NSMinY(copyLine.frame) - 40,
                                        w - 100, 30)];
        [[provenance cell] setWraps:YES];
        [content addSubview:provenance];

        NSButton *continueButton = [[NSButton alloc]
            initWithFrame:NSMakeRect((w - 140) / 2, 44, 140, 32)];
        [continueButton setTitle:@"Continue"];
        [continueButton setBezelStyle:NSBezelStyleRounded];
        [continueButton setFont:[NSFont systemFontOfSize:13]];
        [continueButton setTarget:self];
        [continueButton setAction:@selector(continuePressed:)];
        [continueButton setKeyEquivalent:@"\r"];
        [content addSubview:continueButton];

        // SDS-10 10.2: the version line is composed at runtime from
        // the bundle's own Info.plist (CFBundleShortVersionString +
        // CFBundleVersion) — never hardcoded into the interface.
        NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
        NSString *shortVersion = info[@"CFBundleShortVersionString"];
        NSString *buildVersion = info[@"CFBundleVersion"];
        NSString *versionText;
        if (buildVersion.length &&
            ![buildVersion isEqualToString:shortVersion])
            versionText = [NSString stringWithFormat:@"Version %@ (%@)",
                           shortVersion, buildVersion];
        else
            versionText = [NSString stringWithFormat:@"Version %@",
                           shortVersion];
        NSTextField *version = AcademyWelcomeLabel(
            versionText, 11, NO,
            [NSColor colorWithCalibratedWhite:0.27 alpha:1.0]);
        [version setFrame:NSMakeRect(40, 14, w - 80, 16)];
        [content addSubview:version];

        [window center];
    }
    return self;
}

- (void)playStartupSoundOnce
{
    if (self.soundPlayed)
        return;
    self.soundPlayed = YES;
    NSString *path = [[NSBundle mainBundle]
        pathForResource:@"startup-sound" ofType:@"wav"];
    if (!path.length)
        return;
    self.startupSound = [[NSSound alloc] initWithContentsOfFile:path
                                                    byReference:NO];
    [self.startupSound play];
}

- (IBAction)continuePressed:(id)sender
{
    [[self window] close];
}

@end
