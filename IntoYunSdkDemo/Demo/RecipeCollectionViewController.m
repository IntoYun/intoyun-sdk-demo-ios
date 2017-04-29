//
//  RecipeCollectionViewController.m
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/10.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefreshNormalHeader.h>
#import "RecipeCollectionViewController.h"
#import "IntoRecipeCollectionViewCell.h"
#import "IntoYunSDK.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+IntoYun.h"
#import "SelectTriggerViewController.h"
#import "RecipeDetailViewController.h"

@interface RecipeCollectionViewController ()

//消息数组
@property(nonatomic, strong) NSMutableArray *recipeArray;

@end

@implementation RecipeCollectionViewController

static NSString *const reuseIdentifier = @"recipeCell";


- (NSMutableArray *)messageArray {
    if (!_recipeArray) {
        _recipeArray = [NSMutableArray array];
    }
    return _recipeArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];


    //设置navigation bar
    [self setNavigation];

    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.frame = self.view.bounds;

    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([IntoRecipeCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
//    [self.collectionView registerClass:[IntoRecipeCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];


    // Do any additional setup after loading the view.
    [self loadRecipeData];
    
    // Set the callback（Once you enter the refresh status，then call the action of target，that is call [self loadNewData]）
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadRecipeData)];
    
    // Enter the refresh status immediately
    [self.collectionView.mj_header beginRefreshing];

}

- (void)setNavigation {
    self.navigationItem.title = NSLocalizedString(@"recipe_title", nil);
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back", nill) style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

    //添加
    UIBarButtonItem *rightSharBt = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(onClickAddButton)];
    NSArray *buttonItem = @[rightSharBt];
    self.navigationItem.rightBarButtonItems = buttonItem;

}


- (void)loadRecipeData {
    IntoWeakSelf;
    [IntoYunSDKManager getRecipes:^(id responseObject) {
                [weakSelf.collectionView.mj_header endRefreshing];
                weakSelf.recipeArray = [RecipeModel mj_objectArrayWithKeyValuesArray:responseObject];
                [weakSelf.collectionView reloadData];
            }
                       errorBlock:^(NSInteger code, NSString *errorStr) {
                           [weakSelf.collectionView.mj_header endRefreshing];
                           [MBProgressHUD showError:errorStr];
                       }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onClickAddButton {
    SelectTriggerViewController *selectTriggerViewController = [[SelectTriggerViewController alloc] init];
    selectTriggerViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:selectTriggerViewController animated:YES];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.recipeArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    IntoRecipeCollectionViewCell *cell = [IntoRecipeCollectionViewCell cellWithCollection:collectionView reuseIdentifier:reuseIdentifier cellForItemAtIndexPath:indexPath];

    // Configure the cell
    cell.recipeModel = self.recipeArray[indexPath.row];

    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSLog(@"Clicked %ld", (long) indexPath.row);

    RecipeDetailViewController *recipeDetailViewController = [[RecipeDetailViewController alloc] init];
//    recipeDetailViewController.createRecipe = self.recipeArray[indexPath.row];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self.recipeArray[indexPath.row] mj_keyValues] forKey:@"recipe"];
    recipeDetailViewController.isCreate = NO;
    recipeDetailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:recipeDetailViewController animated:YES];
}


//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.collectionView.frame.size.width / 2 - 2, MAX(self.collectionView.frame.size.height / 4, 180));

}

//设置每个item的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 4;
}

@end
