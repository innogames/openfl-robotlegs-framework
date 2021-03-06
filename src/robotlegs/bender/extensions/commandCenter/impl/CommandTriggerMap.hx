//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.impl;


import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
import robotlegs.bender.extensions.eventCommandMap.impl.EventCommandTrigger;

/**
 * @private
 */

@:keepSub
class CommandTriggerMap
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _triggers = new Map<String,Dynamic>();

	private var _keyFactory:String -> Class<Dynamic> -> String;

	private var _triggerFactory:String -> Class<Dynamic> -> EventCommandTrigger;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * Creates a command trigger map
	 * @param keyFactory Factory function to creates keys
	 * @param triggerFactory Factory function to create triggers
	 */
	public function new(keyFactory:Dynamic, triggerFactory:Dynamic)
	{
		_keyFactory = keyFactory;
		_triggerFactory = triggerFactory;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @private
	 */
	
	public function getTrigger(params:Array<Dynamic>):ICommandTrigger
	{
		var key:String = getKey(params);
		if (_triggers[key] == null) {
			_triggers[key] = createTrigger(params);
		}
		return _triggers[key];
	}

	/**
	 * @private
	 */
	public function removeTrigger(params:Array<Dynamic>):ICommandTrigger
	{
		return destroyTrigger(getKey(params));
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	private function getKey(mapperArgs:Array<Dynamic>):Dynamic
	{
		return Reflect.callMethod(null, _keyFactory, mapperArgs);
		//return _keyFactory.apply(null, mapperArgs);
	}

	private function createTrigger(mapperArgs:Array<Dynamic>):ICommandTrigger
	{
		return Reflect.callMethod(null, _triggerFactory, mapperArgs);
		//return _triggerFactory.apply(null, mapperArgs);
	}

	private function destroyTrigger(key:Dynamic):ICommandTrigger
	{
		var trigger:ICommandTrigger = _triggers[key];
		if (trigger != null)
		{
			trigger.deactivate();
			_triggers.remove(key);
		}
		return trigger;
	}
}