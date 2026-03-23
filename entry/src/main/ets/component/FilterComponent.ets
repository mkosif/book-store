@Component
export struct FilterComponent {
  @Prop categories: string[] = []
  @Prop selectedCategory: string = 'All'
  onCategorySelected: (category: string) => void = () => {}

  build() {
    Scroll() {
      Row() {
        ForEach(this.categories, (category: string) => {
          Button(category)
            .fontSize(10)
            .backgroundColor(this.selectedCategory === category ? Color.Blue : Color.Gray)
            .fontColor(Color.White)
            .borderRadius(15)
            .padding({ left: 8, right: 8, top: 4, bottom: 4 })
            .margin({ right: 5 })
            .onClick(() => {
              this.onCategorySelected(category)
            })
        }, (cat: string) => cat)
      }
      .padding({ left: 5, right: 5 })
    }
    .scrollable(ScrollDirection.Horizontal)
    .scrollBar(BarState.Off)
    .width('100%')
    .padding({ top: 5, bottom: 5 })
  }
}
