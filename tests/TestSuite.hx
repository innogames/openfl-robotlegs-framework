package ;

import robotlegs.bender.extensions.modularity.impl.ModuleConnectorTest;
import haxe.unit.TestRunner;

class TestSuite {
    static public function main(): Void {
        trace("Run Tests");

        var testRunner = new TestRunner();
        testRunner.add(new ModuleConnectorTest());

        testRunner.run();
    }
}
