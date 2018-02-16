package robotlegs.bender.extensions;

import robotlegs.bender.extensions.modularity.impl.ModuleConnectorTest;
import haxe.unit.TestRunner;
import robotlegs.bender.extensions.modularity.ModularityExtensionTest;

class ExtensionsTestSuite {
    public function new() {
        var testRunner = new TestRunner();
        testRunner.add(new ModuleConnectorTest());
        testRunner.add(new ModularityExtensionTest());

        testRunner.run();
    }
}
