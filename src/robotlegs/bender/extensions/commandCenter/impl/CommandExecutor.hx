//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.impl;

import robotlegs.bender.extensions.commandCenter.api.ICommand;
import robotlegs.bender.extensions.commandCenter.api.ICommandExecutor;
import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
import robotlegs.bender.framework.api.IInjector;
import robotlegs.bender.framework.impl.ApplyHooks;
import robotlegs.bender.framework.impl.GuardsApprove;
import robotlegs.bender.extensions.commandCenter.api.CommandPayload;

/**
 * @private
 */

@:keepSub
class CommandExecutor implements ICommandExecutor
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _injector:IInjector;

	private var _removeMapping:ICommandMapping->Void;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * Creates a Command Executor
	 * @param injector The Injector to use. A child injector will be created from it.
	 * @param removeMapping Remove mapping handler (optional)
	 * @param handleResult Result handler (optional)
	 */
	public function new(injector:IInjector, removeMapping:ICommandMapping->Void = null)
	{
		_injector = injector.createChild();
		_removeMapping = removeMapping;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @inheritDoc
	 */
	public function executeCommands(mappings:Array<ICommandMapping>, payload:CommandPayload = null):Void
	{
		var length:Int = mappings.length;
		for (i in 0...length)
		{
			executeCommand(mappings[i], payload);
		}
	}

	/**
	 * @inheritDoc
	 */
	public function executeCommand(mapping:ICommandMapping, payload:CommandPayload = null):Void
	{

		var hasPayload:Bool = (payload != null) && payload.hasPayload();
		
		var injectionEnabled:Bool = hasPayload && mapping.payloadInjectionEnabled;
		var command:ICommand = null;

		if (injectionEnabled) mapPayload(payload);

		if (mapping.guards.length == 0 || GuardsApprove.call(mapping.guards, _injector))
		{
			var commandClass:Class<Dynamic> = mapping.commandClass;
			if (mapping.fireOnce && (_removeMapping != null)) {
				_removeMapping(mapping);
			}
			command = _injector.getOrCreateNewInstance(commandClass);
			if (mapping.hooks.length > 0)
			{
				_injector.map(commandClass).toValue(command);
				ApplyHooks.call(mapping.hooks, _injector);
				_injector.unmap(commandClass);
			}
		}

		if (injectionEnabled) unmapPayload(payload);

		if (command != null)
		{
			command.execute();
		}
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	inline function mapPayload(payload:CommandPayload):Void
	{
		var i:UInt = payload.length;
		while (i-- > 0)
		{
			_injector.map(payload.classes[i]).toValue(payload.values[i]);
		}
	}

	inline function unmapPayload(payload:CommandPayload):Void
	{
		var i:UInt = payload.length;
		while (i-- > 0)
		{
			_injector.unmap(payload.classes[i]);
		}
	}
}
