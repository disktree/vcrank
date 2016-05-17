package net.disktree.kurbel;

import flash.Lib;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.display.StageDisplayState;
import flash.events.Event;
import flash.events.FullScreenEvent;
import flash.events.MouseEvent;
import flash.events.KeyboardEvent;
import flash.events.ContextMenuEvent;
import flash.ui.ContextMenuItem;
import net.disktree.kurbel.Lib;

private typedef FrameSet = {
	var id : String;
	var len : Int;
}

class App extends Sprite {
	
	static var VERSION = "3.0";
	static inline var W = 800;
	static inline var H = 800;
	static var FRAMESETS : Array<FrameSet> = [
		{ id : "horse", len : 900 },
		{ id : "backflip", len : 367 },
		{ id : "juggling", len : 316 },
		{ id : "quetschen", len : 400 },
		{ id : "skater", len : 540 },
		{ id : "taube", len : 403 }
	];
	
	var contextMenuItemFullscreen : ContextMenuItem;
	var video : Bitmap;
	var __frameSet : FrameSet;
	var frameSet : Array<BitmapData>; // currently active frameset
	var frameSetIndex : Int;
	var frameIndex : Int; // currently active frame index
	var speed : Int;
	
	function new() {
		super();
		speed = 1;
	}
	
	public function init() {
	
		video = new Bitmap();
		addChild( video );
		
		loadFrameSet( 0 );
	
		onStageResize();
		
		var cm = new flash.ui.ContextMenu();
		cm.hideBuiltInItems();
		contextMenuItemFullscreen = new ContextMenuItem( "Fullscreen" );
		contextMenuItemFullscreen.addEventListener( ContextMenuEvent.MENU_ITEM_SELECT, _toggleFullscreen );
		cm.customItems.push( contextMenuItemFullscreen );
		flash.Lib.current.contextMenu = cm;
		
		flash.Lib.current.stage.addEventListener( Event.RESIZE, onStageResize );
		flash.Lib.current.stage.addEventListener( MouseEvent.MOUSE_WHEEL, onMouseWheel );
		flash.Lib.current.stage.addEventListener( KeyboardEvent.KEY_DOWN, onKeyDown );
		flash.Lib.current.stage.addEventListener( FullScreenEvent.FULL_SCREEN, onFullScreenChange );
		
		var timer = new haxe.Timer( 10000 );
		timer.run = function(){
			var a = 1+1;
		}
	}
	
	function loadFrameSet( i : Int ) {
		
		frameSetIndex = i;
		__frameSet = FRAMESETS[i];
		trace( "Loading frameset: "+__frameSet.id+":"+__frameSet.len );
		
		frameIndex = 0;
		frameSet = new Array();
		for( j in 1...__frameSet.len+1 ) {
			var b : BitmapData = Type.createInstance( Type.resolveClass( 'net.disktree.kurbel.Frame_'+__frameSet.id+'_'+j ), [W,H] );
			frameSet.push( b );
		}
		
		onStageResize();
		updateFrame();
	}
	
	function updateFrame() {
		video.bitmapData = frameSet[frameIndex];
	}
	
		/*
	function changeFrameIndex( i : Int ) {
		frameIndex += i;
		updateFrame();
		var j = frameIndex + i;
		if( j < 0 )
			frameIndex = frameSet.length-(frameIndex-i);
		else if( frameIndex >= frameSet.length )
			frameIndex = (j-frameSet.length);
		else
			frameIndex = j;
		updateFrame();
	}
		*/
	
	function onMouseWheel( e : MouseEvent ) {
		frameIndex += e.delta * speed;
		if( frameIndex < 0 ) {
			frameIndex = __frameSet.len + frameIndex;
		} else if( frameIndex >= frameSet.length ) {
			frameIndex = frameIndex - __frameSet.len;
		}
		updateFrame();
	}
	
	function onKeyDown( e : KeyboardEvent ) {
		trace( e.keyCode );
		switch( e.keyCode ) {
		/* 
		case 38 : // arrow u
			changeFrameIndex( 100 );
		case 40 : // arrow d
			changeFrameIndex( -100 );
		*/
		case 37 : // arrow l
			var i = frameSetIndex-1;
			if( i < 0 ) i = FRAMESETS.length-1;
			loadFrameSet( i );
		case 39 : // arrow r
			var i = frameSetIndex+1;
			if( i > FRAMESETS.length-1 ) i = 0;
			loadFrameSet( i );
		default :
			speed = e.keyCode-48;
			trace("Speed changed to: x"+speed );
		}
	}
	
	function onStageResize( ?e : Event ) {
		var sw = flash.Lib.current.stage.stageWidth;
		var sh = flash.Lib.current.stage.stageHeight;
		video.x = Std.int( sw/2 - video.width/2 );
		video.y = Std.int( sh/2 - video.height/2 );
		graphics.clear();
		graphics.beginFill( 0x000000 );
		graphics.drawRect( 0, 0, sw, sh );
		graphics.endFill();
	}
	
	function onFullScreenChange( e : FullScreenEvent ) {
		contextMenuItemFullscreen.caption = e.fullScreen ? "Exit fullscreen" : "Fullscreen";
	}
	
	inline function toggleFullscreen() {
		_toggleFullscreen( null );
	}
	
	function _toggleFullscreen( e : ContextMenuEvent ) {
		var s = flash.Lib.current.stage;
		if( s.displayState == StageDisplayState.FULL_SCREEN ) {
			s.displayState = StageDisplayState.NORMAL;
		} else {
			s.displayState = StageDisplayState.FULL_SCREEN;
		}
	}
	
	static function main() {
	
		if( haxe.Firebug.detect() ) haxe.Firebug.redirectTraces();
		trace( "KURBEL "+VERSION );
		
		flash.Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		flash.Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		
		var app = new App();
		Lib.current.addChild( app );
		app.init();
	}
	
}
