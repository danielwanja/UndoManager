package test
{
	import managed.ManagedCollection;
	
	import mx.utils.ObjectProxy;
	
	import org.flexunit.assertThat;
	import org.flexunit.asserts.*;

	public class TestManagedCollection
	{		
		
		[Test]
		public function testCanUndoAdd():void {
			var l:ManagedCollection = new ManagedCollection(["one"]);
			assertFalse(l.canRedo);
			assertFalse(l.canUndo);	
			l.addItem("two");
			assertFalse(l.canRedo);
			assertTrue(l.canUndo);
			l.undo();
			assertEquals(1, l.length);
			assertTrue(l.canRedo);
			assertFalse(l.canUndo);
			l.redo();
			assertEquals(2, l.length);	
			assertEquals("one", l.getItemAt(0));
			assertEquals("two", l.getItemAt(1));
		}

		[Test]
		public function testCanUndoRemove():void {
			var l:ManagedCollection = new ManagedCollection();
			l.addItem("one");
			l.addItem("two");
			assertFalse(l.canRedo);
			assertTrue(l.canUndo);
			l.undo();	
			assertEquals(1, l.length);
			assertEquals("one", l.getItemAt(0));
			l.undo();	
			assertEquals(0, l.length);
			l.redo();
			assertEquals(1, l.length);
			assertEquals("one", l.getItemAt(0));
			l.redo();
			assertEquals(2, l.length);	
			assertEquals("one", l.getItemAt(0));
			assertEquals("two", l.getItemAt(1));			
		}
		
		[Test]
		public function testCanUndoMove():void {
			var l:ManagedCollection = new ManagedCollection(["one", "two"]);
			
		}
		
		[Test]
		public function testCanUndoReplace():void {
			var l:ManagedCollection = new ManagedCollection(["old1", "old2"]);
			l.setItemAt("new1", 0);
			l.setItemAt("new2", 1);
			assertEquals(2, l.length);	
			assertEquals("new1", l.getItemAt(0));
			assertEquals("new2", l.getItemAt(1));			
			assertFalse(l.canRedo);
			assertTrue(l.canUndo);
			l.undo();
			assertEquals("new1", l.getItemAt(0));
			assertEquals("old2", l.getItemAt(1));			
			l.undo();
			assertEquals("old1", l.getItemAt(0));
			assertEquals("old2", l.getItemAt(1));			
			assertTrue(l.canRedo);
			assertFalse(l.canUndo);
			l.redo();
			assertEquals("new1", l.getItemAt(0));
			assertEquals("old2", l.getItemAt(1));			
			l.redo();
			assertEquals("new1", l.getItemAt(0));
			assertEquals("new2", l.getItemAt(1));			
		}
		
		[Test]
		public function testCannotUndoUpdate():void {
			var l:ManagedCollection = new ManagedCollection([new ObjectProxy({name:"old1"}), new ObjectProxy({name:"old2"})]);
			l.getItemAt(0).name = "new1";
			assertFalse(l.canRedo);
			assertFalse(l.canUndo);  // Not managed by the collection
		}
		
		[Ignore('Need to define what undo a refresh means! Sorting?')]
		[Test]
		public function testCanUndoRefresh():void {
			// makes sense? --what happens with sort
		}

		[Ignore('Need to define what undo a reset means!')]		
		[Test]
		public function testCanUndoReset():void {
			// makes sense?
		}

	}
}