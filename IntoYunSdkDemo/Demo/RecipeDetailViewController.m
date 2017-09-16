//
//  RecipeDetailViewController.m
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/28.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import <MJExtension/MJExtension.h>
#import "RecipeDetailViewController.h"
#import "Macros.h"
#import "DatapointModel.h"
#import "IntoSystemDatapoints.h"
#import "IntoYunFMDBTool.h"
#import "IntoYunUtils.h"
#import "TriggerTimerView.h"
#import "TriggerBoolView.h"
#import "TriggerNumberView.h"
#import "TriggerEnumView.h"
#import "ActionEmailView.h"
#import "ActionStringView.h"
#import "ActionBoolView.h"
#import "ActionEnumView.h"
#import "ActionNumberView.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+IntoYun.h"

@interface RecipeDetailViewController () <RecipeSettingDelegate>

@property(nonatomic, weak) UIView *descriptionView;

@property(nonatomic, weak) UIView *typeContentView;

@property(nonatomic, weak) UIView *triggerContentView;

@property(nonatomic, weak) UIView *actionContentView;

@property (nonatomic, weak) UILabel *descriptionLabel;

@property(nonatomic, weak) UIButton *edgeButton;

@property(nonatomic, weak) UIButton *periodButton;

@property(nonatomic, weak) UIScrollView *contentScrollview;

@property(nonatomic, strong) DatapointModel *triggerDatapoint;

@property(nonatomic, strong) DatapointModel *actionDatapoint;

@property(nonatomic, strong) NSMutableDictionary *logicDic;

@property(nonatomic, strong) NSMutableArray *weekArray;

@end

@implementation RecipeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigation];
    [self initData];
    [self initView];
}

- (void)setNavigation {
    self.navigationItem.title = NSLocalizedString(@"recipe_detail_title", nil);
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back", nill) style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    // save
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(onClickSaveButton)];
    NSArray *buttonItem = @[saveButton];
    self.navigationItem.rightBarButtonItems = buttonItem;
}

- (void)initData {
    if (!self.isCreate){
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.createRecipe = [RecipeModel mj_objectWithKeyValues:[defaults valueForKey:@"recipe"]];
    }
    NSNumber *dpIp = self.createRecipe.dpIds[0];
    if ([((NSString *) self.createRecipe.prdIds[0]) isEqualToString:SYSTEM_PRODUCT_ID]) {
        self.triggerDatapoint = ((NSArray *) [IntoSystemDatapoints shareAllDatapoints])[0];
    } else {
        self.triggerDatapoint = [IntoYunFMDBTool getDatapointWithDpID:(NSString *) self.createRecipe.prdIds[0] dpID:[dpIp intValue]];
    }

    dpIp = self.createRecipe.dpIds[1];
    if ([((NSString *) self.createRecipe.prdIds[1]) isEqualToString:SYSTEM_PRODUCT_ID]) {
        self.actionDatapoint = ((NSArray *) [IntoSystemDatapoints shareAllDatapoints])[[dpIp intValue] - 1];
    } else {
        self.actionDatapoint = [IntoYunFMDBTool getDatapointWithDpID:(NSString *) self.createRecipe.prdIds[1] dpID:[dpIp intValue]];
    }


    self.logicDic = [[NSMutableDictionary alloc] initWithCapacity:3];
    [self.logicDic setValue:NSLocalizedString(@"logic_eq", nil) forKey:@"eq"];
    [self.logicDic setValue:NSLocalizedString(@"logic_gt", nil) forKey:@"gt"];
    [self.logicDic setValue:NSLocalizedString(@"logic_lt", nil) forKey:@"lt"];


    NSMutableArray *weekArray = [[NSMutableArray alloc] init];
    [weekArray addObject:NSLocalizedString(@"Sunday", nil)];
    [weekArray addObject:NSLocalizedString(@"Monday", nil)];
    [weekArray addObject:NSLocalizedString(@"Tuesday", nil)];
    [weekArray addObject:NSLocalizedString(@"Wednesday", nil)];
    [weekArray addObject:NSLocalizedString(@"Thursday", nil)];
    [weekArray addObject:NSLocalizedString(@"Friday", nil)];
    [weekArray addObject:NSLocalizedString(@"Saturday", nil)];
    [weekArray addObject:NSLocalizedString(@"everyday", nil)];
    self.weekArray = weekArray;


    if (self.isCreate) {
        [self getRecipeDescription];
    } else {
        [self transferTimeZone:YES];
    }
}

