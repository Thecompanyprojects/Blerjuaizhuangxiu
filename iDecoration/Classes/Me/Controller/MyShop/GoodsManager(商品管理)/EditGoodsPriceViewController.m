//
//  EditGoodsPriceViewController.m
//  iDecoration
//
//  Created by zuxi li on 2018/1/24.
//  Copyright © 2018年 RealSeven. All rights reserved.
//

#import "EditGoodsPriceViewController.h"
#import "CustomParameterItemView.h"
#import "GoodsPriceModel.h"
#import "EditGoodsPriceCell.h"
#import "HKImageClipperViewController.h"

@interface EditGoodsPriceViewController ()<UITableViewDelegate, UITableViewDataSource, CustomParameterItemViewDelegate,UITextFieldDelegate, EditGoodsPriceCellDelegate ,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong)  CustomParameterItemView *customerItemView;

@property (nonatomic, strong) EditGoodsPriceCell *editingCell;
@end

@implementation EditGoodsPriceViewController

#pragma mark - lifeMethod
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (self.priceArray.count == 0) {
        GoodsPriceModel *model = [GoodsPriceModel newModel];
        model.name = @"";
        [self.priceArray addObject:model];
    }
    
    [self createUI];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - NormalMehtod

-(void)createUI{
    self.title = @"价格设置";
    // 返回按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"back1"] highImage:[UIImage imageNamed:@"back1"]  target:self action:@selector(back)];
    
    // 设置导航栏最右侧的按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem rightItemWithTitle:@"保存" target:self action:@selector(saveGoodsAction)];
    
    [self tableView];
}

- (void)back {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"退出编辑" message:@"是否确定退出编辑？" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"否" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"是" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertC addAction:action1];
    [alertC addAction:action2];
    [self presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - 保存点击事件
- (void)saveGoodsAction {
    __block BOOL iscomplete = YES;
    [self.priceArray enumerateObjectsUsingBlock:^(GoodsPriceModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([model.name isEqualToString:@""]) {
//            [self.view endEditing:YES];
//            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入名称"];
//            iscomplete = NO;
//            *stop = YES;
//            return ;
//        }
        if ([model.price isEqualToString:@""]) {
            [self.view endEditing:YES];
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入价格"];
            iscomplete = NO;
            *stop = YES;
            return ;
        }
        
        if ([model.unit isEqualToString:@""]) {
            [self.view endEditing:YES];
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入单位"];
            iscomplete = NO;
            *stop = YES;
            return ;
        }
        
        if ([model.num isEqualToString:@""]) {
            [self.view endEditing:YES];
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请输入库存"];
            iscomplete = NO;
            *stop = YES;
            return ;
        }
        
        if ([model.imageURL isEqualToString:@""]) {
            [self.view endEditing:YES];
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"请上传图片"];
            iscomplete = NO;
            *stop = YES;
            return ;
        }
    }];
    
    
    if (iscomplete) {
        if (self.completeBlock) {
            [self.view endEditing:YES];
            self.completeBlock([self.priceArray copy]);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
   
}

#pragma mark - 添加更多
- (void)addMoreAction {
    [self.view endEditing:YES];
    self.customerItemView.priceArray = self.priceArray;
    [UIView animateWithDuration:0.25 animations:^{
        self.customerItemView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        self.customerItemView.frame = CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64);
    }];
}


#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string ew_JudgeTheillegalCharacter:string] && ![string isEqualToString:@""]) {
        [textField resignFirstResponder];
        [[UIApplication sharedApplication].keyWindow hudShowWithText:@"不支持特殊字符"];
        return NO;
    }
    if (textField.tag != 9) {
        NSInteger index = textField.tag / 100 - 1;
        NSInteger indexTwo = textField.tag % 100;
        GoodsPriceModel *model = self.priceArray[index];
        if (indexTwo == 1) {
//            model.price = textField.text;
            NSString * str = [NSString stringWithFormat:@"%@%@",textField.text,string];

            //匹配以0开头的数字

            NSPredicate * predicate0 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^[0][0-9]+$"];

            //匹配两位小数、整数

            NSPredicate * predicate1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"^(([1-9]{1}[0-9]*|[0])\.?[0-9]{0,2})$"];
            return ![predicate0 evaluateWithObject:str] && [predicate1 evaluateWithObject:str] ? YES : NO;
        }
    }

    return true;
}

// 限制提示文字长度
-(void)textFieldEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage ; // 键盘输入模式
    
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 8) {
                textField.text = [toBeString substringToIndex:8];
                [textField endEditing:YES];
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"字数长度不要超过8字哦！"];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > 8) {
            textField.text = [toBeString substringToIndex:8];
            [textField endEditing:YES];
            // 超长保存前30个字
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"字数长度不要超过8字哦！"];
        }
    }
}

