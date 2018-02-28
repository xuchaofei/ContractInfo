//
//  ContractViewController.m
//  ContractInfo
//
//  Created by csm on 2017/12/7.
//  Copyright © 2017年 YiJu. All rights reserved.
//

#import "ContractViewController.h"
#import <ContactsUI/ContactsUI.h>
#import <Contacts/Contacts.h>
#import "ContactInfoCell.h"
#import "PersonModel.h"
#import <MJExtension/MJExtension.h>

#define screenwidth [UIScreen mainScreen].bounds.size.width
#define screenheight [UIScreen mainScreen].bounds.size.height

@interface ContractViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>{
    
    NSMutableDictionary *_dict;
    
    UISearchBar * _searchBar;
    
    NSMutableArray * _resultArray;
    
    NSArray *_keysArray;

}
@property (nonatomic, weak) UITableView * contactTableView;

@property (nonatomic, strong) UISearchController * searchController;

@end


@implementation ContractViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (!_dict) {
        _dict = [[NSMutableDictionary alloc] init];
    }
    
    NSArray * contract = [_contractInfoArray copy];
    _resultArray = [PersonModel mj_objectArrayWithKeyValuesArray:contract];
    
    [self sortOfModelWith:_resultArray];
    
    [self createTableView];
}

-(void)createTableView{
    
    UITableView * contactTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenwidth, screenheight)];
    contactTableView.delegate = self;
    contactTableView.dataSource = self;
    [self.view addSubview:contactTableView];
    _contactTableView = contactTableView;
    
    if ([self.contactTableView respondsToSelector:@selector(setSeparatorStyle:)]) {
        [self.contactTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    contactTableView.tableHeaderView = [self tableHeaderView];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _keysArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSString * key = [_keysArray objectAtIndex:section];
    NSArray * array = [_dict objectForKey:key];
    
    return array.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_keysArray objectAtIndex:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    
    return _keysArray;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * key = [_keysArray objectAtIndex:indexPath.section];
    NSArray * array = [_dict objectForKey:key];
    
    ContactInfoCell * cell = [ContactInfoCell cellWithTableView:tableView];
    cell.model = array[indexPath.row];
    return cell;
}



- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    
    [_resultArray removeAllObjects];
    
    for (PersonModel * model in _resultArray) {
        
        NSMutableString * mutableString = [[NSMutableString alloc] initWithString:model.contactName];
        CFMutableStringRef mutableStr = (__bridge CFMutableStringRef)mutableString;
        CFStringTransform(mutableStr, NULL, kCFStringTransformMandarinLatin, NO);
        CFStringTransform(mutableStr, NULL, kCFStringTransformStripDiacritics, NO);
        mutableString = (__bridge NSMutableString *)mutableStr;
        
        //转换成小写
        NSString * string = [mutableString lowercaseString];
        
        //再把搜索框中输入的字符串转化成小写
        NSString * searchStr = [_searchBar.text lowercaseString];
        
        NSRange range = [string rangeOfString:searchStr];
        if (range.length > 0) {
            
            [_resultArray addObject:model.contactName];
        }
    }
    
    [self.contactTableView reloadData];
}

-(void)sortOfModelWith:(NSArray *)array{
    
    for (PersonModel * model in array) {
        //1.取出name, 进行汉字转拼音的操作
        NSMutableString * mutableString = [[NSMutableString alloc] initWithString:model.contactName];
        //2. 转化为C中的可变字符串
        CFMutableStringRef  mutableStr = (__bridge CFMutableStringRef)mutableString;
        //3. 对可变字符串进行转拼音的操作
        CFStringTransform(mutableStr, NULL, kCFStringTransformMandarinLatin, NO);
        
        //去音符
        CFStringTransform(mutableStr, NULL, kCFStringTransformStripDiacritics, NO);
        
        //4.把这个C的可变字符串, 重新转化为OC的可变字符串
        mutableString = (__bridge NSMutableString *)mutableStr;
        
        NSLog(@"mutableString---%@",mutableString);
        
        //5. 获取每个name的首字母, 用于设置区头
        NSString * firstChar = [mutableString substringToIndex:1];
        
        //大写转小写
        firstChar = [firstChar lowercaseString];
        
        //6. 根据获取的首字符, 对model对象进行分类
        BOOL isHaveKey = NO;
        for (NSString * key in _dict.allKeys) {
            
            if ([firstChar isEqualToString:key]) {
                
                NSMutableArray * array = [_dict objectForKey:firstChar];
                
                [array addObject:model];
                
                isHaveKey = YES;
            }
        }
    
        if (isHaveKey == NO) {
            
            NSMutableArray * array = [NSMutableArray array];
            
            [array addObject:model];
            
            [_dict setValue:array forKey:firstChar];
        }
    }
    
    _keysArray = [_dict.allKeys sortedArrayUsingSelector:@selector(compare:)];
    
}

-(UIView *)tableHeaderView{
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenwidth, 60)];
    headerView.backgroundColor = [UIColor cyanColor];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 10, screenwidth - 20, 40)];
    _searchBar.delegate = self;
    _searchBar.barTintColor = [UIColor cyanColor];
    
    [headerView addSubview:_searchBar];
  
    return headerView;
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
