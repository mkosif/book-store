@Component
export struct FilterComponent {
  @Prop categories: string[] = []
  @Prop selectedCategory: string = 'All'
  onCategorySelected: (category: string) => void = () => {}

  build() {
    Scroll() {
      Row() {
        ForEach(this.categories, (category: string) => {
          Text(category)
            .fontSize(10)
            .fontColor(this.selectedCategory === category ? '#FFFFFF' : '#666666')
            .backgroundColor(this.selectedCategory === category ? '#2A2A2A' : 'transparent')
            .borderRadius(10)
            .padding({ left: 8, right: 8, top: 3, bottom: 3 })
            .margin({ right: 4 })
            .onClick(() => {
              this.onCategorySelected(category)
            })
        }, (cat: string) => cat)
      }
      .padding({ left: 12, right: 12 })
    }
    .scrollable(ScrollDirection.Horizontal)
    .scrollBar(BarState.Off)
    .width('100%')
    .height(28)
  }
}
