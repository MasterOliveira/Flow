/*****************************************************
 *  
 *  Copyright 2009 Adobe Systems Incorporated.  All Rights Reserved.
 *  
 *****************************************************
 *  The contents of this file are subject to the Mozilla Public License
 *  Version 1.1 (the "License"); you may not use this file except in
 *  compliance with the License. You may obtain a copy of the License at
 *  http://www.mozilla.org/MPL/
 *   
 *  Software distributed under the License is distributed on an "AS IS"
 *  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
 *  License for the specific language governing rights and limitations
 *  under the License.
 *   
 *  
 *  The Initial Developer of the Original Code is Adobe Systems Incorporated.
 *  Portions created by Adobe Systems Incorporated are Copyright (C) 2009 Adobe Systems 
 *  Incorporated. All Rights Reserved. 
 *  
 *****************************************************/
package org.osmf.layout
{
	import flexunit.framework.Assert;
	
	import org.osmf.events.MetadataEvent;
	import org.osmf.metadata.NullMetadataSynthesizer;
	
	public class TestRelativeLayoutMetadata
	{		
		[Before]
		public function setUp():void
		{
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void
		{
		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		[Test]
		public function testChangeEventForX():void
		{
			var lastEvent:MetadataEvent;
			var eventCounter:int = 0;
			
			function onMetadataChange(event:MetadataEvent):void
			{
				lastEvent = event;
				eventCounter++;
			}
			
			var metadata:RelativeLayoutMetadata = new RelativeLayoutMetadata();
			metadata.addEventListener(MetadataEvent.VALUE_CHANGE, onMetadataChange);
			
			metadata.x = 1;
			
			Assert.assertEquals(1, eventCounter);
			Assert.assertEquals(RelativeLayoutMetadata.X, lastEvent.key);
			Assert.assertEquals(NaN, lastEvent.oldValue);
			Assert.assertEquals(1, lastEvent.value);
			Assert.assertEquals(metadata.x, metadata.getValue(RelativeLayoutMetadata.X), 1);
		}
		
		[Test]
		public function testChangeEventForY():void
		{
			var lastEvent:MetadataEvent;
			var eventCounter:int = 0;
			
			function onMetadataChange(event:MetadataEvent):void
			{
				lastEvent = event;
				eventCounter++;
			}
			
			var metadata:RelativeLayoutMetadata = new RelativeLayoutMetadata();
			metadata.addEventListener(MetadataEvent.VALUE_CHANGE, onMetadataChange);
			
			metadata.y = 2;
			
			Assert.assertEquals(1, eventCounter);
			Assert.assertEquals(RelativeLayoutMetadata.Y, lastEvent.key);
			Assert.assertEquals(NaN, lastEvent.oldValue);
			Assert.assertEquals(2, lastEvent.value);
			Assert.assertEquals(metadata.y, metadata.getValue(RelativeLayoutMetadata.Y), 2);
		}
		
		[Test]
		public function testChangeEventForWidth():void
		{
			var lastEvent:MetadataEvent;
			var eventCounter:int = 0;
			
			function onMetadataChange(event:MetadataEvent):void
			{
				lastEvent = event;
				eventCounter++;
			}
			
			var metadata:RelativeLayoutMetadata = new RelativeLayoutMetadata();
			metadata.addEventListener(MetadataEvent.VALUE_CHANGE, onMetadataChange);
			
			metadata.width = 3;
			
			Assert.assertEquals(1, eventCounter);
			Assert.assertEquals(RelativeLayoutMetadata.WIDTH, lastEvent.key);
			Assert.assertEquals(NaN, lastEvent.oldValue);
			Assert.assertEquals(3, lastEvent.value);
			Assert.assertEquals(metadata.width, metadata.getValue(RelativeLayoutMetadata.WIDTH), 3);
		}
		
		[Test]
		public function testChangeEventForHeight():void
		{
			var lastEvent:MetadataEvent;
			var eventCounter:int = 0;
			
			function onMetadataChange(event:MetadataEvent):void
			{
				lastEvent = event;
				eventCounter++;
			}
			
			var metadata:RelativeLayoutMetadata = new RelativeLayoutMetadata();
			metadata.addEventListener(MetadataEvent.VALUE_CHANGE, onMetadataChange);
			
			metadata.height = 4;
			
			Assert.assertEquals(1, eventCounter);
			Assert.assertEquals(RelativeLayoutMetadata.HEIGHT, lastEvent.key);
			Assert.assertEquals(NaN, lastEvent.oldValue);
			Assert.assertEquals(4, lastEvent.value);
			Assert.assertEquals(metadata.height, metadata.getValue(RelativeLayoutMetadata.HEIGHT), 4);
		}
		
		[Test]
		public function testUndefinedGetValue():void
		{			
			var metadata:RelativeLayoutMetadata = new RelativeLayoutMetadata();
			
			Assert.assertEquals(undefined, metadata.getValue(null));
			Assert.assertEquals(undefined, metadata.getValue("@*#$^98367423874"));
		}
		
		[Test]
		public function testSynthesizedMetadata():void
		{			
			var metadata:RelativeLayoutMetadata = new RelativeLayoutMetadata();
			
			Assert.assertTrue(metadata.synthesizer is NullMetadataSynthesizer);
		}
	}
}