- (void)initView {
    self.view.backgroundColor = SetColor(0xf6, 0xf6, 0xf6, 1.0);
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    scrollView.contentSize = scrollView.frame.size;
    scrollView.bounces = NO;
    [self.view addSubview:scrollView];
    self.contentScrollview = scrollView;

    [self initDescriptionView];
    [self initCategoryContentView];
    [self initTriggerView];
    [self initActionView];
    [self initConstraint];
}


// 设置description
- (void)initDescriptionView {
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = DividerColor;

    // 头像
    UIImageView *avatarView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"placehold1"]];
    [contentView addSubview:avatarView];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        DeviceModel *triggerDevice = [IntoYunFMDBTool getDeviceWithID:self.createRecipe.devices[0]];

        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", API_Base_URL, triggerDevice.imgSrc]];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:imageData];

        dispatch_async(dispatch_get_main_queue(), ^{
            avatarView.frame = CGRectMake(avatarView.frame.origin.x, avatarView.frame.origin.y, 60, 60);
            avatarView.layer.masksToBounds = YES;
            avatarView.layer.cornerRadius = 30;
            if (image) {
                avatarView.image = image;
            } else {
                avatarView.image = [UIImage imageNamed:@"placehold1"];
            }
        });
    });

    // 描述
    UILabel *descriptionLabel = [[UILabel alloc] init];
    descriptionLabel.text = self.createRecipe.recipeDescription;
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.textAlignment = NSTextAlignmentLeft;
    descriptionLabel.font = [UIFont systemFontOfSize:15];
    descriptionLabel.textColor = SetColor(0x23, 0x22, 0x22, 1.0);
    [contentView addSubview:descriptionLabel];
    self.descriptionLabel = descriptionLabel;

    // 使能开关
    UISwitch *enableSwitch = [[UISwitch alloc] init];
    [enableSwitch setOn:self.createRecipe.enabled];
    [contentView addSubview:enableSwitch];

    [enableSwitch addTarget:self action:@selector(setEnableVal:) forControlEvents:UIControlEventValueChanged];

    // 布局约束
    [avatarView mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.top.mas_equalTo(avatarView.superview.mas_top).offset(10);
        maker.bottom.mas_equalTo(avatarView.superview.mas_bottom).offset(-10);
        maker.centerY.mas_equalTo(avatarView.superview.mas_centerY).offset(0);
        maker.left.mas_equalTo(avatarView.superview.mas_left).offset(10);
        maker.height.mas_equalTo(60);
        maker.width.mas_equalTo(60);
    }];

    [descriptionLabel mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.centerY.mas_equalTo(descriptionLabel.superview.mas_centerY).offset(0);
        maker.left.mas_equalTo(avatarView.mas_right).offset(10);
        maker.right.mas_equalTo(enableSwitch.mas_left).offset(-10);
    }];

    [enableSwitch mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.centerY.mas_equalTo(enableSwitch.superview.mas_centerY).offset(0);
        maker.right.mas_equalTo(enableSwitch.superview.mas_right).offset(-10);
        maker.width.mas_equalTo(50);
    }];

    [self.contentScrollview addSubview:contentView];
    self.descriptionView = contentView;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


