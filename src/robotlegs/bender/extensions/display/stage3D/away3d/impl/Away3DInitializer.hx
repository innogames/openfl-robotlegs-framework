package robotlegs.bender.extensions.display.stage3D.away3d.impl;

import openfl.events.Event;
import org.swiftsuspenders.utils.CallProxy;
import robotlegs.bender.extensions.display.stage3D.away3d.impl.AwayCollection;
import robotlegs.bender.extensions.display.base.impl.BaseInitializer;
/**
 * ...
 * @author P.J.Shand
 */
@:keepSub
class Away3DInitializer extends BaseInitializer implements org.swiftsuspenders.reflection.ITypeDescriptionAware
{

	public function new()
	{

	}

	override public function addLayer(ViewClass:Class<Dynamic>, index:Int, id:String):Void
	{
		var stage3DRenderContext:Stage3DRenderContext = cast renderContext;
		if (id == "") id = autoID(ViewClass);
		var awayLayer:IAwayLayer = Type.createInstance(ViewClass, [stage3DRenderContext.profile]);
		awayLayer.renderContext = renderContext;

		var awayCollection = new AwayCollection([awayLayer, id]);
		context.configure([awayCollection]);
		contextView.view.addChild(cast awayLayer);

		if (index == -1) layers.addLayer(cast awayLayer);
		else layers.addLayerAt(cast awayLayer, index);
	}
}