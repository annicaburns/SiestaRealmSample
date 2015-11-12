## Synopsis

This is a Work-InProgress. It crashes and needs a serious re-factor, but I'm posting it now anyway as a way to collaborate and get input about the best way to move forward. This is meant to be the simplest possible sample of an app that integrates two libraries that I'd like to use together in a Swift iOS app.

## Motivation

I'd like to use [Siesta](https://github.com/bustoutsolutions/siesta) (an interesting new "resource-oriented" REST networking library for iOS) to manage the communication with my backend Web Service. And I'd like to use [Realm](https://realm.io/) (a cross-platform mobile-optimized database) to persist data between app launches and to support an offline mode. I am having some trouble getting them to play together nicely because Siesta uses multi-threading (for obvious reasons) but Realm has the understandable limitation that one can't pass Realm objects between threads.

## Installation

Clone or download the repo and run the CocoaPods "$pod install" command in the usual way. 

The app will run without crashing out of the box because Siesta's persistance mechanism is turned off. To see where I'm stuck, open GitHubAPI.swift and uncomment this line:

>$0.config.persistentCache = SiestaRealmCache()

## License

Not relevant!
