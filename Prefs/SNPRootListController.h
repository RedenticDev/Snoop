#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <CepheiPrefs/HBRootListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>
#import <Cephei/HBRespringController.h>
#import <Cephei/HBPreferences.h>
#import <AppList/AppList.h>

@interface SNPAppearanceSettings : HBAppearanceSettings
@end

@interface SNPRootListController : HBRootListController {
    UITableView* _table;
}


@property (nonatomic, retain) UIBarButtonItem *respringButton;
@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) UIImageView *headerImageView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UIImageView *iconView;

-(void)respring;

@end

@interface SNPAppListController : PSViewController <UITableViewDelegate> {
    UITableView* _tableView;
    ALApplicationTableDataSource* _dataSource;
}
@end

@interface SNPIndividualAppController : HBListController {
    NSString* _appName;
    NSString* _displayIdentifier;
}
-(id)initWithAppName:(NSString*)appName displayIdentifier:(NSString*)displayIdentifier;
@end
