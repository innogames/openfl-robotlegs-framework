package ;

import openfl.Lib;
import openfl.display.DisplayObject;

class UIImpersonator {
    static public function addChild(child: DisplayObject): Void {
        Lib.current.stage.addChild(child);
    }

    static public function removeChild(child: DisplayObject): Void {
        Lib.current.stage.removeChild(child);
    }
}
