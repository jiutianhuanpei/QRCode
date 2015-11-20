//
//  MenuViewController.m
//  QRCode_Demo
//
//  Created by 沈红榜 on 15/11/18.
//  Copyright © 2015年 沈红榜. All rights reserved.
//

#import "MenuViewController.h"
@class SHBCell;

@protocol SHBCellDelegate <NSObject>

- (void)longPressWithCell:(SHBCell *)cell;

@end

@interface SHBCell : UITableViewCell

@property (nonatomic, assign) id<SHBCellDelegate> delegate;

@end

@implementation SHBCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:@"btn" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickedBtn) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(60, 0, 50, 40);
        [self addSubview:btn];
        
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [self addGestureRecognizer:longPress];
    }
    return self;
}

- (void)clickedBtn {
    NSLog(@"clickedBtn: %@", self.textLabel.text);
}

- (BOOL)becomeFirstResponder {
    return true;
}

- (void)longPress:(UILongPressGestureRecognizer *)lo {
    if (lo.state == UIGestureRecognizerStateBegan) {
        if ([_delegate respondsToSelector:@selector(longPressWithCell:)]) {
            [_delegate longPressWithCell:self];
        }
    }
}

@end

@interface MenuViewController ()<UITableViewDelegate, UITableViewDataSource, SHBCellDelegate>

@property (nonatomic, strong) UIMenuItem            *deleteItem;
@property (nonatomic, strong) UIMenuItem            *copyitem;
@property (nonatomic, strong) UIMenuItem            *pasteItem;
@property (nonatomic, strong) UIMenuController      *menuController;

@end

@implementation MenuViewController {
    UITableView         *_tableView;
    NSIndexPath         *_indexPath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UISearchBar *search  = [[UISearchBar alloc] initWithFrame:CGRectZero];
    [search sizeToFit];
    self.navigationItem.titleView = search;
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    [_tableView registerClass:[SHBCell class] forCellReuseIdentifier:NSStringFromClass([SHBCell class])];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SHBCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SHBCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)deleteItem:(UIMenuController *)item {
    NSLog(@"%@", NSStringFromCGRect(item.menuFrame));
    SHBCell *cell = [_tableView cellForRowAtIndexPath:_indexPath];
    NSLog(@"detail: %@", cell.textLabel.text);
}

- (void)addItem:(UIMenuController *)item {
    SHBCell *cell = [_tableView cellForRowAtIndexPath:_indexPath];
    
    UIPasteboard *paste = [UIPasteboard generalPasteboard];
    paste.string = cell.textLabel.text;
    
}

- (void)pasteItem:(UIMenuController *)item {
    UIPasteboard *paste = [UIPasteboard generalPasteboard];
    ((UISearchBar *)self.navigationItem.titleView).text = paste.string;
}

- (void)longPressWithCell:(SHBCell *)cell {
   [((UISearchBar *)self.navigationItem.titleView) resignFirstResponder];
    [self becomeFirstResponder];
    _indexPath = [_tableView indexPathForCell:cell];
    CGRect rect = [_tableView rectForRowAtIndexPath:_indexPath];
    if (!_deleteItem) {
        _deleteItem = [[UIMenuItem alloc] initWithTitle:@"Delete" action:@selector(deleteItem:)];
    }
    if (!_copyitem) {
        _copyitem = [[UIMenuItem alloc] initWithTitle:@"Copy" action:@selector(addItem:)];
    }
    if (!_menuController) {
        _menuController = [UIMenuController sharedMenuController];
    }
    
    if (!_pasteItem) {
        _pasteItem = [[UIMenuItem alloc] initWithTitle:@"Paste" action:@selector(pasteItem:)];
    }
    
    [_menuController setMenuItems:@[_deleteItem, _copyitem, _pasteItem]];
    [_menuController setTargetRect:rect inView:cell.superview];
    [_menuController setMenuVisible:true animated:true];
    
}



- (BOOL)canBecomeFirstResponder {
    return true;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [((UISearchBar *)self.navigationItem.titleView) resignFirstResponder];
}

@end
