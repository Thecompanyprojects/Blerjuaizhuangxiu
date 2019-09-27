//
//  AddressBookSearchView.m
//  iDecoration
//
//  Created by 张毅成 on 2018/5/14.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "AddressBookSearchView.h"

@implementation AddressBookSearchView

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:(CGRect){0, 10, screenW, 30}];
        _searchBar.barTintColor = [UIColor whiteColor];
        _searchBar.searchBarStyle = UISearchBarStyleMinimal;
        _searchBar.placeholder = @"搜索";
        UITextField *searchField = [_searchBar valueForKey:@"searchField"];
        if (searchField) {
            searchField.layer.cornerRadius = 14.0f;
            searchField.layer.masksToBounds = YES;
        }
    }
    return _searchBar;
}

- (void)drawRect:(CGRect)rect {
    [self addSubview:self.searchBar];
}


@end
