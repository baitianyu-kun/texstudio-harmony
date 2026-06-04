import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import EmbeddedUIExtensionAbility from '@ohos.app.ability.EmbeddedUIExtensionAbility';
import QAbilityStage from '../qabilitystage/QAbilityStage';
import QtUtils from './QtUtils';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import Want from '@ohos.app.ability.Want';
import hilog from '@ohos.hilog';
import qpa from 'libqohos.so';
import {LOG_DOMAIN, LOG_TAG} from '../common/QtAppConstants';

export default abstract class QBaseEmbeddedUiExtensionAbility extends EmbeddedUIExtensionAbility {

  private localStorage: LocalStorage | null = null;
  private launchWant: Want | null = null;

  onCreate(launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(LOG_DOMAIN, LOG_TAG, '%{public}s::onCreate()', this.getClassName());
    QAbilityStage.initQtAppContextInUiExtensionMode(this.context.getApplicationContext(), this.getClassName(), this.context.resourceDir);
    qpa.handleQEmbeddedUiExtensionAbilityOnCreate(this, launchParam);
  }

  onDestroy(): void | Promise<void> {
    hilog.info(LOG_DOMAIN, LOG_TAG, '%{public}s::onDestroy()', this.getClassName());
    return qpa.handleQEmbeddedUiExtensionAbilityOnDestroy(this);
  }

  onSessionCreate(want: Want, session: UIExtensionContentSession): void {
    hilog.info(LOG_DOMAIN, LOG_TAG, '%{public}s::onSessionCreate()', this.getClassName());
    qpa.handleQEmbeddedUiExtensionAbilityOnSessionCreate(this, want, session);
  }

  onSessionDestroy(session: UIExtensionContentSession): void {
    hilog.info(LOG_DOMAIN, LOG_TAG, '%{public}s::onSessionDestroy()', this.getClassName());
    qpa.handleQEmbeddedUiExtensionAbilityOnSessionDestroy(this, session);
  }

  protected abstract getClassName(): string;
}
