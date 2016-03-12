//
//  ViewController.m
//  ConvertHtmlLabel
//
//  Created by Apple on 16/3/12.
//  Copyright © 2016年 ywj. All rights reserved.
//

#import "ViewController.h"

#define AHScreenSize [UIScreen mainScreen].bounds.size
#define AHLabelH     (AHScreenSize.height * 0.5)
#define AHLabelW     AHScreenSize.width

@interface ViewController ()

@property (nonatomic, copy) NSString *htmlExampleStr;

@property (nonatomic, strong) NSAttributedString *htmlArrributeStr;

@property (nonatomic, strong) UILabel *showedLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self.view addSubview:self.showedLabel];
    //html显示到UITextView上
    //[self showHtmlInTheTextViewDemo];
    
    // html显示到webview上
    //[self showHtmlInTheWebView];
    
    // 设置给attributedText不是设置到text上
    self.showedLabel.attributedText = self.htmlArrributeStr;
}

- (void)initData
{
    self.htmlExampleStr = @"我是将<em>html</em>中的相关<em>标签</em>转换的功能<h1>我的第一个标题</h1><p>我的第一个段落。</p>";
}

- (NSString *)replaceHtmlLabelToStr:(NSString *)html
{
    html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"<em>"] withString:@"<em style=\"font-size:18px; color:#11afb8\">"];
    return html;
}

#pragma mark- 懒加载 

///!!!调用懒加载时要用self.htmlArrributeStr 而不是_htmlArrributeStr
///!!!_htmlArrributeStr不会执行懒加载中的方法

- (NSAttributedString *)htmlArrributeStr
{
    if (_htmlArrributeStr == nil) {
        NSString *string = [self replaceHtmlLabelToStr:self.htmlExampleStr];
        NSString *htmlString = [NSString stringWithFormat:@"<em style=\"font-size:18px; color:#454545\"><p>%@</p></em>",string];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding: NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        NSString *str = attrStr.string;
        if ([str containsString:@"\n"]) {
            NSRange range = [str rangeOfString:@"\n"];
            [attrStr replaceCharactersInRange:range withString:@""];
        }
        _htmlArrributeStr = attrStr;
    }
    return _htmlArrributeStr;
}

- (UILabel *)showedLabel
{
    if (_showedLabel == nil) {
        _showedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, AHLabelH + 10, AHLabelW, AHLabelH)];
        _showedLabel.backgroundColor = [UIColor grayColor];
        //default value is 1 害得我找了半天不换行原因
        _showedLabel.numberOfLines = 0;
    }
    return _showedLabel;
}

#pragma mark- 显示到UILabel或者UIWebView上
/*!
 @property
 @abstract 将html内容显示到textView上,
 */
- (void)showHtmlInTheTextViewDemo
{
    NSString * htmlString = @"<html><head><title>菜鸟教程</title></head><body><h1>我的第一个标题</h1><p>我的第一个段落。</p>我是将<em>html</em>中的相关<em>标签</em>转换的<em style=\"font-size:18px; color:#11afb8\">功能</em></em></body></html>";
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    UITextView * textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    textView.backgroundColor = [UIColor grayColor];
    textView.attributedText = attrStr;
    [self.view addSubview:textView];
}

/*!
 @property
 @abstract 将html内容显示到webview上
 */
- (void)showHtmlInTheWebView
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    [webView loadHTMLString:@"<html><head><title>菜鸟教程</title></head><body><h1>我的第一个标题</h1><p>我的第一个段落。</p>我是将<em>html</em>中的相关<em>标签</em>转换的<em style=\"font-size:18px; color:#11afb8\">功能</em></em></body></html>" baseURL:nil];
}

@end
