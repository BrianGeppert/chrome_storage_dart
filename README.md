# chrome_storage_dart

Element access to the [chrome.storage](https://developer.chrome.com/extensions/storage) API.
Based on Polymer.dart's core-localstorage-dart, and provides
[the same API](https://www.polymer-project.org/docs/elements/core-elements.html#core-localstorage)
(except I've added the 'sync' attribute to enable Chrome Sync).

## Usage

Local storage:

    <link rel="import" href="../../packages/chrome_storage_dart/chrome_storage_dart.html">

    <chrome-storage-dart name="key" value="{{ value }}"></chrome-storage-dart>

[Synchronized storage](https://developer.chrome.com/extensions/storage#property-sync):

    <link rel="import" href="../../packages/chrome_storage_dart/chrome_storage_dart.html">

    <chrome-storage-dart name="key" value="{{ value }}" sync></chrome-storage-dart>

Raw value storage (not stored as JSON):

    <link rel="import" href="../../packages/chrome_storage_dart/chrome_storage_dart.html">

    <chrome-storage-dart name="key" value="{{ value }}" useRaw></chrome-storage-dart>

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://www.github.com/BrianGeppert/chrome_storage_dart/issues/
