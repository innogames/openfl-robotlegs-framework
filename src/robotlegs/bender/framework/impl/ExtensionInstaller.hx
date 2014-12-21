//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl;

import openfl.utils.Dictionary;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.ILogger;

/**
 * Installs custom extensions into a given context
 *
 * @private
 */
class ExtensionInstaller
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _classes:Dictionary = new Dictionary(true);

	private var _context:IContext;

	private var _logger:ILogger;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function new(context:IContext)
	{
		_context = context;
		_logger = _context.getLogger(this);
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * Installs the supplied extension
	 * @param extension An object or class implementing IExtension
	 */
	public function install(extension:Dynamic):Void
	{
		if (extension is Class)
		{
			_classes[extension] || install(new (extension as Class));
		}
		else
		{
			var extensionClass:Class = extension.constructor as Class;
			if (_classes[extensionClass])
				return;
			_logger.debug("Installing extension {0}", [extension]);
			_classes[extensionClass] = true;
			extension.extend(_context);
		}
	}

	/**
	 * Destroy
	 */
	public function destroy():Void
	{
		for (var extensionClass:Dynamic in _classes)
		{
			delete _classes[extensionClass];
		}
	}
}
