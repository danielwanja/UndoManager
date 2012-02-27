package managed
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import flashx.undo.UndoManager;

	/**
	 * This class listens to all managed object/collections and records all changes.
	 * This class manages and undo and redo stack.
	 * This class supports groups of managed calls. 
	 * 
	 * This class should allow to support multiple "domains" or "documents" in 
	 * order to have different undo/redo stacks for each project.  How to tie objects to an UndoManager?
	 * 
	 */
	public class UndoManager extends EventDispatcher implements IUndo
	{
		// Using instance for now so that ManagedObjects and ManagedCollections don't need to 
		// be tied to Swiz.
		public static var instance:UndoManager = new UndoManager();
		
		protected var undoList:Array;
		protected var redoList:Array;
		protected var inRedoUndo:Boolean=false;		
		
		protected var currentGroup:UndoGroup;
		
		public function UndoManager()
		{
			reset();		
		}
		
		public function get isInRedoUndo():Boolean {
			return inRedoUndo
		}
		
		public function reset():void {
			undoList = [];
			redoList = [];
			dispatchEvent(new Event('undoChanged'));
		}
		
				
		public function add(undoable:IUndo):void {
			if (currentGroup==null) {
				undoList.push(undoable);
				dispatchEvent(new Event('undoChanged'));
			} else {
				currentGroup.add(undoable);
			}
		}
		
		public function startGroup(name:String):void {
			if (currentGroup!=null) throw new Error("Cannot have nested undo groups.");
			currentGroup = new UndoGroup(name);
		}
		
		
		public function endGroup():void {
			if (currentGroup.length()>0) undoList.push(currentGroup);
			currentGroup = null;
			dispatchEvent(new Event('undoChanged'));			
		}
		
		public function undo():void
		{
			try {
				inRedoUndo = true;
				var undoable:IUndo = undoList.pop();
				redoList.push(undoable);
				undoable.undo();
			} finally {
				inRedoUndo = false;
			}			
			dispatchEvent(new Event('undoChanged'));
		}
		
		public function redo():void
		{
			try {
				inRedoUndo = true;
				var undoable:IUndo = redoList.pop();
				undoList.push(undoable);
				undoable.redo();
			} finally {
				inRedoUndo = false;
			}			
			dispatchEvent(new Event('undoChanged'));
		}
		
		[Bindable('undoChanged')]
		public function get canUndo():Boolean
		{
			return undoList.length>0;
		}
		
		[Bindable('undoChanged')]		
		public function get canRedo():Boolean
		{
			return redoList.length>0;
		}		

		[Bindable('undoChanged')]		
		public function get undoLength():Number {
			return undoList.length;
		}
		
		[Bindable('undoChanged')]		
		public function get redoLength():Number {
			return redoList.length;
		}
		
		
		
	}
}