//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl;


import haxe.ds.ObjectMap;
import robotlegs.bender.framework.api.IExtension;
import org.swiftsuspenders.InjectorMacro;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.ILogger;

/**
 * Installs custom extensions into a given context
 *
 * @private
 */
@:keepSub
class ExtensionInstaller
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _classes: ObjectMap<Dynamic,Bool> = new ObjectMap<Dynamic,Bool>();

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
		if (Std.is(extension, Class))
			installClassExtension(extension);
		else
			instanllInstanceExtension(cast(extension, IExtension));
	}

	private function installClassExtension(classExtension: Class<Dynamic>): Void {
		var extensionInstance = Type.createInstance(classExtension, []);
		install(extensionInstance);
		InjectorMacro.keep(extensionInstance);
	}

	private function instanllInstanceExtension(extension: IExtension): Void {

		if (canInstall(extension)) {
			markExtensionAsInstalled(extension);
			extension.extend(_context);
		}
	}

	private inline function canInstall(extension: IExtension): Bool {
		var isInstalled: Bool = _classes.exists(extension);
		if (isInstalled) _logger.warn("Attempt to install extension with id: " + extension + " twice!");

		return !isInstalled;
	}

	private inline function markExtensionAsInstalled(extension: IExtension): Void {
        _logger.info("Installing extension {0}", [extension]);
		_classes.set(extension, true);
	}

	/**
	 * Destroy
	 */
	public function destroy():Void
	{
		for (propertyName in _classes.keys()) {
			_classes.remove(propertyName);
		}
	}
}
