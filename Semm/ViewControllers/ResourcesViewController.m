//
//  ResourcesViewController.m
//  Semm
//
//  Created by 郭洪军 on 11/2/15.
//  Copyright © 2015 Adwan. All rights reserved.
//

#import "ResourcesViewController.h"
#import "ResCollectionCell.h"
#import "CommonDefine.h"
#import "PayView.h"
#import "CommonMethods.h"
#import "DataManager.h"
#import "ResReuseCell.h"

#import "MJRefresh.h"

/**
 * 随机色
 */
#define MJRandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]

@interface ResourcesViewController ()
/** 存放假数据 */
@property (strong, nonatomic) NSMutableArray *colors;
@end

@implementation ResourcesViewController

static NSString * const reuseIdentifier = @"respic";

- (void)viewDidLoad {
    [super viewDidLoad];
    
//     self.clearsSelectionOnViewWillAppear = NO;
    // Register cell classes
    [self.collectionView registerClass:[ResCollectionCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerClass:[ResReuseCell class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headCell"];
    // Do any additional setup after loading the view.
    
    [self setupRefresh];
}

- (void)setupRefresh
{
    __weak __typeof(self) weakSelf = self;
    
    // 下拉刷新
    self.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 增加5条假数据
        for (int i = 0; i<10; i++) {
            [weakSelf.colors insertObject:MJRandomColor atIndex:0];
        }
        
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.collectionView reloadData];
            
            // 结束刷新
            [weakSelf.collectionView.header endRefreshing];
            
            NSURL* oUrl = [NSURL URLWithString:URL_STRING_O];
            if (![[UIApplication sharedApplication] canOpenURL:oUrl]) {
                NSURL * myURL_APP_A = [NSURL URLWithString:URL_STRING_ONE];
                
                if ([[UIApplication sharedApplication] canOpenURL:myURL_APP_A]) {
                    [[UIApplication sharedApplication] openURL:myURL_APP_A];
                }
            }
            
        });
    }];
    
    [self.collectionView.header beginRefreshing];
    
    /*
    // 上拉刷新
    self.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 增加5条假数据
        for (int i = 0; i<5; i++) {
            [weakSelf.colors addObject:MJRandomColor];
        }
        
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.collectionView reloadData];
            
            // 结束刷新
            [weakSelf.collectionView.footer endRefreshing];
        });
    }];
    // 默认先隐藏footer
    self.collectionView.footer.hidden = YES;
     */
}

#pragma mark - 数据相关
- (NSMutableArray *)colors
{
    if (!_colors) {
        self.colors = [NSMutableArray array];
    }
    return _colors;
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (0==section) {
        return 1;
    }else if(1==section)
    {
        return 6;
    }else if (2==section)
    {
        return 4;
    }else
    {
        return 4;
    }
}

 
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ResCollectionCell* cell = (ResCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    NSString* imageToLoad = [NSString stringWithFormat:@"j_%ld_%ld.png",(long)indexPath.section,(long)indexPath.row];
    cell.imgView.image = [UIImage imageNamed:imageToLoad];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (0 == section) {
        return CGSizeMake(0, 0);
    }else
    {
        return CGSizeMake(320, 24);
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSString* title = @"";
    if (indexPath.section == 1) {
        title = @"今日推荐";
    }else if (indexPath.section == 2)
    {
        title = @"日本影院";
    }else
    {
        title = @"国产自拍";
    }
    
    if (kind == UICollectionElementKindSectionHeader) {
        ResReuseCell *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headCell" forIndexPath:indexPath];

        headerView.titleLabel.text = title;
        
        return headerView;
    }else
    {
        UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"" forIndexPath:indexPath];
       
        return headerView;
    }
}

#pragma mark --UICollectionViewDelegateFlowLayout
 - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
 {
     if (indexPath.section == 0) {
         return CGSizeMake(300*SCREEN_WIDTH/320.0f, 176*SCREEN_WIDTH/320.0f);
     }else
     {
         return CGSizeMake(154*SCREEN_WIDTH/320.0f, 104*SCREEN_WIDTH/320.0f);
     }
 }

 - (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
 {
     return UIEdgeInsetsMake(4*SCREEN_WIDTH/320.0f, 4*SCREEN_WIDTH/320.0f, 4*SCREEN_WIDTH/320.0f, 4*SCREEN_WIDTH/320.0f);
 }


#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/


// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //弹出支付页面
    
//    [[DataManager sharedManager] setFirstIdx:0];
//    [[DataManager sharedManager] setSecondIdx:(int)indexPath.row];
    
//    NSString* key = [NSString stringWithFormat:@"a%dandb%d",0,(int)indexPath.row];
    
    NSString* key = @"isBought";
    
    int success = [[[NSUserDefaults standardUserDefaults]valueForKey:key] intValue];
    
    if (1 == success) {
        NSURL * myURL_APP_A = [NSURL URLWithString:@"http://115.231.181.68/D197985770E67405D6F5B3B66AA2D6DCAEFAB8E7.mp4"];
        if ([[UIApplication sharedApplication] canOpenURL:myURL_APP_A]) {
            [[UIApplication sharedApplication] openURL:myURL_APP_A];
        }
    }else
    {
        PayView* view = [[PayView alloc]initWithFrame:CGRectMake(100, 100, 100, 200)];
        [view setFrame:CGRectMake(0, 0, 300*SCREEN_WIDTH/320.0f, 420*SCREEN_WIDTH/320.0f)];
        [view setCenter:CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height/2) ];
        
        [CommonMethods transitionWithType:kCATransitionFade WithSubtype:kCATransitionFromTop ForView:self.view];
        
        [self.view addSubview:view];
    }
    
}

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