// 设置recipe type
- (void)initCategoryContentView {
    UIView *typeContent = [[UIView alloc] init];

    UIView *edgeView = [[UIView alloc] init];
    edgeView.backgroundColor = SetColor(0x46, 0xa7, 0xf1, 1.0);

    UILabel *edgeTitleLabel = [[UILabel alloc] init];
    edgeTitleLabel.textColor = [UIColor whiteColor];
    edgeTitleLabel.textAlignment = NSTextAlignmentCenter;
    edgeTitleLabel.font = [UIFont systemFontOfSize:17];
    edgeTitleLabel.text = NSLocalizedString(@"recipe_edge", nil);
    [edgeView addSubview:edgeTitleLabel];

    UILabel *edgeLabel = [[UILabel alloc] init];
    edgeLabel.textColor = [UIColor whiteColor];
    edgeLabel.textAlignment = NSTextAlignmentCenter;
    edgeLabel.numberOfLines = 0;
    edgeLabel.font = [UIFont systemFontOfSize:14];
    edgeLabel.text = NSLocalizedString(@"recipe_edge_detail", nil);
    [edgeView addSubview:edgeLabel];

    UIButton *edgeCheck = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([self.createRecipe.category isEqualToString:RECIPE_TYPE_EDGE]) {
        [edgeCheck setImage:[UIImage imageNamed:@"radio_checked"] forState:UIControlStateNormal];
    } else {
        [edgeCheck setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    }
    [edgeView addSubview:edgeCheck];
    self.edgeButton = edgeCheck;
    self.edgeButton.tag = 1;
    [self.edgeButton addTarget:self action:@selector(setCatagoryVal:) forControlEvents:UIControlEventTouchUpInside];

    [edgeTitleLabel mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.top.mas_equalTo(edgeTitleLabel.superview.mas_top).offset(10);
        maker.centerX.mas_equalTo(edgeTitleLabel.superview.mas_centerX).offset(0);
    }];

    [edgeLabel mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.top.mas_equalTo(edgeTitleLabel.mas_bottom).offset(5);
        maker.left.mas_equalTo(edgeLabel.superview.mas_left).offset(10);
        maker.right.mas_equalTo(edgeLabel.superview.mas_right).offset(-10);
        maker.height.mas_greaterThanOrEqualTo(40);
    }];

    [edgeCheck mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.top.mas_equalTo(edgeLabel.mas_bottom).offset(5);
        maker.right.mas_equalTo(edgeCheck.superview.mas_right).offset(-10);
        maker.bottom.mas_equalTo(edgeCheck.superview.mas_bottom).offset(-10);
        maker.height.mas_equalTo(30);
        maker.width.mas_equalTo(30);
    }];

    [typeContent addSubview:edgeView];


    UIView *periodView = [[UIView alloc] init];
    periodView.backgroundColor = SetColor(0x35, 0xc7, 0xec, 1.0);

    UILabel *periodTitleLabel = [[UILabel alloc] init];
    periodTitleLabel.textColor = [UIColor whiteColor];
    periodTitleLabel.textAlignment = NSTextAlignmentCenter;
    periodTitleLabel.font = [UIFont systemFontOfSize:17];
    periodTitleLabel.text = NSLocalizedString(@"recipe_period", nil);
    [periodView addSubview:periodTitleLabel];

    UILabel *periodLabel = [[UILabel alloc] init];
    periodLabel.textColor = [UIColor whiteColor];
    periodLabel.textAlignment = NSTextAlignmentCenter;
    periodLabel.font = [UIFont systemFontOfSize:14];
    periodLabel.text = NSLocalizedString(@"recipe_period_detail", nil);
    periodLabel.numberOfLines = 0;
    [periodView addSubview:periodLabel];

    UIButton *periodCheck = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([self.createRecipe.category isEqualToString:RECIPE_TYPE_PERIOD]) {
        [periodCheck setImage:[UIImage imageNamed:@"radio_checked"] forState:UIControlStateNormal];
    } else {
        [periodCheck setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    }
    [periodView addSubview:periodCheck];
    self.periodButton = periodCheck;
    self.periodButton.tag = 2;
    [self.periodButton addTarget:self action:@selector(setCatagoryVal:) forControlEvents:UIControlEventTouchUpInside];


    [periodTitleLabel mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.top.mas_equalTo(periodTitleLabel.superview.mas_top).offset(10);
        maker.centerX.mas_equalTo(periodTitleLabel.superview.mas_centerX).offset(0);
    }];

    [periodLabel mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.top.mas_equalTo(periodTitleLabel.mas_bottom).offset(5);
        maker.left.mas_equalTo(periodLabel.superview.mas_left).offset(10);
        maker.right.mas_equalTo(periodLabel.superview.mas_right).offset(-10);
        maker.height.mas_greaterThanOrEqualTo(40);
    }];

    [periodCheck mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.top.mas_equalTo(periodLabel.mas_bottom).offset(5);
        maker.right.mas_equalTo(periodCheck.superview.mas_right).offset(-10);
        maker.bottom.mas_equalTo(periodCheck.superview.mas_bottom).offset(-10);
        maker.height.mas_equalTo(30);
        maker.width.mas_equalTo(30);
    }];

    [typeContent addSubview:periodView];

    [edgeView mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.top.mas_equalTo(edgeView.superview.mas_top).offset(0);
        maker.left.mas_equalTo(edgeView.superview.mas_left).offset(0);
        maker.bottom.mas_equalTo(edgeView.superview.mas_bottom).offset(0);
        maker.right.mas_equalTo(periodView.mas_left).offset(-5);
    }];

    [periodView mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.top.mas_equalTo(periodView.superview.mas_top).offset(0);
        maker.right.mas_equalTo(periodView.superview.mas_right).offset(0);
        maker.bottom.mas_equalTo(periodView.superview.mas_bottom).offset(0);
        maker.height.mas_equalTo(edgeView.mas_height);
        maker.width.mas_equalTo(edgeView.mas_width);
    }];

    self.typeContentView = typeContent;
    [self.contentScrollview addSubview:typeContent];
}

