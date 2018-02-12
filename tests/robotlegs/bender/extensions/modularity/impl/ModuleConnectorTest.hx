package robotlegs.bender.extensions.modularity.impl;

import robotlegs.bender.extensions.eventCommandMap.support.SupportEvent;
import robotlegs.bender.extensions.modularity.impl.ModuleConnector;
import robotlegs.bender.extensions.eventDispatcher.EventDispatcherExtension;
import robotlegs.bender.framework.impl.Context;
import robotlegs.bender.framework.api.IContext;
import openfl.events.Event;
import flash.events.IEventDispatcher;
import robotlegs.bender.extensions.modularity.api.IModuleConnector;
import haxe.unit.TestCase;

class ModuleConnectorTest extends TestCase {
    private var parentDispatcher:IEventDispatcher;

    private var childADispatcher:IEventDispatcher;

    private var childBDispatcher:IEventDispatcher;

    private var parentConnector:IModuleConnector;

    private var childAConnector:IModuleConnector;

    private var childBConnector:IModuleConnector;


    override public function setup():Void
    {
        var parentContext:IContext = new Context().install(EventDispatcherExtension);
        var childAContext:IContext = new Context().install(EventDispatcherExtension);
        var childBContext:IContext = new Context().install(EventDispatcherExtension);

        parentContext.addChild(childAContext);
        parentContext.addChild(childBContext);

        parentConnector = new ModuleConnector(parentContext);
        childAConnector = new ModuleConnector(childAContext);
        childBConnector = new ModuleConnector(childBContext);

        parentDispatcher = parentContext.injector.getInstance(IEventDispatcher);
        childADispatcher = childAContext.injector.getInstance(IEventDispatcher);
        childBDispatcher = childBContext.injector.getInstance(IEventDispatcher);
    }

    /*============================================================================*/
    /* Tests                                                                      */
    /*============================================================================*/

    public function test_allows_communication_from_parent_to_child():Void
    {
        parentConnector.onDefaultChannel()
        .relayEvent(SupportEvent.END);
        childAConnector.onDefaultChannel()
        .receiveEvent(SupportEvent.END);

        var wasCalled:Bool = false;
        childADispatcher.addEventListener(SupportEvent.END, function(event:Event):Void {
            wasCalled = true;
        });

        parentDispatcher.dispatchEvent(new SupportEvent(SupportEvent.END));

        assertTrue(wasCalled);
    }

    public function test_allows_communication_from_child_to_parent():Void
    {
        parentConnector.onDefaultChannel()
        .receiveEvent(SupportEvent.END);
        childAConnector.onDefaultChannel()
        .relayEvent(SupportEvent.END);

        var wasCalled:Bool = false;
        parentDispatcher.addEventListener(SupportEvent.END, function(event:Event):Void {
            wasCalled = true;
        });

        childADispatcher.dispatchEvent(new SupportEvent(SupportEvent.END));

        assertTrue(wasCalled);
    }

    public function test_allows_communication_amongst_children():Void
    {
        childAConnector.onDefaultChannel()
        .relayEvent(SupportEvent.END);
        childBConnector.onDefaultChannel()
        .receiveEvent(SupportEvent.END);

        var wasCalled:Bool = false;
        childBDispatcher.addEventListener(SupportEvent.END, function(event:Event):Void {
            wasCalled = true;
        });

        childADispatcher.dispatchEvent(new SupportEvent(SupportEvent.END));

        assertTrue(wasCalled);
    }

    public function test_channels_are_isolated():Void
    {
        parentConnector.onDefaultChannel()
        .relayEvent(SupportEvent.END);
        childAConnector.onChannel('other-channel')
        .receiveEvent(SupportEvent.END);

        var wasCalled:Bool = false;
        childADispatcher.addEventListener(SupportEvent.END, function(event:Event):Void {
            wasCalled = true;
        });

        parentDispatcher.dispatchEvent(new SupportEvent(SupportEvent.END));

        assertFalse(wasCalled);
    }
}

