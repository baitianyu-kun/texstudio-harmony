/*
 * This is a demo component.
 *
 * You may edit this file to your liking. You may add styling or additional components, change the
 * layout.
 *
 * You should not remove the want parameter or the EmbeddedComponent from the layout. Otherwise
 * embedded Qt application will not show up.
 */

import { Want } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

@Component
export struct EmbeddedComponentImpl {
  // This is a want provided by the template part. It must be provided to an EmbeddedComponent.
  // Don't remove it.
  want?: Want;

  build() {
    Row() {
      Column() {
        Text("Hello from EmbeddedComponentImpl")

        // This is the embedded component used to embed Qt application. Don't remove it.
        EmbeddedComponent(this.want, EmbeddedType.EMBEDDED_UI_EXTENSION)
          .width('100%')
          .height('90%')
          .onTerminated((info: TerminationInfo) => {
            console.warn(`Terminarion: code = ${info.code}, want = ${JSON.stringify(info.want)}`);
          })
          .onError((error: BusinessError) => {
            console.error(`Error: code = ${error.code}, message = '${JSON.stringify(error.message)}'`);
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
