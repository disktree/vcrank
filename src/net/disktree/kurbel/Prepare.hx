package net.disktree.kurbel;

import neko.FileSystem;
import neko.io.File;

class Prepare {
	
	static var PATH_LIB = "lib/";
	
	static var buf : StringBuf;
	
	static function main() {
		
		//TODO read args (frameset names)
		
		buf = new StringBuf();
		buf.add( "package net.disktree.kurbel;\n\n" );
		buf.add( "import flash.display.BitmapData;\n" );
		buf.add( "\n// Automatically generated, do NOT edit!\n" );
		
		var frameSetNames = FileSystem.readDirectory( PATH_LIB );
		for( id in frameSetNames ) {
			buf.add('\n// '+id+'\n');
			var framenames = FileSystem.readDirectory( PATH_LIB+id );
			framenames.sort( sortFramesByName );
			var i = 1;
			for( f in framenames ) {
				buf.add( '@:bitmap("' + PATH_LIB + id +"/"+f + '") class Frame_'+id+'_'+i+' extends BitmapData {}\n' );
				i++;
			}
		}
		
		buf.add( '\nclass Lib {}\n' );
		
		var fo = File.write( "src/net/disktree/kurbel/Lib.hx", false );
		fo.writeString( buf.toString() );
		fo.close();
	}
	
	static function sortFramesByName( a : String, b : String ) : Int {
		var i1 = Std.parseInt( a.substr( 4, a.lastIndexOf(".")-4 ) );
		var i2 = Std.parseInt( b.substr( 4, b.lastIndexOf(".")-4 ) );
		return if( i1 < i2 ) -1 else if( i1 > i2 ) 1 else 0;
	}
	
}
