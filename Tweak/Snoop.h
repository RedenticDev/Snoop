#import <Cephei/HBPreferences.h>
#define IOS_13_OR_MORE ([[UIDevice currentDevice].systemVersion floatValue] >= 13.0)

// iOS 13+
@interface SBApplication : NSObject
@property (nonatomic, readonly) NSString* displayName;
@end

@interface SBIcon : NSObject
@end

@interface SBLeafIcon : SBIcon
@end

@interface SBApplicationIcon : SBLeafIcon
-(id)application;
@end

@interface SBIconView : UIView
@property (nonatomic, readonly) NSURL* applicationBundleURLForShortcuts;
@property (nonatomic, retain) SBIcon* icon;
@end

// iOS 11/12
@interface SBUIAppIconForceTouchControllerDataProvider : NSObject
@property (nonatomic, readonly) NSURL* applicationBundleURL;
@end

@interface SBSApplicationShortcutItem : NSObject <NSCopying>
@property (nonatomic, copy) NSString* localizedTitle;
@property (nonatomic, copy) NSString* localizedSubtitle;
@property (nonatomic, copy) NSString* type;
@end
