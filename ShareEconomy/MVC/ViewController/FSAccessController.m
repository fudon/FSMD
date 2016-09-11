//
//  FSAccessController.m
//  ShareEconomy
//
//  Created by FudonFuchina on 16/9/11.
//  Copyright © 2016年 FudonFuchina. All rights reserved.
//

#import "FSAccessController.h"
#import "FSSameKindController.h"

@interface FSAccessController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) NSInteger      selectedIndex;
@property (nonatomic,assign) NSInteger      selectedSection;
@property (nonatomic,strong) UITableView    *tableView;

@end

@implementation FSAccessController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_selectedIndex > -1) {
        [_tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:_selectedSection] animated:NO];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectedIndex = -1;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, WIDTHFC, HEIGHTFC - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"sameKindCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    NSDictionary *dic = self.datas[indexPath.row];
    cell.imageView.image = IMAGENAMED([dic objectForKey:Picture_Name]);
    cell.textLabel.text = [dic objectForKey:Text_Name];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndex = indexPath.row;
    _selectedSection = indexPath.section;
    
    if (_selectBlock) {
        _selectBlock(self,indexPath);
    }    
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
