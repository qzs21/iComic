//
//  DetailViewController.m
//  iComic
//
//  Created by 韦烽传 on 15/9/11.
//  Copyright (c) 2015年 Neva. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailIntroductionCollectionViewCell.h"
#import "DetailAnthologyCollectionViewCell.h"

@interface DetailViewController () <UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet UICollectionView * collectionView;
@property (nonatomic, strong) NSDictionary * dataDictionary;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
            
        default:
            return 10;
            break;
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
            DetailIntroductionCollectionViewCell * introductionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IntroductionCell" forIndexPath:indexPath];
            introductionCell.iconImageView.image = [UIImage imageNamed:@"introduction.jpg"];
//            introductionCell.nameLabel.text = @"";
//            introductionCell.updateNumLabel.text = @"";
//            introductionCell.introductionLabel.text = @"";
            
            return introductionCell;
        }
            
        default:
        {
            DetailAnthologyCollectionViewCell * anthologyCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AnthologyCell" forIndexPath:indexPath];
            anthologyCell.iconImageView.image = [UIImage imageNamed:@"anthology.jpg"];
            anthologyCell.nameLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
            anthologyCell.updateLabel.text = @"2015-09-11";
            return anthologyCell;
        }
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return CGSizeMake(self.view.frame.size.width, 200);
            break;
            
        default:
            return CGSizeMake(100, 100);
            break;
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
