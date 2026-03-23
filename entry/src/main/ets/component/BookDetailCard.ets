@Component
export struct BookDetailCard {
  @Prop image: string
  @Prop title: string
  @Prop description: string
  @Prop authors: string[] = []
  @Prop publisher: string = ''
  @Prop publishedDate: string = ''
  @Prop pageCount: number = 0
  @Prop language: string = ''
  scroller: Scroller = new Scroller()

  build() {
    Column() {
      Image(this.image)
        .height(100)
        .width(120)
        .borderRadius(10)
        .objectFit(ImageFit.Contain)
        .padding({ bottom: 5 })

      Text(this.title)
        .fontSize(11)
        .fontColor(Color.Black)
        .fontWeight(FontWeight.Bold)
        .padding({ bottom: 2 })

      if (this.authors && this.authors.length > 0) {
        Text(this.authors.join(', '))
          .fontSize(9)
          .fontColor(Color.Gray)
          .padding({ bottom: 2 })
      }

      if (this.publisher || this.publishedDate) {
        Text([this.publisher, this.publishedDate].filter(s => s).join(' · '))
          .fontSize(9)
          .fontColor(Color.Gray)
          .padding({ bottom: 2 })
      }

      if (this.pageCount > 0 || this.language) {
        Text([this.pageCount > 0 ? this.pageCount + ' pages' : '', this.language ? this.language.toUpperCase() : ''].filter(s => s).join(' · '))
          .fontSize(9)
          .fontColor(Color.Gray)
          .padding({ bottom: 4 })
      }

      Scroll(this.scroller) {
        Text(this.description)
          .fontSize(9)
          .fontColor(Color.Black)
          .textAlign(TextAlign.Center)
      }
      .height('40%')
      .width('75%')
      .align(Alignment.Center)
      .scrollBar(BarState.Auto)
      .padding({ bottom: 15 })
    }
    .alignItems(HorizontalAlign.Center)
    .backgroundColor('#ffd4c890')
    .padding({ top: 20, bottom: 15 })
    .width('100%')
    .height('100%')
  }
}