// 限制提示文字长度
-(void)nameTextFieldEditChanged:(NSNotification *)obj{
    UITextField *textField = (UITextField *)obj.object;
    NSString *toBeString = textField.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage ; // 键盘输入模式
    
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 22) {
                textField.text = [toBeString substringToIndex:22];
                [textField endEditing:YES];
                [[UIApplication sharedApplication].keyWindow hudShowWithText:@"单位长度不要超过22字哦！"];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > 22) {
            textField.text = [toBeString substringToIndex:22];
            [textField endEditing:YES];
            // 超长保存前30个字
            [[UIApplication sharedApplication].keyWindow hudShowWithText:@"单位长度不要超过22字哦！"];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag != 9) {
        NSInteger index = textField.tag / 100 - 1;
        NSInteger indexTwo = textField.tag % 100;
        GoodsPriceModel *model = self.priceArray[index];
        if (indexTwo==0) {
            model.name = textField.text;
        }
        if (indexTwo == 1) {
            model.price = textField.text;
        }
        if (indexTwo == 2) {
            model.unit = textField.text;
        }
        if (indexTwo == 3) {
            model.num = textField.text;
        }
    }
}

#pragma mark - CustomParameterItemViewDelegate
- (void)parameterItemViewAddItemAction:(CustomParameterItemView *)parameterItemView {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"添加自定义项" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入项目名称(不能超过8个字)";
        textField.tag = 9;
        textField.delegate = self;
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)name:@"UITextFieldTextDidChangeNotification"
                                                  object:textField];
    }];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *nameTextField = alertController.textFields.firstObject;
        NSString *nameText = nameTextField.text;
        if (nameText.length <= 0) {
            [[UIApplication sharedApplication].keyWindow showHudFailed:@"请输入新的分组名称"];
            return ;
        }
        
        NSString * str = [nameText ew_removeSpacesAndLineBreaks];
        if ([str isEqualToString:@""]) {
            [[UIApplication sharedApplication].keyWindow showHudFailed:@"新项目的名称不能只是空格"];
            return ;
        }
        
        GoodsPriceModel *model = [GoodsPriceModel newModel];
        model.name = nameText;
        [parameterItemView.priceArray addObject:model];
        [parameterItemView layoutSubviews];
        
        //        [self.priceArray addObject:model];
        [self.tableView reloadData];
        
    }]];
    
    [self presentViewController:alertController animated:true completion:nil];
}

- (void)parameterItemViewDeleteItemAction:(CustomParameterItemView *)parameterItemView atIndex:(NSInteger)index {
    [self.priceArray removeObjectAtIndex:index];
    [parameterItemView layoutSubviews];
    [self.tableView reloadData];
}

#pragma mark - EditGoodsPriceCellDelegate
- (void)editGoodsPriceCellUploadImage:(EditGoodsPriceCell *)cell {
    self.editingCell = cell;
    [self updataimage];
}

- (void)editGoodsPriceCellDeleteAction:(EditGoodsPriceCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    GoodsPriceModel *model = self.priceArray[indexPath.row];
    [self deleteActionWithModel:model atIndexPath:indexPath];
}

#pragma mark - 图片选择上传 ↓
-(void)updataimage{
    [self.view endEditing:YES];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //选择相册
        [self getPhotoFromAlbumOrCamera:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //选择相机
        [self getPhotoFromAlbumOrCamera:UIImagePickerControllerSourceTypeCamera];
    }];
    [alert addAction:action];
    [alert addAction:action1];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}
//#pragma mark  调用相册或相机
-(void)getPhotoFromAlbumOrCamera:(UIImagePickerControllerSourceType)type{
    
    if ([UIImagePickerController isSourceTypeAvailable:type]) {
        UIImagePickerController *imagePick = [[UIImagePickerController alloc]init];
        imagePick.sourceType = type;
        imagePick.delegate = self;
        imagePick.allowsEditing = NO;
        [self presentViewController:imagePick animated:YES completion:nil];
    }
}

- (UIImage *)turnImageWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *image=[info objectForKey:UIImagePickerControllerOriginalImage];
    //类型为 UIImagePickerControllerOriginalImage 时调整图片角度
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        UIImageOrientation imageOrientation=image.imageOrientation;
        if(imageOrientation!=UIImageOrientationUp) {
            // 原始图片可以根据照相时的角度来显示，但 UIImage无法判定，于是出现获取的图片会向左转90度的现象。
            UIGraphicsBeginImageContext(image.size);
            [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
    }
    return image;
    
}

//图片选择完成
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    //自定义裁剪方式
    UIImage*image = [self turnImageWithInfo:info];
    CGSize tempSize = CGSizeMake( kSCREEN_WIDTH - 40, kSCREEN_WIDTH - 40);
    HKImageClipperViewController *clipperVC = [[HKImageClipperViewController alloc]initWithBaseImg:image
                                                                                     resultImgSize:tempSize clipperType:ClipperTypeImgMove];
    
    __weak typeof(self)weakSelf = self;
    clipperVC.cancelClippedHandler = ^(){
        [picker dismissViewControllerAnimated:YES completion:nil];
    };
    clipperVC.successClippedHandler = ^(UIImage *clippedImage){
        __strong typeof(self)strongSelf = weakSelf;
        
        [strongSelf saveImage:clippedImage];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    };
    
    [picker pushViewController:clipperVC animated:YES];
    
}

