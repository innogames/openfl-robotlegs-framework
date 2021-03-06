//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl;

import openfl.system.ApplicationDomain;
import org.swiftsuspenders.Injector;
import robotlegs.bender.framework.api.IInjector;

/**
 * Robotlegs IInjector Adapter
 */
@:keepSub
class RobotlegsInjector extends Injector implements IInjector
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	/**
	 * @inheritDoc
	 */
	public var parent(get, set):Null<IInjector>;
	
	public function set_parent(parentInjector:IInjector):Null<IInjector>
	{
		this.parentInjector = cast parentInjector;
		return parentInjector;
	}

	/**
	 * @inheritDoc
	 */
	public function get_parent():Null<IInjector>
	{
		return cast this.parentInjector;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	* @inheritDoc
	*/
	public function createChild(applicationDomain:ApplicationDomain = null):IInjector
	{
		var childInjector:IInjector = new RobotlegsInjector();
		if (applicationDomain != null) childInjector.applicationDomain = applicationDomain;
		else childInjector.applicationDomain = this.applicationDomain;
		childInjector.parent = this;
		return childInjector;
	}
}
