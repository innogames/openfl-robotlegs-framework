//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewProcessorMap.impl;


import haxe.ds.ObjectMap;
import robotlegs.bender.framework.api.IInjector;

/**
 * Default View Injection Processor implementation
 * @private
 */
@:keepSub
class ViewInjectionProcessor
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _injectedObjects: ObjectMap<Dynamic,Bool> = new ObjectMap<Dynamic,Bool>();

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function process(view:Dynamic, type:Class<Dynamic>, injector:IInjector):Void
	{
		if (!_injectedObjects.exists(view)) {
            injectAndRemember(view, injector);
        }
	}

	/**
	 * @private
	 */
	public function unprocess(view:Dynamic, type:Class<Dynamic>, injector:IInjector):Void
	{
		// assumption is that teardown is not wanted.
		// if you *do* want teardown, copy this class
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	private function injectAndRemember(view:Dynamic, injector:IInjector):Void
	{
		injector.injectInto(view);
		_injectedObjects.set(view, true);
	}
}
