interface SubWindowNativeNodeCreateInfo {
  xComponentId: string
  onAppear: () => void
  onDisAppear: () => void
}

let subWindowNativeNodeLocalStorage = LocalStorage.getShared();

@Entry(subWindowNativeNodeLocalStorage)
@Component
struct SubWindowNativeNode {
  @LocalStorageLink('createInfo') private createInfo: SubWindowNativeNodeCreateInfo | undefined = undefined

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
