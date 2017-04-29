//
//  SetActionViewController.m
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/28.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import <Masonry/View+MASAdditions.h>
#import "SetActionViewController.h"
#import "Macros.h"
#import "IntoSystemDatapoints.h"
#import "IntoYunFMDBTool.h"
#import "TriggerTimerView.h"
#import "TriggerBoolView.h"
#import "TriggerNumberView.h"
#import "TriggerEnumView.h"
#import "UIImage+Utils.h"
#import "RecipeDetailViewController.h"
#import "RecipeSettingDelegate.h"
#import "ActionBoolView.h"
#import "ActionNumberView.h"
#import "ActionEnumView.h"
#import "ActionStringView.h"
#import "ActionEmailView.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+IntoYun.h"

@interface SetActionViewController ()<RecipeSettingDelegate>

@property (nonatomic, strong) DatapointModel *datapointModel;

@property (nonatomic, weak) UIButton *nextButton;

@end

@implementation SetActionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigation];
    [self initData];
    [self initView];
}

- (void)setNavigation {
    self.navigationItem.title = NSLocalizedString(@"set_action_title", nil);
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back", nill) style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)initData {
    NSNumber *dpIp = self.createRecipe.dpIds[1];
    if ([((NSString *) self.createRecipe.prdIds[1]) isEqualToString:SYSTEM_PRODUCT_ID]){
        self.datapointModel = ((NSArray *)[IntoSystemDatapoints shareAllDatapoints])[[dpIp intValue]-1];
    } else {
        self.datapointModel = [IntoYunFMDBTool getDatapointWithDpID:(NSString *)self.createRecipe.prdIds[1] dpID:[dpIp intValue]];
    }
}

- (void)initView {
    self.view.backgroundColor = SetColor(0xf6, 0xf6, 0xf6, 1.0);
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;

    if ([self.datapointModel.type isEqualToString:EMAIL_DT]){
        ActionEmailView *view = [[ActionEmailView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100) DataPoint:self.datapointModel actionVal:[self.createRecipe.actionVal firstObject]];
        view.delegete = self;
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *maker){
            maker.top.mas_equalTo(view.superview.mas_top).offset(0);
            maker.left.mas_equalTo(view.superview.mas_left).offset(0);
            maker.right.mas_equalTo(view.superview.mas_right).offset(0);
            maker.height.mas_equalTo(250);
        }];
    } else if ([self.datapointModel.type isEqualToString:MESSAGE_DT] || [self.datapointModel.type isEqualToString:STRING_DT]){
        ActionStringView *view = [[ActionStringView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100) DataPoint:self.datapointModel actionVal:[self.createRecipe.actionVal firstObject]];
        view.delegete = self;
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *maker){
            maker.top.mas_equalTo(view.superview.mas_top).offset(0);
            maker.left.mas_equalTo(view.superview.mas_left).offset(0);
            maker.right.mas_equalTo(view.superview.mas_right).offset(0);
            maker.height.mas_equalTo(200);
        }];
    } else if ([self.datapointModel.type isEqualToString:BOOL_DT]){
        ActionBoolView *view = [[ActionBoolView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100) DataPoint:self.datapointModel actionVal:[self.createRecipe.actionVal firstObject]];
        view.delegete = self;
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *maker){
            maker.top.mas_equalTo(view.superview.mas_top).offset(0);
            maker.left.mas_equalTo(view.superview.mas_left).offset(0);
            maker.right.mas_equalTo(view.superview.mas_right).offset(0);
            maker.height.mas_equalTo(100);
        }];
    } else if ([self.datapointModel.type isEqualToString:NUMBER_DT]){
        ActionNumberView *view = [[ActionNumberView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100) DataPoint:self.datapointModel actionVal:[self.createRecipe.actionVal firstObject]];
        view.delegete = self;
        [self.view addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *maker){
            maker.top.mas_equalTo(view.superview.mas_top).offset(0);
            maker.left.mas_equalTo(view.superview.mas_left).offset(0);
            maker.right.mas_equalTo(view.superview.mas_right).offset(0);
            maker.height.mas_equalTo(100);
        }];
    } else if ([self.datapointModel.type isEqualToString:ENUM_DT]){
        ActionEnumView *view = [[ActionEnumView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100) DataPoint:self.datapointModel actionVal:[self.createRecipe.actionVal firstObject]];
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
    if ([self.datapointModel.type isEqualToString:EMAIL_DT] || [self.datapointModel.type isEqualToString:MESSAGE_DT]|| [self.datapointModel.type isEqualToString:STRING_DT]){
        ActionValModel *actionValModel = self.createRecipe.actionVal.firstObject;
        if (!actionValModel.value || [actionValModel.value length]<=0){
            [MBProgressHUD showError:NSLocalizedString(@"error_empty_input", nil)];
            return;
        }
    }
    RecipeDetailViewController *recipeDetailViewController  = [[RecipeDetailViewController alloc] init];
    recipeDetailViewController.createRecipe = self.createRecipe;
    recipeDetailViewController.isCreate = YES;
    recipeDetailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:recipeDetailViewController animated:YES];
}

-(void)onActionChanged:(ActionValModel *)actionVal{
    NSLog(@"action changed");
    NSMutableArray *actionArray = [[NSMutableArray alloc] initWithCapacity:1];
    [actionArray addObject:actionVal];
    self.createRecipe.actionVal = actionArray ;
}


@end
