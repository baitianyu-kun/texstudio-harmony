interface WindowNativeNodeCreateInfo {
  xComponentId: string
  onAppear: () => void
  onAttach: () => void
  onDisAppear: () => void
}

let mainWindowNativeNodeLocalStorage = LocalStorage.getShared();

@Entry(mainWindowNativeNodeLocalStorage)
@Component
struct WindowNativeNode {
  @LocalStorageLink('createInfo') private createInfo: WindowNativeNodeCreateInfo | undefined = undefined

  build() {
    Stack() {
      if (this.createInfo !== undefined) {
        XComponent({
          type: XComponentType.NODE,
          id: this.createInfo.xComponentId,
          libraryname: 'qohos'
        })
  	    .onAttach(this.createInfo.onAttach)
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
