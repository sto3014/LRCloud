#import <Foundation/Foundation.h>
#import <FileProvider/FileProvider.h>

void printUsage() {
    printf("Usage: cloudfile <file-path> <command>\n");
    printf("Commands:\n");
    printf("  materialize - Download the file from the cloud\n");
    printf("  evict - Remove local copy while keeping it in the cloud\n");
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if (argc != 3) {
            printUsage();
            return 1;
        }
        
        NSString *filePath = [NSString stringWithUTF8String:argv[1]];
        NSString *command = [NSString stringWithUTF8String:argv[2]];
        
        NSURL *fileURL = [NSURL fileURLWithPath:filePath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        if ([command isEqualToString:@"materialize"]) {
            NSError *error = nil;
            if (![fileManager startDownloadingUbiquitousItemAtURL:fileURL error:&error]) {
                NSLog(@"Error materializing file: %@", error);
                return 1;
            }
            NSLog(@"Requested materialization of file: %@", filePath);
        } else if ([command isEqualToString:@"evict"]) {
            NSError *error = nil;
            if (![fileManager evictUbiquitousItemAtURL:fileURL error:&error]) {
                NSLog(@"Error evicting file: %@", error);
                return 1;
            }
            NSLog(@"Evicted file: %@", filePath);
        } else {
            printUsage();
            return 1;
        }
    }
    return 0;
}

