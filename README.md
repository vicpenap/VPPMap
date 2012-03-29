# VPPMap (v0.2.0)

VPPMap library for iOS simplifies the creation and management of a MKMapView. Features:
 
 - Automatic annotations management with their views and callouts. 
 - Map region centering based on the current visible annotations. 
 - Automatic annotation clustering.
 - Easy management of pins dropped by user.

### Extending MKMapViewDelegate implementation

 VPPMap provides an implementation to the most used methods found in 
`MKMapViewDelegate` protocol. However, you may need to implement some methods
 not implemented by VPPMap. In this case, you have two alternatives:
 
 - Create a category on VPPMapHelper and implement there all the `MKMapViewDelegate`
 methods you need. Be careful to not implement those already implemented 
 by VPPMapHelper.
 - Subclass VPPMapHelper. This will be a harder alternative, but more customizable.

This project contains a sample application using it. Just open the project in 
XCode, build it and run it.

For full documentation check out 
http://vicpenap.github.com/VPPMap

![](https://github.com/vicpenap/VPPMap/raw/master/screenshot.png)

## Changelog

- 2012/03/14 (v0.2.0): Fixed some bugs, added inheritance in 
VPPMapHelperDelegate to MKMapViewDelegate and updated Documentation.
- 2012/01/31 (v0.1.0): Added method centerOnCoordinate:.

## License 

Copyright (c) 2012 Víctor Pena Placer ([@vicpenap](http://www.twitter.com/vicpenap))
http://www.victorpena.es/


Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

