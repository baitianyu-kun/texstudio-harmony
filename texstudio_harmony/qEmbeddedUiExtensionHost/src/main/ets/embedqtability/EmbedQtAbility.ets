/*
 * Copyright (C) 2025 The Qt Company Ltd.
 * Contact: https://www.qt.io/licensing/
 *
 * This file is an internal part of the Qt for OHOS implementation.
 * It may change from version to version without notice, or even be removed.
 * Do not modify this file unless you know exactly what you are doing.
 */
import { UIAbility, Want, bundleManager } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';

export default class EmbedQtAbility extends UIAbility
{
  public static EMBEDDED_QT_START_WANT_PROP_NAME: string = 'embeddedQtStartWant';

  onWindowStageCreate(windowStage: window.WindowStage): void {
    const qtParameterPrefix: string = 'io.qt.';

    let qtParameters: Record<string, Object> = {};
    if (this.launchWant.parameters) {
      Object.keys(this.launchWant.parameters)
        .filter(key => key.startsWith(qtParameterPrefix))
        .forEach(qtKey => qtParameters[qtKey] = this.launchWant.parameters![qtKey]);
    }

    let localStorageProperties: Record<string, Want> = {};
    localStorageProperties[EmbedQtAbility.EMBEDDED_QT_START_WANT_PROP_NAME] = {
      bundleName: bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT).name,
      abilityName: 'QEmbeddedUiExtensionAbility',
      parameters: qtParameters,
    };
    windowStage.loadContent('pages/Index', new LocalStorage(localStorageProperties))
  }
}
