import { statusBackgroundColor, statusTextColor } from '../utils/ReadingStatusStyle'

@Component
export struct BookCardComponent {
  @Prop title: string
  @Prop pageCount: number | null = null
  @Prop image: string
  @Prop categories: Array<string> | null = null
  @Prop authors: Array<string> | null = null
  @Prop readingStatus: string | null = null

  build() {
    Row() {
      Image(this.image)
        .width(44)
        .height(56)
        .borderRadius(6)
        .objectFit(ImageFit.Cover)

      Column() {
        Text(this.title)
          .fontSize(12)
          .fontColor('#FFFFFF')
          .fontWeight(FontWeight.Medium)
          .maxLines(2)
          .textOverflow({ overflow: TextOverflow.Ellipsis })

        Text(this.authors && this.authors.length > 0 ? this.authors[0] : 'Unknown Author')
          .fontSize(10)
          .fontColor('#888888')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .margin({ top: 3 })

        if (this.readingStatus && this.readingStatus !== 'None') {
          Text(this.readingStatus)
            .fontSize(9)
            .fontColor(statusTextColor(this.readingStatus))
            .backgroundColor(statusBackgroundColor(this.readingStatus))
            .borderRadius(4)
            .padding({ left: 5, right: 5, top: 1, bottom: 1 })
            .margin({ top: 4 })
        }
      }
      .alignItems(HorizontalAlign.Start)
      .layoutWeight(1)
      .padding({ left: 10 })
    }
    .padding({ left: 12, right: 12, top: 8, bottom: 8 })
    .width('100%')
    .backgroundColor('#1A1A1A')
    .borderRadius(12)
  }
}
