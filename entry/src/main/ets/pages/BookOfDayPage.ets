import BookModel from '../model/BookModel';
import { ImageCacheService } from '../model/ImageCacheService';

@Builder
export function BookOfDayPageBuilder() {
  BookOfDayPage()
}

@Entry
@Component
export struct BookOfDayPage {
  @Consume('mainStack') pathStack: NavPathStack;
  @State book: BookModel = {
    title: '',
    pageCount: 0,
    image: '',
    description: '',
    categories: [],
    authors: [],
    publishedDate: '',
    publisher: '',
    previewLink: '',
    language: ''
  }

  aboutToAppear(): void {
    this.book = this.pathStack.getParamByName('BookOfDayPage')[0] as BookModel
  }

  build() {
    NavDestination() {
      Column() {
        // Back button
        Row() {
          Text('‹')
            .fontSize(26)
            .fontColor('#FFFFFF')
            .width(40).height(40)
            .textAlign(TextAlign.Center)
            .backgroundColor('#444444')
            .borderRadius(20)
            .onClick(() => { this.pathStack.pop() })
        }
        .width('100%')
        .padding({ left: 28, top: 12, bottom: 4 })

        Column() {
          Image(ImageCacheService.getInstance().getImage(this.book.image))
            .height(90)
            .width(65)
            .borderRadius(8)
            .objectFit(ImageFit.Contain)
            .margin({ bottom: 12 })

          Text(this.book.title)
            .fontSize(13)
            .fontColor('#FFFFFF')
            .fontWeight(FontWeight.Bold)
            .textAlign(TextAlign.Center)
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .padding({ left: 24, right: 24 })

          if (this.book.authors && this.book.authors.length > 0) {
            Text(this.book.authors[0])
              .fontSize(10)
              .fontColor('#888888')
              .margin({ top: 6 })
          }

          if (this.book.description) {
            Text(this.book.description)
              .fontSize(10)
              .fontColor('#666666')
              .textAlign(TextAlign.Center)
              .maxLines(3)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .padding({ left: 28, right: 28, top: 10 })
          }
        }
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .layoutWeight(1)
        .padding({ bottom: 20 })
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#000000')
    }
    .hideTitleBar(true)
    .backgroundColor('#000000')
  }
}
