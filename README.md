# any_loading

[![Pub](https://img.shields.io/pub/v/any_loading.svg?style=flat-square)](https://pub.dev/packages/any_loading)
[![support](https://img.shields.io/badge/platform-android%20|%20ios%20|%20web%20|%20macos%20|%20windows%20|%20linux%20-blue.svg)](https://pub.dev/packages/any_loading)

Use without context, showToast/showSuccess/showError/showLoading/showNetLoading/showModal for Flutter.

## Features

* support toast, modelDialog, loading.
* support showNetLoading. Block the ui event to delay the display of the loading bar for a few seconds.

## Getting started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  any_loading: <latest_version>
```

## Usage

First, initialize AnyLoading in your MaterialApp or CupertinoApp:

``` dart
MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
    primarySwatch: Colors.blue,
    ),
    home: const TestPage(),
    builder: AnyLoading.init(),
)
```

Then, you can:

``` dart
AnyLoading.showToast('msg');
AnyLoading.showModal(title: 'title', content: 'content', success: (bool isSuccess) => print('isSuccess---$isSuccess'));
AnyLoading.showLoading(title: 'Loading', maskType: AnyLoadingMaskType.black, style:AnyLoadingStyle.dark());
AnyLoading.showNetLoading(title: 'Loading', position: AlignmentDirectional.center, 
                          delayShowIndicatorDuration: Duration(seconds: 5));
AnyLoading.dismiss();
// ...
```

[comment]: <> (## Additional information)