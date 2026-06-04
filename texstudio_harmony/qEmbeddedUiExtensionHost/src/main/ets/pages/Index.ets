/*
 * Copyright (C) 2025 The Qt Company Ltd.
 * Contact: https://www.qt.io/licensing/
 *
 * This file is an internal part of the Qt for OHOS implementation.
 * It may change from version to version without notice, or even be removed.
 * Do not modify this file unless you know exactly what you are doing.
 */
import { Want } from '@kit.AbilityKit';
import EmbedQtAbility from '../embedqtability/EmbedQtAbility';
import { EmbeddedComponentImpl } from '../components/EmbeddedComponentImpl';

@Entry
@Component
struct Index {
  private want: Want = LocalStorage.getShared().get<Want>(EmbedQtAbility.EMBEDDED_QT_START_WANT_PROP_NAME) as Want;

  build() {
    Row() {
      Column() {
        EmbeddedComponentImpl({want: this.want})
          .width('100%')
          .height('100%')
      }
      .width('100%')
    }
    .height('100%')
  }
}
