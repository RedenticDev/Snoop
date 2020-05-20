// Traductions, apps désactivées, désactiver les items stocks pour apps, app name iOS 12
#import "Snoop.h"

NSString* appPath;

// Settings
HBPreferences* prefs;
BOOL enabled = YES;
NSInteger insertAtTop = 0;
NSString* fileManagerName = @"Filza"; // iFile
NSString* fileManagerScheme = @"filza://view"; // ifile:///
NSArray* disabledApps;
NSArray* disableStockItemsApps;

static NSArray* addSnoopToArray(NSArray* array, NSString* appName) {
    NSMutableArray* menuList = [array mutableCopy];
    if (!menuList) menuList = [NSMutableArray new];

    if (enabled) {
        SBSApplicationShortcutItem* snoopItem = [[%c(SBSApplicationShortcutItem) alloc] init];
        snoopItem.localizedTitle = @"Snoop";
        snoopItem.localizedSubtitle = [NSString stringWithFormat:@"Open %@ in %@", appName, fileManagerName];
        snoopItem.type = @"SnoopItem";
        insertAtTop ? [menuList insertObject:snoopItem atIndex:0] : [menuList addObject:snoopItem];
    }

    return menuList;
}

%group iOS_13_PLUS

    %hook SBIconView

        -(NSArray*)applicationShortcutItems {
            appPath = [[self applicationBundleURLForShortcuts].absoluteString stringByReplacingOccurrencesOfString:@"file://" withString:fileManagerScheme];
            return addSnoopToArray(%orig, ((SBApplication*)[(SBApplicationIcon*)self.icon application]).displayName);
        }

        +(void)activateShortcut:(SBSApplicationShortcutItem*)item withBundleIdentifier:(id)arg2 forIconView:(id)arg3 {
            if ([[item type] isEqualToString:@"SnoopItem"]) {
                [[%c(UIApplication) sharedApplication] openURL:[NSURL URLWithString:appPath] options:@{} completionHandler:nil];
                return;
            }
            %orig;
        }

    %end

    %hook _UIContextMenuActionView

        -(id)initWithTitle:(id)title subtitle:(id)arg2 image:(id)image {
            if ([title isEqualToString:@"Snoop"]) {
                image = [[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/SNPPrefs.bundle/forcetouch.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            }
            return %orig;
        }

    %end

%end

%group iOS_11_12

    %hook SBUIAppIconForceTouchControllerDataProvider

        -(NSArray*)applicationShortcutItems {
            appPath = [[self applicationBundleURL].absoluteString stringByReplacingOccurrencesOfString:@"file://" withString:fileManagerScheme];
            return addSnoopToArray(%orig, @"app"); // CFBundleName in appPath/Info.plist
        }

    %end

    %hook SBUIAppIconForceTouchController

        -(void)appIconForceTouchShortcutViewController:(id)arg1 activateApplicationShortcutItem:(SBSApplicationShortcutItem*)item {
            if ([[item type] isEqualToString:@"SnoopItem"]) {
                [[%c(UIApplication) sharedApplication] openURL:[NSURL URLWithString:appPath] options:@{} completionHandler:nil];
                return;
            }
            %orig;
        }

    %end

    %hook SBUIAction

        -(id)initWithTitle:(id)title subtitle:(id)arg2 image:(id)image badgeView:(id)arg4 handler:(/*^block*/id)arg5 {
            if ([title isEqualToString:@"Snoop"]) {
                image = [[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/SNPPrefs.bundle/forcetouch.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            }
            return %orig;
        }

    %end

%end

static void reloadPrefs() {
    enabled = [[prefs objectForKey:@"enabled"] boolValue];
    insertAtTop = [[prefs objectForKey:@"insertAtTop"] intValue];
    fileManagerName = [[prefs objectForKey:@"fileManagerName"] stringValue];
    if ([fileManagerName isEqualToString:@"Filza"]) {
        fileManagerScheme = @"filza://view";
    } else if ([fileManagerName isEqualToString:@"iFile"]) {
        fileManagerScheme = @"ifile:///";
    }
}

%ctor {
    if (enabled) {
        prefs = [[HBPreferences alloc] initWithIdentifier:@"com.redenticdev.snoop"];
        [prefs registerBool:&enabled default:YES forKey:@"enabled"];
        [prefs registerInteger:&insertAtTop default:0 forKey:@"insertAtTop"];
        [prefs registerObject:&fileManagerName default:@"Filza" forKey:@"fileManagerName"];

        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadPrefs, CFSTR("com.redenticdev.snoop/ReloadPrefs"), NULL, CFNotificationSuspensionBehaviorCoalesce);

        if (IOS_13_OR_MORE) {
            %init(iOS_13_PLUS);
        } else {
            %init(iOS_11_12);
        }
    }
}
