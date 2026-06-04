interface FloatWindowNativeNodeCreateInfo {
  xComponentId: string
  onAppear: () => void
  onDisAppear: () => void
}

let floatWindowNativeNodeLocalStorage = LocalStorage.getShared();

@Entry(floatWindowNativeNodeLocalStorage)
@Component
struct FloatWindowNativeNode {
  @LocalStorageLink('createInfo') private createInfo: FloatWindowNativeNodeCreateInfo | undefined = undefined

  build() {
    Stack() {
      if (this.createInfo !== undefined) {
        XComponent({
          type: XComponentType.NODE,
          id: this.createInfo.xComponentId,
          libraryname: 'qohos'
        })
        .onAppear(this.createInfo.onAppear)
        .onDisAppear(this.createInfo.onDisAppear)
        .width('100%')
        .height('100%')
      }
    }
    .width('100%')
    .height('100%')
  }
}
