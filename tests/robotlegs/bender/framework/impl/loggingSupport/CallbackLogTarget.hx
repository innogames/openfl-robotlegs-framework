package robotlegs.bender.framework.impl.loggingSupport;

import robotlegs.bender.framework.api.ILogTarget;

class CallbackLogTarget implements ILogTarget {
    private var _callback: LogParams -> Void;

    public function new(callback: LogParams -> Void) {
        _callback = callback;
    }

    public function log(source: Dynamic, level: UInt, timestamp: Float, message: String, params: Array<Dynamic> = null): Void
    {
        if (_callback != null) {
            _callback(new LogParams(source, level, timestamp, message, params));
        }
    }
}
