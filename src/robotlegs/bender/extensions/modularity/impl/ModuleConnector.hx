//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.modularity.impl;

import openfl.events.EventDispatcher;
import openfl.events.IEventDispatcher;
import robotlegs.bender.extensions.modularity.api.IModuleConnector;
import robotlegs.bender.extensions.modularity.dsl.IModuleConnectionAction;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IInjector;

/**
 * @private
 */

@:keepSub
class ModuleConnector implements IModuleConnector implements org.swiftsuspenders.reflection.ITypeDescriptionAware
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _rootInjector:IInjector;

	private var _localDispatcher:IEventDispatcher;

	private var _configuratorsByChannel:Map<String, ModuleConnectionConfigurator>;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function new(context:IContext)
	{
		var injector:IInjector = context.injector;
		_rootInjector = getRootInjector(injector);
		_localDispatcher = injector.getInstance(IEventDispatcher);
		_configuratorsByChannel = new Map<String, ModuleConnectionConfigurator>();
		context.whenDestroying(destroy);
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @inheritDoc
	 */
	public function onChannel(channelId:String):IModuleConnectionAction
	{
		return getOrCreateConfigurator(channelId);
	}

	/**
	 * @inheritDoc
	 */
	public function onDefaultChannel():IModuleConnectionAction
	{
		return getOrCreateConfigurator('global');
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	private function destroy():Void
	{
		for (channelId in _configuratorsByChannel)
		{
			channelId.destroy();
		}

		_configuratorsByChannel = null;
		_localDispatcher = null;
		_rootInjector = null;
	}

	private function getOrCreateConfigurator(channelId:String):ModuleConnectionConfigurator
	{
		if (_configuratorsByChannel.exists(channelId) == false)
		{
			_configuratorsByChannel.set(channelId, createConfigurator(channelId));
		}

		return _configuratorsByChannel.get(channelId);
	}

	private function createConfigurator(channelId:String):ModuleConnectionConfigurator
	{
		if (_rootInjector.hasMapping(IEventDispatcher, channelId) == false)
		{
			_rootInjector.map(IEventDispatcher, channelId)
				.toValue(new EventDispatcher());
		}
		return new ModuleConnectionConfigurator(_localDispatcher, _rootInjector.getInstance(IEventDispatcher, channelId));
	}

	private function getRootInjector(injector:IInjector):IInjector
	{
		while (injector.parent != null)
		{
			injector = injector.parent;
		}
		return injector;
	}
}