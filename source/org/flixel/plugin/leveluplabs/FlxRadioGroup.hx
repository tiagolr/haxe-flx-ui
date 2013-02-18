package org.flixel.plugin.leveluplabs;
import org.flixel.FlxObject;
import org.flixel.FlxPoint;
import org.flixel.FlxSprite;

/**
 * @author Lars Doucet
 */

class FlxRadioGroup extends FlxGroupX
{

	public var clickable(getClickable, setClickable):Bool;
	public var selectedCode(getSelectedCode, setSelectedCode):String;	
	public var selectedLabel(getSelectedLabel, setSelectedLabel):String;
	public var selectedIndex(getSelectedIndex, setSelectedIndex):Int;
	
	public function new(X:Float, Y:Float, codes_:Array<String>,labels_:Array<String>, callback_:Dynamic, y_space_:Float=25):Void {
		super();
		_y_space = y_space_;
		_callback = callback_;
		x = X;
		y = Y;
		_list_radios = new Array<FlxCheckBox>();
		updateRadios(codes_,labels_);
	}
	
	public function loadGraphics(radio:FlxSprite, dot:FlxSprite, radioHilight:FlxSprite = null):Void {
		for(c in _list_radios) {
			c.loadGraphic(radio, radioHilight);
			c.loadCheckGraphic(dot);
		}
		_refreshRadios();
	}
	
	public override function destroy():Void {
		if (_list_radios != null) {
			U.clearArray(_list_radios);			
		}
		_codes = null;
		_labels = null;
		_callback = null;
		super.destroy();
	}
	
	public function updateLabel(i:Int, label_:String):Bool{
		if (i >= _list_radios.length) return false;
		_labels[i] = label_;
		var c:FlxCheckBox = _list_radios[i];
		if (c != null) {
			c.text = label_;
		}		
		return true;
	}
	
	public function updateCode(i:Int, code_:String):Bool{
		if (i >= _list_radios.length) return false;
		_codes[i] = code_;
		return true;
	}
	
	public function show(b:Bool):Void {
		for(fo in members) {
			fo.visible = b;
		}
	}
	
	public function updateRadios(codes_:Array<String>, labels_:Array<String>):Void {
		_codes = codes_;
		_labels = labels_;
		for(c in _list_radios) {
			c.visible = false;
		}
		_refreshRadios();
	}
	
	/***GETTER / SETTER***/
	
	public function getClickable():Bool { return _clickable; }
	public function setClickable(b:Bool):Bool { 
		_clickable = b;
		for(c in _list_radios) {
			c.active = b;
		}
		return _clickable;
	}
	
	public function getSelectedIndex():Int { return _selected; }
	public function setSelectedIndex(i:Int):Int {
		_selected = i;
		var j:Int = 0;
		for(c in _list_radios) {
			c.checked = false;
			if (j == i) {
				c.checked = true;
			}
			j++;
		}
		return _selected;
	}
	
	public function getSelectedLabel():String { return _labels[_selected]; }
	public function setSelectedLabel(str:String):String {
		var i:Int = 0;
		for(c in _list_radios) {
			c.checked = false;
			if (_labels[i] == str) {
				_selected = i;
				c.checked = true;
				break;
			}
			i++;
		}
		return _labels[_selected];
	}
	
	public function getSelectedCode():String { return _codes[_selected]; }
	public function setSelectedCode(str:String):String {
		var i:Int = 0;
		for(c in _list_radios) {
			c.checked = false;
			if (_codes[i] == str) {
				_selected = i;
				c.checked = true;
				break;
			}
			i++;
		}
		return _codes[_selected];
	}
	
	/**
	 * If you want to show only a portion of the radio group, scrolled line-by-line
	 * This will scroll the "pane" by that amount and return how many lines are above/below
	 * the currently visible pane
	 * @param	scroll How many lines DOWN you have scrolled
	 * @param	max_items Max amount of lines visible
	 * @return a FlxPoint of off-pane radio lines : (count_above,count_below)
	 */
	
	public function setLineScroll(scroll:Int, max_items:Int):FlxPoint{
		var i:Int = 1;
		var yy:Float = y;
		var more_above:Int = 0;
		var more_below:Int = 0;
		for(c in _list_radios) {
			if (i <= scroll) {
				c.visible = false;
				more_above++;
			}else if (i > scroll + max_items) {
				c.visible = false;
				more_below++;
			}else {
				c.x = Std.int(x);
				c.y = Std.int(yy);
				yy += _y_space;
				c.visible = true;
			}
			i++;
		}
		return new FlxPoint(more_above, more_below);
	}
	
	/***GETTER / SETTER***/
	
	
	
	/***PRIVATE***/
	
	private var _labels:Array<String>;
	private var _codes:Array<String>;
	private var _callback:Dynamic;
	
	private var _y_space:Float = 25;
	private var _selected:Int = 0;
	
	private var _clickable:Bool = true;
	private var _list_radios:Array<FlxCheckBox>;
	
	/**
	 * Create the radio elements if necessary, and/or just refresh them
	 */
	
	private function _refreshRadios():Void {
		var xx:Float = 0;
		var yy:Float = 0;
		var i:Int = 0;
		for(code in _codes) {
			var label:String = "";
			if (_labels != null && _labels.length > i) {
				label = _labels[i];
			}else {
				label = "<" + code + ">";	//"soft" error, indicates undefined label
			}
			var c:FlxCheckBox;
			if (_list_radios.length > i) {
				c = _list_radios[i];
				c.visible = true;
				c.text = label;
				if (i == 0) {
					xx = c.x;
					yy = c.y;
				}
			}else {
				c = new FlxCheckBox(Std.int(xx), Std.int(yy), _onClick, [code], label);
				add(c);
				_list_radios.push(c);
			}
			yy += _y_space;
			i++;
		}
	}
		
	private function _onClick(params_:Array<Dynamic>, doCallback:Bool = true):Bool{
		if (!_clickable) { return false; }
		
		var i:Int = 0;
		for(c in _list_radios) {
			var code:String = params_[0];
			c.checked = false;
			if (code == _codes[i]) {
				_selected = i;
				c.checked = true;
			}
			i++;
		}
		
		if (doCallback) {
			if (_callback != null) {
				_callback(params_);
			}
		}
		return true;
	}
}