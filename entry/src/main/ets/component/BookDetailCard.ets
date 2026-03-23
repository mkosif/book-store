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
        .height(80)
        .width(60)
        .borderRadius(8)
        .objectFit(ImageFit.Contain)
        .margin({ bottom: 8 })

      Text(this.title)
        .fontSize(12)
        .fontColor('#FFFFFF')
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .padding({ left: 16, right: 16 })

      if (this.authors && this.authors.length > 0) {
        Text(this.authors[0])
          .fontSize(10)
          .fontColor('#888888')
          .margin({ top: 4 })
      }

      if (this.pageCount > 0) {
        Text(this.pageCount + ' pages' + (this.language ? '  ·  ' + this.language.toUpperCase() : ''))
          .fontSize(9)
          .fontColor('#555555')
          .margin({ top: 2 })
      }

      Scroll(this.scroller) {
        Text(this.description || 'No description.')
          .fontSize(10)
          .fontColor('#AAAAAA')
          .textAlign(TextAlign.Center)
          .padding({ left: 16, right: 16 })
      }
      .height(80)
      .width('100%')
      .margin({ top: 8 })
      .scrollBar(BarState.Off)
    }
    .alignItems(HorizontalAlign.Center)
    .width('100%')
    .height('100%')
    .padding({ top: 12 })
    .backgroundColor('#000000')
  }
}
