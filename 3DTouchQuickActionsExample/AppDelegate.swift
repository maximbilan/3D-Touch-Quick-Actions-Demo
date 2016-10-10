//
//  AppDelegate.swift
//  3DTouchQuickActionsExample
//
//  Created by Maxim Bilan on 4/7/16.
//  Copyright © 2016 Maxim Bilan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	enum ShortcutIdentifier: String {
		case Share
		case Add
		
		init?(fullType: String) {
			guard let last = fullType.componentsSeparatedByString(".").last else { return nil }
			
			self.init(rawValue: last)
		}
		
		var type: String {
			return Bundle.main.bundleIdentifier! + ".\(self.rawValue)"
		}
	}
	
	var window: UIWindow?

	/// Saved shortcut item used as a result of an app launch, used later when app is activated.
	var launchedShortcutItem: UIApplicationShortcutItem?
	
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
		let alertController = UIAlertController(title: "Shortcut Handled", message: "\"\(shortcutItem.localizedTitle)\"", preferredStyle: .alert)
		let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
		alertController.addAction(okAction)
		
		// Display an alert indicating the shortcut selected from the home screen.
		window!.rootViewController?.present(alertController, animated: true, completion: nil)
		
		return handled
	}
	
	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
		
		// Override point for customization after application launch.
		var shouldPerformAdditionalDelegateHandling = true
		
		// If a shortcut was launched, display its information and take the appropriate action
		if let shortcutItem = launchOptions?[UIApplicationLaunchOptionsShortcutItemKey] as? UIApplicationShortcutItem {
			
			launchedShortcutItem = shortcutItem
			
			// This will block "performActionForShortcutItem:completionHandler" from being called.
			shouldPerformAdditionalDelegateHandling = false
		}
		
		return shouldPerformAdditionalDelegateHandling
	}

	func applicationWillResignActive(application: UIApplication) {
		// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
		// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	}

	func applicationDidEnterBackground(application: UIApplication) {
		// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
		// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
	}

	func applicationWillEnterForeground(application: UIApplication) {
		// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(application: UIApplication) {
		guard let shortcut = launchedShortcutItem else { return }
		handleShortCutItem(shortcutItem: shortcut)
		launchedShortcutItem = nil
	}

	func applicationWillTerminate(application: UIApplication) {
		// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	}

	func application(application: UIApplication, performActionForShortcutItem shortcutItem: UIApplicationShortcutItem, completionHandler: (Bool) -> Void) {
		let handledShortCutItem = handleShortCutItem(shortcutItem: shortcutItem)
		completionHandler(handledShortCutItem)
	}

}