// 设置 trigger
- (void)initTriggerView {
    UIView *triggerContentView = [[UIView alloc] init];

    if ([self.triggerDatapoint.type isEqualToString:TIMER_DT]) {
        TriggerTimerView *view = [[TriggerTimerView alloc] initWithFrame:CGRectMake(0, 0, self.triggerContentView.frame.size.width, 100) DataPoint:self.triggerDatapoint crontab:self.createRecipe.crontab];
        view.delegete = self;
        [triggerContentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *maker) {
            maker.top.mas_equalTo(view.superview.mas_top).offset(0);
            maker.left.mas_equalTo(view.superview.mas_left).offset(0);
            maker.right.mas_equalTo(view.superview.mas_right).offset(0);
            maker.height.mas_equalTo(100);
        }];
    } else if ([self.triggerDatapoint.type isEqualToString:BOOL_DT]) {
        TriggerBoolView *view = [[TriggerBoolView alloc] initWithFrame:CGRectMake(0, 0, self.triggerContentView.frame.size.width, 100) DataPoint:self.triggerDatapoint triggerVal:self.createRecipe.triggerVal];
        view.delegete = self;
        [triggerContentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *maker) {
            maker.top.mas_equalTo(view.superview.mas_top).offset(0);
            maker.left.mas_equalTo(view.superview.mas_left).offset(0);
            maker.right.mas_equalTo(view.superview.mas_right).offset(0);
            maker.height.mas_equalTo(100);
        }];
    } else if ([self.triggerDatapoint.type isEqualToString:NUMBER_DT]) {
        TriggerNumberView *view = [[TriggerNumberView alloc] initWithFrame:CGRectMake(0, 0, self.triggerContentView.frame.size.width, 100) DataPoint:self.triggerDatapoint triggerVal:self.createRecipe.triggerVal];
        view.delegete = self;
        [triggerContentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *maker) {
            maker.top.mas_equalTo(view.superview.mas_top).offset(0);
            maker.left.mas_equalTo(view.superview.mas_left).offset(0);
            maker.right.mas_equalTo(view.superview.mas_right).offset(0);
            maker.height.mas_equalTo(100);
        }];
    } else if ([self.triggerDatapoint.type isEqualToString:ENUM_DT]) {
        TriggerEnumView *view = [[TriggerEnumView alloc] initWithFrame:CGRectMake(0, 0, self.triggerContentView.frame.size.width, 100) DataPoint:self.triggerDatapoint triggerVal:self.createRecipe.triggerVal];
        view.delegete = self;
        [triggerContentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *maker) {
            maker.top.mas_equalTo(view.superview.mas_top).offset(0);
            maker.left.mas_equalTo(view.superview.mas_left).offset(0);
            maker.right.mas_equalTo(view.superview.mas_right).offset(0);
            maker.height.mas_equalTo(100);
        }];
    }

    [self.contentScrollview addSubview:triggerContentView];
    self.triggerContentView = triggerContentView;
}

