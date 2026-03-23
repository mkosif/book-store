import { ImageCacheService } from '../model/ImageCacheService'
import { ThemeService } from '../model/ThemeService'

@Component
export struct BookCardComponent {
  @Prop title: string
  @Prop pageCount: number | null = null
  @Prop image: string
  @Prop categories: Array<string> | null = null
  @Prop authors: Array<string> | null = null
  @Prop readingStatus: string | null = null

  build() {
    Column() {
      Image(ImageCacheService.getInstance().getImage(this.image))
        .width(60)
        .height(70)
        .padding({ bottom: 3 })

      Text(this.categories && this.categories.length > 0 ? this.categories.join(', ') : 'No categories')
        .fontSize(9)
        .fontColor(ThemeService.getInstance().getTextColor())
        .padding({ bottom: 3 })

      Text(this.title)
        .fontSize(11)
        .fontColor(ThemeService.getInstance().getTextColor())
        .padding({ bottom: 3 })

      Text(this.authors && this.authors.length > 0 ? this.authors.join(', ') : 'Unknown Author')
        .fontSize(9)
        .fontColor(ThemeService.getInstance().getTextColor())
        .padding({ bottom: 3 })

      Text(this.pageCount !== null ? this.pageCount.toString() + ' pages' : 'Page count unknown')
        .fontSize(9)
        .fontColor(ThemeService.getInstance().getTextColor())
        .padding({ bottom: 3 })

      if (this.readingStatus && this.readingStatus !== 'None') {
        Text(this.readingStatus)
          .fontSize(10)
          .fontColor(Color.White)
          .backgroundColor(Color.Orange)
          .borderRadius(5)
          .padding({ left: 5, right: 5 })
      }
    }
    .padding(10)
    .width('100%')
    .borderRadius(20)
    .backgroundColor(ThemeService.getInstance().getCardBackgroundColor())
  }
}
