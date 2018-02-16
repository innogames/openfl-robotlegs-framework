package robotlegs.bender.extensions.modularity;

import robotlegs.bender.extensions.modularity.api.IModuleConnector;
import robotlegs.bender.extensions.eventDispatcher.EventDispatcherExtension;
import robotlegs.bender.extensions.viewManager.api.IViewManager;
import robotlegs.bender.extensions.viewManager.ViewManagerExtension;
import robotlegs.bender.framework.impl.loggingSupport.LogParams;
import robotlegs.bender.framework.api.LogLevel;
import robotlegs.bender.framework.impl.loggingSupport.CallbackLogTarget;
import robotlegs.bender.extensions.contextView.ContextView;
import openfl.display.Sprite;
import robotlegs.bender.framework.api.LifecycleError;
import robotlegs.bender.extensions.contextView.ContextViewExtension;
import robotlegs.bender.extensions.contextView.StageSyncExtension;
import robotlegs.bender.framework.impl.Context;
import haxe.unit.TestCase;
import robotlegs.bender.framework.api.IContext;

class ModularityExtensionTest extends TestCase {
    private var root:Sprite;

    private var parentView:Sprite;

    private var childView:Sprite;

    private var parentContext:IContext;

    private var childContext:IContext;

    private var rootAddedToStage:Bool;


    override public function setup(): Void {
        rootAddedToStage = false;
        root = new Sprite();
        parentView = new Sprite();
        childView = new Sprite();

        parentContext = new Context().install([StageSyncExtension, ContextViewExtension]);
        childContext = new Context().install([StageSyncExtension, ContextViewExtension]);
    }

    override public function tearDown(): Void {
        if (rootAddedToStage) {
            UIImpersonator.removeChild(root);
        }
    }

    public function test_installing_after_initialization_throws_error(): Void
    {
        var gotException: Bool = false;

        parentContext.initialize();

        try {
            parentContext.install(ModularityExtension);
        }
        catch (error: LifecycleError){
            gotException = true;
        }

        assertTrue(gotException);
    }

    public function test_context_inherits_parent_injector(): Void
    {
        addRootToStage();
        parentContext.install(ModularityExtension).configure(new ContextView(parentView));
        childContext.install(ModularityExtension).configure(new ContextView(childView));
        root.addChild(parentView);
        parentView.addChild(childView);

        assertTrue(childContext.injector.parent == parentContext.injector);
    }

    public function test_context_does_not_inherit_parent_injector_when_not_interested(): Void
    {
        addRootToStage();
        parentContext.install(ModularityExtension).configure(new ContextView(parentView));
        childContext.install(new ModularityExtension(false)).configure(new ContextView(childView));
        root.addChild(parentView);
        parentView.addChild(childView);

        assertTrue(childContext.injector.parent != parentContext.injector);
    }

    public function test_context_does_not_inherit_parent_injector_when_disallowed_by_parent(): Void
    {
        addRootToStage();
        parentContext.install(new ModularityExtension(true, false)).configure(new ContextView(parentView));
        childContext.install(ModularityExtension).configure(new ContextView(childView));
        root.addChild(parentView);
        parentView.addChild(childView);

        assertTrue(childContext.injector.parent != parentContext.injector);
    }

    public function test_extension_logs_error_when_context_initialized_with_no_contextView(): Void
    {
        var errorLogged:Bool = false;
        var logTarget: CallbackLogTarget = new CallbackLogTarget(
            function(log: LogParams): Void {
                var logSourceClassName: String = Type.getClassName(Type.getClass(log.source));
                var modularityExtensionClassName: String = Type.getClassName(ModularityExtension);

                if (logSourceClassName == modularityExtensionClassName && log.level == LogLevel.ERROR) {
                    errorLogged = true;
                }
        });

        childContext.install(ModularityExtension);
        childContext.addLogTarget(logTarget);
        childContext.initialize();

        assertTrue(errorLogged);
    }

    public function test_child_added_to_viewManager_inherits_injector(): Void
    {
        addRootToStage();
        parentContext = new Context()
        .install([
            ContextViewExtension,
            ModularityExtension,
            ViewManagerExtension,
            StageSyncExtension])
        .configure(new ContextView(parentView));

        var viewManager: IViewManager =
        parentContext.injector.getInstance(IViewManager);
        viewManager.addContainer(childView);

        childContext = new Context()
        .install([
            ContextViewExtension,
            ModularityExtension,
            StageSyncExtension])
        .configure(new ContextView(childView));

        root.addChild(parentView);
        root.addChild(childView);

        assertTrue(childContext.injector.parent == parentContext.injector);
    }

    public function test_moduleConnector_mapped_to_injector(): Void
    {
        var actual: Dynamic = null;
        var context : IContext = new Context();
        context.install([
            EventDispatcherExtension,
            ModularityExtension]);

        context.whenInitializing( function(): Void {
        actual = context.injector.getInstance(IModuleConnector);
        });

        context.initialize();
        assertTrue(Std.is(actual, IModuleConnector));
    }

    private function addRootToStage(): Void
    {
        rootAddedToStage = true;
        UIImpersonator.addChild(root);
    }

    public function new() {
        super();
    }
}