// 设置action
- (void)initActionView {

    UIView *actionContentView = [[UIView alloc] init];

    if ([self.actionDatapoint.type isEqualToString:EMAIL_DT]) {
        ActionEmailView *view = [[ActionEmailView alloc] initWithFrame:CGRectMake(0, 0, self.triggerContentView.frame.size.width, 100) DataPoint:self.actionDatapoint actionVal:[self.createRecipe.actionVal firstObject]];
        view.delegete = self;
        [actionContentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *maker) {
            maker.top.mas_equalTo(view.superview.mas_top).offset(0);
            maker.left.mas_equalTo(view.superview.mas_left).offset(0);
            maker.right.mas_equalTo(view.superview.mas_right).offset(0);
            maker.height.mas_equalTo(250);
        }];
    } else if ([self.actionDatapoint.type isEqualToString:MESSAGE_DT] || [self.actionDatapoint.type isEqualToString:STRING_DT]) {
        ActionStringView *view = [[ActionStringView alloc] initWithFrame:CGRectMake(0, 0, self.triggerContentView.frame.size.width, 100) DataPoint:self.actionDatapoint actionVal:[self.createRecipe.actionVal firstObject]];
        view.delegete = self;
        [actionContentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *maker) {
            maker.top.mas_equalTo(view.superview.mas_top).offset(0);
            maker.left.mas_equalTo(view.superview.mas_left).offset(0);
            maker.right.mas_equalTo(view.superview.mas_right).offset(0);
            maker.height.mas_equalTo(200);
        }];
    } else if ([self.actionDatapoint.type isEqualToString:BOOL_DT]) {
        ActionBoolView *view = [[ActionBoolView alloc] initWithFrame:CGRectMake(0, 0, self.triggerContentView.frame.size.width, 100) DataPoint:self.actionDatapoint actionVal:[self.createRecipe.actionVal firstObject]];
        view.delegete = self;
        [actionContentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *maker) {
            maker.top.mas_equalTo(view.superview.mas_top).offset(0);
            maker.left.mas_equalTo(view.superview.mas_left).offset(0);
            maker.right.mas_equalTo(view.superview.mas_right).offset(0);
            maker.height.mas_equalTo(100);
        }];
    } else if ([self.actionDatapoint.type isEqualToString:NUMBER_DT]) {
        ActionNumberView *view = [[ActionNumberView alloc] initWithFrame:CGRectMake(0, 0, self.triggerContentView.frame.size.width, 100) DataPoint:self.actionDatapoint actionVal:[self.createRecipe.actionVal firstObject]];
        view.delegete = self;
        [actionContentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *maker) {
            maker.top.mas_equalTo(view.superview.mas_top).offset(0);
            maker.left.mas_equalTo(view.superview.mas_left).offset(0);
            maker.right.mas_equalTo(view.superview.mas_right).offset(0);
            maker.height.mas_equalTo(100);
        }];
    } else if ([self.actionDatapoint.type isEqualToString:ENUM_DT]) {
        ActionEnumView *view = [[ActionEnumView alloc] initWithFrame:CGRectMake(0, 0, self.triggerContentView.frame.size.width, 100) DataPoint:self.actionDatapoint actionVal:[self.createRecipe.actionVal firstObject]];
        view.delegete = self;
        [actionContentView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *maker) {
            maker.top.mas_equalTo(view.superview.mas_top).offset(0);
            maker.left.mas_equalTo(view.superview.mas_left).offset(0);
            maker.right.mas_equalTo(view.superview.mas_right).offset(0);
            maker.height.mas_equalTo(100);
        }];
    }

    [self.contentScrollview addSubview:actionContentView];
    self.actionContentView = actionContentView;
}

