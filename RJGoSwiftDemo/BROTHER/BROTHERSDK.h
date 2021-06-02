//
//  BROTHERSDK.h
//  BROTHERSDK
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface BROTHERSDK : NSObject{
}
- (NSInteger) openport: (NSString*) destination;
- (NSInteger) openportMFI: (NSString*) MFIdestination;
- (NSInteger) closeport;
- (NSInteger) closeport:(double)delay;
- (NSInteger) setup: (NSString*) width
                height: (NSString*) height
                 speed: (NSString*) speed
               density: (NSString*) density
                sensor: (NSString*) sensor
              vertical: (NSString*) vertical
                offset: (NSString*) offset;
- (NSInteger) clearbuffer;
- (NSInteger) barcode:(NSString*) x
                    y: (NSString*) y
          barcodeType: (NSString*) type
               height: (NSString*) height
             readable: (NSString*) readable
             rotation: (NSString*) rotation
               narrow: (NSString*) narrow
                 wide: (NSString*) wide
                 code: (NSString*) code;
- (NSInteger) printerfont:(NSString*) x
                        y: (NSString*) y
                 fontName: (NSString*) fontName
                 rotation: (NSString*) rotation
       magnificationRateX: (NSString*) xmul
       magnificationRateY: (NSString*) ymul
                  content: (NSString*) content;
- (NSInteger) sendCommand: (NSString*) commandText;
- (NSInteger) printlabel: (NSString*) sets
                                  copies: (NSString*) copies;
- (NSInteger) windowsfont: (int) x
                        y: (int) y
                   height: (int) height
                 rotation: (int) rotation
                    style: (int) style
            withUnderline: (int) withUnderline
                 fontName: (NSString*) fontName
                  content: (NSString*) content;
- (NSInteger) downloadpcx: (NSString*) srcPath
              asName: (NSString*) name;
- (NSInteger) downloadbmp: (NSString*) srcPath
                   asName: (NSString*) name;
- (NSInteger) downloadttf: (NSString*) srcPath
                   asName: (NSString*) name;
- (NSInteger) formfeed;
- (NSInteger) nobackfeed;
- (NSInteger) sendfile: (NSString*) srcPath
                asName: (NSString*) name;
- (NSData *) printerstatus;
- (NSString *) rfidGetReadData;
- (NSInteger) rfidRead: (NSString*) unlock
                format: (NSString*) format
            startBlock: (NSString*) startBlock
          readDataSize: (NSString*) readDataSize
            memoryBank: (NSString*) memoryBank;
- (NSInteger) rfidWrite: (NSString*) lock
                 format: (NSString*) format
             startBlock: (NSString*) startBlock
           readDataSize: (NSString*) readDataSize
             memoryBank: (NSString*) memoryBank
                   data: (NSString*) data;
@end
