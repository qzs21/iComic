//
//  ComicDetailVC.
//  iComic
//
//  Created by 韦烽传 on 15/9/11.
//  Copyright (c) 2015年 Neva. All rights reserved.
//

#import "ComicDetailVC.h"
#import "DetailIntroductionCollectionViewCell.h"
#import "DetailAnthologyCollectionViewCell.h"
#import "ComicReaderVC.h"

@interface ComicDetailVC () <UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet UICollectionView * collectionView;

@end

@implementation ComicDetailVC

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.collectionView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.detail.title;
    
    /// 获取详情
    @weakify(self);
    [ICNetworkDataCenter GET:ICAPIComicDetail params:@{@"workid": SAVE_STRING(self.detail.workid)} block:^(id object, BOOL isCache) {
        @strongify(self);
        if (object) {
            self.detail = [[ICComicDetail alloc] initWithDictionary:object error:nil];
            [self.collectionView reloadData];
        }
    }];
    
    // 捕获屏幕旋转
    [[NSNotificationCenter defaultCenter] addObserver:self.collectionView
                                             selector:@selector(reloadData)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0: return 1; break;
        default: return self.detail.volume.count; break;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            DetailIntroductionCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IntroductionCell" forIndexPath:indexPath];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.detail.image.url]];
            cell.nameLabel.text = self.detail.title;
            cell.updateNumLabel.text = [NSString stringWithFormat:@"共%d集", (int)self.detail.volumecount];
            cell.introductionLabel.text = self.detail.summary;
            [[[cell.watchButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
                [SVProgressHUD showErrorWithStatus:@"前方正在施工🚧"];
            }];
            return cell;
            break;
        }
        case 1:
        {
            ICComicEpisode * episode = self.detail.volume[indexPath.row];
            DetailAnthologyCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AnthologyCell" forIndexPath:indexPath];
            [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:episode.image]];
            cell.nameLabel.text = episode.title;
            cell.updateLabel.text = [episode.date toAboutTimeString];
            return cell;
            break;
        }
        default: return nil; break;
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = collectionView.width;
    switch (indexPath.section) {
        case 0:
        {
            return CGSizeMake(width, 200);
            break;
        }
        default:
        {
            CGFloat w = (width - 10 * 4) / 3;
            return CGSizeMake(w, w);
            break;
        }
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0: break;
        case 1:
        {
            ComicReaderVC * vc = [[ComicReaderVC alloc] init];
            vc.episode = self.detail.volume[indexPath.row];
            [self.navigationController push:vc animated:UINavigationControllerAnimatedPush];
            break;
        }
        default: break;
    }
}

@end
