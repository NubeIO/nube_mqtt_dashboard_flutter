# Nube Mqtt Dashboard - Flutter


## Installation and Usage

The project requires you to have [Flutter Version Management](https://github.com/leoafarias/fvm) installed. This tool allows you to manage multiple channels and releases, and caches these versions locally.

### Flutter Version Management

#### **Installation**

#### Activate Fvm:

> pub global activate fvm

#### Install Project SDK Version 

Since project is already configured to use a specific version, running `install` without any arguments will install the proper version.

> fvm install

### Running Flutter SDK commands
Flutter command within fvm proxies all calls to the CLI; just changing the SDK to be the local one.

For instance, to run the flutter run with a given Flutter SDK version just call the following. FVM will recursively try for a version in a parent directory.

> fvm flutter run

This syntax works also for commands with parameters. The following command will call flutter build for a selected flavor and target.

> fvm flutter build aab --release --flavor prod -t lib/main_prod.dart

In other words, calling a `fvm flutter xxx` command is equivalent to `flutter xxx` if fvm is available in the directory tree.


### Build Generated Files
The generated files are not included in the repo because they cause a lot of conflicts during merge and rebase. This you'll have to run them before starting anything else. 

```
fvm flutter pub run build_runner build 
```

---

### Configure Your IDE

#### VSCode

The project is configured to use a symlink for dynamic switch. You'll have to run the following command to install it though. 

```
fvm install
```

Another option is to add the following to your settings.json. This will list list all Flutter SDKs installed when using VSCode when using Flutter: Change SDK.

You can see all the versions installed by FVM in VS Code by just providing path to versions directory:

````json
{
    "dart.flutterSdkPaths": [
        ".fvm/flutter_sdk"
    ],
    "dart.flutterSdkPath": ".fvm/flutter_sdk",
}
````

---
