# iOS 3D Touch: How to add quick actions

Recently <i>Apple</i> has provided new technology <i>3D Touch</i> for <i>iPhone 6S</i> and <i>6S Plus</i>. Which contains 3 new features for your applications.

![alt tag](https://raw.github.com/maximbilan/3D-Touch-Quick-Actions-Demo/master/img/1.png)

<h3>Quick Actions</h3>

Quick Actions let users do the things they do most often, faster and in fewer steps. Many of these actions can even be done with a single press, right from the Home screen.

![alt tag](https://raw.github.com/maximbilan/3D-Touch-Quick-Actions-Demo/master/img/2.png)

<h3>Peek and Pop</h3>

Let your users preview all kinds of content and even act on it — without having to actually open it. Users can then press a little deeper to Pop into content in your app.

![alt tag](https://raw.github.com/maximbilan/3D-Touch-Quick-Actions-Demo/master/img/3.png)

<h3>Pressure Sensitivity</h3>

Creative apps can take advantage of the pressure-sensing display of iPhone 6 sand iPhone 6s Plus in many ways. For example, they can vary line thickness or give a brush a changing style.

![alt tag](https://raw.github.com/maximbilan/3D-Touch-Quick-Actions-Demo/master/img/4.png)

More information you can of course found on <i>Apple <a href="https://developer.apple.com/ios/3d-touch/">website</a></i>. Guides, tutorials, examples, etc.

I would like to tell about <i>Quick Actions</i>, how to implement in application. Actions can be static or dynamic. Let’s start.

First of all, we need to add <b>UIApplicationShortcutItems</b> to <b>Info.plist</b>. Each child item should be a dictionary and must have at least these required keys:

<b>UIApplicationShortcutItemType</b>: a string which is sent to your application as a part of <i><a href="https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIApplicationShortcutItem_class/">UIApplicationShortcutItem</a></i>. It can be used in code to handle actions for different shortcut types.

<b>UIApplicationShortcutItemTitle</b>: a title of your action. Can be localized.

And there are optional keys:

<b>UIApplicationShortcutItemSubtitle</b>: a subtitle of your action. Also can be localized.

<b>UIApplicationShortcutItemIconType</b>: an optional string which defines built-in icon type:

<pre>
enum UIApplicationShortcutIconType : Int {
  case Compose
  case Play
  case Pause
  case Add
  case Location
  case Search
  case Share
  case Prohibit
  case Contact
  case Home
  case MarkLocation
  case Favorite
  case Love
  case Cloud
  case Invitation
  case Confirmation
  case Mail
  case Message
  case Date
  case Time
  case CapturePhoto
  case CaptureVideo
  case Task
  case TaskCompleted
  case Alarm
  case Bookmark
  case Shuffle
  case Audio
  case Update
}
</pre>

<b>UIApplicationShortcutItemIconFile</b>: an optional string specifying an image from <i>Assets Catalog</i> or from the <i>Bundle</i>.

<b>UIApplicationShortcutItemUserInfo</b>: an optional dictionary of additional user information.
Let’s try. Please add the next data to <i>Info.plist</i>:

<pre>
&#60;key&#62;UIApplicationShortcutItems&#60;/key&#62;
&#60;array&#62;
  &#60;dict&#62;
    &#60;key&#62;UIApplicationShortcutItemIconType&#60;/key&#62;
    &#60;string&#62;UIApplicationShortcutIconTypeShare&#60;/string&#62;
    &#60;key&#62;UIApplicationShortcutItemTitle&#60;/key&#62;
    &#60;string&#62;SHORTCUT_TITLE_SHARE&#60;/string&#62;
    &#60;key&#62;UIApplicationShortcutItemType&#60;/key&#62;
    &#60;string&#62;$(PRODUCT_BUNDLE_IDENTIFIER).Share&#60;/string&#62;
  &#60;/dict&#62;
  &#60;dict&#62;
    &#60;key&#62;UIApplicationShortcutItemIconType&#60;/key&#62;
    &#60;string&#62;UIApplicationShortcutIconTypeAdd&#60;/string&#62;
    &#60;key&#62;UIApplicationShortcutItemTitle&#60;/key&#62;
    &#60;string&#62;SHORTCUT_TITLE_ADD&#60;/string&#62;
    &#60;key&#62;UIApplicationShortcutItemType&#60;/key&#62;
    &#60;string&#62;$(PRODUCT_BUNDLE_IDENTIFIER).Add&#60;/string&#62;
  &#60;/dict&#62;
&#60;/array&#62;
</pre>

Also create <i>InfoPlist.strings</i>:

<pre>
"SHORTCUT_TITLE_SEARCH" = "Search";
"SHORTCUT_TITLE_FAVORITES" = "Favorites";
</pre>

And what we got:

![alt tag](https://raw.github.com/maximbilan/3D-Touch-Quick-Actions-Demo/master/img/5.png)

Let’s implement handling of shortcuts. We need to create the next enumeration:

<pre>
enum ShortcutIdentifier: String {
  case Share
  case Add
 
  init?(fullType: String) {
    guard let last = fullType.componentsSeparatedByString(".").last else { return nil }
    self.init(rawValue: last)
  }
  
  var type: String {
    return NSBundle.mainBundle().bundleIdentifier! + ".\(self.rawValue)"
  }
}
</pre>

And method for handling <i><a href="https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIApplicationShortcutItem_class/">UIApplicationShortcutItem</a></i>. For example:

<pre>
func handleShortCutItem(shortcutItem: UIApplicationShortcutItem) -> Bool {
  var handled = false
  
  // Verify that the provided `shortcutItem`'s `type` is one handled by the application.
  guard ShortcutIdentifier(fullType: shortcutItem.type) != nil else { return false }
  guard let shortCutType = shortcutItem.type as String? else { return false }
switch (shortCutType) {
    case ShortcutIdentifier.Share.type:
      // Handle shortcut 1 (static).
      handled = true
    break
    case ShortcutIdentifier.Add.type:
      // Handle shortcut 2 (static).
      handled = true
    break
    default:
    break
  }
// Construct an alert using the details of the shortcut used to open the application.
  let alertController = UIAlertController(title: "Shortcut Handled", message: "\"\(shortcutItem.localizedTitle)\"", preferredStyle: .Alert)
  let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
  alertController.addAction(okAction)
  // Display an alert indicating the shortcut selected from the home screen.
  window!.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
 
  return handled
}
</pre>

And finally we need call this method in the next <i>AppDelegate</i> situations:

<pre>
func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: Bool -> Void) {
  let handledShortCutItem = handleShortCutItem(shortcutItem)
  completionHandler(handledShortCutItem)
}
</pre>

And in <i>applicationDidBecomeActive</i>:

<pre>
func applicationDidBecomeActive(application: UIApplication) {
  guard let shortcut = launchedShortcutItem else { return }
  handleShortCutItem(shortcut)
  launchedShortcutItem = nil
}
</pre>

That’s all. How to work with dynamic items, you can see in official <i>Apple</i> example, there is not present any difficulties.

<b>NOTE:</b> If you don’t have real iPhone 6 or iPhone 6 Plus, you can test on simulator with helping <a href="https://github.com/DeskConnect/SBShortcutMenuSimulator">this</a>.
