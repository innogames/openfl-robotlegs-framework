package robotlegs.bender.framework.impl.loggingSupport;

class LogParams {
    public var source: Dynamic;

    public var level: UInt;

    public var timestamp: Float;

    public var message: String;

    public var params:Array<Dynamic>;

    public function new(source: Dynamic, level:UInt, timestamp: Float, message: String, params: Array<Dynamic>) {
        this.source = source;
        this.level = level;
        this.timestamp = timestamp;
        this.message = message;
        this.params = params;
    }
}
