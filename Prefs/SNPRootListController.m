#include "SNPRootListController.h"

@implementation SNPRootListController

- (instancetype)init {
    self = [super init];

    if (self) {
        HBAppearanceSettings *appearanceSettings = [[SNPAppearanceSettings alloc] init];
        self.hb_appearanceSettings = appearanceSettings;
        self.respringButton = [[UIBarButtonItem alloc] initWithTitle:@"Respring" style:UIBarButtonItemStylePlain target:self action:@selector(respring)];
        self.respringButton.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = self.respringButton;

        self.navigationItem.titleView = [UIView new];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.titleLabel.text = @"Snoop";
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.navigationItem.titleView addSubview:self.titleLabel];

        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        self.iconView.contentMode = UIViewContentModeScaleAspectFit;
        self.iconView.image = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/SNPPrefs.bundle/icon@2x.png"];
        self.iconView.translatesAutoresizingMaskIntoConstraints = NO;
        self.iconView.alpha = 0.0;
        [self.navigationItem.titleView addSubview:self.iconView];

        [NSLayoutConstraint activateConstraints:@[
            [self.titleLabel.topAnchor constraintEqualToAnchor:self.navigationItem.titleView.topAnchor],
            [self.titleLabel.leadingAnchor constraintEqualToAnchor:self.navigationItem.titleView.leadingAnchor],
            [self.titleLabel.trailingAnchor constraintEqualToAnchor:self.navigationItem.titleView.trailingAnchor],
            [self.titleLabel.bottomAnchor constraintEqualToAnchor:self.navigationItem.titleView.bottomAnchor],
            [self.iconView.topAnchor constraintEqualToAnchor:self.navigationItem.titleView.topAnchor],
            [self.iconView.leadingAnchor constraintEqualToAnchor:self.navigationItem.titleView.leadingAnchor],
            [self.iconView.trailingAnchor constraintEqualToAnchor:self.navigationItem.titleView.trailingAnchor],
            [self.iconView.bottomAnchor constraintEqualToAnchor:self.navigationItem.titleView.bottomAnchor],
        ]];
    }

    return self;
}

-(NSArray *)specifiers {
	if (_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headerImageView.image = [UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/SNPPrefs.bundle/Banner.png"];
    self.headerImageView.translatesAutoresizingMaskIntoConstraints = NO;

    [self.headerView addSubview:self.headerImageView];
    [NSLayoutConstraint activateConstraints:@[
        [self.headerImageView.topAnchor constraintEqualToAnchor:self.headerView.topAnchor],
        [self.headerImageView.leadingAnchor constraintEqualToAnchor:self.headerView.leadingAnchor],
        [self.headerImageView.trailingAnchor constraintEqualToAnchor:self.headerView.trailingAnchor],
        [self.headerImageView.bottomAnchor constraintEqualToAnchor:self.headerView.bottomAnchor],
    ]];

    _table.tableHeaderView = self.headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.tableHeaderView = self.headerView;
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    CGRect frame = self.table.bounds;
    frame.origin.y = -frame.size.height;

    self.navigationController.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:1.00];
    [self.navigationController.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationController.navigationBar.translucent = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.navigationController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;

    if (offsetY > 200) {
        [UIView animateWithDuration:0.2 animations:^{
            self.iconView.alpha = 1.0;
            self.titleLabel.alpha = 0.0;
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.iconView.alpha = 0.0;
            self.titleLabel.alpha = 1.0;
        }];
    }

    if (offsetY > 0) {
        offsetY = 0;
    }
    self.headerImageView.frame = CGRectMake(0, offsetY, self.headerView.frame.size.width, 200 - offsetY);
}

- (void)respring {
	UIAlertController *respring = [UIAlertController alertControllerWithTitle:@"Snoop" message:@"Do you really want to respring you device?" preferredStyle:UIAlertControllerStyleActionSheet];
	UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
		[HBRespringController respring];
	}];

	UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];

	[respring addAction:confirmAction];
	[respring addAction:cancelAction];
	[self presentViewController:respring animated:YES completion:nil];
}

@end

@implementation SNPAppListController

-(id)init {
    self = [super init];
    if (self) {
        // PSSpecifier* specifier = [PSSpecifier preferenceSpecifierNamed:@"Disable Snoop in all apps" target:self set:NULL get:NULL detail:Nil cell:PSButtonCell edit:Nil];
        CGSize size = [[UIScreen mainScreen] bounds].size;
        NSNumber* iconSize = [NSNumber numberWithUnsignedInteger:ALApplicationIconSizeSmall];

        _dataSource = [[ALApplicationTableDataSource alloc] init];
        _dataSource.sectionDescriptors = [NSArray arrayWithObjects:
            [NSDictionary dictionaryWithObjectsAndKeys:
                @"System Applications", ALSectionDescriptorTitleKey,
                @"ALDisclosureIndicatedCell", ALSectionDescriptorCellClassNameKey,
                iconSize, ALSectionDescriptorIconSizeKey,
                @YES, ALSectionDescriptorSuppressHiddenAppsKey,
                @"isSystemApplication = TRUE", ALSectionDescriptorPredicateKey
            , nil],
            [NSDictionary dictionaryWithObjectsAndKeys:
                @"User Applications", ALSectionDescriptorTitleKey,
                @"ALDisclosureIndicatedCell", ALSectionDescriptorCellClassNameKey,
                iconSize, ALSectionDescriptorIconSizeKey,
                @YES, ALSectionDescriptorSuppressHiddenAppsKey,
                @"isSystemApplication = FALSE", ALSectionDescriptorPredicateKey
            , nil]
        , nil];

        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height) style:UITableViewStyleGrouped];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = _dataSource;
        _dataSource.tableView = _tableView;

        [_tableView reloadData];
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    ((UIViewController*)self).title = @"Applications";
    [self.view addSubview:_tableView];
}

-(void)dealloc {
    _tableView.delegate = nil;
    [_tableView release];
    [_dataSource release];
    [super dealloc];
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    UITableViewCell* cell = (UITableViewCell*)[_tableView cellForRowAtIndexPath:indexPath];
    NSString* appName = cell.textLabel.text;
    NSString* appIdentifier = [_dataSource displayIdentifierForIndexPath:indexPath];

    SNPIndividualAppController* controller = [[SNPIndividualAppController alloc] initWithAppName:appName displayIdentifier:appIdentifier];
    controller.rootController = self.rootController;
    controller.parentController = self;

    [self pushController:controller];
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}

@end

@implementation SNPIndividualAppController

-(id)specifiers {
    if (!_specifiers) {
        NSMutableArray* specifiers = (NSMutableArray*)[[self loadSpecifiersFromPlistName:@"AppSettings" target:self] retain];
        for(PSSpecifier *spec in specifiers) {
            NSString* key = [spec propertyForKey:@"key"];
            if (key != nil) {
                [spec setProperty:[NSString stringWithFormat:@"%@-%@", key, _displayIdentifier] forKey:@"key"];
            }
        }
        _specifiers = specifiers;
    }
    return _specifiers;
}

-(id)initWithAppName:(NSString*)appName displayIdentifier:(NSString*)displayIdentifier {
    self = [super init];
    if (self) {
        self.hb_appearanceSettings = [[SNPAppearanceSettings alloc] init];
        _appName = appName;
        _displayIdentifier = displayIdentifier;
    }
    return self;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    ((UIViewController*)self).title = _appName;
}

@end
