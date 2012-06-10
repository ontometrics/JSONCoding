What is JSONCoding?
===================

This is a static library which can be used for iOS applications to convert objects to JSON and convert JSON to objects. This is not only for Foundation objects but any custom object that implements the NSCoding protocol.

* It will convert complex objects to a dictionary of Foundation objects, then use [NSJSONSerialization](http://developer.apple.com/library/ios/#documentation/Foundation/Reference/NSJSONSerialization_Class/Reference/Reference.html) to convert the created dictionary to JSON.

* Same for decoding, it will use the [NSJSONSerialization](http://developer.apple.com/library/ios/#documentation/Foundation/Reference/NSJSONSerialization_Class/Reference/Reference.html) to get the dictionary representing the object, then it will build the complex object from it.
 
How do I add JSONCocing to my project?
======================================

* This is a static library, clone it then use steps [here](http://blog.slidetorock.com/using-a-static-library-in-xcode-4) to add to your project. 