#pragma mark  上传图片到服务器
-(void)saveImage:(UIImage *)image{
    
    //    NSData *data = UIImageJPEGRepresentation(image, PHOTO_COMPRESS);
    NSData *data = [NSObject imageData:image];
    
    NSString *str = [BASEURL stringByAppendingString:@"file/uploadFiles.do"];
    
    // 可以在上传时使用当前的系统事件作为文件名
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    //获取上传图片的时间
    NSString *str1 = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.png", str1];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager setRequestSerializer:[AFJSONRequestSerializer  serializer]];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain", nil];
    __weak typeof(self)  weakSelf = self;
    [manager POST:str parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/png"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        YSNLog(@"上传成功:%@ %@",str,responseObject);
        if ([responseObject[@"code"] integerValue] == 1000) {
            
            NSDictionary *dic = responseObject[@"imgList"][0];
            NSIndexPath *indexPath = [weakSelf.tableView indexPathForCell:weakSelf.editingCell];
            GoodsPriceModel *model = weakSelf.priceArray[indexPath.row];
            model.imageURL = dic[@"imgUrl"];
            weakSelf.editingCell.imageV.image = image;
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        YSNLog(@"%@",error);
    }];

}

#pragma mark - 图片选择上传 ↑

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.priceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EditGoodsPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditGoodsPriceCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"EditGoodsPriceCell" owner:nil options:nil][0];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    
    cell.nameTF.tag = (indexPath.row + 1) * 100 + 0;
    cell.nameTF.delegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(nameTextFieldEditChanged:)name:@"UITextFieldTextDidChangeNotification"
                                              object:cell.nameTF];
    
    cell.priceTF.tag = (indexPath.row + 1) * 100 + 1;
    cell.priceTF.delegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)name:@"UITextFieldTextDidChangeNotification"
                                              object:cell.priceTF];
    
    cell.unitTF.tag = (indexPath.row + 1) * 100 + 2;
    cell.unitTF.delegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)name:@"UITextFieldTextDidChangeNotification"
                                              object:cell.unitTF];
    cell.numTF.tag = (indexPath.row + 1) * 100 + 3;
    cell.numTF.delegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldEditChanged:)name:@"UITextFieldTextDidChangeNotification"
                                              object:cell.numTF];
    
    GoodsPriceModel  *model = self.priceArray[indexPath.row];
    cell.model = model;
    
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.separatorInset = UIEdgeInsetsZero;

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 195;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UITableViewHeaderFooterView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsPriceModel *model = self.priceArray[indexPath.row];
    //删除
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        [self deleteActionWithModel:model atIndexPath:indexPath];
    }];
    deleteRowAction.backgroundColor = [UIColor redColor];
    
    return @[deleteRowAction];
}

- (void)deleteActionWithModel:(GoodsPriceModel *)model atIndexPath:(NSIndexPath *)indexPath {
    
    [self.priceArray removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
    
}


#pragma LazyMethod
-(NSMutableArray*)priceArray{
    if (!_priceArray) {
        _priceArray = [NSMutableArray array];
    }
    return _priceArray;
}


- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kSCREEN_WIDTH, kSCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.backgroundColor = Bottom_Color;
        
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, 80)];
        _tableView.tableFooterView = footerView;
        UIButton *addMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [footerView addSubview:addMoreBtn];
        [addMoreBtn addTarget:self action:@selector(addMoreAction) forControlEvents:UIControlEventTouchUpInside];
        [addMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(0);
            make.size.equalTo(CGSizeMake(180, 50));
        }];
        [addMoreBtn setTitle:@"＋添加自定义填写项" forState:(UIControlStateNormal)];
        addMoreBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [addMoreBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
    }
    return _tableView;
}


- (CustomParameterItemView *)customerItemView {
    if (_customerItemView== nil) {
        _customerItemView= [[CustomParameterItemView alloc] initWithFrame:CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64)];
        _customerItemView.delegate = self;
        _customerItemView.isfromPrice = YES;
        [self.view addSubview:_customerItemView];
        [self.view sendSubviewToBack:self.tableView];
        
        MJWeakSelf;
        _customerItemView.finishBlock = ^(CustomParameterItemView *promptView) {
            weakSelf.priceArray= promptView.priceArray;
            [weakSelf.tableView reloadData];
            [UIView animateWithDuration:0.25 animations:^{
                promptView.frame = CGRectMake(0, kSCREEN_HEIGHT, kSCREEN_WIDTH, kSCREEN_HEIGHT - 64);
            }];
        };
        
    }
    return _customerItemView;
}


@end
