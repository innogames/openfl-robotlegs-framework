//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl;

import openfl.display.DisplayObject;
import openfl.events.Event;
import org.swiftsuspenders.utils.CallProxy;
import robotlegs.bender.extensions.mediatorMap.api.IMediator;
import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;

/**
* @private
*/

@:keepSub
class MediatorManager
{
	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _factory:MediatorFactory;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function new(factory:MediatorFactory)
	{
		_factory = factory;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function addMediator(mediator:IMediator, item:Dynamic, mapping:IMediatorMapping):Void
	{
		var displayObject:DisplayObject = null;
		if (Std.is(item, DisplayObject)) {
			displayObject = cast(item, DisplayObject);
		}
		
		// Watch Display Dynamic for removal
		if (displayObject != null && mapping.autoRemoveEnabled)
			displayObject.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

		// Synchronize with item life-cycle
		initializeMediator(mediator, item);
	}
	
	/**
	 * @private
	 */
	public function removeMediator(mediator:IMediator, item:Dynamic, mapping:IMediatorMapping):Void
	{
		if (Std.is(item, DisplayObject))
			cast(item, DisplayObject).removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

		destroyMediator(mediator);
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	private function onRemovedFromStage(event:Event):Void
	{
		_factory.removeMediators(event.target);
	}

	private function initializeMediator(mediator:IMediator, mediatedItem:Dynamic):Void
	{
		mediator.viewComponent = mediatedItem;
		mediator.initialize();
	}

	private function destroyMediator(mediator:IMediator):Void
	{
		mediator.destroy();
		mediator.viewComponent = null;
		mediator.postDestroy();
	}
}
