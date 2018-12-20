//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewProcessorMap.impl;


import org.swiftsuspenders.utils.UID;
import robotlegs.bender.extensions.viewProcessorMap.dsl.IViewProcessorMapping;

/**
 * @private
 */
@:keepSub
class ViewProcessorViewHandler implements IViewProcessorViewHandler
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _mappings:Array<IViewProcessorMapping> = [];

	private var _knownMappings = new Map<String,Array<IViewProcessorMapping>>();
	private var _interestedMappings = new Map<String,Bool>();

	private var _factory:IViewProcessorFactory;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function new(factory:IViewProcessorFactory):Void
	{
		_factory = factory;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @inheritDoc
	 */
	public function addMapping(mapping:IViewProcessorMapping):Void
	{
		var index:Int = _mappings.indexOf(mapping);
		if (index > -1)
			return;
		_mappings.push(mapping);
		flushCache();
	}

	/**
	 * @inheritDoc
	 */
	public function removeMapping(mapping:IViewProcessorMapping):Void
	{
		var index:Int = _mappings.indexOf(mapping);
		if (index == -1)
			return;
		_mappings.splice(index, 1);
		flushCache();
	}

	/**
	 * @inheritDoc
	 */
	public function processItem(item:Dynamic, type:Class<Dynamic>):Void
	{
		var interestedMappings:Array<Dynamic> = getInterestedMappingsFor(item, type);
		if (interestedMappings != null)
			_factory.runProcessors(item, type, interestedMappings);
	}

	/**
	 * @inheritDoc
	 */
	public function unprocessItem(item:Dynamic, type:Class<Dynamic>):Void
	{
		var interestedMappings:Array<Dynamic> = getInterestedMappingsFor(item, type);
		if (interestedMappings != null)
			_factory.runUnprocessors(item, type, interestedMappings);
	}

	/*============================================================================*/
	/* Private Functions                                                          */
	/*============================================================================*/

	private function flushCache():Void
	{
		_knownMappings = new Map<String,Array<IViewProcessorMapping>>();
		_interestedMappings = new Map<String,Bool>();
	}

	private function getInterestedMappingsFor(view:Dynamic, type:Class<Dynamic>):Array<IViewProcessorMapping>
	{
		var mapping:IViewProcessorMapping;
		var id = Type.getClassName(type);

		// we've seen this type before and nobody was interested
		if (_interestedMappings[id] == false) {
			return null;
		}

		// we haven't seen this type before
		if (_knownMappings[id] == null) {
			_interestedMappings[id] = false;

			for (i in 0..._mappings.length) {
				mapping = _mappings[i];

				if (mapping.matcher.matches(view)) {
					if (_interestedMappings[id] == false) {
						_interestedMappings[id] = true;
						_knownMappings[id] = new Array<IViewProcessorMapping>();
					}

					_knownMappings[id].push(mapping);
				}
			}

			// nobody cares, let's get out of here
			if (_interestedMappings[id] == false) {
				return null;
			}
		}

		// these mappings really do care
		return _knownMappings[id];
	}
}