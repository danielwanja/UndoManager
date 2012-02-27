package managed
{
	public interface IUndo
	{

		function undo():void;
		function redo():void;
		function get canUndo():Boolean;
		function get canRedo():Boolean;
		
	}
}