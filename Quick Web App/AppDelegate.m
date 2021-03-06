//
//  AppDelegate.m
//  Quick Web App
//
//  Created by Victor Torres on 8/26/15.
//  Copyright (c) 2015 Victor Torres. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property (weak) IBOutlet NSImageView *iconPreview;
@property (weak) IBOutlet NSTextField *appName;
@property (weak) IBOutlet NSTextField *appURL;
@property (weak) IBOutlet NSTextField *appIcon;
- (IBAction)chooseIcon:(id)sender;
- (IBAction)createApp:(id)sender;

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)chooseIcon:(id)sender {
    // Choose file here
    NSArray *fileTypes = [NSArray arrayWithObjects: @"png", @"PNG", nil];
    NSOpenPanel * panel = [NSOpenPanel openPanel];
    [panel setAllowedFileTypes:fileTypes];
    [panel setAllowsMultipleSelection:NO];
    [panel setCanChooseDirectories:NO];
    [panel setCanChooseFiles:YES];
    [panel setFloatingPanel:NO];
    NSInteger result = [panel runModal];
    if(result == NSModalResponseOK)
    {
        NSURL *iconURL = [panel URL];
        NSString *iconPath = iconURL.path;
        _appIcon.stringValue = iconPath;
        NSImage *iconImage = [[NSImage alloc] initWithContentsOfURL:iconURL];
        [_iconPreview setImage:iconImage];
        [_iconPreview setImageAlignment:NSImageAlignCenter];
    }
}

- (IBAction)createApp:(id)sender {
    // Run shell script here
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"makeapp" ofType:@"sh"];
    NSString *appName = _appName.stringValue;
    NSString *appURL = _appURL.stringValue;
    NSString *appIcon = _appIcon.stringValue;
    
    // Verifies if any field is blank
    NSString *errorMessage = @"";
    if ([appName isEqual: @""]) {
        errorMessage = @"App name should not be blank.";
    } else if ([appURL isEqual: @""]) {
        errorMessage = @"App URL should not be blank.";
    } else if ([appIcon isEqual: @""]) {
        errorMessage = @"App icon should not be blank.";
    }
    // If there's a blank field, shows alert
    if ([errorMessage isNotEqualTo: @""]) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:errorMessage];
        [alert addButtonWithTitle:@"OK"];
        [alert runModal];
        return;
    }
    
    NSTask *task = [[NSTask alloc] init];
    task.launchPath = filePath;
    task.arguments = @[appName, appURL, appIcon];
    [task launch];
    // Shows alert
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:[NSString stringWithFormat:@"Your app \"%@\" has been created!", appName]];
    [alert addButtonWithTitle:@"OK"];
    [alert runModal];
}
@end