- (void)initConstraint {
    [self.descriptionView mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.top.mas_equalTo(self.descriptionView.superview.mas_top).offset(5);
        maker.left.mas_equalTo(self.descriptionView.superview.mas_left).offset(10);
        maker.right.mas_equalTo(self.view.mas_right).offset(-10);
        maker.height.mas_equalTo(80);
    }];

    [self.typeContentView mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.top.mas_equalTo(self.descriptionView.mas_bottom).offset(5);
        maker.left.mas_equalTo(self.typeContentView.superview.mas_left).offset(10);
        maker.right.mas_equalTo(self.view.mas_right).offset(-10);
        maker.height.mas_equalTo(150);
    }];

    [self.triggerContentView mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.top.mas_equalTo(self.typeContentView.mas_bottom).offset(10);
        maker.left.mas_equalTo(self.triggerContentView.superview.mas_left).offset(10);
        maker.right.mas_equalTo(self.view.mas_right).offset(-10);
        maker.height.mas_equalTo(100);
    }];

    [self.actionContentView mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.top.mas_equalTo(self.triggerContentView.mas_bottom).offset(10);
        maker.left.mas_equalTo(self.actionContentView.superview.mas_left).offset(10);
        maker.right.mas_equalTo(self.view.mas_right).offset(-10);
        maker.height.mas_equalTo(100);
    }];

    [self.contentScrollview mas_makeConstraints:^(MASConstraintMaker *maker) {
        maker.top.mas_equalTo(self.contentScrollview.superview.mas_top).offset(0);
        maker.left.mas_equalTo(self.contentScrollview.superview.mas_left).offset(0);
        maker.right.mas_equalTo(self.contentScrollview.superview.mas_right).offset(0);
        maker.bottom.mas_equalTo(self.contentScrollview.superview.mas_bottom).offset(0);
    }];
}


