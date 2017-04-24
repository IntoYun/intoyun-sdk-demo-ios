//
//  RecipeCollectionViewController.m
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/10.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import "RecipeCollectionViewController.h"
#import "IntoRecipeCollectionViewCell.h"
#import "IntoYunSDK.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+IntoYun.h"
#import "MJExtension.h"

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


    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;

    self.navigationItem.title = NSLocalizedString(@"recipe_title", nil);

    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.frame = self.view.bounds;

    // Register cell classes
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([IntoRecipeCollectionViewCell class]) bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
//    [self.collectionView registerClass:[IntoRecipeCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];


    // Do any additional setup after loading the view.
    [self loadRecipeData];
}


- (void)loadRecipeData {
    IntoWeakSelf;
    [IntoYunSDKManager getRecipes:^(id responseObject) {
                weakSelf.recipeArray = [RecipeModel mj_objectArrayWithKeyValuesArray:responseObject];
                [weakSelf.collectionView reloadData];
            }
                       errorBlock:^(NSInteger code, NSString *errorStr) {
                           [MBProgressHUD showError:errorStr];
                       }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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
}


//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((collectionView.frame.size.width / 2.0) - 3, 200);
}

//定义每个UICollectionView 的 margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 6, 0);
}


/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
