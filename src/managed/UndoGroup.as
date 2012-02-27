package managed
{
	public class UndoGroup implements IUndo
	{
		protected var undoList:Array;
		protected var name:String;
		
		/**
		 * This class represents a group of operation. So the user can use one undo command
		 * to undo many operations that are grouped.
		 */
		public function UndoGroup(name:String)
		{
			this.undoList = [];
			this.name = name;
		}
		
		public function add(undoable:IUndo):void {
			this.undoList.push(undoable);
		}
		
		public function undo():void {
			for each (var undoable:IUndo in undoList) 
			{
				if (undoable.canUndo) undoable.undo();
			}
		}
		
		public function length():Number {
			return this.undoList.length;
		}
			
		public function redo():void {
			for each (var undoable:IUndo in undoList) 
			{
				if (undoable.canRedo) undoable.redo();
			}
		}
		
		public function get canUndo():Boolean
		{
			return true;  // We assume that the UndoManager knows when to call undo/redo
		}
		
		public function get canRedo():Boolean
		{
			return true;  // We assume that the UndoManager knows when to call undo/redo
		}		
	}
}