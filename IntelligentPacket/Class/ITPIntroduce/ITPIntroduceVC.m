//
//  ITPIntroduceVC.m
//  IntelligentPacket
//
//  Created by Seth Chen on 16/6/26.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "ITPIntroduceVC.h"

@interface ITPIntroduceVC ()<UIWebViewDelegate>
{
    UILabel * introduceLabel;
    
    NSArray <NSString *> *introduceStrArr;
    
    NSMutableAttributedString * introduceStr;
}

@property (weak, nonatomic) IBOutlet UIWebView *contWeb;

@end

@implementation ITPIntroduceVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refreshLanguge];
   
    introduceLabel = [UILabel new];
    introduceLabel.backgroundColor  = self.view.backgroundColor;
    introduceLabel.numberOfLines = 0;
    [self.view addSubview:introduceLabel];
    
//    if (!self.isWeb) {
//        self.contWeb.alpha = 0;
//    }else {
        [self.contWeb setDelegate:(id)self];
        self.contWeb.scalesPageToFit = YES;
        [self.contWeb loadRequest:[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.hwhandbag.com"]]];
//    }

}


- (void)webViewDidStartLoad:(UIWebView *)webView {

    [self showHUBAlert:@"" WithDelay:10];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideAlert];
}

- (void)setupUI {
    
    
   
    
    
    
    return;
    
    NSMutableArray <NSDictionary *>* mutAttributesArr = [NSMutableArray array];
    NSMutableArray <NSValue *>* mutRange = [NSMutableArray array];
    NSString * str = @"";
    for (int i = 0 ; i < introduceStrArr.count ; i ++) {
        str = [str stringByAppendingString:introduceStrArr[i]];
        NSRange range = NSMakeRange(str.length - introduceStrArr[i].length, introduceStrArr[i].length);
        NSValue * value = [NSValue valueWithRange:range];
        if (i != 1 && i != 6) {
            NSDictionary * dic = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:16], NSForegroundColorAttributeName:RGB(35, 35, 35)};
            [mutAttributesArr addObject:dic];
            [mutRange addObject:value];
        }else {
            NSDictionary * dic = @{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName:RGB(100, 100, 100)};
            [mutAttributesArr addObject:dic];
            [mutRange addObject:value];
        }
    }
    introduceStr = [[NSMutableAttributedString alloc]initWithString:str];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    [paragraphStyle setLineSpacing:6];
    [paragraphStyle setParagraphSpacing:6];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16], NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGRect rect = [str boundingRectWithSize:CGSizeMake(UI_WIDTH -30, CGFLOAT_MAX)
                                         options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                      attributes:attributes
                                         context:nil];
    for (int i = 0 ; i < mutAttributesArr.count ; i ++) {
        [introduceStr addAttributes:mutAttributesArr[i] range:mutRange[i].rangeValue];
    }
    NSDictionary *attributes__ = @{NSParagraphStyleAttributeName:paragraphStyle.copy};
    [introduceStr addAttributes:attributes__ range:NSMakeRange(0, str.length)];
    
    introduceLabel.frame = CGRectMake(15, 15, UI_WIDTH -30, rect.size.height);
    introduceLabel.attributedText = introduceStr;
}

- (void)refreshLanguge {
    
    //    [self.tableView reloadData];
//    if (self.isWeb) {
        self.title = L(@"Social");
//    }
    
    
    introduceStrArr = @[L(@"Shenzhen Hong Wang handbags Products Co., Ltd.\n"), L(@"Was founded in January 2002, is a professional design and production of bags of production enterprises. Hong Wang to foundry world brand of a gleam of bags products started, after many years of efforts, developed a series of own brand products, mainly including:\n"), L(@"series solar charging bag\n"), L(@"Intelligent outdoor bag series\n"), L(@"Smart bag series\n"), L(@"Smart luggage series\n\n"), L(@"Hong Wang's vision: to do first-class luggage products, to do responsible business, happy work, happy life\n")];
    
    [self setupUI];
}


@end
