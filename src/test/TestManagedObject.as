 package test
{
	import managed.ManagedObject;
	
	import org.flexunit.asserts.*;

	public class TestManagedObject
	{		

		[Test]
		public function testSetProperty():void {
			var o:ManagedObject = new ManagedObject();
			o.name = "Nina";
			o.age = 3.5;
			assertEquals("Nina", o.name);
			assertEquals(3.5, o.age);
			
			o = new ManagedObject({name:"Joshua", age:6.5});
			assertEquals("Joshua", o.name);
			assertEquals(6.5, o.age);
		}

		[Test]
		public function testSetPropertyTracksChanges():void {
			var o:ManagedObject = new ManagedObject({name:"Joshua", age:6});
			assertFalse(o.canRedo);
			assertFalse(o.canUndo);			
			o.age = 6.5;
			assertFalse(o.canRedo);
			assertTrue(o.canUndo);			
			assertEquals(6.5, o.age);
			o.undo();
			assertEquals(6, o.age);
			assertTrue(o.canRedo);
			assertFalse(o.canUndo);			
			o.redo();			
			assertEquals(6.5, o.age);
			o.undo();
			o.age = 7;
			assertFalse(o.canRedo);
			assertTrue(o.canUndo);						
		}
		
		[Test]
		public function testSetPropertyTracksDeletes():void {
			var o:ManagedObject = new ManagedObject({name:"Noah", age:8});
			delete o.age;
			assertNull(o.age);
			assertFalse(o.canRedo);
			assertTrue(o.canUndo);
			o.undo();
			assertEquals(8, o.age);
		}
		
	
	}
}