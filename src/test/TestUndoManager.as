package test
{
	import flexunit.framework.Assert;
	
	import managed.ManagedCollection;
	import managed.ManagedObject;
	import managed.UndoManager;
	
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertFalse;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.object.hasProperties;
	
	public class TestUndoManager
	{		
		protected var undoManager:UndoManager;
		
		[Before]
		public function setUp():void
		{
			undoManager = UndoManager.instance = new UndoManager
		}
		
		[Test]
		public function testUndoManager():void
		{
			assertFalse(undoManager.canRedo);
			assertFalse(undoManager.canUndo);
		}		
		
		[Test]
		public function testUndoRedo():void
		{
			var c:ManagedCollection = new ManagedCollection;
			var o:ManagedObject = new ManagedObject({name:"Daniel"});
			assertEquals(0, undoManager.undoLength);
			assertEquals(0, undoManager.redoLength);
			c.addItem("one");
			c.addItem("two");
			o.name = "Solomon";
			o.name = "Lee";
			assertEquals(4, undoManager.undoLength);
			assertFalse(undoManager.canRedo);
			assertTrue(undoManager.canUndo);
			
			// start undoing 
			
			undoManager.undo();
			assertEquals(2, c.length); // didn't change
			assertEquals("Solomon", o.name);
			
			undoManager.undo();
			assertEquals(2, c.length); // still didn't change
			assertEquals("Daniel", o.name);			
			
			undoManager.undo();
			assertEquals(1, c.length); // now it changed
			assertEquals("Daniel", o.name); // and that one didn't			
			
			undoManager.undo();
			assertEquals(0, c.length); // and again
			assertFalse(undoManager.canUndo);   // reached the begining?			
			
			// start redoing
			undoManager.redo();
			assertEquals(1, c.length); // and restoring

			undoManager.redo();
			assertEquals(2, c.length); 
			
			undoManager.redo();
			assertEquals(2, c.length); 
			assertEquals("Solomon", o.name);
			
			undoManager.redo();
			assertEquals("Lee", o.name);			
			assertFalse(undoManager.canRedo); // reached the end?
			
		}
		
		[Test]
		public function testGroup():void
		{
			var c:ManagedCollection = new ManagedCollection;
			var o:ManagedObject = new ManagedObject({name:"cube", x:100, y:100});
			undoManager.startGroup("changing Collection");
			c.addItem("one");
			c.addItem("two");
			undoManager.endGroup();
			undoManager.startGroup("changing cube");
			o.x = 200;
			o.y = 200;
			undoManager.endGroup();
			assertEquals(2, undoManager.undoLength);
			
			// starting undoing...
			
			undoManager.undo();
			assertThat(o, hasProperties({x:100, y:100}));  // both changes occured at once.
			assertEquals(2, c.length)					   // collection not yet undone
			undoManager.undo();
			assertEquals(0, c.length)					   // collection is back to begining
			assertFalse(undoManager.canUndo);
			
			// and redoing...
			
			undoManager.redo();
			assertEquals(2, c.length)
			assertThat(o, hasProperties({x:100, y:100})); 
			
			undoManager.redo();
			assertThat(o, hasProperties({x:200, y:200})); 
			assertFalse(undoManager.canRedo); // reached the end?
		}
		
	}
}