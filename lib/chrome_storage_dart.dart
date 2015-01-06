/*
 * Copyright (c) 2014 The Polymer Project Authors. All rights reserved.
 * This code may only be used under the BSD style license found at http://polymer.github.io/LICENSE.txt
 * The complete set of authors may be found at http://polymer.github.io/AUTHORS.txt
 * The complete set of contributors may be found at http://polymer.github.io/CONTRIBUTORS.txt
 * Code distributed by Google as part of the polymer project is also
 * subject to an additional IP rights grant found at http://polymer.github.io/PATENTS.txt
 */
/// Dart API for the polymer element `chrome-storage-dart`.
library gep.chrome_storage_dart;

import 'dart:html';
import 'dart:convert' show JSON;
import 'package:polymer/polymer.dart';
import 'package:chrome/chrome_app.dart' as chrome;

/// Element access to localStorage.  The "name" property
/// is the key to the data ("value" property) stored in localStorage.
///
/// `chrome-storage-dart` automatically saves the value to localStorage when
/// value is changed.  Note that if value is an object auto-save will be
/// triggered only when value is a different instance.
///
///     <chrome-storage-dart name="my-app-storage" value="{{value}}"></chrome-storage-dart>
@CustomTag('chrome-storage-dart')
class ChromeStorageDart extends PolymerElement {
  /**
   * Fired when a value is loaded from localStorage.
   * @event chrome-storage-load
   */

  /**
   * The key to the data stored in localStorage.
   *
   * @attribute name
   * @type string
   * @default null
   */
  @observable String name = '';

  /**
   * The data associated with the specified name.
   *
   * @attribute value
   * @type object
   * @default null
   */
  @observable var value;

  /**
   * If true, the value is stored and retrieved without JSON processing.
   *
   * @attribute useRaw
   * @type boolean
   * @default false
   */
  @observable bool useRaw = false;

  /**
   * If true, auto save is disabled.
   *
   * @attribute autoSaveDisabled
   * @type boolean
   * @default false
   */
  @observable bool autoSaveDisabled = false;

  /**
   * If true, the value is synced using Chrome Sync.
   *
   * @attribute sync
   * @type boolean
   * @default false
   */
  @observable bool sync = false;

  @observable bool loaded = false;

  factory ChromeStorageDart() => new Element.tag('chrome-storage-dart');
  ChromeStorageDart.created() : super.created();

  @override
  attached() {
    // wait for bindings are all setup
    this.async((_) => load());
  }

  void valueChanged() {
    if (this.loaded && !this.autoSaveDisabled) {
      this.save();
    }
  }

  void load() {
    if(this.sync) {
      chrome.storage.sync.get(name).then(this.onLoaded);
    } else {
      chrome.storage.local.get(name).then(this.onLoaded);
    }
  }

  void onLoaded(var keys) {
    var v = keys[name];

    if (useRaw) {
      this.value = v;
    } else {
      // localStorage has a flaw that makes it difficult to determine
      // if a key actually exists or not (getItem returns null if the
      // key doesn't exist, which is not distinguishable from a stored
      // null value)
      // however, if not `useRaw`, an (unparsed) null value unambiguously
      // signals that there is no value in storage (a stored null value would
      // be escaped, i.e. "null")
      // in this case we save any non-null current (default) value
      if (v == null) {
        if (this.value != null) {
          this.save();
        }
      } else {
        try {
          v = JSON.decode(v);
        } catch(x) {
        }
        this.value = v;
      }
    }

    this.loaded = true;
    this.asyncFire('chrome-storage-load');
  }

  /**
   * Saves the value to localStorage.
   *
   * @method save
   */
  void save() {
    Map map = {
      name: useRaw ? value : JSON.encode(value)
    };

    if(sync) {
      chrome.storage.sync.set(map);
    } else {
      chrome.storage.local.set(map);
    }
  }
}
