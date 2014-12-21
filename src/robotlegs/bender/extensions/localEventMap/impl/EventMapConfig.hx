//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.localEventMap.impl;

import openfl.events.IEventDispatcher;

/**
 * @private
 */
class EventMapConfig
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	private var _dispatcher:IEventDispatcher;

	/**
	 * @private
	 */
	public function get dispatcher():IEventDispatcher
	{
		return _dispatcher;
	}

	private var _eventString:String;

	/**
	 * @private
	 */
	public function get eventString():String
	{
		return _eventString;
	}

	private var _listener:Function;

	/**
	 * @private
	 */
	public function get listener():Function
	{
		return _listener;
	}

	private var _eventClass:Class;

	/**
	 * @private
	 */
	public function get eventClass():Class
	{
		return _eventClass;
	}

	private var _callback:Function;

	/**
	 * @private
	 */
	public function get callback():Function
	{
		return _callback;
	}

	private var _useCapture:Bool;

	/**
	 * @private
	 */
	public function get useCapture():Bool
	{
		return _useCapture;
	}

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function new(dispatcher:IEventDispatcher, eventString:String, listener:Function, eventClass:Class, callback:Function, useCapture:Bool)
	{
		_dispatcher = dispatcher;
		_eventString = eventString;
		_listener = listener;
		_eventClass = eventClass;
		_callback = callback;
		_useCapture = useCapture;
	}

	public function equalTo(
		dispatcher:IEventDispatcher,
		eventString:String,
		listener:Function,
		eventClass:Class,
		useCapture:Bool):Bool
	{
		return _eventString == eventString
			&& _eventClass == eventClass
			&& _dispatcher == dispatcher
			&& _listener == listener
			&& _useCapture == useCapture;
	}
}