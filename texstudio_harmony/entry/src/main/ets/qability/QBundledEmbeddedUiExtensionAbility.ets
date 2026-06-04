import QBaseEmbeddedUiExtensionAbility from './QBaseEmbeddedUiExtensionAbility';

export default class QBundledEmbeddedUiExtensionAbility extends QBaseEmbeddedUiExtensionAbility {

  protected getClassName(): string {
    return QBundledEmbeddedUiExtensionAbility.name;
  }
}
