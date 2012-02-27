UndoManager
===========

A simple ActionScript library to add undo/redo functionality to your projects.

Overview
========

This library provides three main class, the ManagedCollections, the ManagedObject and the UndoManager. The ManagedCollections and ManagedObject keep track of any underlying changes to themselves, i.e. adding and removing items from the collection and the changing attributes on an Object. The UndoManage keeps track of which object was changed. So in your application you can extend ManagedCollections and ManagedObject for any data structure you want be able to do undo changes.

Usage
=====

Copy the /lib/UndoManager.swc file to the libs folder of your project.

Let's look at a simple example where we add several managed objects to a managed collection

    var c:ManagedCollection = new ManagedCollection;
    var o:ManagedObject = new ManagedObject({name:"Daniel"});
    c.addItem("one");
    c.addItem("two");
    o.name = "Solomon";
    assertFalse(undoManager.canRedo);
    assertTrue(undoManager.canUndo);

Now let's change the name of the managed object:

    o.name = "Lee";

You can then undo that change via the undo manager as follows:

    UndoManager.instance.undo();


After that the name of the managed object is again "Solomon". Notice also that the length of the collection is two. If we continue undoing the length becomes one. Of course you can now redo you changes.

Grouping changes
================

If you have more complex changes that involve changing several attributes or collections operation and you woule like to handle them as one logical change you can group the changes.

For example we start with a cube that is at position 100/100 and we move it to 200/200.

    var cube:ManagedObject = new ManagedObject({name:"cube", x:100, y:100});
    undoManager.startGroup("changing cube");
    cube.x = 200;
    cube.y = 200;
    undoManager.endGroup();

If this move was done via a drag&drop it is really one operation. Not grouping it would require two undo operations which wouldn't feel natural to the user. Here however, by just doing one undo the cube is back at 100/100.

Limitations
===========

- Need to extend ManagedObject and ManagedCollection to support undo/redo functionality. Note you can implement the IUndo interface alternatively.
- is specific to data structure and not a general undo/redo facility. i.e not sure if would work well for a text editor. 
- ManagedObject and ManagedCollection are tied to one instance of the UndoManager. So couldn't support two simultaneous undo/redo session like editing two separate text files.
- Supports only directed acyclic graphs. In other words no recursive graphs.

Contribution
============

I hope this library would also work for you project. Please contact me (Daniel, d@n-so.com) wether you find any limitation and bug or if it worked for your project.

License
=======

MIT

Enjoy!
Daniel Wanja