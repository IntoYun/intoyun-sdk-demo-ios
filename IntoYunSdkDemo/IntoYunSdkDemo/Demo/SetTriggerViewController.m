//
//  SetTriggerViewController.m
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/27.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import "SetTriggerViewController.h"
#import "RecipeModel.h"
#import "Macros.h"
#import "IntoYunFMDBTool.h"
#import "IntoSystemDatapoints.h"
#import "TriggerBoolView.h"
#import <Masonry/View+MASAdditions.h>
#import "RecipeSettingDelegate.h"
#import "UIImage+Utils.h"
#import "TriggerNumberView.h"
#import "TriggerEnumView.h"
#import "TriggerTimerView.h"
#import "SelectActionViewController.h"

@interface SetTriggerViewController ()<RecipeSettingDelegate>

@property (nonatomic, strong) DatapointModel *datapointModel;

@property (nonatomic, weak) UIButton *nextButton;

@end

@implementation SetTriggerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigation];
    [self initData];
    [self initView];
}

- (void)setNavigation {
    self.navigationItem.title = NSLocalizedString(@"set_trigger_title", nil);
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back", nill) style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)initData {
    NSNumber *dpIp = self.createRecipe.dpIds[0];
    if ([((NSString *) self.createRecipe.prdIds[0]) isEqualToString:SYSTEM_PRODUCT_ID]){
        self.datapointModel = ((NSArray *)[IntoSystemDatapoints shareAllDatapoints])[0];
    } else {
        self.datapointModel = [IntoYunFMDBTool getDatapointWithDpID:(NSString *)self.createRecipe.prdIds[0] dpID:[dpIp intValue]];
    }
}

- (void)initView {
    self.view.backgroundColor = SetColor(0xf6, 0xf6, 0xf6, 1.0);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    
    
    if ([self.datapointModel.type isEqualToString:TIMER_DT]){
        TriggerTimerView *view = [[TriggerTimerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100) DataPoint:self.datapointModel crontab:self.createRecipe.crontab];
        view.delegete = self;
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *maker){
            maker.top.mas_equalTo(view.superview.mas_top).offset(0);
            maker.left.mas_equalTo(view.superview.mas_left).offset(0);
            maker.right.mas_equalTo(view.superview.mas_right).offset(0);
            maker.height.mas_equalTo(100);
        }];
    } else if ([self.datapointModel.type isEqualToString:BOOL_DT]){
        TriggerBoolView *view = [[TriggerBoolView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100) DataPoint:self.datapointModel triggerVal:self.createRecipe.triggerVal];
        view.delegete = self;
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *maker){
            maker.top.mas_equalTo(view.superview.mas_top).offset(0);
            maker.left.mas_equalTo(view.superview.mas_left).offset(0);
            maker.right.mas_equalTo(view.superview.mas_right).offset(0);
            maker.height.mas_equalTo(100);
        }];
    } else if ([self.datapointModel.type isEqualToString:NUMBER_DT]){
        TriggerNumberView *view = [[TriggerNumberView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100) DataPoint:self.datapointModel triggerVal:self.createRecipe.triggerVal];
        view.delegete = self;
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *maker){
            maker.top.mas_equalTo(view.superview.mas_top).offset(0);
            maker.left.mas_equalTo(view.superview.mas_left).offset(0);
            maker.right.mas_equalTo(view.superview.mas_right).offset(0);
            maker.height.mas_equalTo(100);
        }];
    } else if ([self.datapointModel.type isEqualToString:ENUM_DT]){
        TriggerEnumView *view = [[TriggerEnumView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100) DataPoint:self.datapointModel triggerVal:self.createRecipe.triggerVal];
        view.delegete = self;
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *maker){
            maker.top.mas_equalTo(view.superview.mas_top).offset(0);
            maker.left.mas_equalTo(view.superview.mas_left).offset(0);
            maker.right.mas_equalTo(view.superview.mas_right).offset(0);
            maker.height.mas_equalTo(100);
        }];
    }

    UIButton *next = [[UIButton alloc] init];
    [next setTitle: NSLocalizedString(@"next", nil) forState:UIControlStateNormal];
    next.titleLabel.textColor = [UIColor whiteColor];
    next.titleLabel.font = [UIFont systemFontOfSize:15];
    next.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    next.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    next.backgroundColor = PrimaryColor;
    [next setBackgroundImage:[UIImage imageWithColor:[UIColor lightGrayColor]] forState:UIControlStateHighlighted];
    [self.view addSubview:next];
    self.nextButton = next;
    
    [next mas_makeConstraints:^(MASConstraintMaker *maker){
        maker.left.mas_equalTo(next.superview.mas_left).offset(10);
        maker.right.mas_equalTo(next.superview.mas_right).offset(-10);
        maker.bottom.mas_equalTo(next.superview.mas_bottom).offset(-150);
        maker.height.mas_equalTo(40);
    }];
    
    [self.nextButton addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)next:(id)sender{
    SelectActionViewController *selectActionViewController  = [[SelectActionViewController alloc] init];
    selectActionViewController.createRecipe = self.createRecipe;
    selectActionViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:selectActionViewController animated:YES];
}

-(void)onTriggerChanged:(TriggerValModel *)triggerVal{
    NSLog(@"trigger changed");
    self.createRecipe.triggerVal = triggerVal;
}

-(void)onCrontabChanged:(CrontabModel *)crontab {
    self.createRecipe.crontab = crontab;
}

@end
