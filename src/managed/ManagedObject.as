package managed
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.events.PropertyChangeEvent;
	import mx.utils.ObjectProxy;
	import mx.utils.StringUtil;
	
	/**
	 * This class keeps track of all attributes that change including collections.
	 * TODO: is an exclusion list maybe required or an includsion list.
	 */
	public dynamic class ManagedObject extends ObjectProxy implements IUndo
	{
		protected var undoList:Array;
		protected var redoList:Array;
		protected var inRedoUndo:Boolean=false;
		
		public function ManagedObject(item:Object=null, uid:String=null, proxyDepth:int=-1)
		{
			super(item, uid, proxyDepth);
			addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, updateHandler)
			undoList = [];
			redoList = [];
		}
		
		protected function updateHandler(event:PropertyChangeEvent):void
		{
			if (inRedoUndo) return;
			undoList.push({kind:event.kind, property:event.property, oldValue:event.oldValue, newValue:event.newValue});
			redoList = [];
			UndoManager.instance.add(this);
		}
		
		public function undo():void
		{
			try {
				inRedoUndo = true;
				var change:Object = undoList.pop();
				redoList.push(change);
				this[change.property] = change.oldValue;
			} finally {
				inRedoUndo = false;
			}			
		}
		
		public function redo():void
		{
			try {
				inRedoUndo = true;
				var change:Object = redoList.pop();
				undoList.push(change);
				this[change.property] = change.newValue;
			} finally {
				inRedoUndo = false;
			}			
		}
		
		public function get canUndo():Boolean
		{
			return undoList.length>0;
		}
		
		public function get canRedo():Boolean
		{
			return redoList.length>0;
		}
	}
}