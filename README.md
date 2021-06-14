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

# Development

## Form Development

Details for the process involved in form development can be found [here](documents/guideline/FORMS.md)

---

## Logging and Debugging 

The project has a centralized logging available. See the example below for how to use. Start using it with static methods: 

The log grabs a TAG from stacktrace if it isn't provided into the static method. Its a bit costly so try avoiding extensive use without a TAG, specially for info levels. 

Various log levels and when to use them can be found [here](documents/LOG.md)

````dart

  Log.i("Test message $argument");
  
  
  // other log levels
  Log.d("DEBUG");
  Log.e("Extra error message", , ex: Exception("Test thorwable"));
  Log.v("VERBOSE");
  Log.w("WARN");


````
---
## Internationalization and Localization

The project uses this [extension](https://marketplace.visualstudio.com/items?itemName=esskar.vscode-flutter-i18n-json) to automatically generate translations for the application. 

The default localization can be found [here](i18n/en-US.json). After any changes or additions to translations, run the following command. 

```
Flutter I18n Json: Update
```

This will update the auto generated file below.


```
lib/generated/i18n.dart
```

### Usage

Use a simple key-value pair JSON format to define your translations.

```json
{
    "hello": "World"
}
```

In the above example `"hello"` is the key for the translation value `"World"`. This can inturn be used as `I18n.of(context).hello`

Placeholders are automatically detected and are enclosed in curly brackets `{variable_here}`:

```json
{
    "greetTo": "Hello {name}"
}
``` 

Here, `{name}` is a placeholder within the translation value for `"greetTo"`. This can inturn be used as `I18n.of(context).greetTo("Ritesh")`

> Nesting and arrays are also supported as can be seen in [file](i18n/en-US.json)

## Plugins and Presets

Some useful extensions for vscode. 

- [Pubspec Asssist](https://marketplace.visualstudio.com/items?itemName=jeroen-meijer.pubspec-assist)
- [Awesome Flutter Snippets](https://marketplace.visualstudio.com/items?itemName=Nash.awesome-flutter-snippets)
- [Advanced New File](https://marketplace.visualstudio.com/items?itemName=patbenatar.advanced-new-file)
- [Bracket Pair Colorizer 2](https://marketplace.visualstudio.com/items?itemName=CoenraadS.bracket-pair-colorizer-2)
- [Bloc Extension](https://marketplace.visualstudio.com/items?itemName=FelixAngelov.bloc)
- [Better Comments](https://marketplace.visualstudio.com/items?itemName=aaron-bond.better-comments)
- [Dart Import](https://marketplace.visualstudio.com/items?itemName=luanpotter.dart-import)
- [Code Spell Checker](https://marketplace.visualstudio.com/items?itemName=streetsidesoftware.code-spell-checker)
- [Git History](https://marketplace.visualstudio.com/items?itemName=donjayamanne.githistory)

Some useful snippets 

The project includes a bunch of useful snippets which can be found in the `dart.code-snippets` under `.vscode`

1. Part Statement - `pts` - Creates a filled-in part statement
1.  Part 'Freezed' statement - `ptf` - Creates a filled-in freezed part statement
1. Freezed Data Class - `fdataclass` - Create a Freezed Data Class
1. Freezed Json Factory - `fjson` - Create a json method in Freezed Data Class
1. Freezed Union  - `funion` - Create a Freezed Union
1. Freezed Union Case - `funioncase` - Create a Freezed Union Case inside a Freezed Union
1. Get instance for Type - `getit` - GetIt instance for Type
1. Mockito Test case - `mocktest` - Create a unit test 

Any additional snippets can be added by creating a appropriate PR. For more info on snippets creation you can look at [this](https://code.visualstudio.com/docs/editor/userdefinedsnippets#_create-your-own-snippets).
