package managed
{
	import mx.collections.ArrayCollection;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	
	/**
	 * The managed collection keeps track of objects added, changed and removed.
	 */ 
	public class ManagedCollection extends ArrayCollection implements IUndo
	{
		protected var undoList:Array;
		protected var redoList:Array;
		protected var inRedoUndo:Boolean=false;
		
		public function ManagedCollection(source:Array=null)
		{
			super(source);
			addEventListener(CollectionEvent.COLLECTION_CHANGE, updateHandler);
			undoList = [];
			redoList = [];			
		}
		
		/**
		 * items 	- ADD/REMOVE array of items
		 * 			- REPLACE/UPDATE array of PropertyChangeEvent (oldValue, newValue)
		 * 			- RESET/REFRESH there are 0 items
		 * location - ADD, MOVE, REMOVE, REPLACE
		 * oldLocation - MOVE
		 * 
		 */
		protected function updateHandler(event:CollectionEvent):void
		{
			if (inRedoUndo) return;
			if (EXCLUSION_LIST.indexOf(event.kind)>-1) return;
			// FIXME: keeping event.items is probably not a good idea.				
			undoList.push({kind:event.kind, items:event.items, location:event.location, oldLocation:event.oldLocation});
			redoList = [];		
			UndoManager.instance.add(this);			
			
		}
		private const EXCLUSION_LIST:Array = [
			CollectionEventKind.MOVE ,  // Never triggers
			CollectionEventKind.UPDATE,	// We use ManagedObjects so no need to track update
			CollectionEventKind.REFRESH , // FIXME: sorting can break this thing
			CollectionEventKind.RESET   // when is this trigger. FIXME: shoule clear undo stack?
		];
		
		public function undo():void
		{
			try {
				inRedoUndo = true;
				var change:Object = undoList.pop();
				redoList.push(change);
				switch(change.kind)
				{
					case CollectionEventKind.ADD       : this.removeItemAt(change.location); break;					
					case CollectionEventKind.REMOVE    : this.addItemAt(change.items[0], change.location); break;
					case CollectionEventKind.REPLACE   : this.setItemAt(change.items[0].oldValue,change.items[0].property); break;
					default: break;
				}				
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
				switch(change.kind)
				{
					case CollectionEventKind.ADD       : this.addItemAt(change.items[0], change.location); break;					
					case CollectionEventKind.REMOVE    : this.removeItemAt(change.location); break;
					case CollectionEventKind.REPLACE   : this.setItemAt(change.items[0].newValue,change.items[0].property); break;
					default: break;
				}				
				
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