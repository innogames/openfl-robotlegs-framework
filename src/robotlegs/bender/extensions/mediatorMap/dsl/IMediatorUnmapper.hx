//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.dsl;

import robotlegs.bender.extensions.mediatorMap.api.IMediator;

/**
 * Unmaps a Mediator
 */
interface IMediatorUnmapper
{
	/**
	 * Unmaps a mediator from this matcher
	 * @param mediatorClass Mediator to unmap
	 */
	function fromMediator(mediatorClass:Class<IMediator>):Void;

	/**
	 * Unmaps all mediator mappings for this matcher
	 */
	function fromAll():Void;
}