- (void)getRecipeDescription {
    NSString *descriptionTriggerStr;
    if ([self.createRecipe.type isEqualToString:RECIPE_TYPE_SCHEDULE]) {
        NSString *weekStr = ![self.createRecipe.crontab.day_of_week isEqualToString:@"7"] ? @"每周" : @"";
        NSString *repeatStr = [NSString stringWithFormat:@"%@%@", weekStr, self.weekArray[[self.createRecipe.crontab.day_of_week intValue]]];

        NSString *timeStr = [NSString stringWithFormat:@"%@:%@", [IntoYunUtils getTheCorrectNum:self.createRecipe.crontab.hour], [IntoYunUtils getTheCorrectNum:self.createRecipe.crontab.minute]];
        descriptionTriggerStr = [NSString stringWithFormat:@"当%@%@%@,",
                                                           [IntoYunUtils getDatapointName:self.triggerDatapoint],
                                                           repeatStr,
                                                           timeStr];
    } else {
        if ([self.triggerDatapoint.type isEqualToString:NUMBER_DT]) {
            float resultValue = [IntoYunUtils parseData2Float:[self.createRecipe.triggerVal.value intValue] Datapoint:self.triggerDatapoint];
            NSString *parseValue = [IntoYunUtils toDecimal:resultValue DataPoint:self.triggerDatapoint];
            descriptionTriggerStr = [NSString stringWithFormat:@"当%@%@%@,",
                                     [IntoYunUtils getDatapointName:self.triggerDatapoint],
                                     [self.logicDic valueForKey:self.createRecipe.triggerVal.op],
                                     parseValue];
        } else if ([self.triggerDatapoint.type isEqualToString:ENUM_DT]) {
            descriptionTriggerStr = [NSString stringWithFormat:@"当%@%@%@,",
                                                               [IntoYunUtils getDatapointName:self.triggerDatapoint],
                                                               [self.logicDic valueForKey:self.createRecipe.triggerVal.op],
                                                               self.triggerDatapoint.datapointEnum[[self.createRecipe.triggerVal.value intValue]]];
        } else if ([self.triggerDatapoint.type isEqualToString:BOOL_DT]) {
            descriptionTriggerStr = [NSString stringWithFormat:@"当%@%@%@,",
                                                               [IntoYunUtils getDatapointName:self.triggerDatapoint],
                                                               @"的状态是",
                                                               [self.createRecipe.triggerVal.value boolValue] ? @"开" : @"关"];
        }
    }

    NSString *descriptionActionStr;
    ActionValModel *actionValModel = self.createRecipe.actionVal.firstObject;

    if ([actionValModel.type isEqualToString:RECIPE_ACTION_EMAIL]) {
        descriptionActionStr = [NSString stringWithFormat:@"则发送邮件%@到%@", actionValModel.value, actionValModel.to];
    } else if ([actionValModel.type isEqualToString:RECIPE_ACTION_MSGBOX]) {
        descriptionActionStr = [NSString stringWithFormat:@"则推送一条系统消息%@", actionValModel.value];
    } else {
        if ([self.actionDatapoint.type isEqualToString:BOOL_DT]) {
            descriptionActionStr = [NSString stringWithFormat:@"则%@的状态设为%i",
                                    [IntoYunUtils getDatapointName:self.actionDatapoint],
                                    [actionValModel.value boolValue]];
        } else if([self.actionDatapoint.type isEqualToString:NUMBER_DT]){
            float resultValue = [IntoYunUtils parseData2Float:[actionValModel.value intValue] Datapoint:self.actionDatapoint];
            NSString *parseValue = [IntoYunUtils toDecimal:resultValue DataPoint:self.actionDatapoint];
            descriptionActionStr = [NSString stringWithFormat:@"则%@的状态设为%@",
                                    [IntoYunUtils getDatapointName:self.actionDatapoint],
                                    parseValue];
            
        } else if ([self.actionDatapoint.type isEqualToString:ENUM_DT]){
            descriptionActionStr = [NSString stringWithFormat:@"则%@的状态设为%@",
                                                              [IntoYunUtils getDatapointName:self.actionDatapoint],
                                                              self.actionDatapoint.datapointEnum[[actionValModel.value intValue]]];
        } else if ([self.actionDatapoint.type isEqualToString:STRING_DT]){
            descriptionActionStr = [NSString stringWithFormat:@"则推送一条消息%@到%@", actionValModel.value, [IntoYunUtils getDatapointName:self.actionDatapoint]];
        }
    }
    NSString *decStr = [NSString stringWithFormat:@"%@%@", descriptionTriggerStr, descriptionActionStr];
    self.createRecipe.recipeDescription = decStr;
    self.descriptionLabel.text = decStr;
}


