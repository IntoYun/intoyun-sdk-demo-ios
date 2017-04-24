//
//  IntoImlinkGuideViewController.m
//  IntoYunSdkDemo
//
//  Created by hui he on 17/4/13.
//  Copyright © 2017年 hui he. All rights reserved.
//

#import "IntoImlinkGuideViewController.h"

@interface IntoImlinkGuideViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;

@end

@implementation IntoImlinkGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = NSLocalizedString(@"add_device", nil);
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"back", nill) style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self initGifImageView];
}

- (NSArray *)animationImages {
    NSMutableArray *imagesArr = [NSMutableArray array];
    for (int i = 1; i < 4; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"config_direct0%d", i]];
        if (image) {
            [imagesArr addObject:image];
        }
    }
    return imagesArr;
}

-(void)initGifImageView{
    self.gifImageView.animationImages = [self animationImages]; //获取Gif图片列表
    self.gifImageView.animationDuration = 0.6;     //执行一次完整动画所需的时长
    self.gifImageView.animationRepeatCount = 0;  //动画重复次数
    [self.gifImageView startAnimating];
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

@end
