   /********* screenshot.m Cordova Plugin Implementation *******/

    #import "DetectScreeRecording.h"
    #import <Cordova/CDV.h>

    @implementation screenshot
    - (void)pluginInitialize
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
            [[NSNotificationCenter defaultCenter] addObserverForName:UIScreenCapturedDidChangeNotification
                          object:nil
                           queue:mainQueue
                      usingBlock:^(NSNotification *note) {
                
                        if ([self.webView respondsToSelector:@selector(stringByEvaluatingJavaScriptFromString:)]) {
                            // UIWebView
                            [self.webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:@"cordova.fireDocumentEvent('screenshot');" waitUntilDone:NO];
                        } else if ([self.webView respondsToSelector:@selector(evaluateJavaScript:completionHandler:)]) {
                            // WKWebView
                            [self.webView performSelector:@selector(evaluateJavaScript:completionHandler:) withObject:@"cordova.fireDocumentEvent('screenshot');" withObject:nil];
                        } else {
                            // cordova lib version is > 4
                            [self.commandDelegate evalJs:@"cordova.fireDocumentEvent('screenshot');" ];
                        }
                      }];
        }
        for (UIScreen *screen in UIScreen.screens) {
               if ([screen respondsToSelector:@selector(isCaptured)]) {
                   // iOS 11+ has isCaptured method.
                   if ([screen performSelector:@selector(isCaptured)]) {
                       [self.webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:@"cordova.fireDocumentEvent('screenshot');" waitUntilDone:NO];


                   } else if (screen.mirroredScreen) {
                       [self.webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:@"cordova.fireDocumentEvent('screenshot');" waitUntilDone:NO]; // mirroring is active
                   }
               } else {
                   // iOS version below 11.0
                   if (screen.mirroredScreen)
                       [self.webView performSelectorOnMainThread:@selector(stringByEvaluatingJavaScriptFromString:) withObject:@"cordova.fireDocumentEvent('screenshot');" waitUntilDone:NO];
               }
           }
    }

    @end
