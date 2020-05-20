#import "SNPRootListController.h"

@implementation SNPAppearanceSettings

-(UIColor *)statusBarTintColor {
    return [UIColor whiteColor];
}

-(UIColor *)navigationBarTitleColor {
    return [UIColor whiteColor];
}

-(UIColor *)navigationBarTintColor {
    return [UIColor whiteColor];
}

-(UIColor *)navigationBarBackgroundColor {
    return [UIColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:1.00];
}

-(BOOL)translucentNavigationBar {
    return NO;
}

-(NSUInteger)largeTitleStyle {
    return 2;
}

@end
