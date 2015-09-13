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

@import TMCache;

@interface ComicDetailVC () <UICollectionViewDelegateFlowLayout>
{
    __strong NSString * _cacheKey;
}

@property (nonatomic, weak) IBOutlet UICollectionView * collectionView;

@property (nonatomic, strong) NSIndexPath * lastReadIndexPath; ///< 最后阅读的IndexPath

@end

@implementation ComicDetailVC

- (NSString *)cacheKey
{
    // 缓存上次观看的集数IndexPath的key
    if (_cacheKey == nil)
    {
        _cacheKey = [NSString stringWithFormat:@"ComicDetailVC.workid.%@", self.detail.workid];
    }
    return _cacheKey;
}
- (void)setLastReadIndexPath:(NSIndexPath *)lastReadIndexPath
{
    [[TMCache sharedCache] setObject:lastReadIndexPath forKey:self.cacheKey block:nil];
}
- (NSIndexPath *)lastReadIndexPath
{
    return [[TMCache sharedCache] objectForKey:self.cacheKey];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.collectionView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.detail.title;
    
    /// 获取详情
    @weakify(self);
    [ICNetworkDataCenter GET:ICAPIComicDetail params:@{@"workid": SAVE_STRING(self.detail.workid)} block:^(id object, BOOL isCache) {
        @strongify(self);
        if (object)
        {
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
    switch (indexPath.section)
    {
        case 0:
        {
            DetailIntroductionCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IntroductionCell" forIndexPath:indexPath];
            cell.contentView.backgroundColor = [UIColor whiteColor];
            [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.detail.image.url]];
            cell.nameLabel.text = self.detail.title;
            cell.updateNumLabel.text = [NSString stringWithFormat:@"共%d集", (int)self.detail.volumecount];
            cell.introductionLabel.text = self.detail.summary;
            
            @weakify(self);
            NSIndexPath * lastReadIndexPath = self.lastReadIndexPath;
            ICComicEpisode * episode = nil;
            NSString * text = nil;
            if (self.detail.volume.count)
            {
                if (lastReadIndexPath && lastReadIndexPath.row < self.detail.volume.count)
                {
                    episode = self.detail.volume[lastReadIndexPath.row];
                    text = [NSString stringWithFormat:@"继续%@", episode.title];
                }
                else
                {
                    episode = self.detail.volume[0];
                    text = [NSString stringWithFormat:@"开始%@", episode.title];
                }
            }
            episode = nil;
            cell.watchButton.title = text;
            
            [[[cell.watchButton rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
                @strongify(self);
                [self goReaderWithRow:lastReadIndexPath.row];
            }];
            
            // 处理收藏按钮
            BOOL hasStar = [ICComicListItem hasFavorite:self.listItem];
            cell.starView.progress = hasStar ? 1.f : 0.f;
            [[[cell.starView rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:cell.rac_prepareForReuseSignal] subscribeNext:^(id x) {
                @strongify(self);
                if (hasStar)
                {
                    [ICComicListItem removeFavorite:self.listItem];
                }
                else
                {
                    [ICComicListItem addFavorite:self.listItem];
                }
                [self.collectionView reloadData];
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
    switch (indexPath.section)
    {
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
- (void)goReaderWithRow:(NSInteger)row
{
    if (row >= self.detail.volume.count)
    {
        return;
    }
    ComicReaderVC * vc = [[ComicReaderVC alloc] init];
    vc.episode = self.detail.volume[row];
    [self.navigationController push:vc animated:UINavigationControllerAnimatedPush];
    
    // 保存最后一次阅读到剧集
    self.lastReadIndexPath = [NSIndexPath indexPathForRow:row inSection:1];
    
    // 纪录历史
    [ICComicListItem addHistory:self.listItem];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0: break;
        case 1:
        {
            [self goReaderWithRow:indexPath.row];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.collectionView reloadData];
            });
            break;
        }
        default: break;
    }
}

@end
