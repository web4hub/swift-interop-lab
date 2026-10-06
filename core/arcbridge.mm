#import "ArcBridge.hxx"

ArcEntry makeEntry(NSObject *object,
                   NSObject *delegate,
                   int64_t value) {

    ArcEntry entry = {
        .object = object,
        .delegate = delegate,
        .value = value
    };

    return entry;
}