- (void)transferTimeZone:(BOOL)initial {
    if ([self.createRecipe.type isEqualToString:RECIPE_TYPE_SCHEDULE]) {
        return;
    }

    int zone = [IntoYunUtils getTimeZone];

    CrontabModel *crontabModel = self.createRecipe.crontab;
    int hour = [crontabModel.hour intValue];
    if (initial) {
        hour = hour - zone;
    } else {
        hour = hour + zone;
    }

    if (hour > 23) {
        if (![crontabModel.day_of_week isEqualToString:@"*"]) {
            int week = [crontabModel.day_of_week intValue];
            week = week + 1;
            if (week > 6) {
                week = 0;
            }
            crontabModel.day_of_week = [NSString stringWithFormat:@"%d", week];
        }
        hour = hour - 24;
        crontabModel.hour = [NSString stringWithFormat:@"%d", hour];
    } else if (hour < 0) {
        if (![crontabModel.day_of_week isEqualToString:@"*"]) {
            int week = [crontabModel.day_of_week intValue];
            week = week - 1;
            if (week < 0) {
                week = 6;
            }
            crontabModel.day_of_week = [NSString stringWithFormat:@"%d", week];
        }
        hour = hour + 24;
        crontabModel.hour = [NSString stringWithFormat:@"%d", hour];
    }
    self.createRecipe.crontab = crontabModel;
}

- (void)setEnableVal:(UISwitch *)sender {
    self.createRecipe.enabled = sender.isOn;
}

- (void)setCatagoryVal:(UIButton *)sender {
    if (sender.tag == 1) {
        self.createRecipe.category = RECIPE_TYPE_EDGE;
        [self.edgeButton setImage:[UIImage imageNamed:@"radio_checked"] forState:UIControlStateNormal];
        [self.periodButton setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    } else {
        self.createRecipe.category = RECIPE_TYPE_PERIOD;
        [self.periodButton setImage:[UIImage imageNamed:@"radio_checked"] forState:UIControlStateNormal];
        [self.edgeButton setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
    }
}

- (void)onTriggerChanged:(TriggerValModel *)triggerVal {
    self.createRecipe.triggerVal = triggerVal;
    [self getRecipeDescription];
}

- (void)onActionChanged:(ActionValModel *)actionVal {
    NSMutableArray *actionArray = [[NSMutableArray alloc] initWithCapacity:1];
    [actionArray addObject:actionVal];
    self.createRecipe.actionVal = actionArray;
    [self getRecipeDescription];
}


- (void)onCrontabChanged:(CrontabModel *)crontab {
    self.createRecipe.crontab = crontab;
    [self getRecipeDescription];
}

- (void)onClickSaveButton {
    [self transferTimeZone:NO];
    if ([self.actionDatapoint.type isEqualToString:EMAIL_DT] || [self.actionDatapoint.type isEqualToString:MESSAGE_DT]|| [self.actionDatapoint.type isEqualToString:STRING_DT]){
        ActionValModel *actionValModel = self.createRecipe.actionVal.firstObject;
        if ([self.actionDatapoint.type isEqualToString:EMAIL_DT] && (!actionValModel.to || [actionValModel.to length] <= 0)) {
            [MBProgressHUD showError:NSLocalizedString(@"error_empty_input", nil)];
            return;
        }
        
        if ([self.actionDatapoint.type isEqualToString:EMAIL_DT] && ![actionValModel.to isValidateEmail]){
            [MBProgressHUD showError:NSLocalizedString(@"error_email_format", nil)];
            return;
        }
        
        if (!actionValModel.value || [actionValModel.value length]<=0){
            [MBProgressHUD showError:NSLocalizedString(@"error_empty_input", nil)];
            return;
        }
    }
    if (self.isCreate) {
        [IntoYunSDKManager createRecipe:[self.createRecipe mj_keyValues] successBlock:^(id responseObj) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }                    errorBlock:^(NSInteger code, NSString *msg) {
            [MBProgressHUD showError:msg];
        }];
    } else {
        [IntoYunSDKManager updateRecipe:self.createRecipe.ID type:self.createRecipe.type recipeInfo:[self.createRecipe mj_keyValues] successBlock:^(id responseObj) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }                    errorBlock:^(NSInteger code, NSString *msg) {
            [MBProgressHUD showError:msg];
        }];
    }
}
@end
